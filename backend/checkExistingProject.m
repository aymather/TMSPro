% Checks to make sure your existing project is 
% actually a file we've worked with before.
% Must contain the following variables...
% settings, TMS, tms
function bool = checkExistingProject(ffile)

    % Look inside mat file for recognized variables
    content = who('-file', ffile);
    if ismember('TMS', content) && ...
       ismember('tms', content) && ...
       ismember('settings', content)
   
        bool = 1;
        
    else
        
        bool = 0;

    end
    
end