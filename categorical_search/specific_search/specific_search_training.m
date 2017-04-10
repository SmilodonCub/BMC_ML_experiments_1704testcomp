%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  _______  _______  _______  _______ _________ _______ _________ _______   
% (  ____ \(  ____ )(  ____ \(  ____ \\__   __/(  ____ \\__   __/(  ____ \  
% | (    \/| (    )|| (    \/| (    \/   ) (   | (    \/   ) (   | (    \/  
% | (_____ | (____)|| (__    | |         | |   | (__       | |   | |        
% (_____  )|  _____)|  __)   | |         | |   |  __)      | |   | |        
%       ) || (      | (      | |         | |   | (         | |   | |        
% /\____) || )      | (____/\| (____/\___) (___| )      ___) (___| (____/\  
% \_______)|/       (_______/(_______/\_______/|/       \_______/(_______/  
%                                                                           
%          _______  _______  _______  _______  _______                      
%         (  ____ \(  ____ \(  ___  )(  ____ )(  ____ \|\     /|            
%         | (    \/| (    \/| (   ) || (    )|| (    \/| )   ( |            
%         | (_____ | (__    | (___) || (____)|| |      | (___) |            
%         (_____  )|  __)   |  ___  ||     __)| |      |  ___  |            
%               ) || (      | (   ) || (\ (   | |      | (   ) |            
%         /\____) || (____/\| )   ( || ) \ \__| (____/\| )   ( |            
%         \_______)(_______/|/     \||/   \__/(_______/|/     \|            
%                                                                                                                                       
% _________ _______  _______ _________ _       _________ _        _______ 
% \__   __/(  ____ )(  ___  )\__   __/( (    /|\__   __/( (    /|(  ____ \
%    ) (   | (    )|| (   ) |   ) (   |  \  ( |   ) (   |  \  ( || (    \/
%    | |   | (____)|| (___) |   | |   |   \ | |   | |   |   \ | || |      
%    | |   |     __)|  ___  |   | |   | (\ \) |   | |   | (\ \) || | ____ 
%    | |   | (\ (   | (   ) |   | |   | | \   |   | |   | | \   || | \_  )
%    | |   | ) \ \__| )   ( |___) (___| )  \  |___) (___| )  \  || (___) |
%    )_(   |/   \__/|/     \|\_______/|/    )_)\_______/|/    )_)(_______)
%                                                                                                                                                          
%   .m script to generate the fields for a txt conditions file for specific
%   search task in monkeylogic. for this task, 
%   1) a category specific fixation point (blue:butterfly red:bear) appears
%   for wait_for_fix msec
%   2) subjects holds fixation for initial_fix msec
%   3) a fixed training target (bear or butterfly) appears for target_fix msec
%   4) there is a second fixation for second_fix
%   5) the target is presented in an array with three random distractors. 
%   the subject has max_reaction_time msec to complete a saccade to the
%   target. saccade_time msec are allowed for a saccade to be completed
%   6) the subject then holds fixation on the target for hold_target_time
%   msec
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
editable('second_fix');    
editable('max_reaction_time');  
editable('saccade_time');       
editable('hold_target_time');
editable('intTint');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 



% task variables
% % % give names to the TaskObjects defined in the conditions file:
fixation_point = 1;     %white square target. fixation size is editable
target_image = 2;       %a randomly selected bear from the training bear folder used consistently throughout task & training
distractor1 = 3;
distractor2 = 4;        %randomly selected targets. different every condition & every text file generation.
distractor3 = 5;
target_primer = 6;      %same as target_image, but with location at center of screen
bzz = 7;

% define time intervals (in ms):
wait_for_fix = 1000;        %interval to wait for fixation to start
initial_fix = 1000;         %hold fixation on fixation_point
target_fix = 1000;          %present target while fixation is maintained
second_fix = 1000;          %hold fixation again
max_reaction_time = 6000;   %max time after second_fix given to complete a saccade
saccade_time = 2000;        %time allowed for saccade
hold_target_time = 700;     %hold fixation on bear_image
intTint = 1000;             %idle time inbetween conditions

% fixation window (in degrees):
fix_window = 2;
target_window = 3;


LoadEventCodes_specific_search_training
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('______________________________________________________________________')
disp('START TIRAL')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 



% initial fixation:
toggleobject(fixation_point, 'eventmarker', FIX_ON, 'status', 'on' ) %toggle fixation_point on
ontarget = eyejoytrack('acquirefix', fixation_point, fix_window, wait_for_fix);
if ~ontarget,                   %make sure fixation during wait_for_fixation
    eventmarker(5)    
    trialerror(4); % no fixation
    toggleobject(fixation_point, 'eventmarker', FIX_OFF, 'status', 'off' ) %toggle fixation_point off
    return
end

ontarget = eyejoytrack('holdfix', fixation_point, fix_window, initial_fix);
if ~ontarget,
    eventmarker(7)
    trialerror(3); % broke fixation
    toggleobject(fixation_point, 'eventmarker', FIX_OFF, 'status', 'off' ) % toggle fixation_point off
    return
end

eventmarker(6);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%present target at fixation
toggleobject([fixation_point target_primer], 'eventmarker', TAR_ON) %turn off fixation_point and turn on primer target
ontarget = eyejoytrack('acquirefix', target_primer, fix_window, target_fix);
if ~ontarget,
    eventmarker(12)
    trialerror(4); % no fixation
    toggleonject(target_primer, 'eventmarker', TAR_OFF, 'status', 'off' ) %toggle off the target primer
    return
end
ontarget = eyejoytrack('holdfix', target_primer, fix_window, second_fix);
if ~ontarget,
    event_marker(16)
    trialerror(3); % broke fixation
    toggleobject(target_primer, 'eventmarker', TAR_OFF, 'status', 'off' ) % toggle fixation_point off
    return
end
eventmarker(14);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%second fixation
toggleobject([fixation_point target_primer],'eventmarker', FIX_ON) %toggle off target primer & turn fixation_point on
ontarget = eyejoytrack('acquirefix', fixation_point, fix_window, wait_for_fix);
if ~ontarget,                   %make sure fixation during wait_for_fixation
    eventmarker(5)
    trialerror(4); % no fixation
    toggleobject(fixation_point, 'eventmarker', FIX_OFF, 'status', 'off' ) %toggle fixation_point off
    return
end
ontarget = eyejoytrack('holdfix', fixation_point, fix_window, initial_fix);
if ~ontarget,
    eventmarker(7)
    trialerror(3); % broke fixation
    toggleobject(fixation_point, 'eventmarker', FIX_OFF, 'status', 'off' ) % toggle fixation_point off
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% bear_image presentation and response
toggleobject([fixation_point target_image distractor1 distractor2 distractor3],...
    'eventmarker', T_ARRAY_ON, 'status', 'on');
% simultaneously turns of fix point and displays target & distractor
[ontarget, rt] = eyejoytrack('holdfix', fixation_point, fix_window, max_reaction_time); 
% rt will be used to update the graph on the control screen
if ontarget, % max_reaction_time has elapsed and is still on fix spot
    eventmarker(23)
    trialerror(1); % no response
    toggleobject([target_image distractor1 distractor2 distractor3], ...
        'eventmarker', T_ARRAY_OFF, 'status', 'off') % toggle bear_image off
    return
end
ontarget = eyejoytrack('acquirefix', target_image, target_window, saccade_time);
if ~ontarget,
    eventmarker(24)
    trialerror(2); % did not land on bear_image
    toggleobject([target_image distractor1 distractor2 distractor3],...
        'eventmarker', T_ARRAY_OFF, 'status', 'off')
    return
end

% hold target then reward
ontarget = eyejoytrack('holdfix', target_image, target_window, hold_target_time);
if ~ontarget,
    eventmarker(25)
    trialerror(5); % broke fixation
    toggleobject([target_image distractor1 distractor2 distractor3],...
        'eventmarker', T_ARRAY_OFF, 'status', 'off')
    return
end

eventmarker(26); %correct
trialerror(0); % correct
toggleobject(bzz, 'eventmarker', BUZZ_ON);
%goodmonkey(50, 3); % 50ms of juice x 3
toggleobject([fixation_point target_image distractor1 distractor2 distractor3],...
    'eventmarker', T_ARRAY_OFF, 'status', 'off'); %turn off bear_image
eventmarker(100);
disp('END TRIAL ....good monkey')
idle(intTint);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 