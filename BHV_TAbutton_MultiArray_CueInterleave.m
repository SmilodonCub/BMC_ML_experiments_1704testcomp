%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                                            
%       _____    ____   ____  ____      ____ 
%  ___|\     \  |    | |    ||    |    |    |
% |    |\     \ |    | |    ||    |    |    |
% |    | |     ||    |_|    ||    |    |    |
% |    | /_ _ / |    .-.    ||    |    |    |
% |    |\    \  |    | |    ||    |    |    |
% |    | |    | |    | |    ||\    \  /    /|
% |____|/____/| |____| |____|| \ ___\/___ / |
% |    /     || |    | |    | \ |   ||   | / 
% |____|_____|/ |____| |____|  \|___||___|/  
%   \(    )/      \(     )/      \(    )/    
%    '    '        '     '        '    '     
%  
% ___ ____ ___  _  _ ___ ___ ____ _  _     _  _ _  _ _    ___ _ ____ ____ ____ ____ _   _             
%  |  |__| |__] |  |  |   |  |  | |\ |     |\/| |  | |     |  | |__| |__/ |__/ |__|  \_/              
%  |  |  | |__] |__|  |   |  |__| | \| ___ |  | |__| |___  |  | |  | |  \ |  \ |  |   |   ___         
%                                                                                                     
% ____ _  _ ____ _ _  _ ___ ____ ____ _    ____ ____ _  _ ____     ___ ____ _  _ ___ ____ _ _    ____ 
% |    |  | |___ | |\ |  |  |___ |__/ |    |___ |__| |  | |___      |  |___  \/   |  |___ | |    |___ 
% |___ |__| |___ | | \|  |  |___ |  \ |___ |___ |  |  \/  |___ ___  |  |___ _/\_  |  |    | |___ |___ 
%                                                                                                     
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%bonnie cooper

%BHV view of data & plot simple analysis for ECVP &/or ESSEM abstract

%% 0 INIT

clear BHV                                                                   %if BHV clear BHV
global ETparams                                                             %WHY DOES THIS NEED TO BE GLOBAL AGAIN?

% section1 Adaptive Event Detection
BHV = bhv_read1701;                                                             %read a BHV file of the users choice
cond_file = BHV.ConditionsFile;                                             %cond_file points to the string of the _cfg structure that corresponds to this .bhv file
correct_idx = find( BHV.TrialError == 0 );
num_correct = length(correct_idx);                                          %how many correct trials were in this .bhv
BHV.NumCorrect = num_correct;                                               %give this a field in the BHV struct. CAN'T REMEMBER WHY THOUGH?

%section2 Trial by trial data inspection
correct = 0;                                                                %this correct counter for EyeMMV plotting
saccade_present = 0;
incorrect = 0;
rxn_time = NaN(size(BHV.AnalogData,2),2);
saccade_rxn_time = NaN(length(BHV.TrialNumber),9);
saccade_limit = 30;
num_saccades = zeros(saccade_limit,2);
fixdur_time = NaN(size(BHV.AnalogData,2),2);
fig_ecc_limit = 20;
TAbutton_TaskObjectNum = 4;


%% 1 ADAPTIVE EVENT DETECTION
% used to get saccade detection info
                                                                            % I DUNNO THIS ISN'T NECESSARY, BUT I JUST WANTED TO 
                                                                            % COMPARE THE TWO DETECTION METHODS. MIGHT REMOVE LATER

%--------------------------------------------------------------------------
% Condition BHV Eye Signal Data
%--------------------------------------------------------------------------
                                                                            %truncate analog data from the end of fixation hold time 
                                                                            %to the end of target hold time and
                                                                            %hold values in ETdata struct. 
for ii= 1:num_correct
                                                                            %find the time of the eventmarker(6) -> successful fixation
                                                                            %hold timeaquired
    fix_aqrd_time = BHV.CodeTimes{correct_idx(ii)}(BHV.CodeNumbers{correct_idx(ii)}==6);
                                                                            %find time of successful target hold time
    target_aqrd_time = BHV.CodeTimes{correct_idx(ii)}(BHV.CodeNumbers{correct_idx(ii)}==14);
                                                                            %ETdata is a struct that will hold analog X Y coordinates
                                                                            %of Eye position data truncated from the successful fixation 
                                                                            %hold to the end of target hold
    ETdata(ii).X = BHV.AnalogData{correct_idx(ii)}.EyeSignal(fix_aqrd_time:target_aqrd_time,1)';
    ETdata(ii).Y = BHV.AnalogData{correct_idx(ii)}.EyeSignal(fix_aqrd_time:target_aqrd_time,2)';
    ETdata(ii).fixTime = fix_aqrd_time;
    ETdata(ii).targetTime = target_aqrd_time;
