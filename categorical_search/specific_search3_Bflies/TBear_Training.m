%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  _____ _                     _             _       _             
% |_   _| |                   | |           (_)     (_)            
%   | | | |__   ___  __ _ _ __| |_ _ __ __ _ _ _ __  _ _ __   __ _ 
%   | | | '_ \ / _ \/ _` | '__| __| '__/ _` | | '_ \| | '_ \ / _` |
%   | | | |_) |  __/ (_| | |  | |_| | | (_| | | | | | | | | | (_| |
%   \_/ |_.__/ \___|\__,_|_|   \__|_|  \__,_|_|_| |_|_|_| |_|\__, |
%                        ______                               __/ |
%                       |______|                             |___/
%                                  
%   .m script to generate the fields for a txt conditions file for Tbear_traing
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  _   _           _                             _       _    
% | | (_)         (_)                           (_)     | |   
% | |_ _ _ __ ___  _ _ __   __ _   ___  ___ _ __ _ _ __ | |_  
% | __| | '_ ` _ \| | '_ \ / _` | / __|/ __| '__| | '_ \| __| 
% | |_| | | | | | | | | | | (_| | \__ \ (__| |  | | |_) | |_  
%  \__|_|_| |_| |_|_|_| |_|\__, | |___/\___|_|  |_| .__/ \__| 
%                           __/ |                 | |         
%                          |___/                  |_|        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                    
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%editables
editable('fix_window');
editable('target_window');
editable('wait_for_fix');        
editable('initial_fix');       
editable('target_fix');      
editable('max_reaction_time');  
editable('saccade_time');       
editable('hold_target_time');
editable('intTint');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 



% task variables
% % % give names to the TaskObjects defined in the conditions file:
% the numbers correspond with the TaskObject# in the text files
fixation_point = 1;     %red square target. 
fixation2_point = 2;
target_image = 3;       
bzz = 4;

% define time intervals (in ms):
wait_for_fix = 1000;        %interval to wait for fixation to start
initial_fix = 1000;         %hold fixation on fixation_point
max_reaction_time = 6000;   %max time after second_fix given to complete a saccade
saccade_time = 2000;        %time allowed for saccade
hold_target_time = 700;     %hold fixation on bear_image
intTint = 1000;             %idle time inbetween conditions

% fixation window (in degrees):
fix_window = 2;
target_window = 3;


LoadEventCodes_MCPKLB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('______________________________________________________________________')
disp('START TRIAL')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
eventmarker(1);



% initial fixation:
toggleobject(fixation_point, 'eventmarker', FIX_ON, 'status', 'on' ); %toggle fixation_point on
ontarget = eyejoytrack('acquirefix', fixation_point, fix_window, wait_for_fix);
if ~ontarget,                   %make sure fixation during wait_for_fixation
    eventmarker(5);    
    trialerror(4); % no fixation
    toggleobject(fixation_point, 'eventmarker', FIX_OFF, 'status', 'off' ); %toggle fixation_point off
    return
end

ontarget = eyejoytrack('holdfix', fixation_point, fix_window, initial_fix);
if ~ontarget,
    eventmarker(7);
    trialerror(3); % broke fixation
    toggleobject(fixation_point, 'eventmarker', FIX_OFF, 'status', 'off' ); % toggle fixation_point off
    return
end

eventmarker(6);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% bear_image presentation and response
toggleobject([fixation_point],...
    'eventmarker', FIX_OFF, 'status', 'off');
toggleobject([fixation2_point target_image ],...
    'eventmarker', TAR_ON, 'status', 'on');
% simultaneously turns of fix point and displays target & distractor
[ontarget, rt] = eyejoytrack('holdfix', fixation_point, fix_window, max_reaction_time); 
% rt will be used to update the graph on the control screen
if ontarget, % max_reaction_time has elapsed and is still on fix spot
    eventmarker(17);
    trialerror(1); % no response
    toggleobject([fixation2_point target_image ], ...
        'eventmarker', TAR_OFF, 'status', 'off'); % toggle bear_image off
    return
end
ontarget = eyejoytrack('acquirefix', target_image, target_window, saccade_time);
if ~ontarget,
    eventmarker(15);
    trialerror(2); % did not land on bear_image
    toggleobject([fixation2_point target_image ],...
        'eventmarker', TAR_OFF, 'status', 'off');
    return
end

% hold target then reward
ontarget = eyejoytrack('holdfix', target_image, target_window, hold_target_time);
if ~ontarget,
    eventmarker(16);
    trialerror(5); % broke fixation
    toggleobject([fixation2_point target_image ],...
        'eventmarker', TAR_OFF, 'status', 'off');
    return
end

eventmarker(14); %correct
trialerror(0); % correct
toggleobject(bzz, 'eventmarker', BUZZ_ON);
%goodmonkey(50, 3); % 50ms of juice x 3
toggleobject([fixation2_point target_image],...
    'eventmarker', T_ARRAY_OFF, 'status', 'off'); %turn off bear_image
eventmarker(100);
disp('END TRIAL ....good monkey')
idle(intTint);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%