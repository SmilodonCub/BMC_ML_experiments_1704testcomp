%dms (timing script)

% This task requires that either an "eye" input or joystick (attached to the
% eye input channels) is available to perform the necessary responses.
% 
% During a real experiment, a task such as this should make use of the
% "eventmarker" command to keep track of key actions and state changes (for
% instance, displaying or extinguishing an object, initiating a movement, etc).

% give names to the TaskObjects defined in the conditions file:
fixation_point = 1;
trialGate = 2;
cue1 = 3;
cue2 = 4;
target = 5;
cue1high = 6;
cue2high = 7;
cue1low = 8;
cue2low = 9;

bzz = 10;
% define time intervals (in ms):

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% _____      _ _   _       _ _          _   _
%|_   _|    (_) | (_)     | (_)        | | (_)
%  | | _ __  _| |_ _  __ _| |_ ______ _| |_ _  ___  _ __
%  | || '_ \| | __| |/ _` | | |_  / _` | __| |/ _ \| '_ \
% _| || | | | | |_| | (_| | | |/ / (_| | |_| | (_) | | | |
% \___/_| |_|_|\__|_|\__,_|_|_/___\__,_|\__|_|\___/|_| |_|
% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global connection
global apmDataList

% List of Event Codes  used for the Task (has to be updated when using new
% event codes / event codes have to be used according to this list
LoadEventCodes; % load event codes


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% _____    _ _ _        _     _
%|  ___|  | (_) |      | |   | |
%| |__  __| |_| |_ __ _| |__ | | ___
%|  __|/ _` | | __/ _` | '_ \| |/ _ \
%| |__| (_| | | || (_| | |_) | |  __/
%\____/\__,_|_|\__\__,_|_.__/|_|\___|
%
editable('SaccadeMode');
editable('Max_Reward');
editable('Min_RT');
editable('Max_RT');
editable('wait_for_fix');

editable('hold_FP_Min');
editable('hold_FP_Max');

%editable('Cue_Duration_Min');
%editable('Cue_Duration_Max');
editable('Hold_Target');
editable('Correct_Target_To_Reward_Delay');

editable('FP_Window');
editable('Target_Window');
 
editable('PostReward_Delay_Min');
editable('PostReward_Delay_Max');

FAILED_TRIAL = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameters for Timing Experimentation %%%%%%%%%%%%%%%%%
SaccadeMode = 2;
Max_Reward = 400;
Min_RT = 100;
Max_RT = 700;
wait_for_fix = 2500;

hold_FP_Min = 300;
hold_FP_Max = 500;

%Cue_Duration_Min = 400;
%Cue_Duration_Max = 400;

%Target duration is controlled by Max_RT

Hold_Target = 200;
Correct_Target_To_Reward_Delay = 150;

FP_Window = 2.5;
Target_Window = 4;

PostReward_Delay_Min = 100;
PostReward_Delay_Max = 100;

ph_to_fix_delay = 100;

TRIAL_ANY_ERROR = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization of the Global Variables as they are empty during the first
% trial
% WARNING: AS WE ARE USING GLOBAL VALUES, MONKEY LOGIC HAS TO BE RESTARTED
% AND NOT ONLY THE FILE HAS TO BE LOADED FOR EACH NEW EXPLORATION
if isempty(connection)
    connection = 0;
end

if isempty(apmDataList)
    apmDataList = [];
end

% try
%     if isempty(NewFields.PositionInCircle)
%         NewFields.PositionInCircle = [];
%         NewFields.ListPositionsOnCircle = [];
%         NewFields.TrialRecord = [];
%         NewFields.SaccadeDelay = [];
%     end
% catch
%     NewFields.PositionInCircle = [];
%     NewFields.ListPositionsOnCircle = [];
%     NewFields.TrialRecord = [];
%     NewFields.SaccadeDelay = [];    
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% _____                             _   _                 ___  _________  ___
%/  __ \                           | | (_)               / _ \ | ___ \  \/  |
%| /  \/ ___  _ __  _ __   ___  ___| |_ _  ___  _ __    / /_\ \| |_/ / .  . |
%| |    / _ \| '_ \| '_ \ / _ \/ __| __| |/ _ \| '_ \   |  _  ||  __/| |\/| |
%| \__/\ (_) | | | | | | |  __/ (__| |_| | (_) | | | |  | | | || |   | |  | |
% \____/\___/|_| |_|_| |_|\___|\___|\__|_|\___/|_| |_|  \_| |_/\_|   \_|  |_/
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Connect to APM if not yet connected (only done once)

% Verify if the connection to the APM is open
% try
%     stat=pnet(connection,'status');
%     if stat == -1 
%         APMConnected = 0;
%     else
%         APMConnected = 1;
%     end
% catch
%     stat = [];
%     APMConnected = 0;
% end
% 
% if isempty(stat) % connection not yet initialized
%     pnet('closeall');
%     hostname = '192.168.35.191';
%     port = 2567;
%     connection=pnet('tcpconnect',hostname,port); % Connecting to the APM Computer
% end
%%%% APM INTERFACE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% _____       __       ______               _                   _____    _       _
%|_   _|     / _|      | ___ \             (_)                 |_   _|  (_)     | |
%  | | _ __ | |_ ___   | |_/ / __ _____   ___  ___  _   _ ___    | |_ __ _  __ _| |
%  | || '_ \|  _/ _ \  |  __/ '__/ _ \ \ / / |/ _ \| | | / __|   | | '__| |/ _` | |
% _| || | | | || (_) | | |  | | |  __/\ V /| | (_) | |_| \__ \   | | |  | | (_| | |
% \___/_| |_|_| \___/  \_|  |_|  \___| \_/ |_|\___/ \__,_|___/   \_/_|  |_|\__,_|_|
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display Information (Eye Movement + Spikes + Events) of the Previous
% Trial
% try
%     EyeSignal = TrialRecord.LastTrialAnalogData.EyeSignal;
%    
%     events = [TrialRecord.LastTrialCodes.CodeTimes TrialRecord.LastTrialCodes.CodeNumbers ];
%   
%      try
%         xEye = EyeSignal(:,1);
%         yEye = EyeSignal(:,2);
%     catch
%         TimeTrialGateOnPreviousTrial = events(find(events(:,2) == 9),1);
%         TimeTrialGateOffPreviousTrial = events(find(events(:,2) == 18),1);
%         TotalTimeTrialGateOn = (TimeTrialGateOffPreviousTrial(1)-TimeTrialGateOnPreviousTrial(end));
%         xEye = ones(1,TotalTimeTrialGateOn);
%         yEye = ones(1,TotalTimeTrialGateOn);
%     end
%     
%     fig = 502;
%     figure(fig); clf;
%     set(fig,'Units','normalized')
%     set(fig,'Position',[0.0006    0.0400    0.3500    0.3100])
%     if TrialRecord.SimulationMode == 1
%         NameFigure = ['Display Trial : ' num2str(TrialRecord.CurrentTrialNumber) '  | Block ' num2str(TrialRecord.CurrentBlock) ' In [SIMULATION MODE]'];
%     else
%         NameFigure = ['Display Trial : ' num2str(TrialRecord.CurrentTrialNumber) '  | Block ' num2str(TrialRecord.CurrentBlock)];
%     end  
%     set(fig,'Name',NameFigure);
% 
%     
%     filename = TrialRecord.DataFile;
%     trialNumber = TrialRecord.CurrentTrialWithinBlock;
%     frq = 1000;
%     
%     %ts = {apmDataList{end}.channel.timestamps * frq};
%     ts = [];
%     TimeStampsTmp = apmDataList{end};
%     for nchan = 1:length(TimeStampsTmp.channel)
%         ts{nchan} = TimeStampsTmp.channel{nchan}.timestamps;
%     end
%     eventsTmp = events(4:end-3,:);
% 
%     showOnlineTrialML(fig, filename, trialNumber, eventsTmp, xEye, yEye, ts);
%     
%     disp('Ended Trial Information Displayed');
% catch
%     disp('Ended Trial Information NOT Displayed');
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(TrialRecord.CurrentConditionInfo)
%Set reward duration
%cues = {'F6'; 'B6L'; 'B6H'; 'F9'; 'B9L'; 'B9H'; 'F3'; 'B3L'; 'B3H'};
rewardcon={TrialRecord.CurrentConditionInfo.Stim2 TrialRecord.CurrentConditionInfo.Stim3};

%%Set actual rewards for each cue
for r = 1:2
    switch rewardcon{r}
        case {'F6'}
            reward_level{r} = 6;
            num_rewards{r} = 2;
            reward_size{r} = reward_level{r}*Max_Reward/11/num_rewards{r};
            disp(['F6 rew = ',num2str(reward_level{r})]);
        case {'B6L'}
            if (rand(1) <= .5)
                reward_level{r} = 7;
                num_rewards{r} = 3;
            else
                reward_level{r} = 5;
                num_rewards{r} = 1;
            end
            reward_size{r} = reward_level{r}*Max_Reward/11/num_rewards{r};
            disp(['B6L rew = ',num2str(reward_level{r})]);
        case {'B6H'}
            if (rand(1) <= .5)
                reward_level{r} = 8;
                num_rewards{r} = 3;
            else
                reward_level{r} = 4;
                num_rewards{r} = 1;
            end
            reward_size{r} = reward_level{r}*Max_Reward/11/num_rewards{r};
            disp(['B6H rew = ',num2str(reward_level{r})]);
        case {'F9'}
            reward_level{r} = 9;
            num_rewards{r} = 2;
            reward_size{r} = reward_level{r}*Max_Reward/11/num_rewards{r};
            disp(['F9 rew = ',num2str(reward_level{r})]);
        case {'B9L'}
            if (rand(1) <= .5)
                reward_level{r} = 10;
                num_rewards{r} = 3;
            else
                reward_level{r} = 8;
                num_rewards{r} = 1;
            end
            reward_size{r} = reward_level{r}*Max_Reward/11/num_rewards{r};
            disp(['B9L rew = ',num2str(reward_level{r})]);
        case {'B9H'}
            if (rand(1) <= .5)
                reward_level{r} = 11;
                num_rewards{r} = 3;
            else
                reward_level{r} = 7;
                num_rewards{r} = 1;
            end
            reward_size{r} = reward_level{r}*Max_Reward/11/num_rewards{r};
            disp(['B9H rew = ',num2str(reward_level{r})]);
        case {'F3'}
            reward_level{r} = 3;
            num_rewards{r} = 2;
            reward_size{r} = reward_level{r}*Max_Reward/11/num_rewards{r};
            disp(['F3 rew = ',num2str(reward_level{r})]);
        case {'B3L'}
            if (rand(1) <= .5)
                reward_level{r} = 4;
                num_rewards{r} = 3;
            else
                reward_level{r} = 2;
                num_rewards{r} = 1;
            end
            reward_size{r} = reward_level{r}*Max_Reward/11/num_rewards{r};
            disp(['B3L rew = ',num2str(reward_level{r})]);
        case {'B3H'}
            if (rand(1) <= .5)
                reward_level{r} = 5;
                num_rewards{r} = 3;
            else
                reward_level{r} = 1;
                num_rewards{r} = 1;
            end
            reward_size{r} = reward_level{r}*Max_Reward/11/num_rewards{r};
            disp(['B3H rew = ',num2str(reward_level{r})]);
        case {'NULL'}
            reward_level{r} = 0;
            num_rewards{r} = 0;
            reward_size{r} = 0;
            disp('NULL');
        otherwise
            reward_level{r} = 0;
            num_rewards{r} = 0;
            reward_size{r} = 0;
            disp('BAD REWARD ASSIGNMENT');
    end
end
%Set Trial Timing

%Fixation timing
DistributionDelay = hold_FP_Min:10:hold_FP_Max;
hold_FPTmpIndex = floor(rand(1) * (length(DistributionDelay))) + 1;
hold_FP = DistributionDelay(hold_FPTmpIndex);
%Cue timing
Cue_Duration = str2num(TrialRecord.CurrentConditionInfo.Stim1);
%Delay Timing
SaccadeDelay = str2num(TrialRecord.CurrentConditionInfo.Stim1);

%Test for Cue-Target congruence
isCong = mod(TrialRecord.CurrentCondition,4) < 2;
%disp(strcat('Cong: ',num2str(isCong),' Delay: ',num2str(SaccadeDelay)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% _____ _____ ___  ______ _____   ___________ _____  ___   _
%/  ___|_   _/ _ \ | ___ \_   _| |_   _| ___ \_   _|/ _ \ | |
%\ `--.  | |/ /_\ \| |_/ / | |     | | | |_/ / | | / /_\ \| |
% `--. \ | ||  _  ||    /  | |     | | |    /  | | |  _  || |
%/\__/ / | || | | || |\ \  | |     | | | |\ \ _| |_| | | || |____
%\____/  \_/\_| |_/\_| \_| \_/     \_/ \_| \_|\___/\_| |_/\_____/
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('[TASK] START TRIAL');
disp('[TASK] Trial Gate ON');
[TimeTrialGateOn] = toggleobject(trialGate, 'eventmarker',TRIAL_START_CD,'status','on');

idle(ph_to_fix_delay);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  _____ ____
% |  ___|  _ \    ___  _ __
% | |_  | |_) |  / _ \| '_ \
% |  _| |  __/  | (_) | | | |
% |_|   |_|      \___/|_| |_|
%
disp('[TASK] FP ON');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display Fixation Point


toggleobject([fixation_point], 'eventmarker',FIX_ON_CD,'status','on');
% Wait for Acquiring Fixation, time wait_for_fix
ontarget = eyejoytrack('acquirefix', fixation_point, FP_Window, wait_for_fix);

if ~ontarget,
    eventmarker(FIX_FAIL_CD); %No fixation
    trialerror(4); % no fixation
    toggleobject(fixation_point,'status','off')
    TRIAL_ANY_ERROR = 4;
end

% Once fixation acquired, hold fixation, time hold_FP
if TRIAL_ANY_ERROR == 0
    eventmarker(FIX_ACH_CD); %Fixation acquired
    ontarget = eyejoytrack('holdfix', fixation_point, FP_Window, hold_FP);
    if ~ontarget,
        eventmarker(7); %broke fixation
        trialerror(4); % broke fixation -- we code this as nofix to more easily sort out fix-breaks during the cue period
        toggleobject(fixation_point, 'eventmarker',FIX_OFF_CD)  
        TRIAL_ANY_ERROR = 4;
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TimeTrialGateOnList = [];
TimeTrialGateOffList = [];
TimeTaskObject1OnList = [];
TimeTaskObject1OffList = [];
TimeTaskObject2OnList = [];
TimeTaskObject2OffList = [];
%Turn on the cue
if TRIAL_ANY_ERROR == 0
    if SaccadeMode == 1 %%Turn on both cues for choice
        [TimeTaskObject1On] = toggleobject([cue1 cue2], 'eventmarker',CUE1_ON_CD,'status','on'); % turn on cue
        disp('[TASK] Cue ON');
    else %%Turn on only Cue 1 for fixation or irrelevant saccade
        [TimeTaskObject1On] = toggleobject([cue1], 'eventmarker',CUE1_ON_CD,'status','on'); % turn on cue
        disp('[TASK] Cue ON');
    end
    ontarget = eyejoytrack('holdfix', fixation_point, FP_Window, Cue_Duration);
    if ~ontarget,
        eventmarker(FIX_BREAK_CD); % broke fixation
        trialerror(3); % broke fixation
        if SaccadeMode == 1
            toggleobject([fixation_point cue1 cue2])
        else
            toggleobject([fixation_point cue1])
        end
    end

    if SaccadeMode == 2
        % Turn OFF the Cue
        [TimeTaskObject1Off] = toggleobject([cue1], 'eventmarker',CUE1_OFF_CD);
        disp('[TASK] Cue OFF');
        %%DELAY PERIOD wait SaccadeDelay
        ontarget = eyejoytrack('holdfix', fixation_point, FP_Window, SaccadeDelay);
        if ~ontarget,
            eventmarker(FIX_BREAK_CD);
            trialerror(3); % broke fixation
            toggleobject([fixation_point])
            TRIAL_ANY_ERROR = 3;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Overlap = 0;
    if SaccadeMode == 1 % Choice Saccade Task %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Turn on the target and off the FP
        disp('[TASK] FP OFF');
        TimeTaskObject2On = toggleobject([fixation_point], 'eventmarker', FIX_OFF_CD);
        %Wait out the minimum RT
        [ontarget rt] = eyejoytrack('holdfix',fixation_point, FP_Window, Min_RT);
        if ~ontarget,
            trialerror(5); % Early Saccade
            toggleobject([cue1 cue2],'eventmarker', CUE1_OFF_CD);
            TRIAL_ANY_ERROR = 5;
        end
        % Wait for Monkey to Perform a Saccade (Break Fixation or Fake break the FP)
        TimeVerificationOverlap = 100; % in ms
        % check overlap
        [ontarget rt] = eyejoytrack('acquirefix', [cue1 cue2 fixation_point], Target_Window, TimeVerificationOverlap);

        MaxRTToFixateHiddenTarget = (Max_RT-TimeVerificationOverlap-Min_RT);
        % Monkey has to NOT hold fixation or acquire fixation target
        %ontarget
        if ontarget == 3, % 3 is the fixation point% target and FP do not overlap, and monkey still looking at FP
            % Monkey now has to break fixation
            [ontarget rt] = eyejoytrack('holdfix', fixation_point, FP_Window, MaxRTToFixateHiddenTarget);
            if ontarget % monkey did not break fixation and stayed on the hidden FP
                eventmarker(MAX_RT_CD);
                trialerror(2); % Late saccade
                toggleobject([cue1 cue2],'eventmarker', CUE1_OFF_CD);
                TRIAL_ANY_ERROR = 2;
            end
        end
        if TRIAL_ANY_ERROR == 0
            % Check if Monkey is making a saccade in the area around the target
            % (even if target still off), the saccade + acquire fixation of
            % target area has to sum to MaxRTToFixateHiddenTarget
            if length(ontarget) > 1 % the target and fixation point overlap
                eventmarker(FIX_FBR_CD);
            else % the Monkey only broke fixation of the FP, but still has to acquire fixation of the target
                [ontarget] = eyejoytrack('acquirefix', [cue1 cue2], Target_Window, MaxRTToFixateHiddenTarget - rt); % check both target and opposite PH
                if ontarget == 1 %if the target window is entered first, continue
                    eventmarker(TARG_ACH_CD);
                    realreward = 1;
                elseif ontarget == 2
                    eventmarker(TARG_ACH_CD);
                    realreward = 2;
                else %otherwise, he entered the opposite window first, so abort the trial
                    eventmarker(15); %Target Missed
                    trialerror(6); % Incorrect Saccade
                    toggleobject([cue1 cue2],'eventmarker', CUE1_OFF_CD) %Turn off the target and end the trial
                    TRIAL_ANY_ERROR = 6;
                end
            end
            
            % Has to stay in the target window for
            % Correct_Target_Delay
            % Hold_Target (target displayed)
            if TRIAL_ANY_ERROR == 0
                if realreward == 1 %% Check holding if chose target 1
                    [ontarget] = eyejoytrack('holdfix', cue1, Target_Window, Hold_Target); %
                else %% Check holding if chose target 2
                    [ontarget] = eyejoytrack('holdfix', cue2, Target_Window, Hold_Target); %
                end
                if ~ontarget % did not hold fixation inside the target window
                    eventmarker(16); %Target fix broken
                    trialerror(7); % Broke secondary fixation (this code is for level breaks, but we don't use it otherwise)
                    toggleobject([cue1 cue2],'eventmarker', CUE1_OFF_CD) %Turn off the cues and end the trial
                    TRIAL_ANY_ERROR = 7;
                end
            end
            %%% CHOICE REWARDS %%%
            if TRIAL_ANY_ERROR == 0
                idle(Correct_Target_To_Reward_Delay);
                toggleobject(bzz);
                goodmonkey(reward_size{realreward}, 'NumReward', num_rewards{realreward}, 'PauseTime', 75);
                disp(['[CHOICE] Juice Sent = ' num2str(reward_size{realreward}) ' num = ' num2str(num_rewards{realreward})]);
                trialerror(0); % correct
            else
                trialerror(6); 
            end
             % Turn OFF Target
             [TimeTaskObject2Off] = toggleobject([cue1 cue2], 'eventmarker', CUE1_OFF_CD);

            disp('[TASK] Target OFF');
            disp('[TASK] END TRIAL');
            TimeTaskObject2OnList = [TimeTaskObject2OnList TimeTaskObject2On];
            TimeTaskObject2OffList = [TimeTaskObject2OffList TimeTaskObject2Off];
        end
    elseif SaccadeMode == 2  % Irrelevant Saccade Task %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Turn on the target and off the FP
        disp('[TASK] FP OFF');
        TimeTaskObject2On = toggleobject([fixation_point target], 'eventmarker', TAR1_ON_CD);
        %Wait out the minimum RT
        [ontarget rt] = eyejoytrack('holdfix',fixation_point, FP_Window, Min_RT);
        if ~ontarget,
            trialerror(5); % Early Saccade
            TimeTaskObject2Off = toggleobject([target],'eventmarker', TAR1_OFF_CD);
            TRIAL_ANY_ERROR = 5;
        end
        % Wait for Monkey to Perform a Saccade (Break Fixation or Fake break the FP)
        TimeVerificationOverlap = 100; % in ms
        % check overlap
        [ontarget rt] = eyejoytrack('acquirefix', [target fixation_point], Target_Window, TimeVerificationOverlap);

        MaxRTToFixateHiddenTarget = (Max_RT-TimeVerificationOverlap-Min_RT);
        % Monkey has to NOT hold fixation or acquire fixation target
        %ontarget
        if ontarget == 2, % 2 is the fixation point% target and FP do not overlap, and monkey still looking at FP
            % Monkey now has to break fixation
            [ontarget rt] = eyejoytrack('holdfix', fixation_point, FP_Window, MaxRTToFixateHiddenTarget);
            if ontarget % monkey did not break fixation and stayed on the hidden FP
                eventmarker(MAX_RT_CD);
                trialerror(2); % Late saccade
                TimeTaskObject2Off = toggleobject([target],'eventmarker', TAR1_OFF_CD);
                TRIAL_ANY_ERROR = 2;
            end
        end
        if TRIAL_ANY_ERROR == 0
            % Check if Monkey is making a saccade in the area around the target
            % (even if target still off), the saccade + acquire fixation of
            % target area has to sum to MaxRTToFixateHiddenTarget
            if length(ontarget) == 2 % the target and fixation point overlap
                eventmarker(FIX_FBR_CD);
            else % the Monkey only broke fixation of the FP, but still has to acquire fixation of the target
                [ontarget] = eyejoytrack('acquirefix', [target], Target_Window, MaxRTToFixateHiddenTarget - rt); % check target
                if ontarget == 1, %if the target window is entered first, continue
                    eventmarker(TARG_ACH_CD);
                else %otherwise, he entered the opposite window first, so abort the trial
                    eventmarker(15); %Target Missed
                    trialerror(6); % Incorrect Saccade
                    TimeTaskObject2Off = toggleobject([target],'eventmarker', TAR1_OFF_CD); %Turn off the target and end the trial
                    TRIAL_ANY_ERROR = 6;
                end
            end
            
            % Has to stay in the target window for
            % Correct_Target_Delay
            % Hold_Target (target displayed)
            [ontarget] = eyejoytrack('holdfix', target, Target_Window, Hold_Target); %
            if ~ontarget % did not hold fixation inside the target window
                eventmarker(16); %Target fix broken
                trialerror(7); % Broke secondary fixation (this code is for level breaks, but we don't use it otherwise)
                TimeTaskObject2Off = toggleobject([target],'eventmarker', TAR1_OFF_CD); %Turn off the target and end the trial
                TRIAL_ANY_ERROR = 7;
            end
            if TRIAL_ANY_ERROR == 0
                idle(Correct_Target_To_Reward_Delay);
                toggleobject(bzz);
                goodmonkey(reward_size{1}, 'NumReward', num_rewards{1}, 'PauseTime', 75); % Send Reward
                disp(['[ISACC] Juice Sent = ' num2str(reward_size{1}) ' num = ' num2str(num_rewards{1})]);
                trialerror(0); % correct
            else
                trialerror(6); 
            end
             % Turn OFF Target
             [TimeTaskObject2Off] = toggleobject([target], 'eventmarker',TAR1_OFF_CD);

            disp('[TASK] Target OFF');
            disp('[TASK] END TRIAL');
            TimeTaskObject2OnList = [TimeTaskObject2OnList TimeTaskObject2On];
            TimeTaskObject2OffList = [TimeTaskObject2OffList TimeTaskObject2Off];
        end
    else  %Fixation Task %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if num_rewards{1} > 1
            toggleobject([fixation_point cue1 cue1high], 'eventmarker', TAR2_ON_CD);
        else
            toggleobject([fixation_point cue1 cue1low], 'eventmarker', TAR2_ON_CD);
        end
        idle(Correct_Target_To_Reward_Delay);
        toggleobject(bzz,'status','on','eventmarker',BUZZ_ON_CD);
        goodmonkey(reward_size{1}, 'NumReward', num_rewards{1}, 'PauseTime', 75);
        disp(['[FIXATION] Juice Sent = ' num2str(reward_size{1}) ' num = ' num2str(num_rewards{1})]);
        disp('[TASK] FP OFF');
        toggleobject([cue1high cue1low], 'eventmarker', TAR2_OFF_CD,'status','off');
        disp('[TASK] Cue OFF');
        trialerror(0); % correct
        disp('[TASK] END TRIAL');
            
    end      
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %TimeTaskObject1OnList = [TimeTaskObject1OnList TimeTaskObject1On];
    %TimeTaskObject1OffList = [TimeTaskObject1OffList TimeTaskObject1Off];
end
   
    % -----------------------------------------------------------------
    % Monkey Screen Part
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% _____ _   _______   ___________ _____  ___   _
%|  ___| \ | |  _  \ |_   _| ___ \_   _|/ _ \ | |
%| |__ |  \| | | | |   | | | |_/ / | | / /_\ \| |
%|  __|| . ` | | | |   | | |    /  | | |  _  || |
%| |___| |\  | |/ /    | | | |\ \ _| |_| | | || |____
%\____/\_| \_/___/     \_/ \_| \_|\___/\_| |_/\_____/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%








% TRIAL_ANY_ERROR numbers are the trialError codes of monkeyLogic
%
[TimeTrialGateOff] = toggleobject(trialGate, 'eventmarker',TRIAL_END_CD,'status','off');
disp('[TASK] Trial Gate OFF');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% _____       _ _                 __                         ___  _________  ___
%/  ___|     (_) |               / _|                       / _ \ | ___ \  \/  |
%\ `--. _ __  _| | _____  ___   | |_ _ __ ___  _ __ ___    / /_\ \| |_/ / .  . |
% `--. \ '_ \| | |/ / _ \/ __|  |  _| '__/ _ \| '_ ` _ \   |  _  ||  __/| |\/| |
%/\__/ / |_) | |   <  __/\__ \  | | | | | (_) | | | | | |  | | | || |   | |  | |
%\____/| .__/|_|_|\_\___||___/  |_| |_|  \___/|_| |_| |_|  \_| |_/\_|   \_|  |_/
%      | |
%      |_|
%%%% GET NUMBER OF SPIKES/TIMESTAMPS FROM APM %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% user_text(['************************']);
% user_text(['-> Trial ' num2str(TrialRecord.CurrentTrialNumber)]);
% 
% user_text('Connecting APM...');
% 
% 
% stat=pnet(connection,'status');
% if stat == -1
%     APMConnectedAfterTrial = 0;
% else
%     APMConnectedAfterTrial = 1;
% end
% 
% if APMConnected ~= APMConnectedAfterTrial
%     user_text('APM DISCONNECTED DURING TASK !!!...');
%     user_text('APM DISCONNECTED DURING TASK !!!...');
%     user_text('APM DISCONNECTED DURING TASK !!!...');
%     trialerror(9);
% end
% 
% % if stat == -1
% %     pnet(connection,'close');
% %     pnet('closeall');
% %     hostname = '192.168.35.191';
% %     port = 2567;
% %     connection=pnet('tcpconnect',hostname,port) % Connecting to the APM Computer
% % end
% % %
% 
% nbChannels = 8;
% 
% for channel = 1:nbChannels
%     apmdataDefault.channel{channel} = [];
%     apmdataDefault.channel{channel}.timestamps = [];
%     apmdataDefault.channel{channel}.nbTimeStamps = [];
%     apmdataDefault.channel{channel}.APMlength = [];
%     apmdataDefault.channel{channel}.ntr =[];
%     apmdataDefault.channel{channel}.ntr1 = [];
%     apmdataDefault.channel{channel}.APMstart = [];
%     apmdataDefault.channel{channel}.APMend = [];
% end
% 
% 
% try
%     if stat == 11
%         disp('  ___  _________  ___   _____ _____ _   _  _   _  _____ _____ _____ ___________   _ ')
%         disp(' / _ \ | ___ \  \/  |  /  __ \  _  | \ | || \ | ||  ___/  __ \_   _|  ___|  _  \ | |')
%         disp('/ /_\ \| |_/ / .  . |  | /  \/ | | |  \| ||  \| || |__ | /  \/ | | | |__ | | | | | |')
%         disp('|  _  ||  __/| |\/| |  | |   | | | | . ` || . ` ||  __|| |     | | |  __|| | | | | |')
%         disp('| | | || |   | |  | |  | \__/\ \_/ / |\  || |\  || |___| \__/\ | | | |___| |/ /  |_|')
%         disp('\_| |_/\_|   \_|  |_/   \____/\___/\_| \_/\_| \_/\____/ \____/ \_/ \____/|___/   (_)')
%         user_text('[OK] APM Connected :-)');
%         
%         user_text('Waiting for Data');
%         disp('Waiting for Data from the APM...');
%         %apmdata=APMPNetClientML(connection)
%         [apmdata ProblemDataAPM] = APMPNetClientML2(connection,nbChannels,TimeTrialGateOn,TimeTrialGateOff);
%         apmDataList{end+1} = apmdata;
%         disp('Data Obtained from the APM');
%         if ProblemDataAPM == 0
%             user_text('[OK] Data Obtained APM');
%         else
%             user_text('[NOT OK] PROBLEM IN DATA APM');
%             user_text(['[NOT OK] ERROR ' num2str(ProblemDataAPM)]);
%             disp('******************************************************************************************************************');
%             disp('****************************** WARNING : PROBLEM IN DATA OBTAINED BY THE APM **************************');
%             disp('******************************************************************************************************************');
%             
%         end
%     else
%         apmDataList{end+1} = apmdataDefault;
%     end
% catch
%     disp('******************************************************************************************************************');
%     disp('****************************** WARNING : DID NOT MANAGE TO CONNECT TO THE APM VIA TCP/IP **************************');
%     disp('******************************************************************************************************************');
%     user_text('[NOT OK] Connection APM');
%     
%     apmDataList{end+1} = apmdataDefault;
%     
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% _____                  ______  ___ _____ ___
%/  ___|                 |  _  \/ _ \_   _/ _ \
%\ `--.  __ ___   _____  | | | / /_\ \| |/ /_\ \
% `--. \/ _` \ \ / / _ \ | | | |  _  || ||  _  |
%/\__/ / (_| |\ V /  __/ | |/ /| | | || || | | |
%\____/ \__,_| \_/ \___| |___/ \_| |_/\_/\_| |_/
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





% user_text('Saving DATA');
% %
% %save DataRecordedTrial
% NewFields.ApmDataList = apmDataList;
% NewFields.ListSupposedRFScreen = ListSupposedRFScreen;
% 
% NewFields.PositionInCircle{end + 1} = PositionInCircle;
% NewFields.ListPositionsOnCircle{end + 1} = ListPositionsOnCircle;
% NewFields.ListExploredPoints = ListExploredPoints;
% NewFields.SaccadeDelay{end+1} = SaccadeDelayTmp;
% % Field used only for debugging:
% % NewFields.TrialRecord{end+1} = TrialRecord;
% 
% disp('Start Saving New Fields...');
% 
% save([TrialRecord.DataFile(1:end-4) 'TMP.mat'],'NewFields')
% disp('New Fields Saved');
% % 
% % bhvFile = [TrialRecord.DataFile];
% % bhvTMPFile = [TrialRecord.DataFile(1:end-4) 'TMP.mat'];
% % try
% %     BHV = MergeBHVandBHVTMP(bhvFile,bhvTMPFile);
% % catch
% %     disp(['BHV File Not Merged on Trial ' num2str(TrialRecord.CurrentBlock)])
% % end
% 
% %saveNewFields(TrialRecord)
% user_text('[OK] DATA SAVED');
% 
% disp('[OK] DATA SAVED');





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%______ _           _               ______ _
%|  _  (_)         | |              |  ___(_)
%| | | |_ ___ _ __ | | __ _ _   _   | |_   _  __ _ _   _ _ __ ___  ___
%| | | | / __| '_ \| |/ _` | | | |  |  _| | |/ _` | | | | '__/ _ \/ __|
%| |/ /| \__ \ |_) | | (_| | |_| |  | |   | | (_| | |_| | | |  __/\__ \
%|___/ |_|___/ .__/|_|\__,_|\__, |  \_|   |_|\__, |\__,_|_|  \___||___/
%            | |             __/ |            __/ |
%            |_|            |___/            |___/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Post-Reward Delay at the end of each trial
DistributionDelay = PostReward_Delay_Min:10:PostReward_Delay_Max;
PostReward_DelayTmpIndex = floor(rand(1) * (length(DistributionDelay))) + 1;
PostReward_Delay = DistributionDelay(PostReward_DelayTmpIndex);
idle(PostReward_Delay);
%end

