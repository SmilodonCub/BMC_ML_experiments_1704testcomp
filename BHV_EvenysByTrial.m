clear all




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
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fignum = 13;
%append .bhv files with some semi-processed data for further analysis

% (1) time to fixate the target (on TP trials), 

% (2) the object initially fixated (most likely the target on TP trials, 
% but this might also be a target-similar distractor on TA trials), 
% the order in which objects are fixated (probably most informative on TA trials), 

% (4) initial saccade latency,

% (5) accuracy.

% (6) time fixation was held befor saccade to a target
global ETparams


%select & read a .bhv file
BHV = bhv_read();
%get the name (str) of the condition file (.txt) that was used for this
%.bhv. this is necessary for files with no info on the target names & pos
cond_file = BHV.ConditionsFile;



%find correct trials & a bear target was present
correct_idx = find(BHV.TrialError == 0);
num_correct = length(correct_idx);

%truncate analog data from the end of fixation hold time to the end of
%terget hold time and hold values in ETdata struct. might as well hold
% %those variable too. why not.
for i = 1:num_correct
    %find the time of the eventmarker(6) corresponding to successful fixation hold time
    %aquired - 100ms
    fix_aqrd_time = BHV.CodeTimes{correct_idx(i)}(BHV.CodeNumbers{correct_idx(i)}==6);
    %find time of successful target hold time
    target_aqrd_time = BHV.CodeTimes{correct_idx(i)}(BHV.CodeNumbers{correct_idx(i)}==14);
    ETdata(i).X = BHV.AnalogData{correct_idx(i)}.EyeSignal(fix_aqrd_time:target_aqrd_time,1)';
    ETdata(i).Y = BHV.AnalogData{correct_idx(i)}.EyeSignal(fix_aqrd_time:target_aqrd_time,2)';
    ETdata(i).fixTime = fix_aqrd_time;
    ETdata(i).targetTime = target_aqrd_time;
end
%  
%process truncated analog data for eye movement events
%--------------------------------------------------------------------------
% Init parameters
%--------------------------------------------------------------------------


ETparams.data = ETdata;
ETparams.screenSz = [BHV.ScreenXresolution BHV.ScreenYresolution];
ETparams.screenDim = [0.4064 0.3048];
ETparams.viewingDist = BHV.ViewingDistance;
ETparams.samplingFreq = BHV.AnalogInputFrequency;
ETparams.blinkVelocityThreshold = 1000;        % if vel > 1000 degrees/s, it is noise or blinks
ETparams.blinkAccThreshold = 100000;          % if acc > 100000 degrees/s^2, it is noise or blinks
ETparams.peakDetectionThreshold = 0.2;            % Initial value of the peak detection threshold. 
ETparams.minFixDur = 0.03;% in seconds
ETparams.minSaccadeDur = 0.015;% in seconds


%Adaptive_Event_Detection
eventDetection

correct = 0;
saccade_present = 0;
incorrect = 0;

rxn_time = NaN(size(BHV.AnalogData,2),2);
num_saccades = zeros(15,2);
fixdur_time = NaN(size(BHV.AnalogData,2),2);

