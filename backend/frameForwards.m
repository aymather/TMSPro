function handles = frameForwards(handles)

    if handles.settings.countindex + 1 <= size(handles.TMS_current, 1)
        handles.settings.countindex = handles.settings.countindex + 1;
        handles.settings.currentframe = handles.TMS_current(handles.settings.countindex,handles.settings.id.Ttrial);
    else
        disp('You are at the end of your data set.');
    end

end