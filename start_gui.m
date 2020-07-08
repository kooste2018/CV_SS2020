% To call variable in workspace:
% Example: mode = evalin('base','render_mode')
% base means it is variable pinned in base workspace, saved into mode

% Initialization of GUI, DO NOT EDIT THIS PART
function varargout = start_gui(varargin)
% START_GUI MATLAB code for start_gui.fig
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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
% End initialization code - DO NOT EDIT PART ABOVE

% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, ~, handles, varargin)
    % Choose default command line output for GUI
    handles.output = hObject;
    % Update handles structure
    guidata(hObject, handles);
    % Clear axes scale of image figure
    axis off
    
% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(~, ~, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;

function Left_Image_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Right_Image_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Start_Point_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Succeed_Frames_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% -------------------------------------------------------------------- %
% ----------------------------CALLBACKS------------------------------- %
% -------------------------------------------------------------------- %

% --------------- Choose Data Path Input Group ----------------------- %
% --- Executes on button press in Main_Working_Folder.
function Main_Working_Folder_Callback(~, ~, handles)
%% Idea source: https://www.youtube.com/watch?v=7EmFShs5y9I&feature=youtu.be^
    % Open browse folder popup window and save chosen folder path 
    folderpath = uigetdir('Search Location of Main Working Folder');
    % Show folder path taken
    set(handles.Path_Name, 'string', folderpath);
    assignin('base','FolderPath',folderpath);

% --- Executes on selection change in Left_Image.
function Left_Image_Callback(hObject, ~, ~)
    % Get cell containing values from string {1,2}
    contents = cellstr(get(hObject,'String'));
    % Read which is the chosen value from cell 
    left_choice = contents(get(hObject,'Value'));
    % Pin value on base workspace
    assignin('base','l',str2double(left_choice));

% --- Executes on selection change in Right_Image.
function Right_Image_Callback(hObject, ~, ~)
    % Get cell containing values from string {2,3}
    contents = cellstr(get(hObject,'String'));
    % Read which is the chosen value from cell 
    right_choice = contents(get(hObject,'Value'));
    % Pin value on base workspace
    assignin('base','r',str2double(right_choice));
    
% -- Executes on selection change in Start_Point.
function Start_Point_Callback(~, ~, handles)
    % Save value in Start_Point as string in variable StartPoint
    StartPoint = get(handles.Start_Point,'String');
    % Pin value on base workspace
    assignin('base','StartPoint',str2double(StartPoint));
    
% -- Executes on selection change in Succeed_Frames.
function Succeed_Frames_Callback(~, ~, handles)
    % Save value in Succeed_Frames as string in variable Succeed_Frames
    Succeed_Frames = get(handles.Succeed_Frames,'String');
    % Pin value on base workspace
    assignin('base','Succeed_Frames',str2double(Succeed_Frames));
    
% --------------- Choose Processing Mode ----------------------- %
% --- Executes on button press in Start_btn.
function Start_btn_Callback(~, ~, handles)
    % Start process by considering stop button as not pressed
    set(handles.Stop_btn, 'userdata', 0);
    % get pinned value StartPoint from base workspace
    i=evalin('base','StartPoint');
    % generate loop starting from Startpoint ending in Succeed_Frame
    while i< evalin('base','Succeed_Frames')
        % update loop
        i=i+1;
        % write loop number
        message = sprintf('i = %d', i);
        set(handles.output_val, 'string', message);
        % add pause for easier observation
        pause(0.1);
        % update figures and updates (including i value written on message)
        drawnow
        % Stop button if pressed will stop loop
        if get(handles.Stop_btn, 'userdata')
            break;
        end
        % If Loop Check is activated, start non-terminating loop 
        if i == evalin('base','Succeed_Frames')&& handles.Loop_check.Value
            i = 1;
        end
    end
% --- Executes on button press in Stop_btn.
function Stop_btn_Callback(~, ~, handles)
    set(handles.Stop_btn,'userdata',1)
% --- Executes on button press in Loop_check.
function Loop_check_Callback(~, ~, ~)
% --- Executes on button press in Save_btn.
function Save_btn_Callback(~, ~, ~)
    % Open save window and determine saved file format name as output.dat
    % (to be changed to avi)
    [filename, pathname] = uiputfile('output.dat');
    path_file = fullfile(pathname,filename);
    a = fopen(path_file,'wt');
    fprintf(a,'Choose Save Location');
    fclose('all');

% --------------- Choose Rendering Mode ----------------------- %
% --- Executes when selected object is changed in Rendering_Mode.
function Rendering_Mode_SelectionChangedFcn(~, eventdata, handles)
    % uppdate value for render_mode for config.m later
    switch(get(eventdata.NewValue,'Tag'))
        case 'Foreground'
            render_mode = get(handles.Foreground,'string');
        case 'Background'
            render_mode = get(handles.Background,'string');
        case 'Overlay'
            render_mode = get(handles.Overlay,'string');
        case 'Substitute'
            render_mode = get(handles.Substitute,'string');
    end
    % Pin value on base workspace
    assignin('base','render_mode',render_mode);
