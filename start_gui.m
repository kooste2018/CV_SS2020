function varargout = start_gui(varargin)
% START_GUI MATLAB code for start_gui.fig
%      START_GUI, by itself, creates a new START_GUI or raises the existing
%      singleton*.
%
%      H = START_GUI returns the handle to a new START_GUI or the handle to
%      the existing singleton*.
%
%      START_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in START_GUI.M with the given input arguments.
%
%      START_GUI('Property','Value',...) creates a new START_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before start_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to start_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help start_gui

% Last Modified by GUIDE v2.5 06-Jul-2020 19:25:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @start_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @start_gui_OutputFcn, ...
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


% --- Executes just before start_gui is made visible.
function start_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to start_gui (see VARARGIN)

% Choose default command line output for start_gui
handles.output = hObject;
sp = get(handles.edit_startpunkt,'String');
SRC = get(handles.popupmenu_szen,'String');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes start_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = start_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in togglebutton_start.
function togglebutton_start_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_start
    global src
    global start
    if get(handles.togglebutton_start,'value') == 1
        set(handles.togglebutton_stop,'value',0);
        set(handles.togglebutton_loop,'value',0);
        set(handles.togglebutton_start,'value',1);
        % test
        axes(handles.axes1)
        im = imread('00000000.jpg');
        imshow(im);
    %else
    end
% functions go here



% --- Executes on button press in togglebutton_loop.
function togglebutton_loop_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_loop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_loop
    if get(handles.togglebutton_loop,'value') == 1
        set(handles.togglebutton_loop,'value',1);
        set(handles.togglebutton_start,'value',0);
        set(handles.togglebutton_stop,'value',0);
    %else
    end
% functions go here


% --- Executes on button press in togglebutton_stop.
function togglebutton_stop_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_stop
    if get(handles.togglebutton_stop,'value') == 1
        set(handles.togglebutton_stop,'value',1);
        set(handles.togglebutton_start,'value',0);
        set(handles.togglebutton_loop,'value',0);
    %else
    end
% functions go here


function edit_startpunkt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_startpunkt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_startpunkt as text
%        str2double(get(hObject,'String')) returns contents of edit_startpunkt as a double
    global start
    start = str2double(get(hObject,'string'));
    %start = str2num(start);
    

% --- Executes during object creation, after setting all properties.
function edit_startpunkt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_startpunkt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_virtuell.
function popupmenu_virtuell_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_virtuell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_virtuell contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_virtuell
    global bg
    valbg = get(hObject,'Value');
    switch valbg
        case 1  % 
            bg = 0;
        case 2  %bg1
            bg = 'bg1'; 
        case 3  %bg2
            bg = 'bg2';
        case 4  %bg3
            bg = 'bg3';
    end
    % functions go here


% --- Executes during object creation, after setting all properties.
function popupmenu_virtuell_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_virtuell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_szen.
function popupmenu_szen_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_szen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_szen contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_szen
    global src
    valszenen = get(hObject,'Value');
    switch valszenen
        case 1  % first line
            src = 0;
        case 2  %P1E_S1
            src = '......P1E_S1'; % noch nicht vollständig
        case 3  %P1E_S2
            src = '......P1E_S2';
        case 4  %P1E_S3
            src = '......P1E_S3';
        case 5  %P1E_S4
            src = '......P1E_S4';
        case 6  %P1L_S1
            src = '......P1L_S1';
        case 7  %P1L_S2
            src = '......P1L_S2';
        case 8  %P1L_S3
            src = '......P1L_S3';
        case 9  %P1L_S4
            src = '......P1L_S4';
        case 10 %P2E_S1
            src = '......P2E_S1';
        case 11 %P2E_S2
            src = '......P2E_S2';
        case 12 %P2E_S3
            src = '......P2E_S3';
        case 13 %P2E_S4
            src = '......P2E_S4';
        case 14 %P2E_S5
            src = '......P2E_S5';
        case 15 %P2L_S1
            src = '......P2L_S1';
        case 16 %P2L_S2
            src = '......P2L_S2';
        case 17 %P2L_S3
            src = '......P2L_S3';
        case 18 %P2L_S4
            src = '......P2L_S4';
        case 19 %P2L_S5
            src = '......P2L_S5';
    end
 

% --- Executes during object creation, after setting all properties.
function popupmenu_szen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_szen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_foreground.
function radiobutton_foreground_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_foreground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_foreground
if(get(hObject,'Value')==get(hObject,'Max'))
    % foregroundfcn
else
    
end


% --- Executes on button press in radiobutton_background.
function radiobutton_background_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_background (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_background
if(get(hObject,'Value')==get(hObject,'Max'))
    % backgroundfcn
else
    
end


% --- Executes on button press in radiobutton_overlay.
function radiobutton_overlay_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_overlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_overlay
if(get(hObject,'Value')==get(hObject,'Max'))
    % overlayfcn
else
    
end


% --- Executes on button press in radiobutton_substitute.
function radiobutton_substitute_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_substitute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_substitute
if(get(hObject,'Value')==get(hObject,'Max'))
    % substituefcn
else
    
end