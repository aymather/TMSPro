% Checks to make sure that the entered setting is valid
function bool = CheckSetSetting(num)
    if isa(num, 'double') && isscalar(num) && ~isnan(num)
        bool = 1;
    else bool = 0;
    end
end