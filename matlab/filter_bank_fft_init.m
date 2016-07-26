%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filters bank (initialization)
% FFT-based version
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT:   fftsize = length of FFT transformation vector: 32,64,128,...
% OUTPUT:  state = created state of filters bank
%                  state.N
%                  state.freqs
%                  state.amp
%                  state.delay
%                  state.cntr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [state] = filter_bank_fft_init( fftsize )

    K = 1.0;
    
    state.freqs  = [ (1:fftsize)*(8000/2/fftsize) ];
    state.N      = fftsize;
    state.amp    = K * ones(state.N);
    state.xdelay = zeros( state.N, 1 );
    state.ydelay = zeros( state.N, state.N );
    state.cntr   = 1;

return
