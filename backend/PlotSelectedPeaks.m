function [currentPeaks, currentValleys] = PlotSelectedPeaks(handles, peaksIndex, valleysIndex)
    
    % Extract data
    onset = handles.TMS(handles.settings.currentframe,handles.settings.id.Taonset) + handles.settings.artifactlength;
    offset = handles.TMS(handles.settings.currentframe,handles.settings.id.Tmoffset);
    raw = handles.tms.data.values(onset : offset,1,handles.settings.currentframe);
    
    % Plot on axes
    axes(handles.axes1); cla;
    l = plot(raw, '-b'); hold on;
    
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
    
    % Plot peaks markers
    plot(handles.popupmenu1.UserData.peaksloc(peaksIndex), handles.popupmenu1.UserData.peaks(peaksIndex), '^r');
    plot(handles.popupmenu2.UserData.valleysloc(valleysIndex), handles.popupmenu2.UserData.valleys(valleysIndex), 'vg');
    
    % Display amplitude value next to each peak / valley
    for it = peaksIndex
        text(handles.popupmenu1.UserData.peaksloc(it), handles.popupmenu1.UserData.peaks(it)-.01, num2str(handles.popupmenu1.UserData.peaks(it)));
    end
    for it = valleysIndex
        text( handles.popupmenu2.UserData.valleysloc(it), handles.popupmenu2.UserData.valleys(it)-.01, num2str(handles.popupmenu2.UserData.valleys(it)));
    end
    set(gca, 'YLim', [min(handles.popupmenu2.UserData.valleys)-.05 max(handles.popupmenu1.UserData.peaks)+.05])
    hold off;
    
    % Set output data
    currentPeaks = handles.popupmenu1.UserData.peaks(peaksIndex);
    currentValleys = handles.popupmenu2.UserData.valleys(valleysIndex);
    
end