%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Delay of signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT:
%   x     = vector 1xN of input signal samples
%   state = current state of delay
%           state.N
%           state.len
%           state.delay
% OUTPUT:
%   y     = vector 1xN of delayed signal samples
%   state = new state of delay
%           state.N
%           state.len
%           state.delay
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y,state] = my_delay(x,state)

    if state.len==0
        y = x;
    else
        % Put new samples from right side
        y = state.delay(:,1);
        y = y.';
        state.delay(:,1) = [];
        state.delay(:,state.len) = x.';
    end

return
