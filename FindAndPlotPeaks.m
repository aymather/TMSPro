function [peaks, peaksloc, valleys, valleysloc] = FindAndPlotPeaks(handles)

    % Extract data
    raw = handles.tms.data.values(1:handles.settings.baseline,1,handles.settings.currentframe);
    
    % Get mean and average out data
    m = mean(raw);
    adj = m + .005;

    % Get Peaks
    [peaks, peaksloc] = findpeaks(raw, 'MinPeakHeight', adj);
    [valleys, valleysloc] = findpeaks(-raw, 'MinPeakHeight', adj);

    % Plot on axes
    axes(handles.axes1); cla;
    plot(raw, '-b'); hold on;
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