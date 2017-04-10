%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ______  __ _          _             _       _              
% | ___ \/ _| |        | |           (_)     (_)             
% | |_/ / |_| |_   _   | |_ _ __ __ _ _ _ __  _ _ __   __ _  
% | ___ \  _| | | | |  | __| '__/ _` | | '_ \| | '_ \ / _` | 
% | |_/ / | | | |_| |  | |_| | | (_| | | | | | | | | | (_| | 
% \____/|_| |_|\__, |   \__|_|  \__,_|_|_| |_|_|_| |_|\__, | 
%               __/ |_____                             __/ | 
%              |___/______|                           |___/ 
%  _____         _  ______ _ _      
% |_   _|       | | |  ___(_) |     
%   | | _____  _| |_| |_   _| | ___ 
%   | |/ _ \ \/ / __|  _| | | |/ _ \
%   | |  __/>  <| |_| |   | | |  __/
%   \_/\___/_/\_\\__\_|   |_|_|\___|
%                                   
%                                  
%   .m script to generate the fields for a txt conditions file for Bfly_traing
%   in monkeylogic. for this task, 
%   1) a category specific fixation point (blue:butterfly red:bear) appears
%   for wait_for_fix msec
%   2) subjects holds fixation for initial_fix msec
%   3) the target is presented in random position. 
%   the subject has max_reaction_time msec to complete a saccade to the
%   target. saccade_time msec are allowed for a saccade to be completed
%   4) the subject then holds fixation on the target for hold_target_time
%   msec
%
%
% 
% %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

function Bfly_Training_TextFile( target_eccentricity, fix_size, cue_size, target_index_id )
%TBEARSEARCH_TRAINING_TEXTFILE generate the text file for specific search task training with teddy bears MonkeyLogic tasks
%and appropriate fixation cue and randomly generated distractor images
%   TBearSearch_Training_TextFile takes:
%       1) target eccentricity. int or vec (to generate multiple
%       eccentricities
%       2) shift_angle. deg. this will shift the target position by a
%       set amount. converted to radians here
%       3) num_conditions --> how many random distractor groupings to
%       arrange for
%       4) cue_size (deg.vis.ang.) size of fixation during
%       target/distractor array presentation
%       5) fix_size (deg.vis.ang.) size of fixation otherwise
%       5) target_index_id --> bear target to be used consistently untill
%       training performance is achieved



%random_target = 84;     % random training target to be used consistently
timing_file = 'TBear_Training';
task_folder =  'C:\monkeylogic\Experiments\categorical_search\specific_search3_Bflies'; 

%task specific
num_positions = 45;
ang_position = (0 : ( 2*pi/num_positions ) : 2*pi);  %radial position of Crc objects
fix_rgb = [ 0 0 1]; %red fixation square. 
fix_fill = 1; %0/1 == open/filled Sqr object

%make a target position array.
objectplacement = cell( num_positions );
target_pos_str = TargetPositionString( num_positions, target_eccentricity, ang_position( 1 ), ang_position( end ) );


%organize lists of target or distractor images
images = dir( [ task_folder,	'\*.bmp'] ); %see the bmp images in this folder's directory
num_images = numel( images ); %count them --> 
num_targets = 0;
name_targets = {};
num_distractors = 0;
name_distractors = {};
for k = 1 : num_images %sort images
    
    image_name = images( k ).name;
    image_cell = cellstr( image_name );
    
    if image_name( 1 ) == 'F'
        num_targets = num_targets + 1;
        name_targets( num_targets ) = image_cell;
        
    elseif image_name( 1 ) == 'D'
        num_distractors = num_distractors + 1;
        name_distractors( num_distractors ) = image_cell;
        
    else
       continue
       
    end
    
end


% %use 'sqr' object for fixation cross fixation cross. This properly formats
% %a string for the fixation object in the 'TaskObject#1' field
fixation_string = [ 'Sqr(' num2str( fix_size ) ',[' num2str( fix_rgb( 1 ) ) ' ' num2str( fix_rgb( 2 ) ) ' '...
    num2str( fix_rgb( 3 ) ) '],' num2str( fix_fill ) ',0,0)' ] ;
fixation2_string = [ 'Sqr(' num2str( cue_size ) ',[' num2str( fix_rgb( 1 ) ) ' ' num2str( fix_rgb( 2 ) ) ' '...
    num2str( fix_rgb( 3 ) ) '],' num2str( fix_fill ) ',0,0)' ] ; 
target_name = char( name_targets( target_index_id ) );
target_tag = target_name( 1:( length( target_name ) - 4 ) );
sound_string = 'Snd(sin,0.400,500.000)';

%create a cell array to hold the entries for the text file
num_collumns = 8; % 4 header + 2*fixations + 1target + buzz 
Condition_cell_array = cell( ( num_positions + 1 ), num_collumns ); %
Condition_cell_array( 1,: ) = {'Condition', 'Frequency', 'Block', 'Timing File',...
    'TaskObject#1', 'TaskObject#2',  'TaskObject#3', 'TaskObject#4' }; %header for the cell array

%populate the cell array with trial values

for j = 1:num_positions
    target_string = [ 'pic(' target_tag ',' char( target_pos_str( j ) ) ')' ];
    Condition_cell_array( ( j + 1 ),: ) = { j ,1, 1, timing_file, fixation_string, fixation2_string...
        target_string, sound_string };
end


filen = TaskFileName( timing_file, task_folder );
fid = fopen(filen,'a+t');
WriteMLTable( fid, Condition_cell_array )
fclose(fid);

end



