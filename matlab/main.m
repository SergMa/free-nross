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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load input (voice,noise) signals from wav-file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%voice_filename  = '../samples/cmu/sample1_8000.wav';
%voice_filename = '../samples/cmu/sample2_8000.wav';
voice_filename = '../samples/cmu/sample3_8000.wav';
%voice_filename = '../samples/cmu/sample4_8000.wav';
%voice_filename = '../samples/cmu/sample5_8000.wav';
%voice_filename = '../samples/cmu/sample6_8000.wav';
%voice_filename = '../samples/cmu/sample7_8000.wav';

%noise_filename  = '../samples/noise/noise_white.wav';
%noise_filename = '../samples/noise/noise_pink.wav';
%noise_filename = '../samples/noise/noise_brown.wav';
%noise_filename = '../samples/noise/noise_badbearing.wav';
%noise_filename = '../samples/noise/noise_diesel.wav';
noise_filename = '../samples/noise/noise_lacetti.wav';
%noise_filename = '../samples/noise/noise_lacetti2.wav';
%noise_filename = '../samples/noise/noise_tractor.wav';
%noise_filename = '../samples/noise/noise_yamzdiesel.wav';

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
x_voice = x_voice.';
x_voice = x_voice(1,:);
N_voice = size(x_voice,2);

x_noise = x_noise.';
x_noise = x_noise(1,:);
N_noise = size(x_noise,2);

% Limit lenght of signal, if needed
TC = 10; %sec
NC = TC*FS;
N = min(N_voice,NC);
x_voice = x_voice(1:N);

% Add noise to voice
VOICE_AMP_DB = -3; %dB
NOISE_AMP_DB = -12; %dB
x = mixer( x_voice, VOICE_AMP_DB, x_noise, NOISE_AMP_DB );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prepare signal to process
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SPECTROGRAM_WIDTH = 512;
SPECTROGRAM_OVR = 16;

% Attenuate input signal (to prevent overflow)
ATT = 1/16;  %scale down factor
x = ATT * x;
N = length(x);

% Convert sample numbers into time ticks (we will use this for plotting)
t = (1:N)/FS;

% Plot input signal
figure(1);
plot(t, 10^(VOICE_AMP_DB/20)*x_voice );
title('input (voice) signal');
xlabel('t,sec');
ylabel('voice');
ylim([-1, +1]);

figure(2);
plot(t,looper(10^(NOISE_AMP_DB/20)*x_noise,N));
title('input (noise) signal');
xlabel('t,sec');
ylabel('noise');
ylim([-1, +1]);

figure(3);
plot(t,x);
title('input (voice+noise) signal');
xlabel('t,sec');
ylabel('x');
ylim([-1*ATT, +1*ATT]);


figure(4);
s_voice = spectrogram( 10^(VOICE_AMP_DB/20)*x_voice, SPECTROGRAM_WIDTH, FS, SPECTROGRAM_OVR);
title('input (voice) signal');

figure(5);
s_noise = spectrogram( looper(10^(VOICE_AMP_DB/20)*x_noise,N), SPECTROGRAM_WIDTH, FS, SPECTROGRAM_OVR);
title('input (noise) signal');

figure(6);
s_signal = spectrogram( x, SPECTROGRAM_WIDTH, FS, SPECTROGRAM_OVR);
title('input (voice+noise) signal');

