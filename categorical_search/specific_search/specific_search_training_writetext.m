%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  _______  _______  _______  _______ _________ _______ _________ _______   
% (  ____ \(  ____ )(  ____ \(  ____ \\__   __/(  ____ \\__   __/(  ____ \  
% | (    \/| (    )|| (    \/| (    \/   ) (   | (    \/   ) (   | (    \/  
% | (_____ | (____)|| (__    | |         | |   | (__       | |   | |        
% (_____  )|  _____)|  __)   | |         | |   |  __)      | |   | |        
%       ) || (      | (      | |         | |   | (         | |   | |        
% /\____) || )      | (____/\| (____/\___) (___| )      ___) (___| (____/\  
% \_______)|/       (_______/(_______/\_______/|/       \_______/(_______/  
%                                                                           
%          _______  _______  _______  _______  _______                      
%         (  ____ \(  ____ \(  ___  )(  ____ )(  ____ \|\     /|            
%         | (    \/| (    \/| (   ) || (    )|| (    \/| )   ( |            
%         | (_____ | (__    | (___) || (____)|| |      | (___) |            
%         (_____  )|  __)   |  ___  ||     __)| |      |  ___  |            
%               ) || (      | (   ) || (\ (   | |      | (   ) |            
%         /\____) || (____/\| )   ( || ) \ \__| (____/\| )   ( |            
%         \_______)(_______/|/     \||/   \__/(_______/|/     \|            
%                                                                                                                                       
% _________ _______  _______ _________ _       _________ _        _______ 
% \__   __/(  ____ )(  ___  )\__   __/( (    /|\__   __/( (    /|(  ____ \
%    ) (   | (    )|| (   ) |   ) (   |  \  ( |   ) (   |  \  ( || (    \/
%    | |   | (____)|| (___) |   | |   |   \ | |   | |   |   \ | || |      
%    | |   |     __)|  ___  |   | |   | (\ \) |   | |   | (\ \) || | ____ 
%    | |   | (\ (   | (   ) |   | |   | | \   |   | |   | | \   || | \_  )
%    | |   | ) \ \__| )   ( |___) (___| )  \  |___) (___| )  \  || (___) |
%    )_(   |/   \__/|/     \|\_______/|/    )_)\_______/|/    )_)(_______)
%                                                                                                                                                          
%   .m script to generate the fields for a txt conditions file for specific
%   search task in monkeylogic. for this task, 
%   1) a category specific fixation point (blue:butterfly red:bear) appears
%   for wait_for_fix msec
%   2) subjects holds fixation for initial_fix msec
%   3) a fixed training target (bear or butterfly) appears for target_fix msec
%   4) there is a second fixation for second_fix
%   5) the target is presented in an array with three random distractors. 
%   the subject has max_reaction_time msec to complete a saccade to the
%   target. saccade_time msec are allowed for a saccade to be completed
%   6) the subject then holds fixation on the target for hold_target_time
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

num_conditions = 100;   % completely arbitrary block length
random_target = 84;     % random training target to be used consistently 

%task specific
target_eccentricity = [ 8 ]; %ATTN: LIMITED TO 1 ECCENTRICITY --> BECAUSE OF POSITION SHIFT FOR DISTRACTORS
num_positions = 4;
shift_angle = pi/4; %to be given in radians
ang_position = (0 : ( 2*pi/num_positions ) : 2*pi) + shift_angle;  %radial position of Crc objects
crc_fill = 1; %0/1 == open/filled Crc object
fix_size = 1; %Sqr object size used for fixation in deg. vis. angle
fix_rgb = [ 1 0 0]; %red fixation square. 
fix_fill = 1; %0/1 == open/filled Sqr object


%target & distractors position string array
%dim = { length( target_pos_str ), 4 } 
%collumns = target, distractor1, distractor2, distractor3
%each row is a position tag assignment grouping for the object placement
%for each condition
objectplacement = cell( num_positions, 4 );
target_pos_str = TargetPositionString( num_positions, target_eccentricity, ang_position( 1 ), ang_position( end ) );
objectplacement( :, 1 ) = target_pos_str;
objectplacement( :, 2 ) = circshift( target_pos_str, 1 );
objectplacement( :, 3 ) = circshift( target_pos_str, 2 );
objectplacement( :, 4 ) = circshift( target_pos_str, 3 );


%organize lists of target or distractor images
image_folder = 'C:\monkeylogic\Experiments\categorical_search\specific_search'; %folder name
images = dir( [ image_folder,	'\*.bmp'] ); %see the bmp images in this folder's directory
num_images = numel( images ); %count them --> this is how many conditions we will have
num_targets = 0;
name_targets = {};
num_distractors = 0;
name_distractors = {};
for k = 1 : num_images
    
    image_name = images( k ).name;
    image_cell = cellstr( image_name );
    
    if image_name( 1 ) == 'B'
        num_targets = num_targets + 1;
        name_targets( num_targets ) = image_cell;
        
    elseif image_name( 1 ) == 'D'
        num_distractors = num_distractors + 1;
        name_distractors( num_distractors ) = image_cell;
        
    else
       continue
       
    end
    
end

distractor_index = zeros( num_conditions, 3 );
for l = 1:3
    rng('shuffle')
    random_index = randi( num_distractors, num_conditions, 1 );
    distractor_index( :, l ) = random_index;
end

% %use 'sqr' object for fixation cross fixation cross. This properly formats
% %a string for the fixation object in the 'TaskObject#1' field
fixation = [ 'Sqr(' num2str( fix_size ) ',[' num2str( fix_rgb( 1 ) ) ' ' num2str( fix_rgb( 2 ) ) ' '...
    num2str( fix_rgb( 3 ) ) '],' num2str( fix_fill ) ',0,0)' ] ;


%create a cell array to hold the entries for the text file
Condition_cell_array = cell( ( num_conditions + 1 ), 11 ); %preallocate for cell array
Condition_cell_array( 1,: ) = {'Condition', 'Frequency', 'Block', 'Timing File',...
    'TaskObject#1', 'TaskObject#2',  'TaskObject#3',  'TaskObject#4',  'TaskObject#5', 'TaskObject#6','TaskObject#7'}; %header for the cell array

%populate the cell array with trial values

    for j = 1:num_conditions
        target_name = char( name_targets( random_target ) );
        target_tag = target_name( 1:( length( target_name ) - 4 ) ); 
        target_string = [ 'pic(' target_tag ',' char( objectplacement( ( mod( j-1,4 ) + 1 ),1 ) ) ];
        d1_name = char( name_distractors( distractor_index( j,1 ) ) );
        d1_tag = d1_name( 1:( length( d1_name ) - 4 ) );
        distractor1_string = [ 'pic(' d1_tag ',' char( objectplacement( ( mod( j-1,4 ) + 1 ),2 ) ) ];
        d2_name = char( name_distractors( distractor_index( j,2 ) ) );
        d2_tag = d2_name( 1:( length( d2_name ) - 4 ) );
        distractor2_string = [ 'pic(' d2_tag ',' char( objectplacement( ( mod( j-1,4 ) + 1 ),3 ) ) ];
        d3_name = char( name_distractors( distractor_index( j,3 ) ) );
        d3_tag = d3_name( 1:( length( d3_name ) - 4 ) );
        distractor3_string = [ 'pic(' d3_tag ',' char( objectplacement( ( mod( j-1,4 ) + 1 ),4 ) ) ];
        target_fix_string = ['pic(' target_tag ',0,0)' ];
        sound_string = ['Snd(sin,0.400,500.000)'];
        Condition_cell_array( ( j + 1 ),: ) = { j ,1, 1, 'specific_search_training', fixation, ...
            target_string, distractor1_string, distractor2_string, distractor3_string, target_fix_string, sound_string };
    end


% % %write cell array as a table to a .txt file saved to the path below
% Text_table = cell2table( Condition_cell_array );
% writetable(Text_table,'C:\monkeylogic\Experiments\categorical_search\specific_search\specific_search_training.txt','Delimiter','\t','WriteVariableNames', false) 
% 
% 
% [num_textlines num_textcol ] = size(Condition_cell_array);
% for m = 1:num_textlines
%     for n = 1:num_textcol
%         if n == num_textcol
%             fprintf( fid, '%s\n', Condition_cell_array{ m, n } )
%         elseif isa(Condition_cell_array{ m, n },'numeric')
%             fprintf( fid, '%d\t', Condition_cell_array{ m, n } )
%         elseif ~isa(Condition_cell_array{ m, n },'numeric')
%             fprintf( fid, '%s\t', Condition_cell_array{ m, n } )
%         end
%     end
% end

WriteMLTable( fid, Condition_cell_array )