for i = 1:size(BHV.AnalogData,2)%num_correct 
    
    %get the x,y positions of TargetObjects in the Target Array
    %and get the index for the TargetObject images
    pos = zeros(4,2);
    ta_im_idx = zeros(4,1);
    
    for j = 1:4
        %regexp the TaskObject string to get the TaskObject position and
        %the image string delimted by ( and ,
        split = regexp( BHV.TaskObject{i,(j + 4)}, '[(,]', 'split');
        %collet the index for the images used as TargetObjects so that they
        %can be plotted in subplot 1. this is just for phun but also helps
        %to make sure things are being indexed properly
        ta_im_idx(j) = find(arrayfun(@(x) strcmpi(BHV.Stimuli.PIC(x).Name, split(2)), 1:numel(BHV.Stimuli.PIC)));
        pos(j,1) = str2double(split(3));
        pos(j,2) = str2double(split(4));
    end
    BHV.ArrayPos{i} = pos;
    
    if BHV.TrialError(i) == 0
        correct = correct + 1;
        
        %was there a target bear present in this trial?
        hazbear = BHV.InfoByCond{BHV.ConditionNumber(i)}.ifBear;
        
        %find the timestamp for the eventmarkers that truncate the analog
        %data from the end of fixation aquisition to the end of target hold
        %time.
        fix_aqrd_time = BHV.CodeTimes{i}(BHV.CodeNumbers{i}==6);
        target_aqrd_time = BHV.CodeTimes{i}(BHV.CodeNumbers{i}==14);
       
        
        %format so that it's good to go for the EyeMMV package
        data = cat(1, BHV.AnalogData{i}.EyeSignal(fix_aqrd_time:target_aqrd_time,1:2)', ...
            1:size(BHV.AnalogData{i}.EyeSignal(fix_aqrd_time:target_aqrd_time,1:2)',2));
        [ A B ] =  fixation_detection_BHV(data', 2.5,2.4,50,14,14);
        %add a field to BHV that holds the fixations
        BHV.Fixations{i} = { A B };
        %this is just to display on figure to help see if things are working:
        num_fix = num2str(size(A,1));
        
        %figure
        fig = figure(fignum);
        set(fig, 'Position', [50 50 1200 800])
        
        fixfig = subplot(3,2,[1 3]);
        %TAG = regexp( BHV.TaskObject{1,6}, '[(,]', 'split')
        %find(arrayfun(@(x) strcmpi(BHV.Stimuli.PIC(x).Name, 'B_63R'), 1:numel(BHV.Stimuli.PIC)))
        set(fixfig, 'Position', [ 0.05 0.35 0.45 0.6])
        plot(BHV.AnalogData{i}.EyeSignal(fix_aqrd_time:target_aqrd_time,1)',BHV.AnalogData{i}.EyeSignal(fix_aqrd_time:target_aqrd_time,2)','co')
        %set(gca,'Fontsize',20)
        hold on
        axis([-15 15 -15 15])
        title([ 'Trial: ', num2str(i), '  BHV: ', num2str(BHV.TrialNumber(i)) , '  Correct', num2str(correct)])
        plot(A(:,1),A(:,2),'r+')
        if hazbear == '1'
            text(A(:,1),A(:,2),num2str(A(:,7)),'HorizontalAlignment','Left','VerticalAlignment','Bottom','FontSize',20,'Color','r')
            text(B(:,1),B(:,2),num2str((1:(size(B,1)))'),'HorizontalAlignment','Right','VerticalAlignment','Top','FontSize',20,'Color','r')
            text( 3, -2, [ '#fix: ' num_fix ] ,'FontSize',20,'Color','r')
            text( 3, 0, 'BEAR','FontSize',20,'Color','r')
            rxn_time(i,1) = target_aqrd_time - fix_aqrd_time - BHV.VariableChanges.hold_target_time.Value;
            num_saccades(size(A,1),1) = num_saccades(size(A,1),1)+ 1;
            fixdur_time(i,1) = A(1,end);
        elseif hazbear == '0'
            text(A(:,1),A(:,2),num2str(A(:,7)),'HorizontalAlignment','Left','VerticalAlignment','Bottom','FontSize',20,'Color','b')
            text(B(:,1),B(:,2),num2str((1:(size(B,1)))'),'HorizontalAlignment','Right','VerticalAlignment','Top','FontSize',20,'Color','b')
            text( 3, 0, 'NO BEAR','FontSize',20,'Color','b')
            text( 3, -2, [ '#fix: ' num_fix ] ,'FontSize',20,'Color','b')
            rxn_time(i,2) = target_aqrd_time - fix_aqrd_time - BHV.VariableChanges.fix_return_time.Value;
            num_saccades(size(A,1),2) = num_saccades(size(A,1),2)+ 1;
            fixdur_time(i,2) = A(1,end);
        end
        
        for k = 1:size(A,1)
            %if fixation - TaskObject#2
            if (A(k,1) - 0)^2 + (A(k,2) - 0)^2 <= BHV.VariableChanges.fix_window.Value %(x - center_x)^2 + (y - center_y)^2 < radius^2
                BHV.ObjectsFixated{i}{k} = BHV.TaskObject{i,3};
                %if TaskObject#4 (ifbear == '1' --> Target; ifbear == '0' -->
                %distractor)
            elseif (A(k,1) - BHV.ArrayPos{i}(1,1))^2 + (A(k,2) - BHV.ArrayPos{i}(1,2))^2 <= BHV.VariableChanges.target_window.Value
                BHV.ObjectsFixated{i}{k} = BHV.TaskObject{i,4};
                %if TargetObject#5
            elseif (A(k,1) - BHV.ArrayPos{i}(2,1))^2 + (A(k,2) - BHV.ArrayPos{i}(2,2))^2 <= BHV.VariableChanges.target_window.Value
                BHV.ObjectsFixated{i}{k} = BHV.TaskObject{i,5};
                %if TargetObject#6
            elseif (A(k,1) - BHV.ArrayPos{i}(3,1))^2 + (A(k,2) - BHV.ArrayPos{i}(3,2))^2 <= BHV.VariableChanges.target_window.Value
                BHV.ObjectsFixated{i}{k} = BHV.TaskObject{i,6};
                %if TargetObject#7
            elseif (A(k,1) - BHV.ArrayPos{i}(4,1))^2 + (A(k,2) - BHV.ArrayPos{i}(4,2))^2 <= BHV.VariableChanges.target_window.Value
                BHV.ObjectsFixated{i}{k} = BHV.TaskObject{i,7};
            end
        end
        
%         if hazbear == '1'
%             num_saccades(size(BHV.ObjectsFixated{i},1),1) = num_saccades(size(BHV.ObjectsFixated{i},1),1)+ 1;
%         elseif hazbear == '0'
%             num_saccades(size(BHV.ObjectsFixated{i},1),2) = num_saccades(size(BHV.ObjectsFixated{i},1),2)+ 1;
%         end
        
        %plot vel based saccade detection
        sacfig = subplot(3,2,5);
        set(sacfig, 'Position', [0.05 0.05 0.45 0.2])
        
         %if any(ETparams.saccadeIdx(1,correct).Idx(:))
             %saccade_present = saccade_present +1;
             plot(ETparams.data(correct).velOrg) %(1:size(ETparams.data(i),2)),
             hold on
             plot(ETparams.data(correct).vel, 'Color', 'r', 'LineWidth', 2)
             for ii = 1:size(ETparams.saccadeInfo,3)
                 if correct <= size(ETparams.saccadeInfo, 2) & ETparams.saccadeInfo(1,correct,ii).start ~= 0 
                     line([( ETparams.saccadeInfo(1,correct,ii).start*1000)...
                         ( ETparams.saccadeInfo(1,correct,ii).start*1000)], ...
                         [0 2], 'Color', [0 1 0], 'LineWidth', 2)
                     line([( ETparams.saccadeInfo(1,correct,ii).end*1000)...
                         ( ETparams.saccadeInfo(1,correct,ii).end*1000)], ...
                         [0 2], 'Color', [0 1 0], 'LineWidth', 2)
                 end
             end
        axis([ 0 2500 0 1 ]);
       
        
        rxnfig = subplot(3,2,2);
        set(rxnfig, 'Position', [0.55 0.7 0.4 0.25])
        idx = find(rxn_time >= BHV.VariableChanges.max_reaction_time.Value);
        rxn_time(idx) = NaN;
        hist(rxn_time, 0:20:BHV.VariableChanges.max_reaction_time.Value, 'stacked', 'barwidth', 20)
        title('Reaction Times (Correct Trials Only)')
        xlim([0 1500])
       
        

        
        fixdurfig = subplot(3,2,4);
        set(fixdurfig, 'Position', [0.55 0.35 0.4 0.25])
        hist(fixdur_time, 0:40:1200, 'stacked', 'barwidth', 20)
        title('Duration of initial fixation hold (Correct trials only)')
        
         
        numsaccfig = subplot(3,2,6);
        set(numsaccfig, 'Position', [0.55 0.05 0.4 0.2])
        bar(0:14, num_saccades,'stacked', 'barwidth', 1)
        title('Number of saccades Bear/NoBear trials')
        
        
%         blank = subplot(3,2,6);
%         set(blank, 'Position', [0.55 0.05 0.4 0.25])
%         text(0.05,0.5,(BHV.ConditionsFile),'FontSize',7)
%         box('off')
%         axis('off')
        
        
        pause(0.25)
        
        
        %clf(sacfig)
        %clf(fixfig)
        if i < num_correct
            clf(fig)
        end
       
     
    elseif BHV.TrialError(i) ~= 0
        incorrect = incorrect + 1;
    end

    
    
end



%idxx = find(rxn_time_hist(:,1) == 0);
%rxn_time_hist(idxx) = NaN;
%data = rxn_time_hist(:,1);
% figure(6)
% x = 0:20:BHV.VariableChanges.max_reaction_time.Value;
% hist(rxn_time(:,1),x)
% hold on
% histfit(rxn_time(:,1),length(x),'gamma') 

  
numsaccfig = subplot(3,2,6);
set(numsaccfig, 'Position', [0.55 0.05 0.4 0.2])
bar(0:14, num_saccades,'stacked', 'barwidth', 1)
viewed_distractors_Bear = sum(num_saccades(3:end,1));
viewed_distractors_NOBear = sum(num_saccades(3:end,2));
text(8,40,[ 'Bear: ' num2str(viewed_distractors_Bear) '   Total: ' num2str(sum(num_saccades(:,1))) ])
text(8,30,[ 'NO Bear: ' num2str(viewed_distractors_NOBear) '   Total: ' num2str(sum(num_saccades(:,2))) ])
title('Number of saccades Bear/NoBear trials')
        
        
        
R = find(rxn_time(:,1)==floor(rxn_time(:,1)));
disp( mean(rxn_time(R)) )
disp( std(rxn_time(R)) )


    






