%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  _______  _______  _______  _______  _______                   
% (  ____ \(  ____ \(  ___  )(  ____ )(  ____ \|\     /|         
% | (    \/| (    \/| (   ) || (    )|| (    \/| )   ( |         
% | (_____ | (__    | (___) || (____)|| |      | (___) |         
% (_____  )|  __)   |  ___  ||     __)| |      |  ___  |         
%       ) || (      | (   ) || (\ (   | |      | (   ) |         
% /\____) || (____/\| )   ( || ) \ \__| (____/\| )   ( |         
% \_______)(_______/|/     \||/   \__/(_______/|/     \|         
%                                                                
%  _______  _______  _______  _______  _______  ______   _______ 
% (  ____ \(  ___  )(  ____ \(  ____ \(  ___  )(  __  \ (  ____ \
% | (    \/| (   ) || (    \/| (    \/| (   ) || (  \  )| (    \/
% | (_____ | (___) || |      | |      | (___) || |   ) || (__    
% (_____  )|  ___  || |      | |      |  ___  || |   | ||  __)   
%       ) || (   ) || |      | |      | (   ) || |   ) || (      
% /\____) || )   ( || (____/\| (____/\| )   ( || (__/  )| (____/\
% \_______)|/     \|(_______/(_______/|/     \|(______/ (_______/
%                                                                                                                              
%                                                                                 
%                                                                                               
%
%
%   monkeylogic timing script for basic receptice field mapping.
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



%task specific
target_eccentricity =  5; %can take multiple eccentricities 
num_positions = [5 3 6 1 10]; %takes multiple values
shiftang_position = 0;
target_radius =  1 ;   %in degrees of vis. angle
target_rgb = [ 1 1 1; 1 0 0; 0 0 1]; %txt_file_generator will make a set of conditions 
%for each color for crc_color (each row)
target_fill = 1; %0/1 == open/filled Crc object
fix_size = 1; %Sqr object size used for fixation in deg. vis. angle
fix_rgb = [ 1 1 1 ]; %white fixation dot. can change. totally can.
fix_fill = 1; %0/1 == open/filled Sqr object
distractor_radius = 1;
distractor_rgb = circshift( target_rgb, [ 1,0 ] );
distractor_fill = 1;
num_task_objects = 16; %this is completely arbitrary. most will be unused spaceholders
% so that the timing file can accept variable numbers of targets. last
% TaskObject is researved for bzz
num_conditions = sum( size( target_rgb, 1 ) * length( target_eccentricity ) * num_positions ); 
%total number of lines to be added to text conditions file
tolerance = 1e-3; %when to round trig maths to zero.

%use 'sqr' object for fixation cross fixation cross
fixation = [ 'Sqr(' num2str( fix_size ) ',[' num2str( fix_rgb( 1 ) ) ' ' num2str( fix_rgb( 2 ) ) ' '...
    num2str( fix_rgb( 3 ) ) '],' num2str( fix_fill ) ',0,0)' ] ;

bzz_string = ['Snd(sin,0.400,500.000)'];

%create a cell array to hold the entries for the text file
Condition_cell_array = cell( ( num_conditions + 1 ), 4 + num_task_objects + 1 ); % 
Condition_cell_array( 1,1:4 ) = {'Condition', 'Frequency', 'Block', 'Timing File'}; % 1st half header for the cell array

%make the second half of header
for k = 1:num_task_objects
    add_task_object = ['TaskObject#' num2str(k)];
    Condition_cell_array( 1, ( 4 + k ) ) = { add_task_object };
end

for r = 1:num_conditions
    Condition_cell_array( ( r+1 ),1:5 ) = { r, 1, 1, 'search_saccade', fixation };
    Condition_cell_array( ( r+1 ),end ) = { bzz_string };
end

Condition_cell_array_counter = 1;
block_counter = 1;
for c = 1:length( target_eccentricity )
    
    for a = 1: length( num_positions )
        
        
        %for every target/distractor configuration
        block_counter = 1;
        ang_position = (0 : ( 2*pi/num_positions( a ) ) : 2*pi) + shiftang_position ;
        block_rows = num_positions( a ) * size( target_rgb, 1 ); %* length( target_eccentricity ( c ) );
        crc_strings_block = cell( block_rows, num_positions( a ) );
        crc_string = ['Crc(' num2str( target_radius ) ',[' ];  %num2str( target_rgb( k,1 ) ) ' ' num2str( target_rgb( k,2 ) ) ' '...
        %num2str( target_rgb( k,3 ) ) '],' num2str( target_fill ) ',' vec_position{j}];
        
        for b = 1:size( target_rgb, 1 )
            %
            %
            %  TAGRET/DISTRACTOR RGB STRINGS
            rgbval_t = target_rgb( b,: );
            crc_str_T = [ crc_string num2str( target_rgb( b,1) ) ' ' ...
                num2str( target_rgb( b,2 ) ) ' ' num2str( target_rgb( b,3 ) ) '],' num2str( target_fill ) ',' ];
            rgbval_d = distractor_rgb( b,: );
            crc_str_D = [ crc_string num2str( distractor_rgb( b,1) ) ' ' ...
                num2str( distractor_rgb( b,2 ) ) ' ' num2str( distractor_rgb( b,3 ) ) '],' num2str( target_fill ) ',' ];
            %
            %
            %           
            
            vec_position = TargetPositionString( num_positions( a ), target_eccentricity( c ), ang_position( 1 ), ang_position( end ) );
            vec_positions = cell( num_positions( a ), num_positions( a ) );
            
            for y = 1:num_positions( a )
                column = circshift( vec_position, y );
                vec_positions( :, y ) = column;
            end
                
            assign_position = cell( num_positions( a ),num_positions( a ) );
            

            bin_assign = zeros( num_positions( a ) );
            bin_assign(:,1) = 1;
            for e = 1:( num_positions( a )^2 )
                %position_string = vec_position{ ( mod( e,num_positions( a )) + 1) };
                if bin_assign(e)
                    position_string = vec_positions{ e };
                    full_crc_str = [crc_str_T position_string ];
                    assign_position( e ) = { full_crc_str };
                else
                    position_string = vec_positions{ e };
                    full_crc_str = [crc_str_D position_string ];
                    assign_position( e ) = { full_crc_str };
                end
            end
            crc_strings_block( block_counter:( block_counter + num_positions( a ) - 1 ),1:num_positions( a ) ) = ...
                assign_position( 1:num_positions( a ),1:num_positions( a ) );
            block_counter = block_counter + num_positions( a );
            %
            % end
            %
        end
        
        Condition_cell_array( ( Condition_cell_array_counter + 1 ):( Condition_cell_array_counter + block_rows ), 6:( 5 + num_positions( a ) ) ) = ...
            crc_strings_block( 1:block_rows,1:num_positions( a ) );
        Condition_cell_array_counter = Condition_cell_array_counter + block_rows;
        
        %
    end
end

% %write cell array as a table to a .txt file saved to the path below
Text_table = cell2table( Condition_cell_array );
writetable(Text_table,'C:\monkeylogic\Experiments\search_saccade\search_saccade.txt','Delimiter','\t','WriteVariableNames', false) 

