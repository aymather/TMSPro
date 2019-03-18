function ShowFrameOnAxis(handles)

    % Handle reject button
    if any(handles.TMS(handles.settings.currentframe, handles.settings.id.Trej_nopulse:handles.settings.id.Trej_other))
        handles.pushbutton13.String = 'Unreject ( x )';
        handles.pushbutton13.UserData = 0;
        
        % Toggle Set new MEP min/max button
        set(handles.text4, 'visible', 'off');
        set(handles.edit2, 'visible', 'off');
    else
        handles.pushbutton13.String = 'Reject ( x )';
        handles.pushbutton13.UserData = 1;
        
        % Toggle Set new MEP min/max button
        set(handles.text4, 'visible', 'on');
        set(handles.edit2, 'visible', 'on');
    end

    % Grab the main axes
    axes(handles.axes1); cla;
    
    % Title
    title([ 'Trial ' num2str(handles.settings.currentframe)]);
    
    % Line
    l = line(1:length(handles.tms.data.values(:,1,handles.settings.currentframe)),handles.tms.data.values(:,1,handles.settings.currentframe),'LineWidth',1,'Color',[0 0 0.5]);
    
    % Title
    rejs = handles.TMS(handles.settings.currentframe,handles.settings.id.Trej_nopulse:handles.settings.id.Trej_maxex);
    if sum(rejs) > 0
        set(l,'Color',[1 0 0]);
        title({['Trial ' num2str(handles.settings.currentframe) ', \color[rgb]{1 0 0}REJECTED: ']; handles.settings.rejreasons{find(rejs,1,'first')}});
    elseif handles.TMS(handles.settings.currentframe, handles.settings.id.Trej_other)
        set(l,'Color',[1 0 0]);
        title({['Trial ' num2str(handles.settings.currentframe) ', \color[rgb]{1 0 0}Manually Rejected']; ''});
    else
        title({['Trial ' num2str(handles.settings.currentframe) ', Amplitude: ' num2str(handles.TMS(handles.settings.currentframe,handles.settings.id.Tmep)) ' mV. \color[rgb]{0 0.5 0}accepted' ];''});
    end
    
    % axes
    if handles.TMS(handles.settings.currentframe,handles.settings.id.Trej_nomep) == 0
        set(gca,'YTick',[handles.TMS(handles.settings.currentframe,handles.settings.id.Tmin) handles.TMS(handles.settings.currentframe,handles.settings.id.Tmax)],'YGrid','on');
        ylabel(['MEP amplitude (mV)']);
    else
        set(gca,'YTick',[]);
    end
    if handles.TMS(handles.settings.currentframe,handles.settings.id.Trej_nomep) == 0 && handles.TMS(handles.settings.currentframe,handles.settings.id.Trej_nopulse) == 0
        set(gca,'XTick',[handles.TMS(handles.settings.currentframe,handles.settings.id.Taonset)+10*handles.settings.srate/1000 handles.TMS(handles.settings.currentframe,handles.settings.id.Tmoffset)],'Xgrid','on');
        xlabel(['time (samples), Rate: ' num2str(handles.settings.srate) ' Hz']);
    else
        set(gca,'XTick',[]);
    end
    set(gca,'YLim',[min(handles.TMS(:,handles.settings.id.Tmin)) max(handles.TMS(:,handles.settings.id.Tmax))]);
    set(gca,'YLim',[min(handles.settings.plotlimitsy) max(handles.settings.plotlimitsy)]);
    set(gca,'XLim',handles.settings.plotlimitsx*handles.settings.srate/1000);
    
end