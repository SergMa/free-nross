%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filters bank
% version 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT:  x     = input sample of signal
%         state = current state of filters bank
%                 state.N
%                 state.freqs
%                 state.HF100_coeff ... state.LF3500_coeff
%                 state.HF100 ... state.LF3500
% OUTPUT: vy    = vector 1xN = filters outputs
%         state = new state of filters bank
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [vy, state] = filter_bank_5(x, state)

    vy = zeros(1,state.N);

    % Filters bank
    [vy(1 ), state.LF300 ] = my_filter( x, state.LF300  );
    [vy(2 ), state.BF600 ] = my_filter( x, state.BF600  );
    [vy(3 ), state.BF900 ] = my_filter( x, state.BF900  );
    [vy(4 ), state.BF1200] = my_filter( x, state.BF1200 );
    [vy(5 ), state.BF1500] = my_filter( x, state.BF1500 );
    [vy(6 ), state.BF1800] = my_filter( x, state.BF1800 );
    [vy(7 ), state.BF2100] = my_filter( x, state.BF2100 );
    [vy(8 ), state.BF2500] = my_filter( x, state.BF2500 );
    [vy(9 ), state.BF3000] = my_filter( x, state.BF3000 );
    [vy(10), state.BF3500] = my_filter( x, state.BF3500 );
    [vy(11), state.HF4000] = my_filter( x, state.HF4000 );

return
