%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measurers of energies bank (Initialization)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT:  N     = number of measurers
%         LEN   = length of measurers (number of samples to
%                 measure energy)
% OUTPUT: state = created state of measurers bank
%                 state.N
%                 state.LEN
%                 state.EG(1) ... state.EG(N)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [state] = energy_bank_init(N, LEN) 

    state.N = N;
    state.LEN = LEN;
    for i=1:state.N
        state.EG(i) = my_energy_init( LEN );
    end

return
