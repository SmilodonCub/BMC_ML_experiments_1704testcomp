%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            _                           _               __        
%           | |                         | |             /  |       
%   ___ __ _| |_ ___  ___  __ _ _ __ ___| |__      _ __ `| |  __ _ 
%  / __/ _` | __/ __|/ _ \/ _` | '__/ __| '_ \    | '_ \ | | / _` |
% | (_| (_| | |_\__ \  __/ (_| | | | (__| | | |   | |_) || || (_| |
%  \___\__,_|\__|___/\___|\__,_|_|  \___|_| |_|   | .__/\___/\__,_|
%                                           ______| |              
%                                          |______|_|                                                       
%   catsearch_p1a  
%   monkeylogic timing script for Phase 1a of Categorical Search tasks.
%
% This is a saccade targeting task.
% A saccade is made to a target (teddy bear object from training set) as soon as it appears.
% The target randomly appears in one of 4 possible display locations
% Then fixation is held on the target for 700ms to get a reward
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% give names to the TaskObjects defined in the conditions file:
fixation_point = 1;
bear_image = 2;
cross = 3;

% define time intervals (in ms):
wait_for_fix = 1000;        %interval to wait for fixation to start
initial_fix = 1000;          %hold fixation on fixation_point
max_reaction_time = 2000;    %max time after initial_fix given to complete a saccade
saccade_time = 2000;          %time allowed for saccade
hold_target_time = 700;     %hold fixation on bear_image

% fixation window (in degrees):
fix_radius = 2;            


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  _____         _    
% |_   _|       | |   
%   | | __ _ ___| | __
%   | |/ _` / __| |/ /
%   | | (_| \__ \   < 
%   \_/\__,_|___/_|\_\
% after fixation is held 4 700ms, a bear_image is presented @ 1 of 4 locations
% block1: (initial fixation) check for good holding fixation
% block2: (bear_image presentation and response) present bear_image,
%               still at fixation?, saccade to target?, if on target is
%               hold_target_time?, if yes, goodmonkey. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                    
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% initial fixation:
toggleobject([fixation_point cross]);   %toggle fixation_point on
ontarget = eyejoytrack('acquirefix', fixation_point, fix_radius, wait_for_fix);
if ~ontarget,                   %make sure fixation during wait_for_fixation
    trialerror(4); % no fixation
    toggleobject([fixation_point cross]) % toggle fixation_point off
    return
end
ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, initial_fix);
if ~ontarget,
    trialerror(3); % broke fixation
    toggleobject([fixation_point cross]) % toggle fixation_point off
    return
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% bear_image presentation and response
toggleobject([fixation_point cross bear_image]); % simultaneously turns of fix point and displays target & distractor
[ontarget rt] = eyejoytrack('holdfix', fixation_point, fix_radius, max_reaction_time); 
% rt will be used to update the graph on the control screen
if ontarget, % max_reaction_time has elapsed and is still on fix spot
    trialerror(1); % no response
    toggleobject([bear_image]) % toggle bear_image off
    return
end
ontarget = eyejoytrack('acquirefix', [bear_image], fix_radius, saccade_time);
if ~ontarget,
    trialerror(2); % no or late response (did not land on bear_image)
    toggleobject([bear_image])
    return
end

% hold target then reward
ontarget = eyejoytrack('holdfix', bear_image, fix_radius, hold_target_time);
if ~ontarget,
    trialerror(5); % broke fixation
    toggleobject([bear_image])
    return
end
trialerror(0); % correct
%goodmonkey(50, 3); % 50ms of juice x 3

toggleobject([bear_image]); %turn off bear_image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 