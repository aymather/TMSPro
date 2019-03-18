function handles = UpdateFilters(handles)

    % Get data matricies
    handles.TMS_temp.nopulse = handles.settings.filter_by(handles.TMS, handles.settings.id.Trej_nopulse);
    handles.TMS_temp.absbase = handles.settings.filter_by(handles.TMS, handles.settings.id.Trej_absbase);
    handles.TMS_temp.nomep = handles.settings.filter_by(handles.TMS, handles.settings.id.Trej_nomep);
    handles.TMS_temp.minex = handles.settings.filter_by(handles.TMS, handles.settings.id.Trej_minex);
    handles.TMS_temp.maxex = handles.settings.filter_by(handles.TMS, handles.settings.id.Trej_maxex);
    handles.TMS_temp.other = handles.settings.filter_by(handles.TMS, handles.settings.id.Trej_other);

    % Get all accepted
    handles.TMS_temp.accepted = handles.settings.get_accepted(handles.TMS, handles.settings.id.Trej_nopulse:handles.settings.id.Trej_other);
    handles.TMS_temp.rejected = handles.settings.get_rejected(handles.TMS, handles.settings.id.Trej_nopulse:handles.settings.id.Trej_other);
    
    % All trials
    handles.TMS_temp.all = handles.TMS;
    
    % Get fieldnames
    names = fieldnames(handles.TMS_temp);

    % Preset Filters
    available_filters = {};

    % Match current rejreasons to fields
    for it = 1:length(handles.settings.rejreasons)
        if ~isempty(handles.TMS_temp.(names{it}))
            available_filters = horzcat(available_filters, handles.settings.rejreasons(it));
        end
    end

    handles.popupmenu3.String = ['All', 'Accepted', 'Rejected', available_filters];
    handles.popupmenu4.String = ['All', 'Accepted', 'Rejected', available_filters];

end