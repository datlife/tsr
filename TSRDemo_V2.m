function varargout = TSRDemo_V2(varargin)
% TSRDEMO_V2 MATLAB code for TSRDemo_V2.fig
%      TSRDEMO_V2, by itself, creates a new TSRDEMO_V2 or raises the existing
%      singleton*.
%
%      H = TSRDEMO_V2 returns the handle to a new TSRDEMO_V2 or the handle to
%      the existing singleton*.
%
%      TSRDEMO_V2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TSRDEMO_V2.M with the given input arguments.
%
%      TSRDEMO_V2('Property','Value',...) creates a new TSRDEMO_V2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TSRDemo_V2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TSRDemo_V2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TSRDemo_V2

% Last Modified by GUIDE v2.5 27-Jul-2016 10:44:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TSRDemo_V2_OpeningFcn, ...
                   'gui_OutputFcn',  @TSRDemo_V2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before TSRDemo_V2 is made visible.
function TSRDemo_V2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TSRDemo_V2 (see VARARGIN)

% Choose default command line output for TSRDemo_V2
handles.output = hObject;
  %HIDE ALL THE DATA
    set(handles.staticMaterial,'visible','off');
    set(handles.popupmenu1,'visible','off');
    set(handles.grbFitMethod,'visible','off');
    set(handles.grbFitMethod,'visible','off');
    set(handles.grbGraphType,'visible','off');
    set(handles.grbEnhancement,'visible','off');
    set(handles.grbData,'visible','off');
    set(handles.chkCursor,'visible','off');
    set(handles.btnShowImage,'enable','off');
    set(handles.txtStatus,'enable','off');
    set(handles.txtCurrentFrame,'enable','off');
    set(handles.txtTime,'enable','off');
    set(handles.grbFitMethod,'Selectedobject',handles.rbnRaw);
    set(handles.grbGraphType,'Selectedobject',handles.rbnOD);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TSRDemo_V2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TSRDemo_V2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnImport.
function btnImport_Callback(hObject, eventdata, handles)

    [filename, path] = uigetfile('*.mat','Select .mat file');
    result = 'N/A';
    if isequal(filename,0)
       disp('User selected Cancel');
       result = 'User cancelled';
    else  
       full_path = fullfile(path,filename);
       load (full_path);
       %initialize data into guidata
       guidata(hObject,handles);
       setappdata(hObject.Parent,'tempdata',Data);  
       %Trying to display thermal data at frame 15
        displayImage(hObject,15,handles);
        setappdata(hObject.Parent,'frame',15);
        set(handles.txtCurrentFrame,'string',15);

        set(handles.txtTime,'string',gettime(15));
        set(handles.sliTime,'Max',size(Data,3));
        set(handles.sliTime,'Value',15);
        
        %Show hidden data
        set(handles.staticMaterial,'visible','on');
        set(handles.popupmenu1,'visible','on');
        set(handles.grbFitMethod,'visible','on');
        set(handles.grbGraphType,'visible','on');
        set(handles.grbEnhancement,'visible','on');

        set(handles.btn2D,'visible','on');
        set(handles.btn3D,'visible','on');
        set(handles.txtCurrentFrame,'enable','on');
        set(handles.txtTime,'enable','on');
     %Analyze COEEFICENT for all pixels   
       set(handles.txtStatus,'string','Processing Data... It may takes up to 3 minutes.');
       [coeff, coeff_1D, coeff_2D] = processData(Data);
       set(handles.chkCursor,'visible','on');
       setappdata(hObject.Parent,'coeff',coeff);
       setappdata(hObject.Parent,'coeff1D',coeff_1D);
       setappdata(hObject.Parent,'coeff2D',coeff_2D);

       result = ['Loaded successfully: ', filename];

    end
set(handles.txtStatus,'string',result);

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function txtCurrentFrame_Callback(hObject, eventdata, handles)
% hObject    handle to txtCurrentFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        value = hObject.String;
        if(isstrprop(value,'digit'))
             frame = round(str2double(value));
             %initialize data into guidata
             displayImage(hObject, frame,handles);
             setappdata(hObject.Parent,'frame', frame);
             set(hObject.txtTime,'string',gettime(frame));
             set(handles.sliTime,'Value', frame);
        end
% Hints: get(hObject,'String') returns contents of txtCurrentFrame as text
%        str2double(get(hObject,'String')) returns contents of txtCurrentFrame as a double


% --- Executes during object creation, after setting all properties.
function txtCurrentFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtCurrentFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtStatus_Callback(hObject, eventdata, handles)
% hObject    handle to txtStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtStatus as text
%        str2double(get(hObject,'String')) returns contents of txtStatus as a double


% --- Executes during object creation, after setting all properties.
function txtStatus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnShowImage.
function btnShowImage_Callback(hObject, eventdata, handles)
% hObject    handle to btnShowImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  S = getappdata(hObject.Parent,'soundData');
  D =  getappdata(hObject.Parent,'defectData');
  data = getappdata(hObject.Parent,'tempdata');
  sound = squeeze(data(S(2),S(1),:));
  defect = squeeze(data(D(2),D(1),:));
  graphNDT(sound,defect);




