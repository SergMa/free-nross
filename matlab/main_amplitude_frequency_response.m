%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test script to measure amplitude frequency response   %
% 2015, Sergei Mashkin                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear all;
close all;

Fs    = 8000;
Fmin  = 0;
Fmax  = 4000;
Fstep = 10;

Ts = 1/Fs;

% Generate frequency vector
freqs = Fmin:Fstep:Fmax;
N = length(freqs);

% Initialize filter
taps = 55;
filters = filter_bank_6_init;
SUBBANDS = filters.N; % Number of filters in bank (number of subbands)


% Measure amplitude frequency response
afr_lin = zeros(SUBBANDS+1,N);
afr_db  = zeros(SUBBANDS+1,N);
t = 0 : Ts : 2*taps*Ts;
xn = length(t);
y = zeros(SUBBANDS+1,xn);
for i=1:N
    w = 2*pi*freqs(i);
    % generate samples to test filter on defined frequency 
    x = sin( w*t );
    for j = 1 : xn
        % y(j) = filter(x(j));
        [vy, filters] = filter_bank_6( x(j), filters );
        out = sum( vy ); % total output of filters bank
        y(:,j) = [vy'; out];
    end
    % get output amplitudes
    y = y(: , taps+1:end);
    y = abs(y);
    afr_lin(:,i) = max(y,[],2);
end
afr_db = 20*log10( afr_lin );


figure(1);

subplot(2,1,1);
plot(freqs,afr_lin(1:SUBBANDS,:),'b', freqs,afr_lin(SUBBANDS+1,:),'r');
grid on;
title('afr linear');

subplot(2,1,2);
plot(freqs,afr_db(1:SUBBANDS,:),'b', freqs,afr_db(SUBBANDS+1,:),'r');
ylim([-70 3]);
grid on;
title('afr db');

