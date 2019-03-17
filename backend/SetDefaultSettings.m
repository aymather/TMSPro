function SetDefaultSettings(handles)

    % Init default values for settings
    handles.output.UserData.artifactlength = 10;
    handles.output.UserData.maxmeplength = 75;
    handles.output.UserData.baselinelength = 60;
    handles.output.UserData.plotlimitsx = [1 500];
    handles.output.UserData.artifactfactor = 2.5;
    handles.output.UserData.plotlimitsy = [-2 2];
    
    % Set those values to the strings displayed to user
    handles.text28.String = '10';
    handles.text29.String = '75';
    handles.text30.String = '60';
    handles.text31.String = '1:500';
    handles.text33.String = '2.5';
    handles.text34.String = '-2:2';

end