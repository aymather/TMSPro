function [peaksIndex, valleysIndex] = GetSelectedPeaksIndex(handles)

    cPeaks = cellstr(get(handles.popupmenu1,'String'));
    cValleys = cellstr(get(handles.popupmenu2,'String'));

    peak = str2double(cPeaks{get(handles.popupmenu1,'Value')});
    valley = str2double(cValleys{get(handles.popupmenu2,'Value')});

    if isnan(peak)
        peaksIndex = 1:length(handles.popupmenu1.UserData.peaks);
    else
        [~,peaksIndex] = min(abs(handles.popupmenu1.UserData.peaks - peak));
    end
    if isnan(valley)
        valleysIndex = 1:length(handles.popupmenu2.UserData.valleys);
    else
        [~,valleysIndex] = min(abs(handles.popupmenu2.UserData.valleys - valley));
    end
    
end