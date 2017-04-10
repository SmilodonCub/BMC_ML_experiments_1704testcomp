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

%task specific
target_eccentricity = [ 8 10 12 ]; %can take multiple eccentricities 
num_positions = 12; 
shiftang_position = pi/4;
ang_position = ( 0 : ( 2*pi/num_positions ) : 2*pi ) + shiftang_position;  %radial position of Crc objects
crc_radius =  1 ;   %in degrees of vis. angle
crc_rgb = [ 1 1 1; 1 0 0; 0 0 1]; %txt_file_generator will make a set of conditions 
%for each color for crc_color (each row)
crc_fill = 1; %0/1 == open/filled Crc object
fix_size = 1; %Sqr object size used for fixation in deg. vis. angle
fix_rgb = [ 1 1 1]; %white fixation dot. can change. totally can.
fix_fill = 1; %0/1 == open/filled Sqr object


num_conditions = size( crc_rgb, 1 ) * length( target_eccentricity ) * num_positions; 
%total number of lines to be added to text conditions file

vec_position = TargetPositionString( num_positions , target_eccentricity, ang_position( 1 ), ( length( ang_position ) - 1 ) ); %an array of strings. each string has the formated 
%postition vectors in deg of visual angle to be used in MonkeyLogic for
%positioning stimuli

%use 'sqr' object for fixation cross fixation cross
fixation = [ 'Sqr(' num2str( fix_size ) ',[' num2str( fix_rgb( 1 ) ) ' ' num2str( fix_rgb( 2 ) ) ' '...
    num2str( fix_rgb( 3 ) ) '],' num2str( fix_fill ) ',0,0)' ] ;

bzz_string = ['Snd(sin,0.400,500.000)'];

%create a cell array to hold the entries for the text file
Condition_cell_array = cell( ( num_conditions + 1 ), 7 ); %preallocate for cell array
Condition_cell_array( 1,: ) = {'Condition', 'Frequency', 'Block', 'Timing File',...
    'TaskObject#1', 'TaskObject#2', 'TaskObject#3'}; %header for the cell array
%populate the cell array with trial values
for k = 1:size( crc_rgb, 1 )
    for j = 1 : ( length( vec_position ) )
        crc_string = ['Crc(' num2str( crc_radius ) ',[' num2str( crc_rgb( k,1 ) ) ' ' num2str( crc_rgb( k,2 ) ) ' '...
            num2str( crc_rgb( k,3 ) ) '],' num2str( crc_fill ) ',' vec_position{j}];
        Condition_cell_array( ( j + length( vec_position )*( k-1 ) + 1 ),: ) = { (j + length( vec_position )*( k-1 )),...
            1, 1, 'rf_mapping', fixation, crc_string, bzz_string };
    end
end
%write cell array as a table to a .txt file saved to the path below
% Text_table = cell2table( Condition_cell_array );
% writetable(Text_table,'C:\monkeylogic\Experiments\RF_Mapping\rf_mapping.txt','Delimiter','\t','WriteVariableNames', false) 

[num_textlines num_textcol ] = size(Condition_cell_array);
for m = 1:num_textlines
    for n = 1:num_textcol
        if n == num_textcol
            fprintf( fid, '%s\n', Condition_cell_array{ m, n } );
        elseif isa(Condition_cell_array{ m, n },'numeric')
            fprintf( fid, '%d\t', Condition_cell_array{ m, n } );
        elseif ~isa(Condition_cell_array{ m, n },'numeric')
            fprintf( fid, '%s\t', Condition_cell_array{ m, n } );
        end
    end
end

fclose(fid);

