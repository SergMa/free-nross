%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filters bank
% version 4
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

function [vy, state] = filter_bank_4(x, state)

    vy = zeros(1,state.N);

    % Filters bank
    [vy(1 ), state.LF200 ] = my_filter( x, state.LF200  );
    [vy(2 ), state.BF400 ] = my_filter( x, state.BF400  );
    [vy(3 ), state.BF600 ] = my_filter( x, state.BF600  );
    [vy(4 ), state.BF800 ] = my_filter( x, state.BF800  );
    [vy(5 ), state.BF1000] = my_filter( x, state.BF1000 );
    [vy(6 ), state.BF1200] = my_filter( x, state.BF1200 );
    [vy(7 ), state.BF1400] = my_filter( x, state.BF1400 );
    [vy(8 ), state.BF1600] = my_filter( x, state.BF1600 );
    [vy(9 ), state.BF1800] = my_filter( x, state.BF1800 );
    [vy(10), state.BF2000] = my_filter( x, state.BF2000 );
    [vy(11), state.BF2400] = my_filter( x, state.BF2400 );
    [vy(12), state.BF2800] = my_filter( x, state.BF2800 );
    [vy(13), state.BF3200] = my_filter( x, state.BF3200 );
    [vy(14), state.BF3600] = my_filter( x, state.BF3600 );
    [vy(15), state.HF4000] = my_filter( x, state.HF4000 );

return
