%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ________________ ___.           __    __                 
% \__    ___/  _  \\_ |__  __ ___/  |__/  |_  ____   ____  
%   |    | /  /_\  \| __ \|  |  \   __\   __\/  _ \ /    \ 
%   |    |/    |    \ \_\ \  |  /|  |  |  | (  <_> )   |  \
%   |____|\____|__  /___  /____/ |__|  |__|  \____/|___|  /
%                 \/    \/                              \/ 
%                                    .__                   
%   ______ ____ _____ _______   ____ |  |__                
%  /  ___// __ \\__  \\_  __ \_/ ___\|  |  \               
%  \___ \\  ___/ / __ \|  | \/\  \___|   Y  \              
% /____  >\___  >____  /__|    \___  >___|  /              
%      \/     \/     \/            \/     \/                             
%                                                                                                                                                
%   .m script to generate the fields for a txt conditions file for specific
%   search task in monkeylogic. for this task, 
%   1) a category specific fixation point (blue:butterfly red:bear) appears
%   for wait_for_fix msec
%   2) subjects holds fixation for initial_fix msec
%   3) on some trials a target is presented: the target is presented in an 
%   array with N random distractors place in N of N+1 posible locations 
%   evenly spaced 360/Ndeg from the target. the subject has max_reaction_time 
%   msec to complete a saccade to the target. saccade_time msec are allowed 
%   for a saccade to be completed
%   4) the subject then holds fixation on the target for hold_target_time
%   msec to recieve a reward
%   5) on other trials, there is no target present, only N+1 distractors. in
%   this case, the subject has max_reaction_time to fixate the Target
%   Absent 'button' for fix_return_time to recieve a reward.
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
%editables. these can be changed dynamically in ML task menu ( press 'v')
editable('fix_window');
editable('target_window');
editable('TAbutton_window');
editable('wait_for_fix');        
editable('initial_fix');            
editable('max_reaction_time');      
editable('hold_target_time');
editable('fix_return_time');
editable('intTint');
editable('reward');
editable('num_reward');
editable('pause_reward');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 



% task variables
% % % give names to the TaskObjects defined in the conditions file:
% the numbers correspond with the TaskObject# in the text files
bzz = 1;
bzz2 = 2;
fixation_point = 3;     %red square target. 
TAbutton = 4;
hold_image = 5;
target_image = 5; 
distractor1_image = 6;
distractor2_image = 7;
distractor3_image = 8;
% stimulus_array length is contingent on the how many distractors, so:
taskobject_array = [ TAbutton target_image distractor1_image distractor2_image distractor3_image ];
num_TaskObjects = length( TrialRecord.CurrentConditionStimulusInfo );
stim_array = taskobject_array( 1:( num_TaskObjects - 3 )); 
distractor_array = taskobject_array( 4:end );


% define time intervals (in ms) these are all editable:
wait_for_fix = 1000;         %interval to wait for fixation to start
initial_fix = 1000;          %hold fixation on fixation_point
max_reaction_time = 10000;    %max time after fixation given to complete a saccade
hold_target_time = 1000;     %hold fixation on bear_image to get reward
fix_return_time = 1000;      %if no bear target is present, this is the interval of time the subject must hold fixation for reward
intTint = 100;               %idle time inbetween conditions, useful to have a pause so that manual reward can be given during training.

% set hot key for manual reward
reward = 400;
num_reward = 3;
pause_reward = 100;
hotkey('g', 'goodmonkey(400, ''NumReward'', 2,''PauseTime'', 50);' ); 

% fixation window (in degrees):
fix_window = 2;
target_window = 3;
TAbutton_window = 3;

%flag in case the Target Absent Button is the target of a saccade for a
%Target present trial
TAbutton_flag = 0;

LoadEventCodes_MCPKLB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('______________________________________________________________________')
disp('START TRIAL')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
eventmarker(1);



% initial fixation:
toggleobject(fixation_point, 'eventmarker', FIX_ON, 'status', 'on' ); %toggle fixation_point on
ontarget = eyejoytrack('acquirefix', fixation_point, fix_window, wait_for_fix);
if ~ontarget,                   %make sure there is a fixation by wait_for_fixation ms after the trial starts
    eventmarker(5);    
    trialerror(4); % no fixation
    toggleobject(fixation_point, 'eventmarker', FIX_OFF, 'status', 'off' ); %toggle fixation_point off
    eventmarker(100);
    disp('did not fixate')
    return
end

ontarget = eyejoytrack('holdfix', fixation_point, fix_window, initial_fix);
if ~ontarget,
    eventmarker(7);
    trialerror(3); % broke fixation
    toggleobject(fixation_point, 'eventmarker', FIX_OFF, 'status', 'off' ); % toggle fixation_point off
    eventmarker(100);
    disp('did not fixate long enough')
    return
end

eventmarker(6);
disp('fixated')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% bear_image presentation and response
targetcon= str2num(TrialRecord.CurrentConditionInfo.ifBear);  %get condition info: does this trial present a target(1) or not(0)?


