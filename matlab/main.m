%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test script to check and demonstrate work of          %
% Free Noise Reduction of Speech Signal (Free-NROSS)    %
%                                                       %
% 2015, Sergei Mashkin                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear all;
close all;
disp('started...');

FS = 8000;  % Sample (discretization) frequency, Hz
TS = 1/FS;  % Sample (discretization) period, sec

INPUT_FILENAME  = './input.wav'; % Name of file for input (noised) signal
OUTPUT_FILENAME = './out.wav';   % Name of file for output (clean) signal

SPECTROGRAM_WIDTH = 512; % Parameters of spectrograms
SPECTROGRAM_OVR   = 16;

USE_HPF100 = 0; % 0 - disable input High Pass Filter 100 Hz cut freq, 1 - enable

ATT = 1/4;      % Scale down factor (to protect against of overflow)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load input (voice,noise) signals from wave-files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

USE_AUTOSCALE = 1; % 0 - disable autoscale of input signals, 1 - enable

%voice_filename = '../samples/cmu/sample1_8000.wav';         VOICE_AMP_DB = 0;
%voice_filename = '../samples/cmu/sample2_8000.wav';         VOICE_AMP_DB = 0;
voice_filename  = '../samples/cmu/sample3_8000.wav';         VOICE_AMP_DB = 0;
%voice_filename = '../samples/cmu/sample4_8000.wav';         VOICE_AMP_DB = 0;
%voice_filename = '../samples/cmu/sample5_8000.wav';         VOICE_AMP_DB = 0;
%voice_filename = '../samples/cmu/sample6_8000.wav';         VOICE_AMP_DB = 0;
%voice_filename = '../samples/cmu/sample7_8000.wav';         VOICE_AMP_DB = 0;

%noise_filename = '../samples/noise/noise_white.wav';        NOISE_AMP_DB = -12;
%noise_filename = '../samples/noise/noise_pink.wav';         NOISE_AMP_DB = -12;
%noise_filename = '../samples/noise/noise_brown.wav';        NOISE_AMP_DB = -12;
%noise_filename = '../samples/noise/noise_badbearing.wav';   NOISE_AMP_DB = -12;
%noise_filename = '../samples/noise/noise_diesel.wav';       NOISE_AMP_DB = -12;
noise_filename  = '../samples/noise/noise_lacetti.wav';      NOISE_AMP_DB = -12;
%noise_filename = '../samples/noise/noise_lacetti2.wav';     NOISE_AMP_DB = -12;
%noise_filename = '../samples/noise/noise_tractor.wav';      NOISE_AMP_DB = -12;
%noise_filename = '../samples/noise/noise_yamzdiesel.wav';   NOISE_AMP_DB = -12;

[x_voice,ffs_voice,bits_voice] = wavread(voice_filename);
if ffs_voice~=FS
    error('invalid sample frequency of input voice wavefile');
end

[x_noise,ffs_noise,bits_noise] = wavread(noise_filename);
if ffs_noise~=FS
    error('invalid sample frequency of input noise wavefile');
end

% Make horizontal vectors. If wavefiles are stereo, use only the first channels
% now x has range [-1..+1]
x_voice = x_voice(:,1).';
N_voice = size(x_voice,2);

x_noise = x_noise(:,1).';
N_noise = size(x_noise,2);

% Normalize power of signals, if needed
if USE_AUTOSCALE==1
    x_voice = autoscale(x_voice, 1.0);
    x_noise = autoscale(x_noise, 1.0);
end

% Limit lenght of signal, if needed.
TC = 10; %sec  Set TC=0 to make no limit.
if TC > 0
    N = min(N_voice, TC*FS );
    x_voice = x_voice(1:N);
end

% Add noise to voice
x = mixer( x_voice, VOICE_AMP_DB, x_noise, NOISE_AMP_DB );
N = length(x);

