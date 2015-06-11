% Noise Gate
%
% ex = energy of input signal
% en = estimate of energy of noise
% T1 = Highest noisegate threshold (if signal is higher of T1, transmit full signal)
% T2 = noisegate threshold 2
% T3 = noisegate threshold 3
% T4 = noisegate threshold 4
% T5 = noisegate threshold 5
% T6 = noisegate threshold 6
% T7 = Lowest noisegate threshold (if signal is lower of T7, do not transmit signal)
% T1 > T2 > T3 > T4 > T5 > T6 > T7
function [ alpha ] = noisegate( ex, en, T1,T2,T3,T4,T5,T6,T7 )
    M = length(ex);
    alpha = zeros(1,M);
    for k=1:M
        if     ex(k) > T1 * en(k)
            alpha(k) = 1.1;
        elseif ex(k) > T2 * en(k)
            alpha(k) = 1.0;
        elseif ex(k) > T3 * en(k)
            alpha(k) = 0.7;
        elseif ex(k) > T4 * en(k)
            alpha(k) = 0.4;
        elseif ex(k) > T5 * en(k)
            alpha(k) = 0.2;
        elseif ex(k) > T6 * en(k)
            alpha(k) = 0.1;
        elseif ex(k) > T7 * en(k)
            alpha(k) = 0.1;
        else
            alpha(k) = 0.1;
        end
    end
return
