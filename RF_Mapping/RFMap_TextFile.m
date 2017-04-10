%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  _______  _______  _______  _______  _______  _______ _________ _        _______ 
% (  ____ )(  ____ \(       )(  ___  )(  ____ )(  ____ )\__   __/( (    /|(  ____ \
% | (    )|| (    \/| () () || (   ) || (    )|| (    )|   ) (   |  \  ( || (    \/
% | (____)|| (__    | || || || (___) || (____)|| (____)|   | |   |   \ | || |      
% |     __)|  __)   | |(_)| ||  ___  ||  _____)|  _____)   | |   | (\ \) || | ____ 
% | (\ (   | (      | |   | || (   ) || (      | (         | |   | | \   || | \_  )
% | ) \ \__| )      | )   ( || )   ( || )      | )      ___) (___| )  \  || (___) |
% |/   \__/|/_____  |/     \||/     \||/       |/       \_______/|/    )_)(_______)
%           (_____)                                                                
%                                                                                 
%                                                                                               
%
%
%   .m script for generating the txt conditions file for a basic receptice field mapping task.
%
% This is a rceptive field mapping task. circular targets displayed 
% by user specified eccentricity across a user specified array of
% locations.
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

function RFMap_TextFile( target_eccentricity, num_positions, angle_range, shift_angle, target_rgb )
%RFMAP_TEXTFILE generate the text file for 'RF_Mapping' MonkeyLogic tasks
%   RFMap_TextFile takes:
%       1) target eccentricity. int or vec (to generate multiple
%       eccentricities
%       2) num_positions how many posible positions the target can be in
%       within the specified angle range
%       4) angle_range. radians. max angle from 0 to space target positions
%       across
%       5) shift_angle. radians. this will shift the target position by a
%       set amount
%       4) target_rgb. any [ m, 3 ] size matrix


%task specific
task_folder = 'C:\monkeylogic\Experiments\RF_Mapping';
timing_file = 'rf_mapping';
ang_position = ( 0 : ( angle_range/num_positions ) : angle_range ) + shift_angle;  %radial position of Crc objects
crc_radius =  1 ;   %in degrees of vis. angle
crc_fill = 1; %0/1 == open/filled Crc object
fix_size = 1; %Sqr object size used for fixation in deg. vis. angle
fix_rgb = [ 1 1 1]; %white fixation dot. can change. totally can.
fix_fill = 1; %0/1 == open/filled Sqr object


num_conditions = size( target_rgb, 1 ) * length( target_eccentricity ) * num_positions; 
%total number of lines to be added to text conditions file

vec_position = TargetPositionString( num_positions , target_eccentricity, ang_position( 1 ), ( length( ang_position ) - 1 ) ); %an array of strings. each string has the formated 
%postition vectors in deg of visual angle to be used in MonkeyLogic for
%positioning stimuli

%use 'sqr' object for fixation cross fixation cross
fixation = [ 'Sqr(' num2str( fix_size ) ',[' num2str( fix_rgb( 1 ) ) ' ' num2str( fix_rgb( 2 ) ) ' '...
    num2str( fix_rgb( 3 ) ) '],' num2str( fix_fill ) ',0,0)' ] ;

bzz_string = 'Snd(sin,0.400,500.000)';

%create a cell array to hold the entries for the text file
Condition_cell_array = cell( ( num_conditions + 1 ), 7 ); %preallocate for cell array
Condition_cell_array( 1,: ) = {'Condition', 'Frequency', 'Block', 'Timing File',...
    'TaskObject#1', 'TaskObject#2', 'TaskObject#3'}; %header for the cell array
%populate the cell array with trial values
for k = 1:size( target_rgb, 1 )
    for j = 1 : ( length( vec_position ) )
        crc_string = ['Crc(' num2str( crc_radius ) ',[' num2str( target_rgb( k,1 ) ) ' ' num2str( target_rgb( k,2 ) ) ' '...
            num2str( target_rgb( k,3 ) ) '],' num2str( crc_fill ) ',' vec_position{j}];
        Condition_cell_array( ( j + length( vec_position )*( k-1 ) + 1 ),: ) = { (j + length( vec_position )*( k-1 )),...
            1, 1, timing_file, fixation, crc_string, bzz_string };
    end
end


filen = TaskFileName( timing_file, task_folder );
fid = fopen(filen,'a+t');
WriteMLTable( fid, Condition_cell_array )
fclose(fid);


end

