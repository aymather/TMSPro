% Checks plot limits, we have to do this a little
% differently because it requires two values separated
% by a '-'
function bool = CheckRange(min, max)
    if ~isnan(min) && ...
       ~isnan(max) && ...
       isa(min, 'double') && ...
       isa(max, 'double')
   
        bool = 1;
    else bool = 0;
    end
end