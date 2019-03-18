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
    
    if isempty(peaks) || isempty(valleys)
        
        warning('Not detecting enough activity within MEP window. Try setting a new MEP window.');
        
    else
        
        % Plot on axes
        axes(handles.axes1); cla;
        l = plot(raw, '-b'); hold on;

        % Title
        makeTitleForAxis(handles, l)

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
        
        % Toggle extra buttons on
        ToggleButtonDisplay(handles,1);
        
        % Add peaks/valleys to popupmenus for callbacks
        handles.popupmenu1.UserData.peaks = peaks;
        handles.popupmenu1.UserData.peaksloc = peaksloc;
        handles.popupmenu2.UserData.valleys = valleys;
        handles.popupmenu2.UserData.valleysloc = valleysloc;

        % Put peaks/valleys into popupmenu options
        handles.popupmenu1.String = {'All Peaks', peaks};
        handles.popupmenu2.String = {'All Valleys', valleys};
        
        % Update handles structure
        guidata(hObject, handles);
        
    end
    
end