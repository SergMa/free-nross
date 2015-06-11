%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measurers of energies bank
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT:  vy    = vector 1xN = filters outputs
%         state = current state of measurers bank
%                 state.N
%                 state.LEN
%                 state.EG(1) ... state.EG(N)
% OUTPUT: ey    = vector 1xN = measurers outputs
%         state = new state of measurers bank
%                 state.N
%                 state.LEN
%                 state.EG(1) ... state.EG(N)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ey, state] = energy_bank(vy, state) 

    % Measure energies
    ey = zeros(1,state.N);
    for i=1:state.N
        [ey(i), state.EG(i)] = my_energy( vy(i), state.EG(i) );
    end

return
