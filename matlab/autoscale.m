% Autoscale signal
function y = autoscale( x, normx )
    %Calculate max amplitude of signal
    maxx = max( max( abs(x) ) );
    %Scale signal to maxx = normx
    if(maxx>0)
        y = (normx/maxx) * x;
    else
        y = x;
    end
return
