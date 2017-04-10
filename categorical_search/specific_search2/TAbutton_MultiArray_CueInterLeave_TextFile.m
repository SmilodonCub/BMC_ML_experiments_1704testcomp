%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% ________________ ___.           __    __                               
% \__    ___/  _  \\_ |__  __ ___/  |__/  |_  ____   ____                
%   |    | /  /_\  \| __ \|  |  \   __\   __\/  _ \ /    \               
%   |    |/    |    \ \_\ \  |  /|  |  |  | (  <_> )   |  \              
%   |____|\____|__  /___  /____/ |__|  |__|  \____/|___|  /_____         
%                 \/    \/                              \/_____/         
%    _____        .__   __  .__   _____                                  
%   /     \  __ __|  |_/  |_|__| /  _  \___________________  ___.__.     
%  /  \ /  \|  |  \  |\   __\  |/  /_\  \_  __ \_  __ \__  \<   |  |     
% /    Y    \  |  /  |_|  | |  /    |    \  | \/|  | \// __ \\___  |     
% \____|__  /____/|____/__| |__\____|__  /__|   |__|  (____  / ____|_____
%         \/                           \/                  \/\/   /_____/
%
% _________               .___        __               .____                                   
% \_   ___ \ __ __   ____ |   | _____/  |_  ___________|    |    ____ _____ ___  __ ____       
% /    \  \/|  |  \_/ __ \|   |/    \   __\/ __ \_  __ \    |  _/ __ \\__  \\  \/ // __ \      
% \     \___|  |  /\  ___/|   |   |  \  | \  ___/|  | \/    |__\  ___/ / __ \\   /\  ___/      
%  \______  /____/  \___  >___|___|  /__|  \___  >__|  |_______ \___  >____  /\_/  \___  >_____
%         \/            \/         \/          \/              \/   \/     \/          \/_____/
%
%   .m script to generate the fields for a .txt conditions file for
%   TAbutton_MultiArray_CueInterLeave
%   a behavioral search task in monkeylogic. for this task, 
%   target arrays with different numbers of distractors and different
%   geometrys (positions are evenly spaced) interleaved with and without a target cue for the initial fixation
%   are presented in this way:
%   1) different category specific targets (specified by target_index_ids) are interwoven across trials in
%   the same block
%   2) randomly, either a category specific fixation cue (corresponding to the target bear if present), or a category 
%   appropriate (e.g. red for teddy bear)fixation square appears
%   for wait_for_fix msec
%   3) subjects holds fixation for initial_fix msec
%   4) after the initial fixation hold, fixation is extinguished and the target array appears along with
%   a Target Absent 'Button' located outside the array as specified by
%   'cue_eccentricity' degrees
%   5) on some trials (100-percent_nobear)% a target is presented: the target is presented in an 
%   array with num_distract random distractors placed in num_distract of
%   three posible locations. the locations are always evenly spaced (90deg
%   seperation) although the array randomly rotates about fixation
%   the subject has max_reaction_time 
%   msec to complete a saccade to the target. saccade_time msec are allowed 
%   for a saccade to be completed. the subject then holds fixation on the 
%   target for hold_target_time msec to recieve a reward
%   6) on other trials (percent_nobear)% there is no target present, only (num_distract+1) 
%   distractors in (num_distract + 1) posible locations. 
%   in this case, the subject has max_reaction_time to saccade to the
%   Target Absent 'Button'
%   and hold for hold_target_time to recieve a reward.
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

function TAbutton_MultiArray_CueInterLeave_TextFile( target_eccentricity, TAbutton_eccentricity, num_conditions, fix_size, ...
    TAbutton_size, image_size, num_distract, percent_nobear, target_index_ids )
%TBEAR_SACCADEAVE_TEXTFILE generates the .txt file for specific search task training with teddy bears MonkeyLogic tasks
%and appropriate fixation cue and randomly generated distractor images
%   TBearSearch_Training_TextFile takes:
%       1) target eccentricity. int 
%       2) TA 'button' eccentricity. int 
%       3) num_conditions --> how many random distractor groupings to
%       arrange for
%       4) fixation size (deg.vis.ang.) size of fixation during the
%       innitial fixation period.
%       5) cue_size (deg.vis.ang.) size of fixation during
%       target/distractor array presentation
%       6) image_size (deg.vis.ang) size of target & distractors
%       7) num_distract vector of possible distractor positions to fill.
%       final array geometry will have num_distract + 1 positions
%       8) percent_nobear percentage of trials with no target
%       present(subject must return to fixation to recieve reward)
%       9) target_index_ids --> 1,m vector of bear target indexs to be
%       interleaved across trials within a block where m is the number of
%       targets

% Load configuration info:
taskname = 'TAbutton_MultiArray_CueInterLeave';
condfile = 'C:\monkeylogic\Experiments\categorical_search\specific_search\default_cfg';
MLC = getMLConfig( condfile );
pix_per_degvisang = MLC.PixelsPerDegree; 
[task_folder timing_file] = fileparts('C:\monkeylogic\Experiments\categorical_search\specific_search2\TAbutton_MultiArray');
fix_rgb = [ 1 0 0]; %red fixation square. 
fix_fill = 1; %0/1 == open/filled Sqr object 

len_distract = length(num_distract); %one block for each target array configuration
num_blocks = 2; %one block for bear cue present, the other for fixation square

