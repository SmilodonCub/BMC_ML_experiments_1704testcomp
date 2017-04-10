%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%_______  _______ _________ _______  _______  _______  _______  _______          
%(  ____ \(  ___  )\__   __/(  ____ \(  ____ \(  ___  )(  ____ )(  ____ \|\     /|
%| (    \/| (   ) |   ) (   | (    \/| (    \/| (   ) || (    )|| (    \/| )   ( |
%| |      | (___) |   | |   | (_____ | (__    | (___) || (____)|| |      | (___) |
%| |      |  ___  |   | |   (_____  )|  __)   |  ___  ||     __)| |      |  ___  |
%| |      | (   ) |   | |         ) || (      | (   ) || (\ (   | |      | (   ) |
%| (____/\| )   ( |   | |   /\____) || (____/\| )   ( || ) \ \__| (____/\| )   ( |
%(_______/|/     \|   )_(   \_______)(_______/|/     \||/   \__/(_______/|/     \|
%                                                                                 
%                                                                                               
%
% 
%            _                           _               __        
%           | |                         | |             /  |       
%   ___ __ _| |_ ___  ___  __ _ _ __ ___| |__      _ __ `| |  __ _ 
%  / __/ _` | __/ __|/ _ \/ _` | '__/ __| '_ \    | '_ \ | | / _` |
% | (_| (_| | |_\__ \  __/ (_| | | | (__| | | |   | |_) || || (_| |
%  \___\__,_|\__|___/\___|\__,_|_|  \___|_| |_|   | .__/\___/\__,_|
%                                           ______| |              
%                                          |______|_|              
%   
%   monkeylogic timing script for Categorical Search tasks.
%
% This is a saccade targeting task.
% A saccade is made to a target (teddy bear object from training set) as soon as it appears.
% The target randomly appears in one of 4 possible display locations
% Then fixation is held on the target for 700ms to get a reward
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
%  _                                       _ _           _   
% (_)                                     | (_)         | |  
%  _ _ __ ___   __ _  __ _  ___   __ _  __| |_ _   _ ___| |_ 
% | | '_ ` _ \ / _` |/ _` |/ _ \ / _` |/ _` | | | | / __| __|
% | | | | | | | (_| | (_| |  __/| (_| | (_| | | |_| \__ \ |_ 
% |_|_| |_| |_|\__,_|\__, |\___| \__,_|\__,_| |\__,_|___/\__|
%                     __/ |  ______        _/ |              
%                    |___/  |______|      |__/               
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    
% image_folder = 'C:\monkeylogic\Experiments\categorical_search\training bears';
% images = dir([image_folder,	'\*.bmp']);
% Num = numel(images);
% max_width = zeros(1, Num);
% max_height = zeros(1, Num);
% Image_Names = {};
%  
% for i = 1:Num
% 	filename = images(i).name;
% 	image = imread(filename);
% 	[height, width, dim] = size(image);
% 	max_width(i) = width;
% 	max_height(i) = height;
% end
% 	
% final_width = max(max_width);
% final_height = max(max_height);	
% 
% for j = 1:Num
% 	filename2 = images(j).name;
%     image2 = imread(filename2);
% 	[height, width, dim] = size(image2);
% 	Height_add = final_height - height;
% 	Width_add = final_width - width;
% 	image_pad = padarray(image2, [Height_add, Width_add], 255, 'post');
% 	image_shift = circshift(image_pad, floor(Height_add/2), 1);
% 	image_shift = circshift(image_shift, floor(Width_add/2), 2);
%     filename2 = ['padded_' filename2];
%     Image_Names = [Image_Names {filename2}];
%     imwrite(image_shift, ['C:\Users\Public\Documents\catsearch_im\catsearch_trainingbears\' filename2]);
% end
%  
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%  _        _      __ _ _                                         _             
% | |      | |    / _(_) |                                       | |            
% | |___  _| |_  | |_ _| | ___     __ _  ___ _ __   ___ _ __ __ _| |_ ___  _ __ 
% | __\ \/ / __| |  _| | |/ _ \   / _` |/ _ \ '_ \ / _ \ '__/ _` | __/ _ \| '__|
% | |_ >  <| |_  | | | | |  __/  | (_| |  __/ | | |  __/ | | (_| | || (_) | |   
%  \__/_/\_\\__| |_| |_|_|\___|   \__, |\___|_| |_|\___|_|  \__,_|\__\___/|_|   
%            ______         ______ __/ |                                        
%           |______|       |______|___/                                         
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% target_eccentricity = 10;  %task specific
% num_positions = 4;         %task specific
% 
% tolerance = 1e-6; %when to round trig maths to zero.
% %this is done just for readability of the text file output.
% %this tolerance ( 1e-6 ) is much lower than screen resolution,
% %so there is no effect on the task for doing this
% 
% ang_position = 0 : ( 2*pi/num_positions ) : 2*pi;  %angles of postions
% vec_position = cell( num_positions,1 ); %an array of strings. each string has the formated 
% %postition vectors in deg of visual angle to be used in MonkeyLogic for
% %positioning stimuli
% 
% %calculate the target position vectors & make formated strings
% for n = 1:num_positions
%     vec_pos_x = target_eccentricity * cos( ang_position( n ) );
%     if abs( vec_pos_x ) < tolerance
%         vec_pos_x = 0;
%     end
%     vec_pos_xstr = num2str( vec_pos_x );
%     vec_pos_y = target_eccentricity * sin( ang_position( n ) );
%     if abs( vec_pos_y ) < tolerance
%         vec_pos_y = 0;
%     end
%     vec_pos_ystr = num2str( vec_pos_y );
%     vec_position( n ) = { [ vec_pos_xstr ',' vec_pos_ystr ')' ] };
% end
% 
% %calculate the possible task objects based on the number of .bmp files in
% %the task folder
% image_folder = 'C:\monkeylogic\Experiments\categorical_search\catsearch_p1a'; %folder name
% images = dir( [ image_folder,	'\*.bmp'] ); %see the bmp images in this folder's directory
% Num_targets = numel( images ); %count them --> this is how many conditions we will have
% 
% %use homemade fixation cross
% fixation = 'pic( cross_fix,0,0 )';
% 
% %create a cell array to hold the entries for the text file
% Condition_cell_array = cell( ( num_positions*Num_targets + 1 ), 6 ); %preallocate for cell array
% Condition_cell_array( 1,: ) = {'Condition', 'Frequency', 'Block', 'Timing File',...
%     'TaskObject#1', 'TaskObject#2'}; %header for the cell array
% %populate the cell array with trial values
% for k = 1:num_positions
%     for j = 1:Num_targets
%         filename = images( j ).name;
%         filetag = filename( 1:( length( filename ) - 4 ) ); 
%         pic_string = ['pic(' filetag ',' vec_position{k}];
%         Condition_cell_array( ( j + Num_targets*( k-1 ) + 1 ),: ) = { (j + Num_targets*( k-1 )),...
%             1, 1, 'catsearch_p1a', fixation, pic_string };
%     end
% end
% %write cell array as a table to a .txt file saved to the path below
% Text_table = cell2table( Condition_cell_array );
% writetable(Text_table,'C:\monkeylogic\Experiments\categorical_search\catsearch_p1a\catsearch_p1a.txt','Delimiter','\t','WriteVariableNames', false) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  _____         _    
% |_   _|       | |   
%   | | __ _ ___| | __
%   | |/ _` / __| |/ /
%   | | (_| \__ \   < 
%   \_/\__,_|___/_|\_\
% after fixation is held 4 700ms, a bear_image is presented @ 1 of 4 locations
% task variables
% block1: (initial fixation) check for good holding fixation
% block2: (bear_image presentation and response) present bear_image,
%               still at fixation?, saccade to target?, if on target is
%               hold_target_time?, if yes, goodmonkey. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                    
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% task variables
% % % give names to the TaskObjects defined in the conditions file:
fixation_point = 1;
bear_image = 2;

% define time intervals (in ms):
wait_for_fix = 1000;        %interval to wait for fixation to start
initial_fix = 1000;          %hold fixation on fixation_point
max_reaction_time = 2000;    %max time after initial_fix given to complete a saccade
saccade_time = 2000;          %time allowed for saccade
hold_target_time = 700;     %hold fixation on bear_image

% fixation window (in degrees):
fix_radius = 2;            


% initial fixation:
toggleobject(fixation_point) %toggle fixation_point on
ontarget = eyejoytrack('acquirefix', fixation_point, fix_radius, wait_for_fix);
if ~ontarget,                   %make sure fixation during wait_for_fixation
    trialerror(4); % no fixation
    toggleobject(fixation_point) %toggle fixation_point off
    return
end
ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, initial_fix);
if ~ontarget,
    trialerror(3); % broke fixation
    toggleobject(fixation_point) % toggle fixation_point off
    return
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% bear_image presentation and response
toggleobject([fixation_point bear_image]);
% simultaneously turns of fix point and displays target & distractor
[ontarget, rt] = eyejoytrack('holdfix', fixation_point, fix_radius, max_reaction_time); 
% rt will be used to update the graph on the control screen
if ontarget, % max_reaction_time has elapsed and is still on fix spot
    trialerror(1); % no response
    toggleobject([bear_image]) % toggle bear_image off
    return
end
ontarget = eyejoytrack('acquirefix', bear_image, fix_radius, saccade_time);
if ~ontarget,
    trialerror(2); % no or late response (did not land on bear_image)
    toggleobject(bear_image)
    return
end

% hold target then reward
ontarget = eyejoytrack('holdfix', bear_image, fix_radius, hold_target_time);
if ~ontarget,
    trialerror(5); % broke fixation
    toggleobject([bear_image])
    return
end
trialerror(0); % correct
%goodmonkey(50, 3); % 50ms of juice x 3

toggleobject([bear_image]); %turn off bear_image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 