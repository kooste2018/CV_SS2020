% Update from previous version: Now this version provide output for image segmentation, but it is still not yet capable of self updating, 
% meaning, if N=1, start=0, next(ir) will give only left and right matrices of size 600x800x((N+1)*3) from '...0000.jpg' and '....0001.jpg'

% if '...0004.jpg' and '....0005.jpg' are needed, then use ImageReader(src,1,2,start,N) with start = 4, N =1 

% Future update will fix this issue, but this should at least provide output for further processing

% To use:
% 1. src = 'F:\CV\P1E_S1' or own local folder location with this format
% (format from challenge PDF)
% 2. ir = ImageReader(src,1,2,0,1)
% 3. [left,right,loop]=next(ir);
classdef ImageReader
  % Define properties needed to process two of the three video streams from a scene folder and play endless loop
    properties  
        l               % L         Linkes Bild, die Werte{1,2}
        r               % R         Rechtes Bild, die Werte{2,3}
        Start = 0;      % start     Anfangsnummer für Lesevorgang
        n = 1;          % N         Endnummer für Lesevorgang
        Loop = 0;       % Loop
    end
    % How do we do this shit
    methods
        % Image Reader 
        % src standard input: 'F:\CV\P1E_S1'
        function ir = ImageReader(src, L, R, varargin)     
            if (L==R)
                fprintf('L and R must be different!\n');
                L = 3;
            end
            % Validation requirement
            L_validation = @(x) isnumeric(x) && (x==1) || (x==2);
            R_validation = @(x) isnumeric(x) && (x==3) || (x==2);
            start_validation = @(x) isnumeric(x);
            N_validation = @(x) isnumeric(x);
            % Input Parser
            p=inputParser;
            % Dateipfad zu Szenenordner
            p.addRequired('src');
            p.addRequired('L',L_validation);
            p.addRequired('R',R_validation);
            p.addOptional('start',ir.Start,start_validation);
            p.addOptional('N',ir.n,N_validation);
            p.parse(src, L, R, varargin{:});
            % Input into data
            ir.l = append(src,'_C',string(p.Results.L),'\'); % Standard l input _C1
            ir.r = append(src,'_C',string(p.Results.R),'\'); % Standard r input _C3
            ir.Start = p.Results.start;
            ir.n = p.Results.N;
            % Expected Output:
            % ImageReader with properties:
            % l: "F:\CV\P1E_S1_C1\"
            % r: "F:\CV\P1E_S1_C2\"
            % Start: 3
            % n: 4
        end
    end
    methods
        % Laden von Bildern
        function [left, right, loop] = next(ir)
            left = [];
            right = [];
            loop = 0;
            data_L = dir([ir.l,'*.jpg']);
            %%here I have error. check help site of dir. You want to list all jpg files but you may first enter the pfad by cd.
            data_R = dir([ir.r,'*.jpg']);
            Size_L = length(data_L);  % Size_R = length(data_R); Size_R = Size_L;
            Size = Size_L; % z.B. 2292 images
            im_list_L = [data_L.name];
            im_list_L = cellstr(reshape((im_list_L),12,[])');
            im_list_R = [data_R.name];
            im_list_R = cellstr(reshape((im_list_R),12,[])');
            % When will it end
            if ir.n+ir.Start > Size % im Ordner nicht mehr genuegend Bilder zur Verfuegung stehen
                END = Size;
                loop = 1;
            else
                END = ir.Start+ir.n;
            end
            % Left & right
            for counter = ir.Start:END
                % Write source by combining ir.l / ir.r with ir.Start 
                % Result: F:\CV\P1E_S1_C1\00000001.jpg
                left_src = [ir.l,char(im_list_L(counter_l+1))];
                right_src = [ir.r,char(im_list_R(counter_r+1))];
                % Determine values inside
                left = cat(3,left,imread(left_src));
                left_value = im_list_L(counter_l+1);
                fprintf(1, 'Left value: %s \n', left_value{:})
                right = cat(3,right,imread(right_src));
                right_value = im_list_R(counter_r+1);
                fprintf(1, 'Right value: %s \n', right_value{:})
            end
        end
    end
end
