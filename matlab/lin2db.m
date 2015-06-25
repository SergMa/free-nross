% Convert linear value to decibells
function db = lin2db(lin)
    db = 20*log2(lin);
return