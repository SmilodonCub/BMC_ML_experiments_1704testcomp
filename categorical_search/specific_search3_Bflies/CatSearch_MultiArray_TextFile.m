%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  _____       _   _____                     _     
% /  __ \     | | /  ___|                   | |    
% | /  \/ __ _| |_\ `--.  ___  __ _ _ __ ___| |__  
% | |    / _` | __|`--. \/ _ \/ _` | '__/ __| '_ \ 
% | \__/\ (_| | |_/\__/ /  __/ (_| | | | (__| | | |
%  \____/\__,_|\__\____/ \___|\__,_|_|  \___|_| |_|
%                                                  
%                                                  
%  _____                         _                 
% |  ___|                       | |                
% | |____  _____ _ __ ___  _ __ | | __ _ _ __      
% |  __\ \/ / _ \ '_ ` _ \| '_ \| |/ _` | '__|     
% | |___>  <  __/ | | | | | |_) | | (_| | |        
% \____/_/\_\___|_| |_| |_| .__/|_|\__,_|_|        
%                         | |                      
%                         |_|                      
%  _____         _  ______ _ _      
% |_   _|       | | |  ___(_) |     
%   | | _____  _| |_| |_   _| | ___ 
%   | |/ _ \ \/ / __|  _| | | |/ _ \
%   | |  __/>  <| |_| |   | | |  __/
%   \_/\___/_/\_\\__\_|   |_|_|\___|
%                                   
%                                  
%   .m script to generate the fields for a txt conditions file for Exemplar
%   Search using either Teddy bears or Butterflies as targets
%   in monkeylogic.
%
%
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function CatSearch_MultiArray_TextFile( target_eccentricity, TAbutton_eccentricity, num_conditions, fix_size, ...
    TAbutton_size, image_size, num_distract, percent_target, target_index_ids, category )
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
taskname = 'TAbutton_MultiArray';
condfile = 'C:\monkeylogic\Experiments\categorical_search\specific_search\default_cfg';
MLC = getMLConfig( condfile );
pix_per_degvisang = MLC.PixelsPerDegree; 
[task_folder timing_file] = fileparts('C:\monkeylogic\Experiments\categorical_search\specific_search2\TAbutton_MultiArray');
fix_rgb = [ 1 0 0]; %red fixation square. 
fix_fill = 1; %0/1 == open/filled Sqr object 

  
%organize lists of target or distractor images
[ T D ] = CatSearchListSortImages( task_folder, category );

%make a date unique random sequence stream
stream = RandStream('mt19937ar','seed',sum(100*clock));

%random order index of distractor images 
max_num_distract = max( num_distract );
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
num_nobears = floor(num_conditions*percent_target/100);
nobears_index = randi( stream, num_conditions, [ num_nobears, 1 ] );


evenpos_shiftang = randi( stream, [0,90], [ num_conditions, 1 ] ); %shift_angle values for TargetPositionString
% randomly add 1-90 deg to shift the T/D array position



% strings for return to fixation cue and reward sounds (buzz).
fixation = [ 'Sqr(' num2str( fix_size ) ',[' num2str( fix_rgb( 1 ) ) ' ' num2str( fix_rgb( 2 ) ) ' '...
    num2str( fix_rgb( 3 ) ) '],' num2str( fix_fill ) ',0,0)' ] ; 
% ex: Sqr(0.5,[1 0 0],1,0,0) 
correct_sound_string = 'Snd(sin,0.400,500.000)';
wrong_sound_string = 'Snd(sin,0.400,400.000)';

len_distract = length(num_distract); %one block for bear cue present, the other for fixation square

%create a cell array to hold the entries for the text file
num_task_objects = 5 + max_num_distract; %2*fixations + 1target + num_distract + 2xbuzz
Condition_cell_array = cell( ( length(num_distract)*num_conditions + 1 ), 5 + num_task_objects ); % 
Condition_cell_array( 1,1:5 ) = {'Condition', 'Info', 'Frequency', 'Block', 'Timing File'}; 
for k = 1:num_task_objects
    add_task_object = ['TaskObject#' num2str(k)];
    Condition_cell_array( 1, ( 5 + k ) ) = { add_task_object };
end



%populate the cell array with trial values
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
                Condition_cell_array( ( j + 1 + (jj-1)*num_conditions), (10 + d) ) = { distractor_string }; 
                d = d + 1;
            end
        end
        
        %make the full row of Condition_cell_array to represent a condition in
        %the MonkeyLogic Condition text file.
        
        Condition_cell_array( ( j + 1 + (jj-1)*num_conditions), 1:10 ) = { j+ (jj-1)*num_conditions, ...
            info_string ,1, 1, timing_file, correct_sound_string, wrong_sound_string, fix_cue, TA_button, target_string };
        
        
    end
end

%filen = 'C:\monkeylogic\Experiments\categorical_search\Search_Exp1_im\test.txt'
filen = TaskFileName( taskname, task_folder );
fid = fopen(filen,'a+t');
WriteMLTable( fid, Condition_cell_array )
fclose(fid);

end
