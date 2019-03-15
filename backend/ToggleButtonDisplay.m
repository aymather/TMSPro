function status = ToggleButtonDisplay(handles, bool)

    if nargin > 1
        
        if bool; toggle = 'on'; else; toggle = 'off'; end

        set(handles.popupmenu1, 'visible', toggle);
        set(handles.popupmenu2, 'visible', toggle);
        set(handles.pushbutton8, 'visible', toggle);
        set(handles.pushbutton10, 'visible', toggle);
        set(handles.pushbutton12, 'visible', toggle);
        
    else
        
        s = get(handles.popupmenu1,'visible');
        if strcmp(s, 'off')
            status = 0;
        else
            status = 1;
        end
        
    end
    
end