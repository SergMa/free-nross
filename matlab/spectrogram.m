%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [] = spectrogram(x, width)
% Plot spectrogramm of defined signal
% INPUTS:  x = 1xN - signal samples
%          width   - width of spectrogram, must be power of 2 (16,32,64,128,256,512,1024,2048,4096)
%          fs      - sample frequency, Hz
%          ovr     - overlay factor of fft pieces, must be mod(width,ovr)==0
% OUTPUTS: s = spectrogram array
function [s] = spectrogram( x, width, fs, ovr )

    % this function is based on spectrogram examples
    % http://dsp.stackexchange.com/questions/12803/get-spectrogram-matrix-without-specgram-in-matlab
    % http://warpproject.org/trac/wiki/WARPLab/Examples/Spectrogram
    % http://www.ee.columbia.edu/ln/rosa/matlab/sgram/

    if (width~=16) && (width~=32) && (width~=64) && (width~=128) && (width~=256) && (width~=512) && (width~=1024) && (width~=2048) && (width~=4096)
        error('invalid or unsupported width');
    end
    if mod(width,ovr)>0
        error('invalid ovr: must be mod(width,ovr)==0');
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
    N = length(x1);
    M = N/width;

    % reshape signal
    if(ovr==1)
        z = reshape( x1, width, [] );
    else
        x1 = [x1, zeros(1,width)]; %add zeros at the end (to shift window)
        z = zeros(width, ovr*N/width);
        for i=1:M
            for j=1:ovr
                pos = (i-1)*width + 1 + (j-1)*(width/ovr);
                z( : , (i-1)*ovr+j ) = x1( pos : pos + width - 1).';
            end
        end
    end

    % make FFT, logarithmic scale
    MIN_POWER = 10^(-120/20); %-120 dB
    s = 20*log10( abs(fft(z)) + MIN_POWER );

    % cut off half of FFT output
    s = s(1:width/2 , :);

    % plot spectrogram in current axis
    time = (0:N)/fs;
    freq = 0:fs/2/width:fs/2;

    imagesc(time,freq,s);
    axis xy;
    xlabel('time,sec');
    ylabel('freq,Hz');
    %colorbar;

return
