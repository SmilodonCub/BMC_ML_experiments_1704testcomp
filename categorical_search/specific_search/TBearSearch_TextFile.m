%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% _________ ______   _______  _______  _______          
% \__   __/(  ___ \ (  ____ \(  ___  )(  ____ )         
%    ) (   | (   ) )| (    \/| (   ) || (    )|         
%    | |   | (__/ / | (__    | (___) || (____)|         
%    | |   |  __ (  |  __)   |  ___  ||     __)         
%    | |   | (  \ \ | (      | (   ) || (\ (            
%    | |   | )___) )| (____/\| )   ( || ) \ \__         
%    )_(   |/ \___/ (_______/|/     \||/   \__/         
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
%                                                                                 
%   .m script to generate the fields for a txt conditions file for specific
%   search task in monkeylogic. for this task, 
%   1) a category specific fixation point (blue:butterfly red:bear) appears
%   for wait_for_fix msec
%   2) subjects holds fixation for initial_fix msec
%   3) on some trials a target is presented: the target is presented in an 
%   array with N random distractors place in N of three posible location 
%   evenly spaced 90dev from the target. the subject has max_reaction_time 
%   msec to complete a saccade to the target. saccade_time msec are allowed 
%   for a saccade to be completed
%   4) the subject then holds fixation on the target for hold_target_time
%   msec to recieve a reward
%   5) on other trials, there is no target present, only N distractors. in
%   this case, the subject has max_reaction_time to return to the fixation
%   point and hold for hold_target_time to recieve a reward.
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

function TBearSearch_TextFile( target_eccentricity, shift_angle, num_conditions, cue_size, fix_size, num_distract, percent_nobear, target_index_id )
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
%       5) fix_size (deg.vis.ang) size of fixation otherwise
%       6) num_distractors int N of 3 possible distractor positions to fill
%       7) percent_nobear (%) percent of trials within the block that Do
%       NOT have a target bear present in the search array.
%       8) target_index_id --> bear target to be used consistently untill
%       training performance is achieved




timing_file = 'TBearSearch';
task_folder =  'C:\monkeylogic\Experiments\categorical_search\specific_search'; 
num_positions = 4;
shift_angle = shift_angle * ( ( 2*pi )/360 );
ang_position = (0 : ( 2*pi/num_positions ) : 2*pi) + shift_angle;  %radial position of Crc objects
fix_rgb = [ 1 0 0]; %red fixation square. 
fix_fill = 1; %0/1 == open/filled Sqr object


%make a target position sting array. gets appended to end of TaskObject#
%text string entry of the Condition_cell_array
target_pos_str = TargetPositionString( num_positions, target_eccentricity, ang_position( 1 ), ang_position( end ) );

  
%organize lists of target or distractor images
[ T D ] = ListSortImages( task_folder );


%make a date unique random sequence
stream = RandStream('mt19937ar','seed',sum(100*clock));
%random order index of distractor images 
distractor_index = randi( stream,  size(D,2), [ num_conditions, 4 ] );
%make a vector for random interleaved nobear trials
num_nobears = floor(num_conditions*percent_nobear/100);
nobears_index = randi( stream, num_conditions, [ num_nobears, 1 ] );


% %use 'sqr' object for fixation cross fixation cross. This properly formats
% %a string for the fixation object in the 'TaskObject#1' field
fixation = [ 'Sqr(' num2str( fix_size ) ',[' num2str( fix_rgb( 1 ) ) ' ' num2str( fix_rgb( 2 ) ) ' '...
    num2str( fix_rgb( 3 ) ) '],' num2str( fix_fill ) ',0,0)' ] ;
fixation2 = [ 'Sqr(' num2str( cue_size ) ',[' num2str( fix_rgb( 1 ) ) ' ' num2str( fix_rgb( 2 ) ) ' '...
    num2str( fix_rgb( 3 ) ) '],' num2str( fix_fill ) ',0,0)' ] ; 
sound_string = 'Snd(sin,0.400,500.000)';



