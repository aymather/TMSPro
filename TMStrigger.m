function TMStrigger(type,daq)
% type
if strcmpi(type,'sweep')
    pin = 64; port = 1;
elseif strcmpi(type,'tms1') || strcmpi(type,'tms')
    pin = 16; port = 1;
elseif strcmpi(type,'tms2')
    pin = 4; port = 1;
end

DaqDOut(daq,port,pin);
WaitSecs(0.005);
DaqDOut(daq,port,0);