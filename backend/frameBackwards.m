function handles = frameBackwards(handles)

    if handles.settings.countindex - 1 > 0
        handles.settings.countindex = handles.settings.countindex - 1;
        handles.settings.currentframe = handles.TMS_current(handles.settings.countindex,handles.settings.id.Ttrial);
    else
        disp('You are at the beginning of your data set.');
    end

end