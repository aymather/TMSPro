function makeTitleForAxis(handles, l)

    % Generate title
    trial = handles.TMS(handles.settings.currentframe,:);
    if any(trial(:,handles.settings.id.Trej_nopulse:handles.settings.id.Trej_other))
        set(l,'Color',[1 0 0]);
        pos = find(trial(:,handles.settings.id.Trej_nopulse:handles.settings.id.Trej_other) == 1);
        t = {['Trial ' num2str(handles.settings.currentframe) ', \color[rgb]{1 0 0}REJECTED: ']};
        for it = 1:length(pos)
            t = [t, ['\color[rgb]{1 0 0}' handles.settings.rejreasons(pos(it)) ' | ']];
        end
        title([cell2mat(t);{''}]);
    else
        title({['Trial ' num2str(handles.settings.currentframe) ', Amplitude: ' num2str(handles.TMS(handles.settings.currentframe,handles.settings.id.Tmep)) ' mV. \color[rgb]{0 0.5 0}accepted' ];''});
    end
    set(handles.axes1,'FontName','Avenir');
    
end