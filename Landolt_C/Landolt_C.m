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
%                                                                                               
%
%
%   .m script for generating the txt conditions file for landolt C memory guided saccade task.
%
% 
% %
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
LoadEventCodes_MCPKLB                 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%

% EDITABLE
editable( 'wait_for_fix' );         %interval to wait for fixation to start
editable( 'initial_fix' );          %hold fixation on fixation_point
editable( 'precue_fix' );           %interval between fixation and cue presentation
editable( 'cue_fix' );              %hold fixation during cue presentation
editable( 'max_reaction_time' );    %max time after initial_fix given to complete a saccade
editable( 'saccade_time' );         %time allowed for saccade
editable( 'hold_target_time' );     %hold fixation on bear_image
editable( 'fix_window' ); 
editable( 'target_window' );


%time intervals (in ms):
wait_for_fix = 1000;         %interval to wait for fixation to start
initial_fix = 1000;          %hold fixation on fixation_point
precue_fix = 200;            %interval between fixation & cueing
cue_fix = 1000;              %hold fixation during cue presentation
max_reaction_time = 5000;    %max time after initial_fix given to complete a saccade
saccade_time = 3000;         %time allowed for saccade
hold_target_time = 700;      %hold fixation on image

% fixation window (in deg.vis.ang.):
fix_window = 2;
target_window = 3;


%give names to the TaskObjects defined in the conditions file:
fixation_point = 1;
target = 2;
distractor1 = 3;
distractor2 = 4;
distractor3 = 5;
cue = 6;
bzz = 7;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('______________________________________________________________________')
disp('START TIRAL')
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
% initial hold fixation
ontarget = eyejoytrack('holdfix', fixation_point, fix_window, initial_fix);
if ~ontarget,
    eventmarker(7);
    trialerror(3); % broke fixation
    toggleobject(fixation_point, 'eventmarker', FIX_OFF, 'status', 'off' ); % toggle fixation_point off
    return
end

%monkey held fixation
eventmarker(6);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cue target position

%keep looking at fix during cue presentation
toggleobject([fixation_point cue], 'eventmarker', CUE_ON, 'status', 'on'); %turn off fixation_point and turn on primer target
ontarget = eyejoytrack('acquirefix', cue, fix_window, precue_fix);
if ~ontarget,
    eventmarker(33);
    trialerror(4); % no fixation
    toggleonject([fixation_point cue], 'eventmarker', CUE_OFF, 'status', 'off' );%toggle off the target primer
    return
end
%hold fixation during cue interval cue_fix
ontarget = eyejoytrack('holdfix', cue, fix_window, cue_fix);
if ~ontarget,
    event_marker(35);
    trialerror(3); % broke fixation
    toggleobject([fixation_point cue], 'eventmarker', CUE_OFF, 'status', 'off' ); % toggle fixation_point off
    return
end
eventmarker(36);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% target array presentation and response
%toggle on target/distractors toggle off cue
toggleobject([fixation_point cue], 'eventmarker', CUE_OFF, 'status', 'off')
toggleobject([target distractor1 distractor2 distractor3],...
    'eventmarker', T_ARRAY_ON, 'status', 'on');
[ontarget, rt] = eyejoytrack('holdfix', fixation_point, fix_window, max_reaction_time); 
% rt will be used to update the graph on the control screen
if ontarget, % max_reaction_time has elapsed and is still on fix spot
    eventmarker(17);
    trialerror(1); % no response
    toggleobject([target distractor1 distractor2 distractor3], ...
        'eventmarker', T_ARRAY_OFF, 'status', 'off'); % toggle target array off
    return
end
ontarget = eyejoytrack('acquirefix', target, target_window, saccade_time);
if ~ontarget,
    eventmarker(23);
    trialerror(2); % did not land on target array
    toggleobject([target distractor1 distractor2 distractor3],...
        'eventmarker', T_ARRAY_OFF, 'status', 'off');
    return
end

% hold target then reward
ontarget = eyejoytrack('holdfix', target, target_window, hold_target_time);
if ~ontarget,
    eventmarker(25);
    trialerror(5); % broke fixation
    toggleobject([ target distractor1 distractor2 distractor3],...
        'eventmarker', T_ARRAY_OFF, 'status', 'off');
    return
end

eventmarker(26); %correct
trialerror(0); % correct
toggleobject(bzz, 'eventmarker', BUZZ_ON);
goodmonkey(50); % 50ms of juice
toggleobject([target distractor1 distractor2 distractor3],...
    'eventmarker', T_ARRAY_OFF, 'status', 'off'); %turn off target array
eventmarker(100); %trial over
disp('Successful Trial: GOOD MONKEY')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 