% --- Executes on slider movement.
function sliTime_Callback(hObject, eventdata, handles)
% hObject    handle to sliTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if(strcmp(handles.txtCurrentFrame.Enable,'on'))
        current_frame = round(hObject.Value);
        if(current_frame >0)
            %GENERATE IMAGE
            %CHECK WHICH OPTION IS SELECTED
           displayImage(hObject,current_frame,handles);
           set(handles.txtCurrentFrame,'String',current_frame);
           set(handles.txtTime,'String',gettime(current_frame));
           setappdata(hObject.Parent,'frame',current_frame);
        end
    end
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in btn2D.
function btn2D_Callback(hObject, eventdata, handles)
% hObject    handle to btn2D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     data = getappdata(hObject.Parent,'tempdata');
     frame = getappdata(hObject.Parent,'frame');  
    displayImage(hObject.Parent, frame,handles);
     colorbar;
     set(handles.btn2D,'enable','off');
     set(handles.btn3D,'enable','on');
     set(handles.chkCursor,'visible','on');

% --- Executes on button press in btn3D.
function btn3D_Callback(hObject, eventdata, handles)
% hObject    handle to btn3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    data = getappdata(hObject.Parent,'tempdata');
     frame = getappdata(hObject.Parent,'frame');  
     displayImage(hObject.Parent, frame,handles); 
     colorbar;
     set(handles.btn3D,'enable','off');
     set(handles.btn2D,'enable','on');
     set(handles.chkCursor,'visible','off');


% --- Executes on button press in chkCursor.
function chkCursor_Callback(hObject, eventdata, handles)
% hObject    handle to chkCursor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 if (get(hObject,'Value') == get(hObject,'Max'))   
     set(handles.grbData,'visible','on');
     set(handles.btnShowImage,'enable','on'); 
     [sound, defect] = datagrabber(handles,hObject);
      set(handles.XSound,'String', sound(1,1));
      set(handles.YSound,'String', sound(1,2));
      set(handles.XDefect,'String', defect(1,1));
      set(handles.YDefect,'String', defect(1,2));
 else
      set(handles.grbData,'visible','off');
     set(handles.btnShowImage,'enable','off');
 end
% Hint: get(hObject,'Value') returns toggle state of chkCursor


% --- Executes on button press in rbnOD.
function rbnOD_Callback(hObject, eventdata, handles)
% hObject    handle to rbnOD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbnOD


% --- Executes on button press in rbn1D.
function rbn1D_Callback(hObject, eventdata, handles)
% hObject    handle to rbn1D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbn1D


% --- Executes on button press in rbn2D.
function rbn2D_Callback(hObject, eventdata, handles)
% hObject    handle to rbn2D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbn2D


% --- Executes on button press in chkMedianFilter.
function chkMedianFilter_Callback(hObject, eventdata, handles)
% hObject    handle to chkMedianFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 current_state = get(hObject,'Value');
    frame =  getappdata(hObject.Parent.Parent,'frame');
    displayImage(hObject.Parent, frame,handles);
% Hint: get(hObject,'Value') returns toggle state of chkMedianFilter


% --- Executes on button press in chkNormalize.
function chkNormalize_Callback(hObject, eventdata, handles)
% hObject    handle to chkNormalize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  frame =  getappdata(hObject.Parent.Parent,'frame');
    displayImage(hObject.Parent, frame,handles);
% Hint: get(hObject,'Value') returns toggle state of chkNormalize


% --- Executes during object creation, after setting all properties.
function grbFitMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grbFitMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in rbnRaw.
function rbnRaw_Callback(hObject, eventdata, handles)
% hObject    handle to rbnRaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    frame =  getappdata(hObject.Parent.Parent,'frame');
    displayImage(hObject.Parent, frame,handles);
% Hint: get(hObject,'Value') returns toggle state of rbnRaw


% --- Executes on button press in rbnPlFit.
function rbnPlFit_Callback(hObject, eventdata, handles)
% hObject    handle to rbnPlFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    frame =  getappdata(hObject.Parent.Parent,'frame');
    displayImage(hObject.Parent, frame,handles);
 
% Hint: get(hObject,'Value') returns toggle state of rbnPlFit


% --- Executes on button press in rbnInterp.
function rbnInterp_Callback(hObject, eventdata, handles)
% hObject    handle to rbnInterp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    frame =  getappdata(hObject.Parent.Parent,'frame');
    displayImage(hObject.Parent, frame,handles);
% Hint: get(hObject,'Value') returns toggle state of rbnInterp


% --- Executes on button press in rbnSpline.
function rbnSpline_Callback(hObject, eventdata, handles)
% hObject    handle to rbnSpline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    frame =  getappdata(hObject.Parent.Parent,'frame');
    displayImage(hObject.Parent, frame,handles);
% Hint: get(hObject,'Value') returns toggle state of rbnSpline



function txtTime_Callback(hObject, eventdata, handles)
% hObject    handle to txtTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtTime as text
%        str2double(get(hObject,'String')) returns contents of txtTime as a double


% --- Executes during object creation, after setting all properties.
function txtTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
