%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measurer of signal energy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Calculate average signal "energy" as sum of abs values of signal
% samples over len samples.
%
% INPUT:
%   x = input sample of signal
%   state = current state of measurer:
%           state.len
%           state.counter
%           state.sum
%           state.out
% OUTPUT:
%   energy = output value of energy
%   state  = new state of measurer:
%            state.len
%            state.counter
%            state.sum
%            state.out
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [energy,state] = my_energy(x,state)

    %state.sum = state.sum + x*x;    %true energy formula
    state.sum = state.sum + abs(x);

    state.counter = state.counter + 1;
    if state.counter >= state.len
        %state.out = state.sum .^ 0.5;   %true energy formula
        state.out = state.sum / state.len;
        state.counter = 0;
        state.sum = 0;
    end
    energy = state.out;

return
