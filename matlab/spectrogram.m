%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [] = spectrogram(x, width)
% Plot spectrogramm of defined signal
% INPUTS:  x = 1xN - signal samples
%          width - width of spectrogram, must be power of 2 (...,64,128,256,512,1024,...)
%          fs = sample frequency, Hz
% OUTPUTS: ---
function [] = spectrogram( x, width, fs )

    % this function is based on spectrogram examples
    % http://dsp.stackexchange.com/questions/12803/get-spectrogram-matrix-without-specgram-in-matlab
    % http://warpproject.org/trac/wiki/WARPLab/Examples/Spectrogram
    % http://www.ee.columbia.edu/ln/rosa/matlab/sgram/

    if (width~=16) && (width~=32) && (width~=64) && (width~=128) && (width~=256) && (width~=512) && (width~=1024) && (width~=2048) && (width~=4096)
        error('invalid or unsupported width');
    end

    % make horizontal signal vector
    if (size(x,1)==1)
        x1 = x;
    else
        x1 = x.';
    end

    % add zeros to normally reshape by width
    N = length(x1);
    M = mod(N,width);
    if M>0
        x1 = [x1 zeros(1,width-M)];
    end

    % reshape signal
    z = reshape( x1, width, [] );

    % make FFT, logarithmic scale
    y = 20*log10( abs(fft(z)) );

    % cut off half of FFT output
    y = y(1:width/2 , :);

    % plot spectrogram in current axis
    time = (0:N)/fs;
    freq = 0:fs/2/width:fs/2;

    imagesc(time,freq,y);
    axis xy;
    xlabel('time,sec');
    ylabel('freq,Hz');
    %colorbar;

return
