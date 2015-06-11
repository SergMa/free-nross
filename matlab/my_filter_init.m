%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIR-filter (initialization)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% бунд:
%   coeff = coefficients of FIR-filter
%бшунд:
%   state = created FIR-filter state:
%           state.len
%           state.coeff
%           state.delay
%           state.out
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [state] = my_filter_init(coeff)

        state.coeff = coeff;
        state.len   = length(state.coeff);
        state.delay = zeros(1,state.len);
        state.out   = 0;

return
