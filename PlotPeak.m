function [currentPeaks, currentValleys] = PlotPeak(handles, peaksIndex, valleysIndex)
    
    % Extract data
    raw = handles.tms.data.values(1:handles.settings.baseline,1,handles.settings.currentframe);
    
    % Plot on axes
    axes(handles.axes1); cla;
    plot(raw, '-b'); hold on;
    plot(handles.popupmenu1.UserData.peaksloc(peaksIndex), handles.popupmenu1.UserData.peaks(peaksIndex), '^r');
    plot(handles.popupmenu2.UserData.valleysloc(valleysIndex), handles.popupmenu2.UserData.valleys(valleysIndex), 'vg');
    
    % Display amplitude value next to each peak / valley
    for it = peaksIndex
        x = text(handles.popupmenu1.UserData.peaksloc(it), handles.popupmenu1.UserData.peaks(it)-.01, num2str(handles.popupmenu1.UserData.peaks(it)));
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