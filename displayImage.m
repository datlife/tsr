function [] =  displayImage(hObject,current_frame,handles)     
   %Validate if available options are ready
      med_filt_box = get(handles.chkMedianFilter, 'Value');
      normalize_box = get(handles.chkNormalize, 'Value');    
     
     %Vingette Removal
      image = validateFitMethod(hObject,current_frame,handles);
     %Median Filter Box is checked
         if( med_filt_box  == 1.0)  
               %  image = wiener2(image);  
                image = medfilt2(image,[3 3],'symmetric');
         end
     %Normalize Filter is checked
         if( normalize_box  == 1.0)
            %Remove extreme noise 
            %Morphological enveloping filter             
         end
     %Visualize Data
         if(strcmp(handles.btn2D.Enable,'off'))
              imagesc(image);
             colormap(gray);
              colorbar;
              set(handles.txtStatus,'string',strcat('string','Frame ',num2str(current_frame),' is being displayed in 2D.'));
         else
              rotate3d on; 
              mesh(image);
              colorbar;
              set(handles.txtStatus,'string',strcat('string','Frame ',num2str(current_frame),' is being displayed. in 3D.'));
         end