end
%  

%--------------------------------------------------------------------------
% Init Event Detection parameters
%--------------------------------------------------------------------------


ETparams.data = ETdata;                                                     %pass on the truncated eye movement data
ETparams.screenSz = [BHV.ScreenXresolution BHV.ScreenYresolution];          %from BHV file, pass Screen resolution
ETparams.screenDim = [0.4064 0.3048];                                       %have no idea why this isn't in the BHV file
                                                                            %these are screen dimensions of the in use Dell screen 
                                                                            %in 1701. [ width height ] in m.
ETparams.viewingDist = BHV.ViewingDistance;                                 %pass on from BHV file
ETparams.samplingFreq = BHV.AnalogInputFrequency;                           %pass on from BHV file
ETparams.blinkVelocityThreshold = 1000;                                     %if vel > 1000 degrees/s, it is noise or blinks
ETparams.blinkAccThreshold = 100000;                                        %if acc > 100000 degrees/s^2, it is noise or blinks
ETparams.peakDetectionThreshold = 0.2;                                      %Initial value of the peak detection threshold. 
ETparams.minFixDur = 0.03;                                                  %in seconds
ETparams.minSaccadeDur = 0.015;                                             %in seconds


%--------------------------------------------------------------------------
% Adaptive_Event_Detection
%--------------------------------------------------------------------------
                                                                            %event detection algorithm accompanying the article
                                                                            %Nyström, M. & Holmqvist, K. (in press), 
                                                                            %"An adaptive algorithm for fixation, saccade, 
                                                                            %and glissade detection in eye-tracking data". 
                                                                            %Behavior Research Methods

eventDetection                                                              %run event detection


%% 2 TRIAL BY TRIAL DATA VISUALIZATION.
%visually inspect Eye Position signal & target array (sketch).
%compare adaptive (saccade) event detection with fixation event detection


