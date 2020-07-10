% To call variable in workspace:
% Example: mode = evalin('base','render_mode')
% base means it is variable pinned in base workspace, saved into mode

% Initialization of GUI, DO NOT EDIT THIS PART
function varargout = start_gui(varargin)
% Last Modified by GUIDE v2.5 10-Jul-2020 09:55:47
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

% --- Executes during object creation, after setting all properties.
function Szene_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Portal_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function E_L_CreateFcn(hObject, eventdata, handles)
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
    assignin('base','folderpath',folderpath);

% --- Executes on selection change in Portal.
function Portal_Callback(hObject, eventdata, handles)
    % Get cell containing values from string {2,3}
    contents = cellstr(get(hObject,'String'));
    % Read which is the chosen value from cell 
    choice = contents(get(hObject,'Value'));
    % Pin value on base workspace
    assignin('base','Portal',string(choice));

% --- Executes on selection change in E_L.
function E_L_Callback(hObject, eventdata, handles)
    % Get cell containing values from string {2,3}
    contents = cellstr(get(hObject,'String'));
    % Read which is the chosen value from cell 
    choice = contents(get(hObject,'Value'));
    % Pin value on base workspace
    if strcmp(string(choice),"Enter")
        assignin('base','E_L','E');
    else
        assignin('base','E_L','L');
    end

% --- Executes on selection change in Szene.
function Szene_Callback(hObject, eventdata, handles)
    % Get cell containing values from string {2,3}
    contents = cellstr(get(hObject,'String'));
    % Read which is the chosen value from cell 
    choice = contents(get(hObject,'Value'));
    % Pin value on base workspace
    assignin('base','Szene',string(choice));

% --- Executes on button press in bg_location.
function bg_location_Callback(hObject, eventdata, handles)
    % Open browse folder popup window and save chosen folder path 
    [bgfile,bgpath] = uigetfile('*.jpg');
    bgpath_true = strcat(bgpath,bgfile);
    % Show folder path taken
    set(handles.BG_path_name, 'string', bgpath_true);
    % assign bg
    assignin('base','bg',im2double(imread(bgpath_true)));
        
% --- Executes on selection change in Left_Image.
function Left_Image_Callback(hObject, ~, handles)
    % Get cell containing values from string {1,2}
    contents = cellstr(get(hObject,'String'));
    % Read which is the chosen value from cell 
    left_choice = contents(get(hObject,'Value'));
    % Pin value on base workspace
    assignin('base','L',str2double(left_choice));
    % if left is 2, then right can only be 3
    if evalin('base','L')==2
        assignin('base','R',3);
        set(handles.Right_Image,'enable','off');
    else
        set(handles.Right_Image,'enable','on');
    end

% --- Executes on selection change in Right_Image.
function Right_Image_Callback(hObject, ~, handles)
    % Get cell containing values from string {2,3}
    contents = cellstr(get(hObject,'String'));
    % Read which is the chosen value from cell 
    right_choice = contents(get(hObject,'Value'));
    % Pin value on base workspace
    assignin('base','R',str2double(right_choice));
    
% -- Executes on selection change in Start_Point.
function Start_Point_Callback(~, ~, handles)
    % Save value in Start_Point as string in variable StartPoint
    StartPoint = get(handles.Start_Point,'String');
    % Pin value on base workspace
    assignin('base','start',str2double(StartPoint));
    
% -- Executes on selection change in Succeed_Frames.
function Succeed_Frames_Callback(~, ~, handles)
    % Save value in Succeed_Frames as string in variable Succeed_Frames
    Succeed_Frames = get(handles.Succeed_Frames,'String');
    % Pin value on base workspace
    assignin('base','N',str2double(Succeed_Frames));
    
