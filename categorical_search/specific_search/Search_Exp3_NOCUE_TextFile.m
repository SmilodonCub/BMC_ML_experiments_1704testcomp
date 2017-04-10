%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%                          _                      _   _____ 
%                         | |                    | | |____ |
%  ___  ___  __ _ _ __ ___| |__    _____  ___ __ | |_    / /
% / __|/ _ \/ _` | '__/ __| '_ \  / _ \ \/ / '_ \| __|   \ \
% \__ \  __/ (_| | | | (__| | | ||  __/>  <| |_) | |_.___/ /
% |___/\___|\__,_|_|  \___|_| |_| \___/_/\_\ .__/ \__\____/ 
%                             ______       | |              
%                            |______|      |_|             
%
%
%   .m script to generate the fields for a .txt conditions file for the search_exp3
%   a behavioral search task in monkeylogic. for this task, 
%   1) different category specific targets are interwoven across trials in
%   the same block
%   2) a category specific fixation cue (corresponding to the target bear if present) appears
%   for wait_for_fix msec
%   3) subjects holds fixation for initial_fix msec
%   4) on some trials (100-percent_nobear)% a target is presented: the target is presented in an 
%   array with num_distract random distractors placed in num_distract of
%   three posible locations. the locations are always evenly spaced (90deg
%   seperation) although the array randomly rotates about fixation
%   the subject has max_reaction_time 
%   msec to complete a saccade to the target. saccade_time msec are allowed 
%   for a saccade to be completed. the subject then holds fixation on the 
%   target for hold_target_time msec to recieve a reward
%   5) on other trials (percent_nobear)% there is no target present, only (num_distract+1) 
%   distractors in (num_distract + 1) posible locations. 
%   in this case, the subject has max_reaction_time to return to the fixation
%   point and hold for hold_target_time to recieve a reward.
%   the subject has max_reaction_time 
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

function Search_Exp3_NOCUE_TextFile( target_eccentricity, num_conditions, fix_size, cue_size, image_size, num_distract, percent_nobear, target_index_ids )
%TBEAR_SACCADEAVE_TEXTFILE generates the .txt file for specific search task training with teddy bears MonkeyLogic tasks
%and appropriate fixation cue and randomly generated distractor images
%   TBearSearch_Training_TextFile takes:
%       1) target eccentricity. int 
%       3) num_conditions --> how many random distractor groupings to
%       arrange for
%       4) cue_size (deg.vis.ang.) size of fixation during
%       target/distractor array presentation
%       5) image_size (deg.vis.ang) size of target & distractors
%       6) num_distract int N of 3 possible distractor positions to fill
%       7) percent_nobear percentage of trials with no target
%       present(subject must return to fixation to recieve reward)
%       8) target_index_ids --> 1,m vector of bear target indexs to be
%       interleaved across trials within a block where m is the number of
%       targets

% Load configuration info:
taskname = 'Search_Exp3_NOCUE';
condfile = 'C:\monkeylogic\Experiments\categorical_search\specific_search\default_cfg';
MLC = getMLConfig( condfile );
pix_per_degvisang = MLC.PixelsPerDegree; 
[task_folder timing_file] = fileparts('C:\monkeylogic\Experiments\categorical_search\specific_search\TBearSearch');
num_positions = 4;
fix_rgb = [ 1 0 0]; %red fixation square. 
fix_fill = 1; %0/1 == open/filled Sqr object

  
%organize lists of target or distractor images
[ T D ] = ListSortImages( task_folder );

%make a date unique random sequence stream
stream = RandStream('mt19937ar','seed',sum(100*clock));

%random order index of distractor images 
distractor_index = randi( stream,  size(D,2), [ num_conditions, 4 ] );
%for (relatively) even sampling of specified targets targets
idx = repmat(target_index_ids, 1, round(num_conditions/length(target_index_ids)));
idxx = cat(2, idx, target_index_ids(1:(num_conditions - length(idx))));
%random order index of interleaved targets from target_index_ids
interleaved_target_index = randperm( stream, num_conditions);

%IMAGE INFO 4 T/D SCALING & FINDING RANDOM POSITIONS PLACEMENT
%images have been padded to have the same height/width.
%find the pixel dimentions that adjust the image to image_size:
size_pixels = ceil(image_size * pix_per_degvisang);
%find radius of a circle that closes around adjusted image dimentions
% im_radius_pixels =  sqrt(2*(size_pixels)^2)/2;
% im_eccentricity_pixels = ceil( target_eccentricity* pix_per_degvisang);
% target_angle = 2*asind( im_radius_pixels/im_eccentricity_pixels );


%INDEXES TO SET UP BEAR/NOBEAR  
num_nobears = floor(num_conditions*percent_nobear/100);
nobears_index = randi( stream, num_conditions, [ num_nobears, 1 ] );


evenpos_shiftang = randi( stream, 90, [ num_conditions, 1 ] ); %shift_angle values for TargetPositionString
% randomly add 1-90 deg to shift the T/D array position


% strings for return to fixation cue and reward sounds (buzz).
fixation = [ 'Sqr(' num2str( fix_size ) ',[' num2str( fix_rgb( 1 ) ) ' ' num2str( fix_rgb( 2 ) ) ' '...
    num2str( fix_rgb( 3 ) ) '],' num2str( fix_fill ) ',0,0)' ] ; 
fixation2 = [ 'Sqr(' num2str( cue_size ) ',[' num2str( fix_rgb( 1 ) ) ' ' num2str( fix_rgb( 2 ) ) ' '...
    num2str( fix_rgb( 3 ) ) '],' num2str( fix_fill ) ',0,0)' ] ; 
sound_string = 'Snd(sin,0.400,500.000)';

num_blocks = 2; %one block for bear cue present, the other for fixation square

%create a cell array to hold the entries for the text file
num_task_objects = 4 + num_distract; %2*fixations + 1target + num_distract + buzz
Condition_cell_array = cell( ( 2*num_conditions + 1 ), 5 + num_task_objects ); % 
Condition_cell_array( 1,1:5 ) = {'Condition', 'Info', 'Frequency', 'Block', 'Timing File'}; 
for k = 1:num_task_objects
    add_task_object = ['TaskObject#' num2str(k)];
    Condition_cell_array( 1, ( 5 + k ) ) = { add_task_object };
end



%populate the cell array with trial values

for j = 1:num_conditions
    % target name is random interleaved from idxx
    target_name = char( T( idxx(interleaved_target_index(j)) ) );
    TB_tag = target_name( 1:( length( target_name ) - 4 ) );
    %TBear_split = regexp(regexp(target_name, '\_', 'split'), '\.', 'split');
    %Target_Bear = TBear_split{2}{1};
%     cue_string = [ 'pic(' TB_tag ',0,0,' num2str(size_pixels) ',' num2str(size_pixels) ')'];
%     fix_cue = [ cue_string ] ;
    
    condition_position =  1:num_positions;
    shift_angle = evenpos_shiftang( j );
    shift_angle = shift_angle * ( ( 2*pi )/360 );
    ang_position = (0 : ( 2*pi/num_positions ) : 2*pi) + shift_angle;  %radial position of Crc objects
    %make a target position sting array. get appended to end of TaskObject#
    target_pos_str = TargetPositionString( num_positions, target_eccentricity, ang_position( 1 ), ang_position( end ) );
    if ~ismember( j, nobears_index )
        info_string = '''ifBear'', ''1''';
        tindx = randi([ 1 num_positions ]);
        condition_position([tindx]) = [];
        target_string = [ 'pic(' TB_tag ',' char( target_pos_str( tindx )) ',' num2str(size_pixels) ',' num2str(size_pixels) ')'];
    elseif ismember( j, nobears_index )
        info_string = '''ifBear'', ''0'''; %,''TA''';
        dindx = randi([ 1 num_positions ]);
        condition_position([dindx]) = [];
        target_name = char( D( distractor_index( j,1 ) ) );
        target_tag = target_name( 1:( length( target_name ) - 4 ) );
        target_string = [ 'pic(' target_tag ',' char( target_pos_str( dindx ) )  ',' num2str(size_pixels) ',' num2str(size_pixels) ')'];
    end
    
    array_cellarray = {};
    d = 1;
    while d <= num_distract %do the same as above for as many additional
        %distractors that the num_distract calls for while loop to check
        %against redundant distractors being used simulaneously in the
        %same array
        dindx = randi([ 1 ( num_distract + 1 - d ) ]);
        ddindx = condition_position( dindx );
        %pos_index( d + 1 ) = ddindx;
        condition_position([dindx]) = [];
        d_name = char( D( distractor_index( j,(d+1) ) ) );
        dname_split = regexp(d_name, '\.', 'split');
        d_tag = dname_split{1};
        dtag_split = regexp(d_tag, '\_', 'split');
        distractor_string = [ 'pic(' d_tag ',' char( target_pos_str( ddindx ) )  ',' num2str(size_pixels) ',' num2str(size_pixels) ')'  ];
        distractor_infostr = regexprep([ dtag_split{2} '_' char( target_pos_str( ddindx ) )],'[,%!]','_');
        array_entry = [ ',' '''TA' num2str( 1 + d ) ''',' '''' distractor_infostr ];
        if ~strcmp(d_name, target_name) || ~ismember( array_entry, array_cellarray )
            array_cellarray{d} = array_entry;
            Condition_cell_array(  j + 1 , (9 + d) ) = { distractor_string };
            d = d + 1;
        end
    end
    
    %make the full row of Condition_cell_array to represent a condition in
    %the MonkeyLogic Condition text file.
    
    Condition_cell_array(  j + 1, 1:9 ) = { j, info_string ,1, 1, timing_file, sound_string, fixation, fixation2, target_string };
    
end
 

%filen = 'C:\monkeylogic\Experiments\categorical_search\Search_Exp1_im\test.txt'
filen = TaskFileName( taskname, task_folder );
fid = fopen(filen,'a+t');
WriteMLTable( fid, Condition_cell_array )
fclose(fid);

end