for ii = 1:size(BHV.AnalogData,2)                                           %for every trial 
    %--------------------------------------------------------------------------
    % TaskObject Info
    %--------------------------------------------------------------------------
                                                                            %get the x,y positions of TargetObjects in the Target Array
                                                                            %and get the index for the TargetObject images
                                                                            %BHV.TaskObjects == (1)Bzz(correct), (2)Bzz(incorrect), (3)Sqr(fixation),
                                                                            % (4)Sqr(TAbutton), (5)pic (Target ifBear == 1 or randomD ifBear ==0)
                                                                            % (6:end)pic randomD
                                                                            
    trialArraySize = 0;                                                     %we need to get the number of TrialObjects for this trial    
    for hh = 1:length(BHV.TaskObject(BHV.ConditionNumber(ii),...
            TAbutton_TaskObjectNum:end))                                    %from BHV.TaskObject(5:whatever the end is(it's variable from one .txt 
                                                                            %file to the next))
                                                                            %don't need all TaskObjects 2xBzz of fixation Sqr
        if ~isempty(BHV.TaskObject{BHV.ConditionNumber(ii),...
                hh+(TAbutton_TaskObjectNum-1)})                             %if the field in the BHV struct is NOT empty...
            trialArraySize = trialArraySize + 1;                            %increment trialArraySize by 1
        end
    end
    pos = cell(trialArraySize,3);                                           %preallocate pos to hold TaskObject's x,y positions & string 'name'              
    %ta_im_idx = zeros(trialArraySize,1);                                   %preallocate ta_im_idx for the string 'name' of the image used
    saccade_rxn_time(ii,9) = trialArraySize-1;
    
    
    
    for jj = 1:trialArraySize                                               %for each TaskObject in this file
                                                                            %regexp the TaskObject string to get the TaskObject position and
                                                                            %the image string delimted by ( and ,
        split = regexp( BHV.TaskObject{BHV.ConditionNumber(ii),...
            (jj + (TAbutton_TaskObjectNum-1))}, '[(,)]', 'split');
                                                                            %collet the index for the images used as TargetObjects so that they
                                                                            %can be plotted in subplot 1. this is just for phun but also helps
                                                                            %to make sure things are being indexed properly
                                                                            %havent implemented; rather use simple circles in visualization
       %ta_im_idx(j) = find(arrayfun(@(x) strcmpi(BHV.Stimuli.PIC(x).Name, split(2)), 1:numel(BHV.Stimuli.PIC)));
                                                                            %these pos are used to sketch the array in the EyePosition subplot
       if split{1}(1) == 'p'                                                % pic & Sqr have X,Y coordinates in different fields
           pos{jj,1} = str2double(split(3));                                %X pos
           pos{jj,2} = str2double(split(4));                                %Y pos
           pos{jj,3} = split(2);                                            %T/D string 'name'
       elseif split{1}(1) == 'S'
           pos{jj,1} = str2double(split(5));                                %X pos
           pos{jj,2} = str2double(split(6));                                %Y pos
           pos{jj,3} = split(1);                                            %ML object 'Sqr'
       end
       
    end
    BHV.ArrayPos{ii} = pos;                                                 %hold this in a new field ArrayPos of BHV
    
    %--------------------------------------------------------------------------
    % Visualization of Correct Trials
    %--------------------------------------------------------------------------
    
    if BHV.TrialError(ii) == 0                                              %if the current trial is correct, do all these things
        correct = correct + 1;                                              %this is vestigial debugging.
        
                                                                            %was there a target bear present in this trial?
        haztarget = BHV.InfoByCond{BHV.ConditionNumber(ii)}.ifTarget;           %have to index InfoByCond by ConditionNumber or it all goes to hell
        
                                                                            %find the timestamp for the eventmarkers that truncate the analog
                                                                            %data from the end of fixation aquisition to the end of target hold
                                                                            %time. have to do this again cause looping over all trials not jsut correct
        fix_aqrd_time = BHV.CodeTimes{ii}(BHV.CodeNumbers{ii}==6);          %end initial fixation
        target_aqrd_time = BHV.CodeTimes{ii}(BHV.CodeNumbers{ii}==14);      %end target aquired time
       
        
                                                                            %format for EyeMMV package fixation detection
        data = cat(1, BHV.AnalogData{ii}.EyeSignal(fix_aqrd_time:target_aqrd_time,1:2)', ...
            1:size(BHV.AnalogData{ii}.EyeSignal(fix_aqrd_time:target_aqrd_time,1:2)',2));
                                                                            %EyeMMV
                                                                            %Krassanakis, V., Filippakopoulou, V., & Nakos, B. (2014). 
                                                                            %EyeMMV toolbox: An eye movement post-analysis tool based on a two-step 
                                                                            %spatial dispersion threshold for fixation identification. 
                                                                            %Journal of Eye Movement Research, 7(1): 1, 1-10.
        [ A B ] =  fixation_detection_BHV(data', 2.5,2.4,50,14,14);         %EyeMMV fixation detection
        BHV.Fixations{ii} = { A B };                                        %add a field to BHV that holds the fixations
        num_fix = num2str(size(A,1));                                       %this is just to display on figure to help debug
        
                                                                            
        fig = figure(9);                                                    %figure
        set(fig, 'Position', [50 50 1200 800])                              %figure position
        
        fixfig = subplot(3,2,[1 3]);                                        %fixation subplot == fixfig
        %TAG = regexp( BHV.TaskObject{1,6}, '[(,]', 'split')
        %find(arrayfun(@(x) strcmpi(BHV.Stimuli.PIC(x).Name, 'B_63R'), 1:numel(BHV.Stimuli.PIC)))
        set(fixfig, 'Position', [ 0.05 0.35 0.45 0.6])                      %fixfig position w/in fig     
        plot(BHV.AnalogData{ii}.EyeSignal(fix_aqrd_time:target_aqrd_time,1)',...
            BHV.AnalogData{ii}.EyeSignal(fix_aqrd_time:target_aqrd_time,2)','co')
                                                                            %plot Eyesignal data
        hold on
        axis([-fig_ecc_limit fig_ecc_limit -fig_ecc_limit fig_ecc_limit])   %set fixfig limits
        title([ 'Trial: ', num2str(ii), '  BHV: ', ...
            num2str(BHV.TrialNumber(ii)) , '  Correct', num2str(correct)])
        plot(A(:,1),A(:,2),'r+')                                            %plot the fixations
        plot(pos{1,1},pos{1,2},'s','LineStyle', 'none', ...
            'MarkerEdgeColor',[0.5 0.5 0.5],...
            'MarkerFaceColor',[0.5 0.5 0.5],'MarkerSize',15)                %plot the TAbutton
        plot(cell2mat(pos(3:end,1)),cell2mat(pos(3:end,2)),'o',...
            'LineStyle', 'none', 'MarkerEdgeColor',[1 0 0],...
            'MarkerFaceColor',[1 0 0],'MarkerSize',20)                      %plot array additional distractors
        if haztarget == '1'
            plot(pos{2,1},pos{2,2},'o','LineStyle', 'none', 'MarkerEdgeColor',[0 1 0],...
                'MarkerFaceColor',[0 1 0],'MarkerSize',20)                  %plot Target (Bear target is present)
            text(A(:,1),A(:,2),num2str(A(:,7)),'HorizontalAlignment',...
                'Left','VerticalAlignment','Bottom','FontSize',12,'Color','r')
            text(B(:,1),B(:,2),num2str((1:(size(B,1)))'),'HorizontalAlignment',...
                'Right','VerticalAlignment','Top','FontSize',12,'Color','r')
            text( 3, -2, [ '#fix: ' num_fix ] ,'FontSize',15,'Color','r')
            %text( 3, 0, 'BEAR','FontSize',20,'Color','r')                  %put some text on the plot that tells how long fixations were,
                                                                            %how many fixations, and if there is a Bear Present. 4 debugging.
                                                                            
            rxn_time(ii,1) = target_aqrd_time - fix_aqrd_time...            %piggybacking some data sorting since we filter for Target Abs/Pres
                - BHV.VariableChanges.hold_target_time.Value;               %get reaction time
            num_saccades(size(A,1),1) = num_saccades(size(A,1),1)+ 1;       %place a 1 in num_saccades to indicate num_saccades
            fixdur_time(ii,1) = A(1,end);                                   %get the first fixation duration time from A
                                                                            %this is left over from when the TAbutton was at fixation
                                                                            %to study the monkeys behavior fro strategies (holding by default)
            if size(A,1) <= 2                                               %is there were only 2 fixations & the trial was a correct one 
                                                                            %& w/a target then the subject made a direct saccade to the target
                saccade_rxn_time(ii,1) = rxn_time(ii,1);            %place this trials reaction time in immediate_saccade_rxn_time
            elseif size(A,1) > 2                                            %if there were more than 2 fixations,
                saccade_rxn_time(ii,2) = rxn_time(ii,1);              %get the reaction time...
                saccade_rxn_time(ii,3) = size(A,1);                   %get the number of fixations...
                saccade_rxn_time(ii,7) = 1;                           %'1' for hazbear(?) and place in multi_saccade_rxn_time
            end
        elseif haztarget == '0'
            plot(pos{2,1},pos{2,2},'o','LineStyle', 'none', 'MarkerEdgeColor',[1 0 0],...
                'MarkerFaceColor',[1 0 0],'MarkerSize',20)                  %plot Distractor (No Bear Present this trial)
            text(A(:,1),A(:,2),num2str(A(:,7)),'HorizontalAlignment',...
                'Left','VerticalAlignment','Bottom','FontSize',12,'Color','b')
            text(B(:,1),B(:,2),num2str((1:(size(B,1)))'),'HorizontalAlignment',...
                'Right','VerticalAlignment','Top','FontSize',12,'Color','b')
            %text( 3, 0, 'NO BEAR','FontSize',20,'Color','b')
            text( 3, -2, [ '#fix: ' num_fix ] ,'FontSize',15,'Color','b')
            rxn_time(ii,2) = target_aqrd_time - fix_aqrd_time - BHV.VariableChanges.fix_return_time.Value;
            num_saccades(size(A,1),2) = num_saccades(size(A,1),2)+ 1;
            fixdur_time(ii,2) = A(1,end);
            if size(A,1) <= 2
                saccade_rxn_time(ii,4) = rxn_time(ii,2); 
            elseif size(A,1) > 2 
                saccade_rxn_time(ii,5) = rxn_time(ii,2);
                saccade_rxn_time(ii,6) = size(A,1);
                saccade_rxn_time(ii,7) = 0;
            end
        end
        
        %pause
        
        %--------------------------------------------------------------------------
        % Evaluate Fixation Positions (did they land on a TaskObject?)
        %--------------------------------------------------------------------------
        
        numTaskObjectsFixd = 0;
        for kk = 1:(size(A,1)-1)                                            %for every fixation detected by EyeMMV
                                                                            %find out if it landed on a TaskObject
                                                                            %if it did, add the TaskObject string to
                                                                            %a new field in BHV, BHV.ObjectsFixated
                                                                            %DOES NOT USE 'FIXATION' AS A TASK OBJECT HERE
                                                                            %ONLY TARGET ARRAY & TABUTTON
                                                                            %-1 because first fixation will always be @fixation
            
            
            for mm = 1:size(pos,1)                                          %for every TaskObject for this particular trial
                                                                            %check to see if the mean fixation x,y coordinates
                                                                            %from EyeMMV are within the target_window for any
                                                                            %TaskObject's position (target array or TAbutton)
                                                                            %if it is, add the TaskObject string into an ordered cell
                                                                            %of ObjectsFixated in the BHV struct
                                                                            
                if (A(kk+1,1) - pos{mm,1})^2 + (A(kk+1,2) - pos{mm,2})^2 <= 4%... 
                        %BHV.VariableChanges.fix_window.Value                %where fix_window.Value is the window radius in dva
                    BHV.ObjectsFixated{ii}{kk} = ...
                        BHV.TaskObject{BHV.ConditionNumber(ii),...
                        (mm + (TAbutton_TaskObjectNum-1))};
                    numTaskObjectsFixd = numTaskObjectsFixd + 1;
                end
                
                
            end
            
        end
        saccade_rxn_time(ii,8) = numTaskObjectsFixd;
        %disp(BHV.ObjectsFixated{ii})
        %pos{:,3}
        
        %pause
    
        
        %--------------------------------------------------------------------------
        % Visualization of Correct Trials
        %--------------------------------------------------------------------------    
        
                                                                            %plot vel based saccade detection
        sacfig = subplot(3,2,5);                                            %draw & position the axis for sacfig
        set(sacfig, 'Position', [0.05 0.05 0.45 0.2])
        plot(ETparams.data(correct).velOrg)                                 %plot the 'original' velocity data
        hold on
        plot(ETparams.data(correct).vel, 'Color', 'r', 'LineWidth', 2)      %plot smoothed velocity data
        for iii = 1:size(ETparams.saccadeInfo,3)                            %for every saccade field for this trial
            sac_start = ETparams.saccadeInfo(1,correct,iii).start*1000;     %get saccade start time
            sac_end = ETparams.saccadeInfo(1,correct,iii).end*1000;         %get saccade end time
            if ~isempty(sac_start)                                          %if there is a number in the field
                line([sac_start sac_start], [0 2],...                       %plot a line for the start and end of that saccade
                    'Color', [0 1 0], 'LineWidth', 2)
                line([sac_end sac_end], [0 2],...
                    'Color', [0 1 0], 'LineWidth', 2)
            end
        end
        axis([ 0 2500 0 1 ]);
        
        %pause
        
        
        rxnfig = subplot(3,2,2);
        set(rxnfig, 'Position', [0.55 0.7 0.4 0.25])
        idx = find(rxn_time >= BHV.VariableChanges.max_reaction_time.Value);
        rxn_time(idx) = NaN;
        hist(rxn_time, 0:20:BHV.VariableChanges.max_reaction_time.Value,...
            'stacked', 'barwidth', 20)
        title('Reaction Times (Correct Trials Only)')
        legend('Target', 'No Target')
        xlim([0 1500])
        
        
        
        
        setSizeFig = subplot(3,2,4);
        xvals = unique(saccade_rxn_time(:,9));
        saccadeBySet = zeros(length(xvals),4);
        for nn = 1:length(xvals)
            bearSacRxnT = cat(1, saccade_rxn_time(find(~isnan(saccade_rxn_time(:,1)) & saccade_rxn_time(:,9) == xvals(nn)),1),...
                saccade_rxn_time(find(~isnan(saccade_rxn_time(:,2)) & saccade_rxn_time(:,9) == xvals(nn)),2));
            saccadeBySet(nn,1) = mean(bearSacRxnT);
            saccadeBySet(nn,2) = std(bearSacRxnT);
            NObearSacRxnT = cat(1, saccade_rxn_time(find(~isnan(saccade_rxn_time(:,4)) & saccade_rxn_time(:,9) == xvals(nn)),4),...
                saccade_rxn_time(find(~isnan(saccade_rxn_time(:,5)) & saccade_rxn_time(:,9) == xvals(nn)),5));
            saccadeBySet(nn,3) = mean(NObearSacRxnT);
            saccadeBySet(nn,4) = std(NObearSacRxnT);
        end
        set(setSizeFig, 'Position', [0.55 0.35 0.4 0.25])
        scatter(saccade_rxn_time((saccade_rxn_time(:,1) > 0),9),saccade_rxn_time((saccade_rxn_time(:,1) > 0),1),'or', 'filled')
        hold on
        scatter(saccade_rxn_time((saccade_rxn_time(:,2) > 0),9),saccade_rxn_time((saccade_rxn_time(:,2) > 0),2), 'or', 'filled')
        scatter(saccade_rxn_time((saccade_rxn_time(:,4) > 0),9),saccade_rxn_time((saccade_rxn_time(:,4) > 0),4), 'og', 'filled')
        scatter(saccade_rxn_time((saccade_rxn_time(:,5) > 0),9),saccade_rxn_time((saccade_rxn_time(:,5) > 0),5), 'og', 'filled')
        errorbar(xvals, saccadeBySet(:,1), saccadeBySet(:,2), 'sk','MarkerSize', 15)
        errorbar(xvals, saccadeBySet(:,3), saccadeBySet(:,4), '*k','MarkerSize', 15)
        %legend('B imm fix', 'B multi fix', 'NoB imm fix', 'NoB multi fix', 'Location', 'BestOutside')
        title('Effect of Set size on Rxn Time')
        xlim([0 10])
        ylim([0 2500])
        
        
        numSacFig = subplot(3,2,6);
        set(numSacFig, 'Position', [0.55 0.05 0.4 0.2])
%         xxvals = unique(saccade_rxn_time(:,8));
%         numSacBySet = zeros(length(xxvals),6);
%         for nn = 1:length(xxvals)
%             bearSacRxnT = cat(1, saccade_rxn_time(find(~isnan(saccade_rxn_time(:,1)) & saccade_rxn_time(:,8) == xxvals(nn)),1),...
%                 saccade_rxn_time(find(~isnan(saccade_rxn_time(:,2)) & saccade_rxn_time(:,8) == xxvals(nn)),2));
%             numSacBySet(nn,1) = mean(bearSacRxnT);
%             numSacBySet(nn,2) = std(bearSacRxnT);
%             numSacBySet(nn,4) = length(bearSacRxnT);
%             NObearSacRxnT = cat(1, saccade_rxn_time(find(~isnan(saccade_rxn_time(:,4)) & saccade_rxn_time(:,8) == xxvals(nn)),4),...
%                 saccade_rxn_time(find(~isnan(saccade_rxn_time(:,5)) & saccade_rxn_time(:,8) == xxvals(nn)),5));
%             numSacBySet(nn,3) = mean(NObearSacRxnT);
%             numSacBySet(nn,4) = std(NObearSacRxnT);
%             numSacBySet(nn,6) = length(NObearSacRxnT);
%         end
        %bar(xxvals, numSacBySet(:,5:6),'stacked', 'barwidth', 1)
        bar(1:saccade_limit, num_saccades,'stacked', 'barwidth', 1)
        title('Number of saccades Bear/NoBear trials')
        

        %
                 pause(0.5)
        %
        %
        %         %clf(sacfig)
        %         %clf(fixfig)
        %         if ii < num_correct
        %             clf(fig)
        %         end
        %
        %
        %     elseif BHV.TrialError(ii) ~= 0
        %         incorrect = incorrect + 1;
    end
    %
    %
    %
end
%
% 
