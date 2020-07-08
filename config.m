%% Computer Vision Challenge 2020 config.m

%% Generall Settings
% Group number:
group_number = 35;

% Group members:
members = {'Jiangnan Huang', 'Zhiwei Lin','Nan Chen', 'Ivan Hartono'};

% Email-Address (from Moodle!):
mail = {'jiangnan.huang@tum.de', 'zhiwei.lin@tum.de','nan.chen@tum.de','hartono.ivan@tum.de'};


%% Setup Image Reader
% Specify Scene Folder
if ispc
    src = strcat(pwd,'\originalfiles\P1E_S1');
else
    if ismac||isunix
        src = strcat(pwd,'/originalfiles/P1E_S1');
    else
        error("System not supported!\n");
    end
end

% Select Cameras
L =1;
R =2;

% Choose a start point
start = randi(1000);
start=291;

% Choose the number of succseeding frames
N =2;

%get object
ir = ImageReader(src, L, R, start, N);

%set loop 
loop=0;

%% Output Settings
% Output Path
if ispc
    dst = strcat(pwd,'\output.avi');
else
    if ismac||isunix
        dst = strcat(pwd,'/output.avi');
    else
        error("System not supported!\n");
    end
end

% Load Virual Background
if ispc
    bgpath = strcat(pwd,'\bg\bg1');
else
    if ismac||isunix
        bgpath = strcat(pwd,'/bg/bg1');
    else
        error("System not supported!\n");
    end
end
bg = im2double(imread(bgpath));

% Select rendering mode
mode = "substitute";

% Create a movie array
movie=cell(1,5000);
movie_flag=0;

%index for movie, for loop later
i=1;

% Store Output?
store = true;
