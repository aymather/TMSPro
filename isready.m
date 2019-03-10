% Checks to see if Create New Project is ready
% to create.
function bool = isready(handles)

    if isfield(handles.output.UserData, 'inputFile') && ...
       isfield(handles.output.UserData, 'outputFile') && ...
       strcmp(handles.output.UserData.inputFile(end-3:end), '.mat') && ...
       strcmp(handles.output.UserData.outputFile(end-3:end), '.mat') && ...
       exist(handles.output.UserData.inputFile) == 2
        
        bool = 1;
        
    else
        
        bool = 0;
        
    end
        
end