%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measurer of signal energy (Initialization)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Calculate average signal "energy" as sum of abs values of signal
% samples over len samples.
%
% INPUT:
%   len = number of signal samples to calculate energy
% OUTPUT:
%   state = created state of the measurer
%           state.len
%           state.counter
%           state.sum
%           state.out
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [state] = my_energy_init(len)

        state.len     = len;
        state.sum     = 0;
        state.counter = 0;
        state.out     = 0;
        energy        = 0;

return
