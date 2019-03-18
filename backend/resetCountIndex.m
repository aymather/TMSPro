function handles = resetCountIndex(handles)

    handles.settings.countindex = 1;
    handles.settings.currentframe = handles.TMS_current(handles.settings.countindex,handles.settings.id.Ttrial);
    
end