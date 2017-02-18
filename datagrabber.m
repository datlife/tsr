function [ sound, defect ] = datagrabber(handles,hObject)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
hFigure = handles.figure1;
cursorMode = datacursormode(gcf);
set(cursorMode, 'enable','on');
set(cursorMode,'DisplayStyle','datatip',...
'SnapToDataVertex','off','Enable','on');
info = getCursorInfo(cursorMode);

if ~isempty(info)
sound = info(1).Position;
setappdata(hObject.Parent,'soundData',[143, 145]);
defect= info(2).Position;
setappdata(hObject.Parent,'defectData',defect);
end
end


