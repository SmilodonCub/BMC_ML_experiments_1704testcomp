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
%                                                                                 
%            _                           _                _____       
%           | |                         | |              / __  \      
%   ___ __ _| |_ ___  ___  __ _ _ __ ___| |__      _ __  `' / /' __ _ 
%  / __/ _` | __/ __|/ _ \/ _` | '__/ __| '_ \    | '_ \   / /  / _` |
% | (_| (_| | |_\__ \  __/ (_| | | | (__| | | |   | |_) |./ /__| (_| |
%  \___\__,_|\__|___/\___|\__,_|_|  \___|_| |_|   | .__/ \_____/\__,_|
%                                           ______| |                 
%                                          |______|_|                                                                                                               
% 
%
%   .m script to generate the fields for a txt conditions file for specific
%   search task in monkeylogic. for this task, a category specific fixation
%   target will be display (blue for butterflies and red for teddy bears). 
%   Once the fixation spot is toggled off, the monkey is to make a saccade 
%   to the appropriate target location in a field of three other distractor 
%   targets.
%
% 
% %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  _____         _    
% |_   _|       | |   
%   | | __ _ ___| | __
%   | |/ _` / __| |/ /
%   | | (_| \__ \   < 
%   \_/\__,_|___/_|\_\
% after fixation is held 4 700ms, a bear_image is presented @ 1 of 4 locations
% task variables
% page1: (initial fixation) check for good holding fixation
% page2: (bear_image presentation and response) present bear_image,
%               still at fixation?, saccade to target?, if on target is
%               hold_target_time?, if yes, goodmonkey. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                    
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% task variables
% % % give names to the TaskObjects defined in the conditions file:
fixation_point = 1;
target_image = 2;
distractor1 = 3;
distractor2 = 4;
distractor3 = 5;
target_primer = 6;

% define time intervals (in ms):
wait_for_fix = 1000;        %interval to wait for fixation to start
initial_fix = 1000;       %hold fixation on fixation_point
target_fix = 1000;      %present target while fixation is maintained
second_fix = 1000;      %hold fixation again
max_reaction_time = 2000;    %max time after initial_fix given to complete a saccade
saccade_time = 2000;          %time allowed for saccade
hold_target_time = 700;     %hold fixation on bear_image

% fixation window (in degrees):
fix_radius = 2;
target_primer_radius = 3;


% initial fixation:
toggleobject(fixation_point) %toggle fixation_point on
ontarget = eyejoytrack('acquirefix', fixation_point, fix_radius, wait_for_fix);
if ~ontarget,                   %make sure fixation during wait_for_fixation
    trialerror(4); % no fixation
    toggleobject(fixation_point) %toggle fixation_point off
    return
end
ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, initial_fix);
if ~ontarget,
    trialerror(3); % broke fixation
    toggleobject(fixation_point) % toggle fixation_point off
    return
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%present target at fixation
toggleobject([fixation_point target_primer]) %turn off fixation_point and turn on primer target
ontarget = eyejoytrack('acquirefix', target_primer, target_primer_radius, target_fix);
if ~ontarget,
    trialerror(4); % no fixation
    toggleonject(target_primer) %toggle off the target primer
    return
end
ontarget = eyejoytrack('holdfix', target_primer, target_primer_radius, second_fix);
if ~ontarget,
    trialerror(3); % broke fixation
    toggleobject(target_primer) % toggle fixation_point off
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%second fixation
toggleobject([fixation_point target_primer]) %toggle off target primer & turn fixation_point on
ontarget = eyejoytrack('acquirefix', fixation_point, fix_radius, wait_for_fix);
if ~ontarget,                   %make sure fixation during wait_for_fixation
    trialerror(4); % no fixation
    toggleobject(fixation_point) %toggle fixation_point off
    return
end
ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, initial_fix);
if ~ontarget,
    trialerror(3); % broke fixation
    toggleobject(fixation_point) % toggle fixation_point off
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% bear_image presentation and response
toggleobject([fixation_point target_image distractor1 distractor2 distractor3]);
% simultaneously turns of fix point and displays target & distractor
[ontarget, rt] = eyejoytrack('holdfix', fixation_point, fix_radius, max_reaction_time); 
% rt will be used to update the graph on the control screen
if ontarget, % max_reaction_time has elapsed and is still on fix spot
    trialerror(1); % no response
    toggleobject([target_image distractor1 distractor2 distractor3]) % toggle bear_image off
    return
end
ontarget = eyejoytrack('acquirefix', target_image, fix_radius, saccade_time);
if ~ontarget,
    trialerror(2); % no or late response (did not land on bear_image)
    toggleobject([target_image distractor1 distractor2 distractor3])
    return
end

% hold target then reward
ontarget = eyejoytrack('holdfix', target_image, fix_radius, hold_target_time);
if ~ontarget,
    trialerror(5); % broke fixation
    toggleobject([target_image distractor1 distractor2 distractor3])
    return
end
trialerror(0); % correct
%goodmonkey(50, 3); % 50ms of juice x 3

toggleobject([target_image distractor1 distractor2 distractor3]); %turn off bear_image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 