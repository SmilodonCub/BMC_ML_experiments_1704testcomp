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
%   monkeylogic timing script for basic receptice field mapping.
%
%   1) fixation point appears
%   2) monkey has wait_for_fix msecs to acquire fixation
%   3) monkey holds fixation for initial_fix msecs
%   4) fixation point toggles off & target toggles on
%   5) monkey has max_reaction_time to complete a saccade to the target and
%   saccade_time msecs are allowed for a saccade
%   6) monkey must mainitain fixation on the target for hold_target_time
%   msecs
%   7) goodmonkey
% 
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
%editables
editable('wait_for_fix')        %interval to wait for fixation to start (msec)
editable('initial_fix')         %hold fixation on fixation_point (msec)
editable('max_reaction_time')   %max time after initial_fix given to complete a saccade (msec)
editable('saccade_time')        %time allowed for saccade (msec)
editable('hold_target_time')    %hold fixation on bear_image (msec)
editable('fix_radius')          %fixation window (deg.vis.ang)
editable('target_radius')       %target sacade window (deg.vis.ang.)
editable('intTint')             %idle time inbetween conditions (msec)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% task variables
% % % give names to the TaskObjects defined in the conditions file:
fixation_point = 1;
target_crc = 2;
bzz = 3;

% define time intervals (in ms):
wait_for_fix = 1000;        %interval to wait for fixation to start
initial_fix = 1000;          %hold fixation on fixation_point
max_reaction_time = 6000;    %max time after initial_fix given to complete a saccade
saccade_time = 2000;          %time allowed for saccade
hold_target_time = 700;     %hold fixation on bear_image

% fixation window (in deg.vis.ang.):
fix_radius = 2;
target_radius = 3;


LoadEventCodes_RFM
disp('************************************************************************')
disp('START TRIAL')
eventmarker(1)
% initial fixation:
toggleobject(fixation_point, 'eventmarker', FIX_ON_RFM, 'status', 'on') %toggle fixation_point on
ontarget = eyejoytrack('acquirefix', fixation_point, fix_radius, wait_for_fix);
if ~ontarget,                   %make sure fixation during wait_for_fixation
    eventmarker(5)
    trialerror(4); % no fixation
    toggleobject(fixation_point, 'eventmarker', FIX_OFF_RFM, 'status', 'off') %toggle fixation_point off
    return
end
ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, initial_fix);
if ~ontarget,
    eventmarker(7)
    trialerror(3); % broke fixation
    toggleobject(fixation_point, 'eventmarker', FIX_OFF_RFM, 'status', 'off') % toggle fixation_point off
    return
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% bear_image presentation and response
toggleobject([fixation_point target_crc], 'eventmarker', TARG_ON_RFM);
% simultaneously turns of fix point and displays target
[ontarget, rt] = eyejoytrack('holdfix', fixation_point, fix_radius, max_reaction_time); 
% rt will be used to update the graph on the control screen
if ontarget, % max_reaction_time has elapsed and is still on fix spot
    eventmarker(17)
    trialerror(1); % no response
    toggleobject(target_crc, 'eventmarker', TARG_OFF_RFM, 'status', 'off') % toggle target off
    return
end
ontarget = eyejoytrack('acquirefix', target_crc, target_radius, saccade_time);
if ~ontarget,
    eventmarker(15)
    trialerror(2); % no or late response (did not land on target)
    toggleobject(target_crc, 'eventmarker', TARG_OFF_RFM, 'status', 'off')
    return
end

% hold target then reward
ontarget = eyejoytrack('holdfix', target_crc, target_radius, hold_target_time);
if ~ontarget,
    eventmarker(16)
    trialerror(5); % broke fixation
    toggleobject(target_crc, 'eventmarker', TARG_OFF_RFM, 'status', 'off')
    return
end
trialerror(0); % correct
toggleobject(bzz, 'eventmarker', BUZZ_ON_RFM, 'status', 'on')
eventmarker(14)
%goodmonkey(50, 3); % 50ms of juice x 3

toggleobject(target_crc, 'eventmarker', TARG_OFF_RFM, 'status', 'off'); %turn off bear_image
disp('END TRIAL')
eventmarker(100)
idle(intTint)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 