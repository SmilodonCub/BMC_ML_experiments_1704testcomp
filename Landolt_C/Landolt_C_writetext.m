%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  _        _______  _        ______   _______  _    _________   _______           
% ( \      (  ___  )( (    /|(  __  \ (  ___  )( \   \__   __/  (  ____ \          
% | (      | (   ) ||  \  ( || (  \  )| (   ) || (      ) (     | (    \/          
% | |      | (___) ||   \ | || |   ) || |   | || |      | |     | |                
% | |      |  ___  || (\ \) || |   | || |   | || |      | |     | |                
% | |      | (   ) || | \   || |   ) || |   | || |      | |     | |                
% | (____/\| )   ( || )  \  || (__/  )| (___) || (____/\| |     | (____/\          
% (_______/|/     \||/    )_)(______/ (_______)(_______/)_(_____(_______/          
%                                                         (_____)                  
%           _______ __________________ _______ _________ _______          _________
% |\     /|(  ____ )\__   __/\__   __/(  ____ \\__   __/(  ____ \|\     /|\__   __/
% | )   ( || (    )|   ) (      ) (   | (    \/   ) (   | (    \/( \   / )   ) (   
% | | _ | || (____)|   | |      | |   | (__       | |   | (__     \ (_) /    | |   
% | |( )| ||     __)   | |      | |   |  __)      | |   |  __)     ) _ (     | |   
% | || || || (\ (      | |      | |   | (         | |   | (       / ( ) \    | |   
% | () () || ) \ \_____) (___   | |   | (____/\   | |   | (____/\( /   \ )   | |   
% (_______)|/   \__/\_______/   )_(   (_______/   )_(   (_______/|/     \|   )_(   
%                                                                                                                                               
%                                                                                 
%                                                                                               
%
%
%   .m script for generating the txt conditions file for landolt C memory guided saccade task.
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
task_folder = 'C:\monkeylogic\Experiments\Landolt_C';
pixperdeg = MLConfig.PixelsPerDegree;  %MLConfig is in workspace once a task is loaded in ML main menu
%                                      %OR can type it directly from the ML
%                                      main menu


%task specific

target_eccentricity = [ 8 10 ]; %can take multiple eccentricities 
num_positions = 4; 
shiftang_position = 0; % shift the angle of the targets in radians
ang_position = ( 0 : ( 2*pi/num_positions ) : 2*pi ) + shiftang_position;  %radial position of Crc objects
sqr_radius =  1 ;   %in degrees of vis. angle
sqr_rgb = [ 0.25 0.25 0.25; 0.5 0.5 0.5; 0.75 0.75 0.75; 1 1 1 ]; %txt_file_generator will make a set of conditions 
%for each color for crc_color (each row)
sqr_fill = 1; %0/1 == open/filled Crc object
fix_size = 1; %Sqr object size used for fixation in deg. vis. angle
fix_rgb = [ 1 1 1]; %white fixation dot. can change. totally can.
fix_fill = 1; %0/1 == open/filled Sqr object

Landolt_C = makeLandolt_C( pixperdeg, 0.5, 2, [ 1 1 1 ] );
mother_image = [ task_folder '\LC' ];
imwrite( Landolt_C, [ mother_image '.bmp' ] );
Landolt_C_name = [ mother_image '.bmp' ];
for i = 1:4
    theta = round( ang_position( i ) * ( 360 / ( 2*pi ) ) );
    task_Lcrc = imread( Landolt_C_name );
    theta_task_Lcrc = imrotate( task_Lcrc, theta );
    task_Lcrc_name = [ mother_image num2str( i ) '.bmp'];
    imwrite( theta_task_Lcrc, task_Lcrc_name );
end


num_task_objects = 7; %fix, 4 target square, 1 landolt_c, 1 bzz
num_conditions = size( sqr_rgb, 1 ) * length( target_eccentricity ) * num_positions; 
%total number of lines to be added to text conditions file
timing_file = 'Landolt_C';
datev = datevec(date);
filen = strcat(task_folder, '\', timing_file,'_',num2str(datev(1)),'_',num2str(datev(2)),'_',num2str(datev(3)),'.txt');
fid = fopen(filen,'a+t');


vec_position =  TargetPositionString( num_positions , target_eccentricity, ang_position( 1 ), ang_position( 4 ) ); 

%use 'sqr' object for fixation cross fixation cross
fixation = [ 'Sqr(' num2str( fix_size ) ',[' num2str( fix_rgb( 1 ) ) ' ' num2str( fix_rgb( 2 ) ) ' '...
    num2str( fix_rgb( 3 ) ) '],' num2str( fix_fill ) ',0,0)' ] ;

bzz_string = ['Snd(sin,0.400,500.000)'];

%create a cell array to hold the entries for the text file
text_col = 4 + num_task_objects;
Condition_cell_array = cell( ( num_conditions + 1 ), text_col ); %preallocate for cell array
Condition_cell_array( 1,: ) = {'Condition', 'Frequency', 'Block', 'Timing File',...
    'TaskObject#1', 'TaskObject#2', 'TaskObject#3', 'TaskObject#4', 'TaskObject#5', 'TaskObject#6', 'TaskObject#7' }; %header for the cell array
%populate the cell array with trial values
%count = 0;
for l = 1 : ( size( sqr_rgb, 1 ) )
    for k = 1 : ( length( target_eccentricity ) )
        for j = 1 : num_positions
            target_string = ['Sqr(' num2str( sqr_radius ) ',[' num2str( sqr_rgb( l,1 ) ) ' ' num2str( sqr_rgb( l,2 ) ) ' '...
                num2str( sqr_rgb( l,3 ) ) '],' num2str( sqr_fill ) ',' vec_position{ mod( j,4 ) + 1 }];
            Landolt_C_tag = [ 'LC' num2str( j ) ];
            landolt_C_string = [ 'Pic(' Landolt_C_tag ',0 ,0)' ];
            distractor1_string = ['Sqr(' num2str( sqr_radius ) ',[' num2str( sqr_rgb( l,1 ) ) ' ' num2str( sqr_rgb( l,2 ) ) ' '...
                num2str( sqr_rgb( l,3 ) ) '],' num2str( sqr_fill ) ',' vec_position{ mod( j + 1,4 ) + 1 }];
            distractor2_string = ['Sqr(' num2str( sqr_radius ) ',[' num2str( sqr_rgb( l,1 ) ) ' ' num2str( sqr_rgb( l,2 ) ) ' '...
                num2str( sqr_rgb( l,3 ) ) '],' num2str( sqr_fill ) ',' vec_position{ mod( j + 2,4 ) + 1 }];
            distractor3_string = ['Sqr(' num2str( sqr_radius ) ',[' num2str( sqr_rgb( l,1 ) ) ' ' num2str( sqr_rgb( l,2 ) ) ' '...
                num2str( sqr_rgb( l,3 ) ) '],' num2str( sqr_fill ) ',' vec_position{ mod( j + 3,4 ) + 1 }];
            Condition_cell_array( ( j + 1 + num_positions*( k-1 ) + num_positions*length( target_eccentricity )*( l-1 ) ),: ) = ...
                { ( j + num_positions*( k-1 ) + num_positions*length( target_eccentricity )*( l-1 ) ),...
                1, 1, timing_file, fixation, target_string, distractor1_string, distractor2_string, distractor3_string, landolt_C_string, bzz_string };
            %count = count + 1
        end
    end
end

%write cell array as a table to a .txt file saved to the path below
% Text_table = cell2table( Condition_cell_array );
% writetable(Text_table,'C:\monkeylogic\Experiments\Landolt_C\Landolt_C.txt','Delimiter','\t','WriteVariableNames', false) 

[num_textlines num_textcol ] = size(Condition_cell_array);
for m = 1:num_textlines
    for n = 1:num_textcol
        if n == num_textcol
            fprintf( fid, '%s\n', Condition_cell_array{ m, n } )
        elseif isa(Condition_cell_array{ m, n },'numeric')
            fprintf( fid, '%d\t', Condition_cell_array{ m, n } )
        elseif ~isa(Condition_cell_array{ m, n },'numeric')
            fprintf( fid, '%s\t', Condition_cell_array{ m, n } )
        end
    end
end

fclose(fid)