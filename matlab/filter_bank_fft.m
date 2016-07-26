%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filters bank
% FFT-based version
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT:  x     = input sample of signal
%         state = current state of filters bank
%                 state.N
%                 state.freqs
%                 state.taps
%                 state.xdelay
%                 state.ydelay
%                 state.cntr
% OUTPUT: vy    = vector 1xN = filters outputs
%         state = new state of filters bank
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [vy, state] = filter_bank_fft(x, state)

    if(state.cntr==1)
        %Make FFT/IFFT filtering
        fx = fft( state.xdelay, state.N );
        fx( (state.N/2+1) : state.N ) = [];
        for i=1 : (state.N/2)
            flt = zeros( state.N, 1 );
            flt(i) = state.amp(i) * fx(i);
            y = 2*real( ifft(flt,state.N) );
            state.ydelay(:,i) = y;
        end
    end

    %Buffer x in input delay buffer
    state.xdelay( state.cntr ) = x;
    %Output samples from output delay buffers
    vy = state.ydelay( state.cntr , : );

    state.cntr = state.cntr + 1;
    if(state.cntr > state.N)
        state.cntr = 1;
    end

return
