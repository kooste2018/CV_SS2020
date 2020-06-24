%% Computer Vision Challenge 2020 config.m

%% Generall Settings
% Group number:
group_number = 35;

% Group members:
members = {'Jiangnan Huang', 'Zhiwei Lin','Nan Chen', 'Ivan Hartono'};

% Email-Address (from Moodle!):
mail = {'jiangnan.huang@tum.de', 'daten.hannes@tum.de'};


%% Setup Image Reader
% Specify Scene Folder
src = "Path/to/my/ChokePoint/P1E_S1";

% Select Cameras
L =1
R =2

% Choose a start point
start = randi(1000)

% Choose the number of succseeding frames
N =1

ir = ImageReader(src, L, R, start, N);


%% Output Settings
% Output Path
dst = "C:\master\learning materials\CV\challenge\output.avi";

% Load Virual Background
bg = imread("C:\master\learning materials\CV\challenge\bg1.jpg")

% Select rendering mode
mode = "substitute";

% Create a movie array
movie=cell(1,1000);
if start == 0
    for i=1:1000
        movie{i}=0;
    end
end

% Store Output?
store = true;
