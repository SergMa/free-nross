%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mix two signals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT:
%   x1    = vector 1xN1 of input signal-1 samples
%   amp1  = amplitude of signal-1, dB
%   x2    = vector 1xN2 of input signal-2 samples
%   amp2  = amplitude of signal-2, dB
% OUTPUT:
%   y     = vector 1xN1 of mixed signal
%           if N2<N1 signal-2 will be looped
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y] = mixer(x1,amp1, x2,amp2)
    N1 = length(x1);
    N2 = length(x2);
    xx = looper(x2,N1);
    y = x1*db2lin(amp1) + xx*db2lin(amp2);
return
