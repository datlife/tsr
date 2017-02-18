function [data] = validateGraphType(hObject,handles)

    current_rdbtn  = get(handles.grbGraphType,'SelectedObject');
    current_fit_option = get(current_rdbtn,'Tag');
    
    switch current_fit_option
        case 'rbnOD'
           data = getappdata(hObject,'coeff');
        case 'rbn1D'
             data = getappdata(hObject,'coeff1D');        
        case 'rbn2D'
             data = getappdata(hObject,'coeff2D');  
    end

 end 