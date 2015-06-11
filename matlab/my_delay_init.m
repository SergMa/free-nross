%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Delay of signal (initialization)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT:
%   N     = number of delay buffers (number of inputs/outputs)
%   len   = number of taps in delay buffer
% OUTPUT:
%   state = created state of delay 
%           state.N
%           state.len
%           state.delay
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [state] = my_delay_init(N,len)

    % Put out oldest samples, put in newest samples from right side
    state.N = N;
    state.len = len;
    state.delay = zeros(N,len);

return