% Convert sample numbers into time ticks (we will use this for plotting)
t = (1:N)/FS;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prepare signal to process
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Save input signal into input wavefile
wavwrite( x.',FS,bits_voice,INPUT_FILENAME);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize filters bank and energies measurers bank
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filters = filter_bank_5_init;
SUBBANDS = filters.N; % Nubmer of subbands in filters bank
TAPS = filters.taps;  % Length of filters

% equalization coefficients of filters bank subbands
corr = ones(1,SUBBANDS);

% transmittance coefficients of filter bank subbands
alpha = ones(1,SUBBANDS);
ALPHA_MIN = 0.1;
ALPHA_MAX = 1.0;

% noise energy estimates of filter bank subbands
noise_e = zeros(1,SUBBANDS);

% speech energy estimates of filter bank subbands
signal_e = zeros(1,SUBBANDS);

% Initialize energy measurers:
ENERGY_LEN = 1;
% Single measurer of input signal
energyx = my_energy_init(ENERGY_LEN);
% Measurers of subband signals
energies = energy_bank_init(SUBBANDS, ENERGY_LEN);

% High-pass filter (cut frequency is about 100 Hz)
hf100_xdelay = 0;
hf100_ydelay = 0;

% Delay of signals
vy_delay = my_delay_init( SUBBANDS, ENERGY_LEN );

% Counters
incrtime = zeros(1,SUBBANDS);

% Subband settings
TR    = zeros(1,SUBBANDS);
TF    = zeros(1,SUBBANDS);
TIME1 = zeros(1,SUBBANDS);
TIME2 = zeros(1,SUBBANDS);
ATR   = zeros(1,SUBBANDS);
ATF   = zeros(1,SUBBANDS);
for k=1:SUBBANDS
    TR(k)    = 0.8;            %Raise up factor
    TF(k)    = 0.993;          %Fall down factor
    TIME1(k) = 16000;
    TIME2(k) = 32000;
    ATR(k)   = 0.9;            %Raise up factor
    ATF(k)   = 0.999 - k*0.01; %Fall down factor
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main processing code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y = zeros(1,N);

ttt_ex  = zeros(1,N);

ttt_y         = zeros(SUBBANDS,N);
ttt_e         = zeros(SUBBANDS,N);
ttt_noise_e   = zeros(SUBBANDS,N);
ttt_signal_e  = zeros(SUBBANDS,N);
ttt_alpha     = zeros(SUBBANDS,N);

for i=1:N
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Check, is there voice activity in signal.
    % If not, refresh noise parameters,
    % if yes, leave noise parameters unchanged

    % input, scale down
    mic = ATT * x(i);

    % Optional: High pass filter (100 Hz cut frequency)
    if USE_HPF100==1
        [fmic, hf100_xdelay, hf100_ydelay] = hf100( mic, hf100_xdelay, hf100_ydelay );
    else
        fmic = mic;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Subband filters bank
    [vy, filters] = filter_bank_5( fmic, filters );

    % Measure energies estimates of filters bank outputs
    %[ey, energies] = energy_bank( vy, energies );
    ey = abs( vy );

    % Measure energy estimate of filters bank input
    %[ex,energyx] = my_energy( mic, energyx );
    ex = abs( fmic );

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Make estimates of noise and speech signals

    % Slow envelope of signal
    for k=1:SUBBANDS
        if ey(k) > signal_e(k)
            signal_e(k) = ey(k) - (ey(k) - signal_e(k)) * TR(k);
        else
            signal_e(k) = signal_e(k) * TF(k);
        end
    end
    %signal_e = ey;

    % Estimate energy of noise (three speed increment factor)
    INCR  = ATT*2*0.0000001;
    INCR2 = ATT*2*0.0000005;
    INCR3 = ATT*2*0.0000025;
    for k=1:SUBBANDS
        if signal_e(k) < noise_e(k)
            incrtime(k) = 0;
            noise_e(k) = signal_e(k);
        else
            if incrtime(k) < TIME1(k)
                incrtime(k) = incrtime(k) + 1;
                noise_e(k) = noise_e(k) + INCR;
            elseif incrtime(k) < TIME2(k)
                incrtime(k) = incrtime(k) + 1;
                noise_e(k) = noise_e(k) + INCR2;
            else
                noise_e(k) = noise_e(k) + INCR3;
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Find transmittance coefficients for subbands
    SENS = 1.5;
    a = max(0,signal_e - SENS*noise_e) ./ (signal_e + 0.00001*ATT);

    for k=1:SUBBANDS
       if a(k) > alpha(k)
           alpha(k) = a(k) - (a(k) - alpha(k)) * ATR(k);
       else
           alpha(k) = alpha(k) * ATF(k);
       end
    end

    alpha = max(alpha,ALPHA_MIN);
    alpha = min(alpha,ALPHA_MAX);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate clean output signal

    % Compensate delay of energies measurers
    [vy2, vy_delay] = my_delay( vy, vy_delay );

    % get output signal as weighted sum of subband filters outputs
    y(i) = sum( corr .* alpha .* vy2 );
    
    % output scale up
    y(i) = (1/ATT) * y(i);

    % Collect some variables for analisys
    ttt_ex(i) = ex;
    ttt_ey{i} = ey;
    for k=1:SUBBANDS
        ttt_y(k,i)        = vy(k);
        ttt_e(k,i)        = ey(k);
        ttt_noise_e(k,i)  = noise_e(k);
        ttt_signal_e(k,i) = signal_e(k);
        ttt_alpha(k,i)    = alpha(k);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

% Make time-shift of output signal to compensate filters delay
% (this is needed to compare spectrogramms more precisely)
timeshift = TAPS + ENERGY_LEN;
y = [ y( timeshift:end ) , zeros(1,timeshift-1) ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot graphics, make estimates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fig = 1;

% Plot waveforms of signals
figure(fig);
fig = fig + 1;
subplot(2,2,1);
    plot(t, db2lin(VOICE_AMP_DB)*x_voice );
    title('voice signal');  xlabel('t,sec');  ylabel('voice');
    ylim([-1, +1]);
subplot(2,2,2);
    plot(t,looper(db2lin(NOISE_AMP_DB)*x_noise,N));
    title('noise signal');  xlabel('t,sec');  ylabel('noise');
    ylim([-1, +1]);
subplot(2,2,3);
    plot(t,x);
    title('voice+noise signal');  xlabel('t,sec');  ylabel('voice+noise');
    ylim([-1, +1]);
subplot(2,2,4);
    plot(t,y);
    title('cleaned signal');  xlabel('t,sec');  ylabel('y');
    ylim([-1, +1]);

% Build and plot spectrogramms of signals
figure(fig);
fig = fig + 1;
subplot(2,2,1);
    s_voice = spectrogram( db2lin(VOICE_AMP_DB)*x_voice, SPECTROGRAM_WIDTH, FS, SPECTROGRAM_OVR);
    title('input (voice) signal');
subplot(2,2,2);
    s_noise = spectrogram( looper(db2lin(VOICE_AMP_DB)*x_noise,N), SPECTROGRAM_WIDTH, FS, SPECTROGRAM_OVR);
    title('input (noise) signal');
subplot(2,2,3);
    s_signal = spectrogram( x, SPECTROGRAM_WIDTH, FS, SPECTROGRAM_OVR);
    title('input (voice+noise) signal');
subplot(2,2,4);
    s_clean = spectrogram( y, SPECTROGRAM_WIDTH, FS, SPECTROGRAM_OVR);
    title('processed (voice+noise) signal');

% Estimate quality of noise reduction: compare spectrogramms
% of original voice and cleaned voice.
% s_voice, s_noise, s_signal, s_clean
s_diff = abs( s_clean - s_voice );
figure(fig);
fig = fig + 1;
imagesc(s_diff);
axis xy;

avg_s_diff = mean(mean(s_diff));
std_s_diff = std(std(s_diff));

avg_s_diff
std_s_diff

% Plot graphics of energies estimates
MAXEE = max(max(ttt_e));
MAXSE = max(max(ttt_signal_e));
MAXNE = max(max(ttt_noise_e));
MAXE = max([MAXEE,MAXSE,MAXNE]);
k = 1;
while (k<=SUBBANDS)
    figure(fig);
    fig = fig + 1;
    subplot(5,1,1);
    plot(t,x,'b', t,y,'g'); xlabel('t,sec'); ylabel('s,y'); legend('s=v+n','y=s-n'); ylim([-1,1]);
    for i=1:4
        if k<=SUBBANDS
            subplot(5,1,2+i-1);
            plot(t,ttt_e(k,:),'g', t,ttt_signal_e(k,:),'r', t,ttt_noise_e(k,:),'k');
            legend(['e(',num2str(k),')'], ['signal_e(',num2str(k),')'], ['noise_e(',num2str(k),')']);
            xlabel('t,sec'); ylabel('e');
            ylim([0-0.1*MAXE,MAXE+0.1*MAXE]);
        end
        k = k + 1;
    end
end

% Plot graphics of transmittance coefficients
MAXA = max(max(ttt_alpha));
k = 1;
while (k<=SUBBANDS)
    figure(fig);
    fig = fig + 1;
    subplot(5,1,1);
    plot(t,x,'b', t,y,'g'); xlabel('t,sec'); ylabel('s,y'); legend('s=v+n','y=s-n'); ylim([-1,1]);
    for i=1:4
        if k<=SUBBANDS
            subplot(5,1,2+i-1);
            plot(t,ttt_alpha(k,:),'r');
            xlabel('t,sec'); ylabel(['alpha(',num2str(k),')']);
            ylim([0-0.1*MAXA,MAXA+0.1*MAXA]);
        end
        k = k + 1;
    end
end

% Plot graphics of filterbank outputs
MAXY = max(max(abs(ttt_y)));
k = 1;
while (k<=SUBBANDS)
    figure(fig);
    fig = fig + 1;
    subplot(5,1,1);
    plot(t,x,'b', t,y,'g'); xlabel('t,sec'); ylabel('s,y'); legend('s=v+n','y=s-n'); ylim([-1,1]);
    for i=1:4
        if k<=SUBBANDS
            subplot(5,1,2+i-1);
            plot(t,ttt_y(k,:),'r');
            xlabel('t,sec'); ylabel(['y(',num2str(k),')']);
            ylim([-MAXY,MAXY]);
        end
        k = k + 1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save processed (clean) signal into output wavefile
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

wavwrite(y',FS,bits_voice,OUTPUT_FILENAME);

disp('finished!');