%create a cell array to hold the entries for the text file
num_task_objects = 4 + num_distract; %2*fixations + 1target + num_distract + buzz
Condition_cell_array = cell( ( num_conditions + 1 ), 5 + num_task_objects ); % 
Condition_cell_array( 1,1:5 ) = {'Condition', 'Info', 'Frequency', 'Block', 'Timing File'}; 
for k = 1:num_task_objects
    add_task_object = ['TaskObject#' num2str(k)];
    Condition_cell_array( 1, ( 5 + k ) ) = { add_task_object };
end

TB_name = char( T( target_index_id ) ); %image file nametag
TBear_split = regexp(TB_name, '\_', 'split');
Target_Bear = TBear_split{2};

%populate the cell array with trial values
for j = 1:num_conditions
    pos_index = zeros(4,1);
    condition_position =  1:num_positions; 
    if ~ismember( j, nobears_index )
        info_string = '''ifBear'', ''1'',''TA1'','; %start info string --> directs target/distractor names & position in .bhv files
        tindx = randi([ 1 num_positions ]); %randomly pic a position for the target
        pos_index(1) = tindx; 
        condition_position([tindx]) = []; %remove that index from possible position to avoid superposition of TargetObjects
        target_name = TB_name; %image file nametag
        target_tag = target_name( 1:( length( target_name ) - 4 ) ); %shorten
        target_string = [ 'pic(' target_tag ',' char( target_pos_str( tindx ) ) ')' ]; %build a string formatted for use as a MonkeyLogic TaskObject
        tbear_string = [ Target_Bear '_' char( target_pos_str( tindx ) ) ];
        target_infostr = regexprep(tbear_string,'[,%!]','_'); % string for BHV.InfoByCond structure
    elseif ismember( j, nobears_index ) %do the same as above for the nobear case
        info_string = '''ifBear'', ''0'',''TA1'',';
        dindx = randi([ 1 num_positions ]); 
        pos_index(1) = dindx;
        condition_position([dindx]) = [];
        target_name = char( D( distractor_index( j,1 ) ) );
        target_tag = target_name( 1:( length( target_name ) - 4 ) );
        target_string = [ 'pic(' target_tag ',' char( target_pos_str( dindx ) ) ')' ];
        target_infostr = regexprep(target_string(7:(end-1)),'[,%!]','_');
    end
    
    array_cellarray = {};
    d = 1;
    while d <= num_distract %do the same as above for as many additional 
        %distractors that the num_distract calls for while loop to check 
        %against redundant distractors being used simulaneously in the 
        %same array
        dindx = randi([ 1 ( num_distract + 1 - d ) ]);
        ddindx = condition_position( dindx );
        pos_index( d + 1 ) = ddindx;
        condition_position([dindx]) = [];
        d_name = char( D( distractor_index( j,(d+1) ) ) );
        d_tag = d_name( 1:( length( d_name ) - 4 ) );
        distractor_string = [ 'pic(' d_tag ',' char( target_pos_str( ddindx ) ) ')' ];
        distractor_infostr = regexprep(distractor_string(7:(end-1)),'[,%!]','_');
        array_entry = [ ',' '''TA' num2str( 1 + d ) ''',' '''' distractor_infostr ]; 
        if ~strcmp(d_name, target_name) || ~ismember( array_entry, array_cellarray ) 
            array_cellarray{d} = array_entry;
            Condition_cell_array( ( j + 1 ), (9 + d) ) = { distractor_string };
            d = d + 1;
        end
    end
    
    %Info_string passes 
    Info_string = [ info_string '''' target_infostr '''' array_cellarray{1} '''' array_cellarray{2} '''' array_cellarray{3} '''']; %concatenate the full Info string
    %make the full row of Condition_cell_array to represent a condition in
    %the MonkeyLogic Condition text file.
    Condition_cell_array( ( j + 1 ), 1:9 ) = { j, Info_string ,1, 1, timing_file, sound_string, fixation, fixation2, target_string };
    
   
end

%write the MonkeyLogic text file 
filen = TaskFileName( timing_file, task_folder );
fid = fopen(filen,'a+t');
WriteMLTable( fid, Condition_cell_array )
fclose(fid);

end

