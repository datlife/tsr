function [image] =  validateFitMethod(hObject,current_frame,handles)
%Validate current selected fitting method

    current_rdbtn  = get(handles.grbFitMethod,'SelectedObject');
    current_fit_option = get(current_rdbtn,'Tag');
    switch current_fit_option
        case 'rbnRaw'
         %Regular data  
          data1 = getappdata(hObject.Parent,'tempdata');
          image = data1(:,:,current_frame);
        case 'rbnPlFit'
           %Polynominal fit
          data = validateGraphType(hObject.Parent,handles);
          image = generateImage(handles,data,current_frame);      
        case 'rbnInterp'
        case 'rbnSpline'
       %default case
       
    end
end

