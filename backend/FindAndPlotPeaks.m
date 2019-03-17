function [peaks, peaksloc, valleys, valleysloc] = FindAndPlotPeaks(handles)

    % Extract data
    onset = handles.TMS(handles.settings.currentframe,handles.settings.id.Taonset) + handles.settings.artifactlength;
    offset = handles.TMS(handles.settings.currentframe,handles.settings.id.Tmoffset);
    raw = handles.tms.data.values(onset : offset,1,handles.settings.currentframe);
    
    % Get mean and average out data
    m = mean(raw);
    adj = m;

    % Get Peaks
    [peaks, peaksloc] = findpeaks(raw, 'MinPeakHeight', adj);
    [valleys, valleysloc] = findpeaks(-raw, 'MinPeakHeight', adj);

    % Plot on axes
    axes(handles.axes1); cla;
    l = plot(raw, '-b'); hold on;
    
    % Title
    rejs = handles.TMS(handles.settings.currentframe,handles.settings.id.Trej_nopulse:handles.settings.id.Trej_maxex);
    if sum(rejs) > 0
        set(l,'Color',[1 0 0]);
        title({['Trial ' num2str(handles.settings.currentframe) ', \color[rgb]{1 0 0}REJECTED: ']; handles.settings.rejreasons{find(rejs,1,'first')}});
    elseif handles.TMS(handles.settings.currentframe, handles.settings.id.Trej_manual)
        set(l,'Color',[1 0 0]);
        title({['Trial ' num2str(handles.settings.currentframe) ', \color[rgb]{1 0 0}Manually Rejected']; ''});
    else
        title({['Trial ' num2str(handles.settings.currentframe) ', Amplitude: ' num2str(handles.TMS(handles.settings.currentframe,handles.settings.id.Tmep)) ' mV. \color[rgb]{0 0.5 0}accepted' ];''});
    end
    
    % Label peaks/valleys
    peaksPlot = plot(peaksloc,  peaks, '^r');
    valleysPlot = plot(valleysloc, -valleys, 'vg');
    for it = 1:length(peaksPlot.XData)
        text(peaksPlot.XData(it), peaksPlot.YData(it)-.01, num2str(peaks(it)));
    end
    for it = 1:length(valleysPlot.XData)
        text(valleysPlot.XData(it), valleysPlot.YData(it)-.01, num2str(-valleys(it)));
    end
    set(gca, 'YLim', [min(-valleys)-.05 max(peaks)+.05])
    hold off;
    valleys = -valleys;
    
end