% Save input signal into input wavefile
wavwrite( (x.')/ATT,FS,bits_voice,INPUT_FILENAME);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize filters bank and energies measurers bank
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filters = filter_bank_5_init;
SUBBANDS = filters.N; % Nubmer of subbands in filters bank

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main processing code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y = zeros(1,N);

ttt_ex  = zeros(1,N);

ttt_y1  = zeros(1,N);
ttt_y2  = zeros(1,N);
ttt_y3  = zeros(1,N);
ttt_y4  = zeros(1,N);
ttt_y5  = zeros(1,N);
ttt_y6  = zeros(1,N);
ttt_y7  = zeros(1,N);
ttt_y8  = zeros(1,N);
ttt_y9  = zeros(1,N);
ttt_y10 = zeros(1,N);

ttt_e1  = zeros(1,N);
ttt_e2  = zeros(1,N);
ttt_e3  = zeros(1,N);
ttt_e4  = zeros(1,N);
ttt_e5  = zeros(1,N);
ttt_e6  = zeros(1,N);
ttt_e7  = zeros(1,N);
ttt_e8  = zeros(1,N);
ttt_e9  = zeros(1,N);
ttt_e10 = zeros(1,N);

ttt_noise_e1   = zeros(1,N);
ttt_noise_e2   = zeros(1,N);
ttt_noise_e3   = zeros(1,N);
ttt_noise_e4   = zeros(1,N);
ttt_noise_e5   = zeros(1,N);
ttt_noise_e6   = zeros(1,N);
ttt_noise_e7   = zeros(1,N);
ttt_noise_e8   = zeros(1,N);
ttt_noise_e9   = zeros(1,N);
ttt_noise_e10  = zeros(1,N);

ttt_signal_e1  = zeros(1,N);
ttt_signal_e2  = zeros(1,N);
ttt_signal_e3  = zeros(1,N);
ttt_signal_e4  = zeros(1,N);
ttt_signal_e5  = zeros(1,N);
ttt_signal_e6  = zeros(1,N);
ttt_signal_e7  = zeros(1,N);
ttt_signal_e8  = zeros(1,N);
ttt_signal_e9  = zeros(1,N);
ttt_signal_e10 = zeros(1,N);

ttt_alpha_e1   = zeros(1,N);
ttt_alpha_e2   = zeros(1,N);
ttt_alpha_e3   = zeros(1,N);
ttt_alpha_e4   = zeros(1,N);
ttt_alpha_e5   = zeros(1,N);
ttt_alpha_e6   = zeros(1,N);
ttt_alpha_e7   = zeros(1,N);
ttt_alpha_e8   = zeros(1,N);
ttt_alpha_e9   = zeros(1,N);
ttt_alpha_e10  = zeros(1,N);

for i=1:N
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Check, is there voice activity in signal.
    % If not, refresh noise parameters,
    % if yes, leave noise parameters unchanged

    % input
    mic = x(i);

    [x(i), hf100_xdelay, hf100_ydelay] = hf100( x(i), hf100_xdelay, hf100_ydelay );

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Subband filters bank
    [vy, filters] = filter_bank_5( x(i), filters );

    % Measure energies estimates of filters bank outputs
    %[ey, energies] = energy_bank( vy, energies );
    ey = abs( vy );

    % Measure energy estimate of filters bank input
    %[ex,energyx] = my_energy( x(i), energyx );
    ex = abs( x(i) );

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Make estimates of noise and speech signals

    % Slow envelope of signal
    TR = 0.8;    %Raise up factor: Ts/Tr, Tr=1ms, Ts=1/8000Hz=0.125ms
    TF = 0.993;  %Fall down factor
    for k=1:SUBBANDS
        if ey(k) > signal_e(k)
            signal_e(k) = ey(k) - (ey(k) - signal_e(k)) * TR;
        else
            signal_e(k) = signal_e(k) * TF;
        end
    end
    %signal_e = ey;

    % Estimate energy of noise (three speed increment factor)
    INCR  = 0.0000001;
    INCR2 = 0.0000005;
    INCR3 = 0.0000025;
    for k=1:SUBBANDS
        if signal_e(k) < noise_e(k)
            incrtime(k) = 0;
            noise_e(k) = signal_e(k);
        else
            if incrtime(k) < 16000
                incrtime(k) = incrtime(k) + 1;
                noise_e(k) = noise_e(k) + INCR;
            elseif incrtime(k) < 32000
                incrtime(k) = incrtime(k) + 1;
                noise_e(k) = noise_e(k) + INCR2;
            else
                noise_e(k) = noise_e(k) + INCR3;
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Find transmittance coefficients for subbands

    % Version 11 (works well) ----------------------------
    SENS = 1.5;
    a = max(0,signal_e - SENS*noise_e) ./ (signal_e + 0.00001*ATT);

    ATR = 0.9;
    ATF = 0.999;
    for k=1:SUBBANDS
       if a(k) > alpha(k)
           alpha(k) = a(k) - (a(k) - alpha(k)) * ATR;
       else
           alpha(k) = alpha(k) * ATF;
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
    
    % scale up
    y(i) = (1/ATT) * y(i);

    % Save values for plotting
    ttt_ex(i) = ex;
    ttt_ey{i} = ey;

    ttt_y1(i)  = vy(1);
    ttt_y2(i)  = vy(2);
    ttt_y3(i)  = vy(3);
    ttt_y4(i)  = vy(4);
    ttt_y5(i)  = vy(5);
    ttt_y6(i)  = vy(6);
    ttt_y7(i)  = vy(7);
    ttt_y8(i)  = vy(8);
    ttt_y9(i)  = vy(9);
    ttt_y10(i) = vy(10);

    ttt_e1(i)  = ey(1);
    ttt_e2(i)  = ey(2);
    ttt_e3(i)  = ey(3);
    ttt_e4(i)  = ey(4);
    ttt_e5(i)  = ey(5);
    ttt_e6(i)  = ey(6);
    ttt_e7(i)  = ey(7);
    ttt_e8(i)  = ey(8);
    ttt_e9(i)  = ey(9);
    ttt_e10(i) = ey(10);

    ttt_noise_e1(i)   = noise_e(1);
    ttt_noise_e2(i)   = noise_e(2);
    ttt_noise_e3(i)   = noise_e(3);
    ttt_noise_e4(i)   = noise_e(4);
    ttt_noise_e5(i)   = noise_e(5);
    ttt_noise_e6(i)   = noise_e(6);
    ttt_noise_e7(i)   = noise_e(7);
    ttt_noise_e8(i)   = noise_e(8);
    ttt_noise_e9(i)   = noise_e(9);
    ttt_noise_e10(i)  = noise_e(10);

    ttt_signal_e1(i)  = signal_e(1);
    ttt_signal_e2(i)  = signal_e(2);
    ttt_signal_e3(i)  = signal_e(3);
    ttt_signal_e4(i)  = signal_e(4);
    ttt_signal_e5(i)  = signal_e(5);
    ttt_signal_e6(i)  = signal_e(6);
    ttt_signal_e7(i)  = signal_e(7);
    ttt_signal_e8(i)  = signal_e(8);
    ttt_signal_e9(i)  = signal_e(9);
    ttt_signal_e10(i) = signal_e(10);

    ttt_alpha_e1(i)   = alpha(1);
    ttt_alpha_e2(i)   = alpha(2);
    ttt_alpha_e3(i)   = alpha(3);
    ttt_alpha_e4(i)   = alpha(4);
    ttt_alpha_e5(i)   = alpha(5);
    ttt_alpha_e6(i)   = alpha(6);
    ttt_alpha_e7(i)   = alpha(7);
    ttt_alpha_e8(i)   = alpha(8);
    ttt_alpha_e9(i)   = alpha(9);
    ttt_alpha_e10(i)  = alpha(10);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

% Plot processed (clean) signal
figure(7);
plot(t,y);
title('processed (clean) signal');
xlabel('t,sec');
ylabel('y');

figure(8);
s_clean = spectrogram( y, SPECTROGRAM_WIDTH, FS, SPECTROGRAM_OVR);
title('processed (voice+noise) signal');



% now we have:
% s_voice, s_noise, s_signal, s_clean
s_diff = abs( s_clean - s_voice );
figure(9);
imagesc(s_diff);
axis xy;

avg_s_diff = mean(mean(s_diff));
std_s_diff = std(std(s_diff));

avg_s_diff
std_s_diff

% break;
% 
% % Plot help graphics
% figure(3);
% subplot(6,1,1); plot(t,x+1,'b',t,y-1,'r'); legend('x','y');
% subplot(6,1,2); plot(t,ttt_e1,'r',t,ttt_noise_e1,'b'); legend('e1','n1');
% subplot(6,1,3); plot(t,ttt_e2,'r',t,ttt_noise_e2,'b'); legend('e2','n2');
% subplot(6,1,4); plot(t,ttt_e3,'r',t,ttt_noise_e3,'b'); legend('e3','n3');
% subplot(6,1,5); plot(t,ttt_e4,'r',t,ttt_noise_e4,'b'); legend('e4','n4');
% subplot(6,1,6); plot(t,ttt_e5,'r',t,ttt_noise_e5,'b'); legend('e5','n5');
% 
% figure(4);
% subplot(6,1,1); plot(t,x+1,'b',t,y-1,'r'); legend('x','y');
% subplot(6,1,2); plot(t,ttt_e6, 'r',t,ttt_noise_e6, 'b'); legend('e6','n6');
% subplot(6,1,3); plot(t,ttt_e7, 'r',t,ttt_noise_e7, 'b'); legend('e7','n7');
% subplot(6,1,4); plot(t,ttt_e8, 'r',t,ttt_noise_e8, 'b'); legend('e8','n8');
% subplot(6,1,5); plot(t,ttt_e9, 'r',t,ttt_noise_e9, 'b'); legend('e9','n9');
% subplot(6,1,6); plot(t,ttt_e10,'r',t,ttt_noise_e10,'b'); legend('e10','n10');
% 
% figure(5);
% subplot(6,1,1); plot(t,x+1,'b',t,y-1,'r'); legend('x','y');
% subplot(6,1,2); plot(t,ttt_alpha_e1);  ylim([-0.1, 2.1]); legend('a1');
% subplot(6,1,3); plot(t,ttt_alpha_e2);  ylim([-0.1, 2.1]); legend('a2');
% subplot(6,1,4); plot(t,ttt_alpha_e3);  ylim([-0.1, 2.1]); legend('a3');
% subplot(6,1,5); plot(t,ttt_alpha_e4);  ylim([-0.1, 2.1]); legend('a4');
% subplot(6,1,6); plot(t,ttt_alpha_e5);  ylim([-0.1, 2.1]); legend('a5');
% 
% figure(6);
% subplot(6,1,1); plot(t,x+1,'b',t,y-1,'r'); legend('x','y');
% subplot(6,1,2); plot(t,ttt_alpha_e6);  ylim([-0.1, 2.1]); legend('a6');
% subplot(6,1,3); plot(t,ttt_alpha_e7);  ylim([-0.1, 2.1]); legend('a7');
% subplot(6,1,4); plot(t,ttt_alpha_e8);  ylim([-0.1, 2.1]); legend('a8');
% subplot(6,1,5); plot(t,ttt_alpha_e9);  ylim([-0.1, 2.1]); legend('a9');
% subplot(6,1,6); plot(t,ttt_alpha_e10); ylim([-0.1, 2.1]); legend('a10');
% 
% figure(7);
% subplot(6,1,1); plot(t,x+1,'b',t,y-1,'r'); legend('x','y');
% subplot(6,1,2); plot(t,ttt_signal_e1,'r',t,ttt_noise_e1,'b'); legend('s1','n1');
% subplot(6,1,3); plot(t,ttt_signal_e2,'r',t,ttt_noise_e2,'b'); legend('s2','n2');
% subplot(6,1,4); plot(t,ttt_signal_e3,'r',t,ttt_noise_e3,'b'); legend('s3','n3');
% subplot(6,1,5); plot(t,ttt_signal_e4,'r',t,ttt_noise_e4,'b'); legend('s4','n4');
% subplot(6,1,6); plot(t,ttt_signal_e5,'r',t,ttt_noise_e5,'b'); legend('s5','n5');
% 
% figure(8);
% subplot(6,1,1); plot(t,x+1,'b',t,y-1,'r'); legend('x','y');
% subplot(6,1,2); plot(t,ttt_signal_e6, 'r',t,ttt_noise_e6, 'b'); legend('s6', 'n6');
% subplot(6,1,3); plot(t,ttt_signal_e7, 'r',t,ttt_noise_e7, 'b'); legend('s7', 'n7');
% subplot(6,1,4); plot(t,ttt_signal_e8, 'r',t,ttt_noise_e8, 'b'); legend('s8', 'n8');
% subplot(6,1,5); plot(t,ttt_signal_e9, 'r',t,ttt_noise_e9, 'b'); legend('s9', 'n9');
% subplot(6,1,6); plot(t,ttt_signal_e10,'r',t,ttt_noise_e10,'b'); legend('s10','n10');
% 
% figure(9);
% subplot(6,1,1); plot(t,x+1,'b',t,y-1,'r'); legend('x','y');
% subplot(6,1,2); plot(t,ttt_y1,'r'); legend('y1');
% subplot(6,1,3); plot(t,ttt_y2,'r'); legend('y2');
% subplot(6,1,4); plot(t,ttt_y3,'r'); legend('y3');
% subplot(6,1,5); plot(t,ttt_y4,'r'); legend('y4');
% subplot(6,1,6); plot(t,ttt_y5,'r'); legend('y5');
% 
% figure(10);
% subplot(6,1,1); plot(t,x+1,'b',t,y-1,'r'); legend('x','y');
% subplot(6,1,2); plot(t,ttt_y6, 'r'); legend('y6');
% subplot(6,1,3); plot(t,ttt_y7, 'r'); legend('y7');
% subplot(6,1,4); plot(t,ttt_y8, 'r'); legend('y8');
% subplot(6,1,5); plot(t,ttt_y9, 'r'); legend('y9');
% subplot(6,1,6); plot(t,ttt_y10,'r'); legend('y10');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save processed (clean) signal into output wavefile
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

wavwrite(y',FS,bits_voice,OUTPUT_FILENAME);

disp('finished!');
