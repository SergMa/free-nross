%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loop signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT:
%   x    = vector 1xN of input signal samples
%   M    = needed number of samples
% OUTPUT:
%   y     = vector 1xM of looped signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y] = looper(x,M)

    y = x;
    while(1)
        y = [y, x];
        if( length(y) >= M )
            break;
        end
    end

    y = y(1:M);

return
