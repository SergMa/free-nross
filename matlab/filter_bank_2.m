%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filters bank
% version 2
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

function [vy, state, debug] = filter_bank_2(x, state)

    vy = zeros(1,state.N);

    % Filters bank
    [y_lf2000, state.LF2000] = my_filter( x, state.LF2000 );
    [y_hf2000, state.HF2000] = my_filter( x, state.HF2000 );

      [y_lf1000, state.LF1000] = my_filter( y_lf2000, state.LF1000 );
      [y_hf1000, state.HF1000] = my_filter( y_lf2000, state.HF1000 );

        [y_lf400, state.LF400] = my_filter( y_lf1000, state.LF400 );
        [y_hf400, state.HF400] = my_filter( y_lf1000, state.HF400 );

          [y_lf200, state.LF200] = my_filter( y_lf400, state.LF200 );
          [y_hf200, state.HF200] = my_filter( y_lf400, state.HF200 );

            [y_lf100, state.LF100] = my_filter( y_lf200, state.LF100 );
            [y_hf100, state.HF100] = my_filter( y_lf200, state.HF100 );

            [y_lf300, state.LF300] = my_filter( y_hf200, state.LF300 );
            [y_hf300, state.HF300] = my_filter( y_hf200, state.HF300 );

          [y_lf700, state.LF700] = my_filter( y_hf400, state.LF700 );
          [y_hf700, state.HF700] = my_filter( y_hf400, state.HF700 );

            [y_lf550, state.LF550] = my_filter( y_lf700, state.LF550 );
            [y_hf550, state.HF550] = my_filter( y_lf700, state.HF550 );

            [y_lf850, state.LF850] = my_filter( y_hf700, state.LF850 );
            [y_hf850, state.HF850] = my_filter( y_hf700, state.HF850 );

        [y_lf1500, state.LF1500] = my_filter( y_hf1000, state.LF1500 );
        [y_hf1500, state.HF1500] = my_filter( y_hf1000, state.HF1500 );

          [y_lf1250, state.LF1250] = my_filter( y_lf1500, state.LF1250 );
          [y_hf1250, state.HF1250] = my_filter( y_lf1500, state.HF1250 );

          [y_lf1750, state.LF1750] = my_filter( y_hf1500, state.LF1750 );
          [y_hf1750, state.HF1750] = my_filter( y_hf1500, state.HF1750 );

      [y_lf3000, state.LF3000] = my_filter( y_hf2000, state.LF3000 );
      [y_hf3000, state.HF3000] = my_filter( y_hf2000, state.HF3000 );

        [y_lf2500, state.LF2500] = my_filter( y_lf3000, state.LF2500 );
        [y_hf2500, state.HF2500] = my_filter( y_lf3000, state.HF2500 );

        [y_lf3500, state.LF3500] = my_filter( y_hf3000, state.LF3500 );
        [y_hf3500, state.HF3500] = my_filter( y_hf3000, state.HF3500 );

    % Filters outputs
    vy(1)  = y_lf100;
    vy(2)  = y_hf100;
    vy(3)  = y_lf300;
    vy(4)  = y_hf300;
    vy(5)  = y_lf550;
    vy(6)  = y_hf550;
    vy(7)  = y_lf850;
    vy(8)  = y_hf850;
    vy(9)  = y_lf1250;
    vy(10) = y_hf1250;
    vy(11) = y_lf1750;
    vy(12) = y_hf1750;
    vy(13) = y_lf2500;
    vy(14) = y_hf2500;
    vy(15) = y_lf3500;
    vy(16) = y_hf3500;

    debug.vy1(1) = y_lf2000;
    debug.vy1(2) = y_hf2000;

      debug.vy2(1) = y_lf1000;
      debug.vy2(2) = y_hf1000;
      debug.vy2(3) = y_lf3000;
      debug.vy2(4) = y_hf3000;

        debug.vy3(1) = y_lf400;
        debug.vy3(2) = y_hf400;
        debug.vy3(3) = y_lf1500;
        debug.vy3(4) = y_hf1500;
        debug.vy3(5) = y_lf2500;
        debug.vy3(6) = y_hf2500;
        debug.vy3(7) = y_lf3500;
        debug.vy3(8) = y_hf3500;

          debug.vy4(1) = y_lf200;
          debug.vy4(2) = y_hf200;
          debug.vy4(3) = y_lf700;
          debug.vy4(4) = y_hf700;
          debug.vy4(5) = y_lf1250;
          debug.vy4(6) = y_hf1250;
          debug.vy4(7) = y_lf1750;
          debug.vy4(8) = y_hf1750;
          debug.vy4(9) = y_lf2500;
          debug.vy4(10) = y_hf2500;
          debug.vy4(11) = y_lf3500;
          debug.vy4(12) = y_hf3500;

return
