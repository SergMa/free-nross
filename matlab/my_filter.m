%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIR-filter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT:
%   x = input signal sample
%   state = current FIR-filter state:
%           state.len
%           state.coeff
%           state.delay
%           state.out
% OUTPUT:
%   y = output (filtered) signal sample
%   state = new FIR-filter state:
%           state.len
%           state.coeff
%           state.delay
%           state.out
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y,state] = my_filter(x,state)

        % Put new sample from right side
        state.delay(1) = [];
        state.delay(state.len) = x;
        % Calculate FIR output
        state.out = sum( state.coeff .* state.delay );
        y = state.out;

return