%organize lists of target or distractor images
[ T D ] = ListSortImages( task_folder );

%make a date unique random sequence stream
stream = RandStream('mt19937ar','seed',sum(100*clock));

%random order index of distractor images 
max_num_distract = max( num_distract );
%for (relatively) even sampling of specified targets
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


evenpos_shiftang = randi( stream, [0,90], [ num_conditions, 1 ] ); %shift_angle values for TargetPositionString
% randomly add 1-90 deg to shift the T/D array position



% strings for return to fixation cue and reward sounds (buzz).
fixation = [ 'Sqr(' num2str( fix_size ) ',[' num2str( fix_rgb( 1 ) ) ' ' num2str( fix_rgb( 2 ) ) ' '...
    num2str( fix_rgb( 3 ) ) '],' num2str( fix_fill ) ',0,0)' ] ; 
% ex: Sqr(0.5,[1 0 0],1,0,0) 
correct_sound_string = 'Snd(sin,0.400,500.000)';
wrong_sound_string = 'Snd(sin,0.400,400.000)';


%create a cell array to hold the entries for the text file
num_task_objects = 5 + max_num_distract; %2*fixations + 1target + num_distract + 2xbuzz
Condition_cell_array = cell( ( num_blocks*length(num_distract)*num_conditions + 1 ), 5 + num_task_objects ); % 
Condition_cell_array( 1,1:5 ) = {'Condition', 'Info', 'Frequency', 'Block', 'Timing File'}; 
for k = 1:num_task_objects
    add_task_object = ['TaskObject#' num2str(k)];
    Condition_cell_array( 1, ( 5 + k ) ) = { add_task_object };
end


%populate the cell array with trial values
for jjj = 1:num_blocks
    
    for jj = 1:len_distract
        
        num_positions = num_distract(jj) + 1;
        TAbutton_random_array_pos = randi( stream, [1,num_positions], [ num_conditions, 1]);
        distractor_index = randi( stream,  size(D,2), [ num_conditions, (num_distract(jj) + 1) ] );
        
        for j = 1:num_conditions
            % target name is random interleaved from idxx
            target_name = char( T( idxx(interleaved_target_index(j)) ) );
            TB_tag = target_name( 1:( length( target_name ) - 4 ) );
            %TBear_split = regexp(regexp(target_name, '\_', 'split'), '\.', 'split');
            %Target_Bear = TBear_split{2}{1};
            cue_string = [ 'pic(' TB_tag ',0,0,' num2str(size_pixels) ',' num2str(size_pixels) ')'];
            fix_cue = [ cue_string ] ;
            
            condition_position =  1:num_positions;
            shift_angle = evenpos_shiftang( j );
            shift_angle = shift_angle * ( ( 2*pi )/360 );
            ang_position = (0 : ( 2*pi/num_positions ) : 2*pi) + shift_angle;  %radial position of Crc objects
            %make a target position sting array. get appended to end of TaskObject#
            TAbutton_ang_position = ang_position + pi/num_positions;
            target_pos_str = TargetPositionString( num_positions, target_eccentricity, ang_position( 1 ), ang_position( end ) );
            TAbutton_pos_str = TargetPositionString( num_positions, TAbutton_eccentricity, TAbutton_ang_position( 1 ), TAbutton_ang_position( end ) );
            TA_button = [ 'Sqr(' num2str( TAbutton_size ) ',[' num2str( fix_rgb( 1 ) ) ' ' num2str( fix_rgb( 2 ) ) ' '...
                num2str( fix_rgb( 3 ) ) '],' num2str( fix_fill ) ',' char( TAbutton_pos_str( TAbutton_random_array_pos(j) ) ) ')' ];
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
            while d <= num_distract(jj) %do the same as above for as many additional
                %distractors that the num_distract calls for while loop to check
                %against redundant distractors being used simulaneously in the
                %same array
                dindx = randi([ 1 ( num_distract(jj) + 1 - d ) ]);
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
                    Condition_cell_array( ( j + 1 + (jj-1)*num_conditions + (jjj-1)*num_conditions*len_distract), (10 + d) ) = { distractor_string };
                    d = d + 1;
                end
            end
            
            %make the full row of Condition_cell_array to represent a condition in
            %the MonkeyLogic Condition text file.
            
            if jjj == 1
                Condition_cell_array( ( j + 1 + (jj-1)*num_conditions), 1:10 ) = { (j+ (jj-1)*num_conditions), ...
                    info_string ,1, 1, timing_file, correct_sound_string, wrong_sound_string, fix_cue, TA_button, target_string };
            elseif jjj == 2
                Condition_cell_array( ( j + 1 + (jj-1)*num_conditions) + num_conditions*len_distract, 1:10 ) = { (j+ (jj-1)*num_conditions+ (jjj-1)*num_conditions*len_distract), ...
                    info_string ,1, 1, timing_file, correct_sound_string, wrong_sound_string, fixation, TA_button, target_string };
            end
            
        end
        
    end
    
    
end


%filen = 'C:\monkeylogic\Experiments\categorical_search\Search_Exp1_im\test.txt'
filen = TaskFileName( taskname, task_folder );
fid = fopen(filen,'a+t');
WriteMLTable( fid, Condition_cell_array )
fclose(fid);

end

