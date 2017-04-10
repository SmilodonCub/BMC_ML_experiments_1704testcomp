%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  _______  _______  _______  _______  _______             _______  _______  _______  _______  _______  ______   _______ 
% (  ____ \(  ____ \(  ___  )(  ____ )(  ____ \|\     /|  (  ____ \(  ___  )(  ____ \(  ____ \(  ___  )(  __  \ (  ____ \
% | (    \/| (    \/| (   ) || (    )|| (    \/| )   ( |  | (    \/| (   ) || (    \/| (    \/| (   ) || (  \  )| (    \/
% | (_____ | (__    | (___) || (____)|| |      | (___) |  | (_____ | (___) || |      | |      | (___) || |   ) || (__    
% (_____  )|  __)   |  ___  ||     __)| |      |  ___  |  (_____  )|  ___  || |      | |      |  ___  || |   | ||  __)   
%       ) || (      | (   ) || (\ (   | |      | (   ) |        ) || (   ) || |      | |      | (   ) || |   ) || (      
% /\____) || (____/\| )   ( || ) \ \__| (____/\| )   ( |  /\____) || )   ( || (____/\| (____/\| )   ( || (__/  )| (____/\
% \_______)(_______/|/     \||/   \__/(_______/|/     \|  \_______)|/     \|(_______/(_______/|/     \|(______/ (_______/
%                                                                                                                                                                                   
%                                                                                 
%                                                                                             
%
%   monkeylogic timing script for basic search saccade task.
%   1) fixation point appears 
%   2) monkey has wait_for_fx msec to fixate & must hold for initial_fix
%   msec within fix_radius (degvisang)
%   3) an array of target/distractors appears & the fixation point
%   disappears
%   4) monkey has max_reaction_time msec to make a saccade to the target
%   within target_radius (degvisang)
%   5) once acquired, monkey must hold fixation on target for
%   hold_target_time msec
%

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
LoadEventCodes_MCPKLB                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 
% % % give names to the TaskObjects defined in the conditions file:
bzz = 1;
fixation_point = 2;
crc1 = 3; crc2 = 4; crc3 = 5; crc4 = 6; crc5 = 7; crc6 = 8; crc7 = 9; crc8 = 10; crc9 = 11; crc10 = 12; crc11 = 13; crc12 = 14; crc13 = 15; crc14 = 16;
targetobject_array = [fixation_point crc1 crc2 crc3 crc4 crc5 crc6 crc7 crc8 crc9 crc10 crc11 crc12 crc13 crc14];


% EDITABLE
editable( 'wait_for_fix' );         %interval to wait for fixation to start (msec)
editable( 'initial_fix' );          %hold fixation on fixation_point (msec)
editable( 'max_reaction_time' );    %max time after initial_fix given to complete a saccade (msec)
editable( 'saccade_time' );         %time allowed for saccade (msec)
editable( 'hold_target_time' );     %hold fixation on bear_image (msec)
editable( 'fix_radius' );           %fixation saccade window (deg.vis.ang.)
editable( 'target_radius' );        %target saccade window (deg.vis.ang.)
editable( 'intTint');               %idle time inbetween conditions (msec)


% define time intervals (in ms):
wait_for_fix = 1000;        %interval to wait for fixation to start (msec)
initial_fix = 1000;         %hold fixation on fixation_point (msec)
max_reaction_time = 5000;   %max time after initial_fix given to complete a saccade (msec)
saccade_time = 3000;        %time allowed for saccade (msec)
hold_target_time = 700;     %hold fixation on image (msec)
intTint = 1000;             %idle time inbetween conditions (msec)

% fixation window (in degrees):
fix_radius = 2;
target_radius = 3;

%START TRIAL
disp('*********************************************************************************************')
disp('START TRIAL')
eventmarker(1);

% initial fixation:
toggleobject( fixation_point, 'eventmarker', FIX_ON, 'status', 'on' ); %toggle fixation_point on
ontarget = eyejoytrack('acquirefix', fixation_point, fix_radius, wait_for_fix);
if ~ontarget,                   %make sure fixation during wait_for_fixation
    eventmarker(5);
    trialerror(4); % no fixation
    toggleobject( fixation_point, 'eventmarker', FIX_OFF, 'status', 'off' ); %toggle fixation_point off
    return
end
ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, initial_fix);
if ~ontarget,
    eventmarker(7);
    trialerror(3); % broke fixation
    toggleobject( fixation_point, 'eventmarker', FIX_OFF, 'status', 'off' ); % toggle fixation_point off
    return
end
eventmarker(6);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% target array presentation and response
% stimulus_array length is contingent on the current condition, so:
num_TaskObjects = length( TrialRecord.CurrentConditionStimulusInfo );
stimulus_array = targetobject_array( 1:(num_TaskObjects-1));


toggleobject( stimulus_array, 'eventmarker', T_ARRAY_ON );
% simultaneously turns of fix point and displays target & distractor
[ ontarget, rt ] = eyejoytrack( 'holdfix', fixation_point, fix_radius, max_reaction_time ); 
% rt will be used to update the graph on the control screen
if ontarget, % max_reaction_time has elapsed and is still on fix spot
    eventmarker(17);
    trialerror( 1 ); % no response
    toggleobject( stimulus_array, 'eventmarker', T_ARRAY_OFF, 'status', 'off'  ); % toggle target image off
    return
end
ontarget = eyejoytrack('acquirefix', crc1, target_radius, saccade_time);
if ~ontarget,
    eventmarker(15);
    trialerror(2); % no or late response (did not land on target image)
    toggleobject( stimulus_array, 'eventmarker', T_ARRAY_OFF, 'status', 'off');
    return
end

% hold target then reward
ontarget = eyejoytrack('holdfix', crc1, target_radius, hold_target_time);
if ~ontarget,
    eventmarker(16);
    trialerror(5); % broke fixation
    toggleobject( stimulus_array, 'eventmarker', T_ARRAY_OFF, 'status', 'off' );
    return
end

eventmarker(14);
trialerror(0); % correct
%goodmonkey(50, 3,'PauseTime', 75); % 50ms of juice x 3
disp('reward given to a good monkey');

toggleobject( stimulus_array, 'eventmarker', T_ARRAY_OFF, 'status', 'off' ); %turn off target image
toggleobject( bzz, 'eventmarker', BUZZ_ON );
eventmarker(100);
disp('END TRIAL')
idle(intTint)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
