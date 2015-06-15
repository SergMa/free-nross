%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test script to measure amplitude frequency response   %
% 2015, Sergei Mashkin                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear all;
close all;

img_file = 'out/afr_filter_bank_5.png';
%img_file = 'out/afr_filter_bank_6.png';
%img_file = 'out/afr_filter_bank_7.png';

Fs    = 8000;  %sample frequency, Hz
Fmin  = 0;     %min    frequency, Hz
Fmax  = 4000;  %max    frequency, Hz
Fstep = 5;     %step   frequency, Hz

Ts = 1/Fs;

% Generate frequency vector
freqs = Fmin:Fstep:Fmax;
N = length(freqs);

% Initialize filters

filters = filter_bank_5_init;
%filters = filter_bank_6_init;
%filters = filter_bank_7_init;

SUBBANDS = filters.N; % Number of filters in bank (number of subbands)
taps = filters.taps;


% Measure amplitude frequency response
afr_lin = zeros(SUBBANDS+1,N);
afr_db  = zeros(SUBBANDS+1,N);
t = 0 : Ts : 3*taps*Ts;
xn = length(t);
y = zeros(SUBBANDS+1,xn);
for i=1:N
        w = 2*pi*freqs(i);
        % generate samples to test filter on defined frequency 
        x = sin( w*t );
        for j = 1 : xn
                % y(j) = filter(x(j));
        
                [vy, filters] = filter_bank_5( x(j), filters );
                %[vy, filters] = filter_bank_6( x(j), filters );
                %[vy, filters] = filter_bank_7( x(j), filters );
        
                out = sum( vy ); % total output of filters bank
                y(:,j) = [vy'; out];
        end
        % get output amplitudes
        y1 = y(: , end-taps:end); %do not use first taps samples (transient)
        y1 = abs(y1);
        afr_lin(:,i) = max(y1,[],2);
end
afr_db = 20*log10( max(afr_lin,1e-6) );  % 1e-6 limit to protect of log(0)


% Draw plots, save them to image file
figure(1);

subplot(2,1,1);
plot(freqs,afr_lin(1:SUBBANDS,:),'b', freqs,afr_lin(SUBBANDS+1,:),'r');
grid on;
title('AFR linear');
xlabel('freq, Hz');
ylabel('out, linear');

subplot(2,1,2);
plot(freqs,afr_db(1:SUBBANDS,:),'b', freqs,afr_db(SUBBANDS+1,:),'r');
ylim([-70 3]);
grid on;
title('AFR dB');
xlabel('freq, Hz');
ylabel('out, dB');

print('-dpng',img_file);
