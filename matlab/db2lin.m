% Convert decibells to linear value
function lin = db2lin( db )
    lin = 10^(db/20);
return