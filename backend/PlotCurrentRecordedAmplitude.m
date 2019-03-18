% Finds current Tmax and Tmin and displays that
% to the user
function PlotCurrentRecordedAmplitude(handles)
    
    % Shortcuts
    Tmax = handles.TMS(handles.settings.currentframe, handles.settings.id.Tmax);
    Tmin = handles.TMS(handles.settings.currentframe, handles.settings.id.Tmin);
    
    % Extract data
    onset = handles.TMS(handles.settings.currentframe,handles.settings.id.Taonset) + handles.settings.artifactlength;
    offset = handles.TMS(handles.settings.currentframe,handles.settings.id.Tmoffset);
    raw = handles.tms.data.values(onset : offset,1,handles.settings.currentframe);
    
    % Get the X coordinates
    [~,TmaxX] = min(abs(raw - Tmax));
    [~,TminX] = min(abs(raw - Tmin));
    
    % Plot on axes
    axes(handles.axes1); cla;
    l = plot(raw, '-b'); hold on;
    
    % Title
    makeTitleForAxis(handles, l)
    
    % Plot markers
    plot(TmaxX, Tmax, '^r');
    plot(TminX, Tmin, 'vg');
    
    % Show values
    text(TmaxX, Tmax-.01, num2str(Tmax));
    text(TminX, Tmin-.01, num2str(Tmin));
    
    % Set Y-limit
    set(gca, 'YLim', [min(handles.popupmenu2.UserData.valleys)-.05 max(handles.popupmenu1.UserData.peaks)+.05])
    
    hold off;

end