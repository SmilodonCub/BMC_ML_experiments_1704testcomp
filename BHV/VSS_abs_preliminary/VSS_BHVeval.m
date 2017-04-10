%clear all 
global ETparams


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

%take a bunch of .bhv files and batch process what you need for behavioral
%analysis
% 
% 
% 
% 
% 
%select & read .bhv files from specified folder
bhv_folder = 'C:\Users\Public\Documents\BHV\bhv_ecvp';
bhv_files = dir([bhv_folder,	'\*.bhv']);
[task_folder timing_file] = fileparts( bhv_folder );
length_bhv_files = length( bhv_files );

ECVP_BHV_eval = struct([]);

for h = 1: length_bhv_files % for each .bhv file
    
    %basics to hold in the struct entry
     full_bhvname = [ bhv_folder '\' bhv_files(h).name ];
     ECVP_BHV_eval(h).FileName = bhv_files(h).name;
     BHV = bhv_read( full_bhvname );
     disp(BHV.DataFileName)
     cond_file = BHV.ConditionsFile;
     ECVP_BHV_eval(h).CondFileName = cond_file;     
     %find correct trials & a bear target was present
     correct_idx = find(BHV.TrialError == 0);
     ECVP_BHV_eval(h).CorrectIdx = correct_idx;
     num_correct = length(correct_idx);
     disp(num_correct)
     %BHV.NumCorrect = num_correct;
     
     
     %--------------------------------------------------------------------------
     % Init parameters
     %--------------------------------------------------------------------------
          %truncate analog data from the end of fixation hold time to the end of
     %terget hold time and hold values in ETdata struct.
     for j = 1:num_correct
         %find the time of the eventmarker(6) -> successful fixation hold time
         %aquired - 100ms
         fix_aqrd_time = BHV.CodeTimes{correct_idx(j)}(BHV.CodeNumbers{correct_idx(j)}==6);
         %find time of successful target hold time
         target_aqrd_time = BHV.CodeTimes{correct_idx(j)}(BHV.CodeNumbers{correct_idx(j)}==14);
         ETdata(j).X = BHV.AnalogData{correct_idx(j)}.EyeSignal(fix_aqrd_time:target_aqrd_time,1)';
         ETdata(j).Y = BHV.AnalogData{correct_idx(j)}.EyeSignal(fix_aqrd_time:target_aqrd_time,2)';
         ETdata(j).fixTime = fix_aqrd_time;
         ETdata(j).targetTime = target_aqrd_time;
     end
     
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
     
     
     %some things we want to grab as we loop through the bhv file
     rxn_time = NaN(size(BHV.AnalogData,2),2);
     immediate_saccade_rxn_time = NaN(2, length(BHV.TrialNumber));
     multi_saccade_rxn_time = NaN(3, length(BHV.TrialNumber));
     incorrect_trial = NaN(1, length(BHV.TrialNumber));
     num_saccades = zeros(15,2);
     fixdur_time = NaN(size(BHV.AnalogData,2),2);
     correct = 0;
     incorrect = 0;
     target = 0;
     notarget = 0;
     total_target = 0;
     total_notarget = 0;
     cue_present = 0;
     
     if  BHV.TaskObject{ 1,2 }( 1 ) == 'p'
         cue_present = 1;
     end
     
     %go through all trials now.
     for i = 1:size(BHV.AnalogData,2)
         %if the trial is correct
         %fixation detection
         %was there a bear?
         %was there no bear?
         %object fixation
         %get the x,y positions of TargetObjects in the Target Array
         %and get the index for the TargetObject images
         pos = zeros(4,2);
         ta_im_idx = zeros(4,1);
         
         for j = 1:4
             %regexp the TaskObject string to get the TaskObject position and
             %the image string delimted by ( and ,
             split = regexp( BHV.TaskObject{i,(j + 3)}, '[(,]', 'split');
             %collet the index for the images used as TargetObjects so that they
             %can be plotted in subplot 1. this is just for phun but also helps
             %to make sure things are being indexed properly
             ta_im_idx(j) = find(arrayfun(@(x) strcmpi(BHV.Stimuli.PIC(x).Name, split(2)), 1:numel(BHV.Stimuli.PIC)));
             pos(j,1) = str2double(split(3));
             pos(j,2) = str2double(split(4));
         end
         BHV.ArrayPos{i} = pos;
         
         %does the trial have a bear target
         hazbear = BHV.InfoByCond{BHV.ConditionNumber(i)}.ifBear;
         if hazbear
             total_target = total_target + 1;
         elseif ~hazbear
             total_notarget = total_notarget + 1;
         end
         
         
         if BHV.TrialError(i) == 0 %if the trail is correct
             correct = correct + 1;
             %was there a target bear present in this trial?
              
             
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
             
             
             if hazbear == '1'
                 target = target + 1;
                 rxn_time(i,1) = target_aqrd_time - fix_aqrd_time - BHV.VariableChanges.hold_target_time.Value;
                 num_saccades(size(A,1),1) = num_saccades(size(A,1),1)+ 1;
                 fixdur_time(i,1) = A(1,end);
                 if size(A,1) <= 2
                     immediate_saccade_rxn_time(1,i) = rxn_time(i,1);
                     immediate_saccade_rxn_time(2,i) = 1;
                 elseif size(A,1) > 2
                     multi_saccade_rxn_time(1,i) = rxn_time(i,1);
                     multi_saccade_rxn_time(2,i) = size(A,1);
                     multi_saccade_rxn_time(3,i) = 1;
                 end
             elseif hazbear == '0'
                 notarget = notarget + 1;
                 rxn_time(i,2) = target_aqrd_time - fix_aqrd_time - BHV.VariableChanges.fix_return_time.Value;
                 num_saccades(size(A,1),2) = num_saccades(size(A,1),2)+ 1;
                 fixdur_time(i,2) = A(1,end);
                 if size(A,1) > 1
                     multi_saccade_rxn_time(1,i) = rxn_time(i,2);
                     multi_saccade_rxn_time(2,i) = size(A,1);
                     multi_saccade_rxn_time(3,i) = 0;
                 end
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
             
             
             
         elseif BHV.TrialError(i) ~= 0
             incorrect = incorrect + 1; %maybe make a 2,X vetor with the indexes & error code
             incorrect_trial(i) = BHV.TrialError(i);
             
         end
         
         
     end
     
     ECVP_BHV_eval(h).RxnTime = rxn_time;
     ECVP_BHV_eval(h).ImmSacc_RxnTime = immediate_saccade_rxn_time;
     ECVP_BHV_eval(h).MultiSacc_RxnTime = multi_saccade_rxn_time;
     ECVP_BHV_eval(h).InCorr = incorrect_trial;
     ECVP_BHV_eval(h).NumSacc_bar = num_saccades;
     ECVP_BHV_eval(h).First_FixDurr = fixdur_time;
     ECVP_BHV_eval(h).Correct = correct;
     ECVP_BHV_eval(h).InCorrect = incorrect;
     ECVP_BHV_eval(h).TargetPres = target;
     ECVP_BHV_eval(h).TargetAbsent = notarget;
     ECVP_BHV_eval(h).CuePres = cue_present;
     
     
     clear BHV
     clear ETdata
     clear ETparams
end

all_cuepres_tarpres_rxntime = [];
all_nocue_tarpres_rxntime = [];
multi_cue_tarpres = [];
multi_cue_NOtarpres = [];
multi_NOcue_tarpres = [];
multi_NOcue_NOtarpres = [];




for k = 1:length( ECVP_BHV_eval )
    if ECVP_BHV_eval(k).CuePres == 1
        rxntimes_idx = find(ECVP_BHV_eval(k).RxnTime(:,1)>= 1);
        %disp(ECVP_BHV_eval(k).RxnTime(rxntimes_idx,1))
        %pause
        all_cuepres_tarpres_rxntime = cat(1,all_cuepres_tarpres_rxntime,ECVP_BHV_eval(k).RxnTime(rxntimes_idx,1));
        target_idx = find(ECVP_BHV_eval(k).MultiSacc_RxnTime(3,:)==1);
        multi_cue_tarpres = cat(2, multi_cue_tarpres, ECVP_BHV_eval(k).MultiSacc_RxnTime(2,target_idx)); 
        NOtarget_idx = find(ECVP_BHV_eval(k).MultiSacc_RxnTime(3,:)==0);
        multi_cue_NOtarpres = cat(2, multi_cue_NOtarpres, ECVP_BHV_eval(k).MultiSacc_RxnTime(2,NOtarget_idx)); 
    elseif ECVP_BHV_eval(k).CuePres == 0
        rxntimes_idx = find(ECVP_BHV_eval(k).RxnTime(:,1)>= 1);
        %disp(ECVP_BHV_eval(k).RxnTime(rxntimes_idx,1))
        %pause
        all_nocue_tarpres_rxntime = cat(1,all_nocue_tarpres_rxntime,ECVP_BHV_eval(k).RxnTime(rxntimes_idx,1));
        target_idx = find(ECVP_BHV_eval(k).MultiSacc_RxnTime(3,:)==1);
        multi_NOcue_tarpres = cat(2, multi_NOcue_tarpres, ECVP_BHV_eval(k).MultiSacc_RxnTime(2,target_idx)); 
        NOtarget_idx = find(ECVP_BHV_eval(k).MultiSacc_RxnTime(3,:)==0);
        multi_NOcue_NOtarpres = cat(2, multi_NOcue_NOtarpres, ECVP_BHV_eval(k).MultiSacc_RxnTime(2,NOtarget_idx));
    end
end

diff = length(all_cuepres_tarpres_rxntime)-length(all_nocue_tarpres_rxntime);
all_nocue_tarpres_rxntime = cat(1, all_nocue_tarpres_rxntime, NaN(diff,1));
all_tarpres_rxntime = cat(2, all_cuepres_tarpres_rxntime, all_nocue_tarpres_rxntime);

figure('Position', [100 100 300 300])
errorbar([nanmean(all_tarpres_rxntime(:,1)) nanmean(all_tarpres_rxntime(:,2))], [nanstd(all_tarpres_rxntime(:,1)) nanstd(all_tarpres_rxntime(:,2))], 'sr','LineStyle', 'none','MarkerSize', 10)
ylim([0 1500]);
set(gca, 'XTick', 1:2)
set(gca, 'XTickLabel', {'Cue','No Cue'})
ylabel('Ave Search Time (msec)')
title('Mean Search Times for Correct Target Present Trials')

figure('Position', [100 100 1000 400])
hist(all_tarpres_rxntime, 0:50:2200)
ylim([0 500]);
set(gca, 'XTick', 1:500:2200)
ylabel('Num Trials')
legend('Cue','No Cue', 'Location', 'NorthEast')
title('Distribution of Reaction Times')


figure('Position', [100 100 300 300])
errorbar([mean(multi_cue_tarpres) mean(multi_cue_NOtarpres) mean(multi_NOcue_tarpres) mean(multi_NOcue_NOtarpres)], ...
    [std(multi_cue_tarpres) std(multi_cue_NOtarpres) std(multi_NOcue_tarpres) std(multi_NOcue_NOtarpres)], ...
    'sr','LineStyle', 'none','MarkerSize', 10)
ylim([0 15]);
set(gca, 'XTick', 1:4)
set(gca, 'XTickLabel', {'Cue +T','Cue -T', '-Cue +T','-Cue -T'})
ylabel('Ave number saccade')
title('Average #Saccade for MultiSaccade Trials')

max_length = max([length(multi_cue_tarpres) length(multi_cue_NOtarpres) length(multi_NOcue_tarpres) length(multi_NOcue_NOtarpres)]);
multi_cue_tarpres =  cat(2, multi_cue_tarpres, NaN(1,(max_length - length(multi_cue_tarpres))));
multi_cue_NOtarpres = cat(2, multi_cue_NOtarpres, NaN(1,(max_length - length(multi_cue_NOtarpres))));
multi_NOcue_tarpres = cat(2, multi_NOcue_tarpres, NaN(1,(max_length - length(multi_NOcue_tarpres))));
multi_NOcue_NOtarpres = cat(2, multi_NOcue_NOtarpres, NaN(1,(max_length - length(multi_NOcue_NOtarpres))));

multi_numsacc = cat(1, multi_cue_tarpres, multi_cue_NOtarpres, multi_NOcue_tarpres, multi_NOcue_NOtarpres);

figure('Position', [100 100 800 400])
hist(multi_numsacc', 1:10)
ylim([0 100]);
set(gca, 'XTick', 1:10)
legend('Cue +T','Cue -T', '-Cue +T','-Cue -T', 'Location', 'NorthEast')
ylabel('Num Saccades')
title('Distribution of Multiple Saccades')

imm_percent = (length(all_cuepres_tarpres_rxntime) - length(multi_cue_tarpres) - length(multi_cue_NOtarpres))/length(all_cuepres_tarpres_rxntime);