toggleobject([fixation_point],...
    'eventmarker', FIX_OFF, 'status', 'off'); %turn off fixation
toggleobject([ stim_array ],...
    'eventmarker', T_ARRAY_ON, 'status', 'on');

[ arrayon_time, arrayon_frame ] = trialtime;
array_time = arrayon_time;

break_flag = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% bear_image present
if targetcon == 1
    disp('there is a bear target')   
    
    while array_time < ( arrayon_time + max_reaction_time )
        [ array_time, arrayon_frame ] = trialtime;
         % turns on fix2 point and displays target array
        [ontarget, rt] = eyejoytrack('holdfix', fixation_point, fix_window, max_reaction_time);
        if ontarget, % max_reaction_time has elapsed and is still on fix spot
            eventmarker(17);
            trialerror(1); % no response
            toggleobject([stim_array], ...
                'eventmarker', T_ARRAY_OFF, 'status', 'off'); % toggle target array off
            eventmarker(100);
            disp('did not leave fixation/react in time')
            return
        end
        
        [ontarget, rt] = eyejoytrack('acquirefix', [target_image TAbutton], target_window, max_reaction_time); %'acquirefix', TAbutton, target_window, max_reaction_time);
        if ~ontarget,
            eventmarker(15);
            trialerror(6); % did not land on bear_image
            toggleobject([stim_array],...
                'eventmarker', T_ARRAY_OFF, 'status', 'off');
            eventmarker(100);
            disp('did not land on the target in time')
            return
        elseif ontarget==2,
            hold_target_time = 50;
            TAbutton_flag = 1;
            hold_image = 4;
            target_window = 1.5;
%             trialerror(6);
%             eventmarker(41);  
%             toggleobject([stim_array],...
%                 'eventmarker', T_ARRAY_OFF, 'status', 'off');
%             eventmarker(100);
%             disp('landed on TAbutton while a Target was present')
%             return
        end
        
        % hold target then reward
        ontarget = eyejoytrack('holdfix', hold_image, target_window, hold_target_time);
        if ~ontarget && array_time >= ( arrayon_time + max_reaction_time - hold_target_time),
            eventmarker(16);
            trialerror(3); % broke fixation on target
            toggleobject([stim_array],...
                'eventmarker', T_ARRAY_OFF, 'status', 'off');
            eventmarker(100);
            disp('did not hold target long enough')
            return 
        elseif ontarget,
            if TAbutton_flag == 0;
                eventmarker(14); %correct
                trialerror(0); % correct
                toggleobject(bzz, 'eventmarker', BUZZ_ON);
                goodmonkey(reward, 'NumReward', num_reward, 'PauseTime', pause_reward);
                [ endtime, endframe ] = trialtime;
                disp(['GOOD MONKEY....trialtime = ' num2str(endtime)])
                break_flag = 1;
                break
            elseif TAbutton_flag == 1;
                trialerror(6);
                eventmarker(41);
                toggleobject(bzz2, 'eventmarker', BUZZ_ON);
                toggleobject([stim_array],...
                    'eventmarker', T_ARRAY_OFF, 'status', 'off');
                eventmarker(100);
                disp('landed on TAbutton while a Target was present')
                return
            end
        end
        
        if break_flag == 1
            break
        end
       
    end
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% no bear_image present
elseif targetcon == 0
    disp('there is no bear')
    while array_time < ( arrayon_time + max_reaction_time )
        [ array_time, arrayon_frame ] = trialtime;
        
        ontarget = eyejoytrack('acquirefix', TAbutton, fix_window, max_reaction_time);
        if ~ontarget, 
            eventmarker(15);
            trialerror(1); % did not land on bear_image
            toggleobject([stim_array],...
                'eventmarker', T_ARRAY_OFF, 'status', 'off');
            eventmarker(100);
            return
        end
        
        % hold target then reward
        ontarget = eyejoytrack('holdfix', TAbutton, fix_window, fix_return_time);
        if ~ontarget && array_time >= ( arrayon_time + max_reaction_time - fix_return_time ),
            eventmarker(16);
            trialerror(3); % broke fixation
            toggleobject([stim_array],...
                'eventmarker', T_ARRAY_OFF, 'status', 'off');
            eventmarker(100);
            disp('did not retrun to fixation long enough')
            return
        elseif ontarget
            eventmarker(14); %correct
            trialerror(0); % correct
            toggleobject(bzz, 'eventmarker', BUZZ_ON);
            goodmonkey(reward, 'NumReward', num_reward, 'PauseTime', pause_reward);
            [ endtime, endframe ] = trialtime;
            disp(['GOOD MONKEY....trialtime = ' num2str(endtime)])
            break_flag = 1;
            break
        end
        
        if break_flag == 1
            break
        end
        
    end
    
end
    
toggleobject([stim_array],...
    'eventmarker', T_ARRAY_OFF, 'status', 'off'); %turn off bear_image
eventmarker(100);
[ endtime, endframe ] = trialtime;
disp( ['END TRIAL @ t =' num2str(endtime)] )
idle(intTint);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%