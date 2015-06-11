%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filters bank
% version 6
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

function [vy, state] = filter_bank_6(x, state)

    vy = zeros(1,state.N);

    % Filters bank
    [vy(1 ), state.LF100 ] = my_filter( x, state.LF100  );
    [vy(2 ), state.BF200 ] = my_filter( x, state.BF200  );
    [vy(3 ), state.BF300 ] = my_filter( x, state.BF300  );
    [vy(4 ), state.BF400 ] = my_filter( x, state.BF400  );
    [vy(5 ), state.BF500 ] = my_filter( x, state.BF500  );
    [vy(6 ), state.BF600 ] = my_filter( x, state.BF600  );
    [vy(7 ), state.BF700 ] = my_filter( x, state.BF700  );
    [vy(8 ), state.BF800 ] = my_filter( x, state.BF800  );
    [vy(9 ), state.BF900 ] = my_filter( x, state.BF900  );
    [vy(10), state.BF1000] = my_filter( x, state.BF1000 );
    [vy(11), state.BF1150] = my_filter( x, state.BF1150 );
    [vy(12), state.BF1300] = my_filter( x, state.BF1300 );
    [vy(13), state.BF1450] = my_filter( x, state.BF1450 );
    [vy(14), state.BF1600] = my_filter( x, state.BF1600 );
    [vy(15), state.BF1800] = my_filter( x, state.BF1800 );
    [vy(16), state.BF2000] = my_filter( x, state.BF2000 );
    [vy(17), state.BF2200] = my_filter( x, state.BF2200 );
    [vy(18), state.BF2400] = my_filter( x, state.BF2400 );
    [vy(19), state.BF2600] = my_filter( x, state.BF2600 );
    [vy(20), state.BF2900] = my_filter( x, state.BF2900 );
    [vy(21), state.BF3200] = my_filter( x, state.BF3200 );
    [vy(22), state.BF3500] = my_filter( x, state.BF3500 );
    [vy(23), state.HF4000] = my_filter( x, state.HF4000 );

return
