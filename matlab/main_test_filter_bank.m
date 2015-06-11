%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test script to check filters bank                     %
% 2015, Sergei Mashkin                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measure amplitude frequency characteristic of filters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear all;
close all;
disp('started...');

FS = 8000; % Sample (discretization) frequency, Hz
TS = 1/FS; % Sample (discretization) period, Hz

inputfilename = './input.wav'; % Name of file for input (noised) signal
outfilename   = './out.wav';   % Name of file for output (clean) signal

    ffs = 8000;
    bits = 16;

    MINFREQ = 0;
    MAXFREQ = 4000;
    Tsec = 40;    %total length, sec

    N = Tsec/TS; %total length, samples
    x = zeros(1,N);
    freq   = MINFREQ;
    dfreq  = (MAXFREQ-MINFREQ)/N;
    phase  = 0;
    for i=1:N
        x(i) = sin( phase );
        freq = freq + dfreq;
        phase = phase + 2*pi* (10*round(freq/10)) /FS;
    end

% Convert sample numbers into time ticks (we will use this in plots)
t = 1:N;
t = t/FS;

% Show input signal
figure(1);
plot(t,x);

% Save input signal into input wavefile
wavwrite(x',FS,bits,inputfilename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize filters bank
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filters = filter_bank_7_init;
SUBBANDS = filters.N; % Number of filters in bank (number of subbands)

% equalization coefficients of filters bank subbands
corr = ones(1,SUBBANDS);
%corr(3) = 0;
%corr(7) = 0;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Measure amplitude frequency characteristic of filters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    y = zeros(1,N);

    for i=1:N
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % filters bank
        [vy, filters] = filter_bank_7( x(i), filters );

        % Get filters bank output signal
        y(i) = sum( corr .* vy );

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end

    % Show amplitude frequency characteristic
    figure(2);
    plot(t,y);
    title('y');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save filtered signal into output wavefile
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

wavwrite(y',FS,bits,outfilename);

disp('finished!');