% --------------- Choose Processing Mode ----------------------- %
% --- Executes on button press in Start_btn.
function Start_btn_Callback(hObject, eventdata, handles)
    % Start process by considering stop button as not pressed
    set(handles.Stop_btn, 'userdata', 0);
    % render all button for parameter unchangeable
    set([handles.Main_Working_Folder,handles.bg_location,handles.Save_btn, handles.Portal, handles.E_L, handles.Szene],'enable','off');
    set([handles.Left_Image, handles.Right_Image, handles.Start_Point, handles.is_save, handles.Succeed_Frames],'enable','off');
    set([handles.Foreground,handles.Background,handles.Substitute,handles.Overlay, handles.Loop_check],'enable','off');
    if ispc
        used_Data = strcat(evalin('base','folderpath'),'\',evalin('base','Portal'),evalin('base','E_L'),'_',evalin('base','Szene'));
    else
        if ismac||isunix
            used_Data = strcat(evalin('base','folderpath'),'/',evalin('base','Portal'),evalin('base','E_L'),'_',evalin('base','Szene'));
        else
            error("System not supported!\n");
        end
    end
    % Define src variable by combining folder path with chosen portal,
    % entry method, and scene
    assignin('base','src',used_Data);
    set(handles.Used_Data_Points, 'string', used_Data);
    % get pinned value StartPoint from base workspace
    start = evalin('base','start');
    loop = handles.Loop_check.Value;
    src = evalin('base','src');
    L = evalin('base','L');
    R = evalin('base','R');
    N = evalin('base','N');
    %index for movie, for loop later
    i = 1;
    % Create a movie array
    movie=cell(1,5000);
    % From this part start processing using challenge.m algorithm
    % Image Reading part
    ir = ImageReader(src, L, R, start, N);
    while loop ~= 1
    % Get next image tensors
        [left,right,loop]=next(ir);
    % Generate binary mask
        mask=segmentation(left,right);
    % Render new frame
        frame=left(:,:,1:3);
        result = im2uint8(render(frame,mask,bg,mode));
        %double not work due to precision error, memory error and so on
        movie(i)={result};
        i=i+1;
    end
 %% Write Movie to Disk
    if evalin('base','store') 
        writerObj = VideoWriter(dst,'Motion JPEG AVI');
        % create the video writer with 1 fps
        writerObj.FrameRate = 5;
        % open the video writer
        open(writerObj);
        %clip movie, delete blank frames
        movie=movie(1:i-1);
        % write the frames to the video
        for u=1:length(movie)
            % convert the image to a frame
            frame = im2frame(movie{u});
            writeVideo(writerObj, frame);
        end
        % close the writer object
        close(writerObj);
    end   
    % generate loop starting from Startpoint ending in Succeed_Frame
    while i< evalin('base','N')+i
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
        if i == evalin('base','N')&& handles.Loop_check.Value
            i = 1;
        end
    end
    
    obj = VideoReader('E:\Download\CV_2020_G35-master\CV_2020_G35-master\output.avi');%path of video
    % obj = VideoReader(dst)
    numFrames = obj.NumFrames;% number of frames
	for i = 1 : numFrames	
        frame = read(obj,i);%read the current frame
        axes(handles.Image_Show)
        imshow(frame);%show frame
        %imwrite(frame,strcat('D:\Project\Pictures\',num2str(i),'.jpg'),'jpg');%save the frames
    end
    % turn all button on again
    set([handles.Main_Working_Folder,handles.bg_location,handles.Save_btn, handles.Portal, handles.E_L, handles.Szene],'enable','on');
    set([handles.Left_Image, handles.Right_Image, handles.Start_Point, handles.is_save, handles.Succeed_Frames],'enable','on');
    set([handles.Foreground,handles.Background,handles.Substitute,handles.Overlay, handles.Loop_check],'enable','on');
    % if data is saved
    if handles.is_save.Value
       save_message = sprintf('save successful');
    else
        save_message = sprintf('Data not saved');
    end
    set(handles.Save_status, 'string', save_message);

% --- Executes on button press in Stop_btn.
function Stop_btn_Callback(~, ~, handles)
    set(handles.Stop_btn,'userdata',1)

% --- Executes on button press in Loop_check.
function Loop_check_Callback(hObject, eventdata, handles)

% --- Executes on button press in is_save.
function is_save_Callback(hObject, eventdata, handles)
    if handles.is_save.Value
        assignin('base','store',1);
    else
        assignin('base','store',0);
    end
    
% --- Executes on button press in Save_btn.
function Save_btn_Callback(~, ~, ~)
    % Open save window and determine saved file format name as output.dat
    % (to be changed to avi)
    [filename, pathname] = uiputfile('output.avi');
    path_file = fullfile(pathname,filename);
    a = fopen(path_file,'wt');
    fprintf(a,'Choose Save Location');
    fclose('all');
    if ispc||ismac||isunix
        dst = strcat(pathname,'output.avi');
    else
        error("System not supported!\n");
    end
    assignin('base','dst',dst);
    

% --------------- Choose Rendering Mode ----------------------- %
% --- Executes when selected object is changed in Rendering_Mode.
function Rendering_Mode_SelectionChangedFcn(~, eventdata, handles)
    % uppdate value for render_mode for config.m later
    switch(get(eventdata.NewValue,'Tag'))
        case 'Foreground'
            render_mode = get(handles.Foreground,'string');
            set(handles.bg_location,'enable','on');
        case 'Background'
            render_mode = get(handles.Background,'string');
            set(handles.bg_location,'enable','on');
        case 'Overlay'
            render_mode = get(handles.Overlay,'string');
            set(handles.bg_location,'enable','on');
        case 'Substitute'
            render_mode = get(handles.Substitute,'string');
            set(handles.bg_location,'enable','off');
    end
    % Pin value on base workspace
    assignin('base','mode',render_mode);
