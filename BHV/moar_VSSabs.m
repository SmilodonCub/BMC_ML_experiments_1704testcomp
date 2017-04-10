% Here are my thoughts so far.
% 
% First part:
% Rather than looking at immediate fixation trials, I think you should focus on correct trials-- defined as trials in which the monkey got a reward regardless of how many saccades were made. Then you could look at total search time (say, from leaving fixation until reward) as a function of cue/no cue, number of distractors, number of potential targets. You could also look at the number of saccades made in the trial as a function of these same factors.
% I didnt do this because then it is difficult to compare rxn times of bear/ no bear trials, but will make comparisons for multi trials?
% 
% But if you only select the 1st saccade wins trials, then you are by definition selecting those trials in which the search was relatively efficient, so perhaps you wouldn't expect to see much in the way of RT changes with these various factors. I will make comparisons as a function of # distractors viewed for bear/no bear and cued/uncued.
% 
% Second part:
% This looks good. If I understand what you're saying, it's that more saccades are made in target absent than target present trials? That would make sense.
% 
% Rob
% 
% -> Correct trials 
% 	a) total search time for Cue/ No Cue
% 	b) total search time as a fxn of number of distractors viewed for Cue / No Cue
% 	c) total search time as a fxn of the number of potential bear targets  for Cue / No Cue
% 	d) ave number of saccades (overal & multi) as fxn of Cue / No Cue
% 	e) ave number of saccades (overal & multi) as fxn of number of potential bear targets

% 	a) total search time for Cue/ No Cue

Cue_RxnT = [];
Cue_numS = [];
Cue_B_AveMulti = zeros(2,size(Multi_Sacc_Info,2));
Cue_NB_AveMulti = zeros(2,size(Multi_Sacc_Info,2));
NOCue_RxnT = [];
NOCue_numS = [];
NOCue_B_AveMulti = zeros(2,size(Multi_Sacc_Info,2));
NOCue_NB_AveMulti = zeros(2,size(Multi_Sacc_Info,2));

Cue_B_AveMulti_byNT = zeros(1,15);
Cue_NB_AveMulti_byNT = zeros(1,15);
NOCue_B_AveMulti_byNT = zeros(1,15);
NOCue_NB_AveMulti_byNT = zeros(1,15);

CB_5 = [];
CNB_5 = [];
NCB_5 = [];
NCNB_5 = [];
CB_7 = [];
CNB_7 = [];
NCB_7 = [];
NCNB_7 = [];
CB_8 = [];
CNB_8 = [];
NCB_8 = [];
NCNB_8 = [];
CB_9 = [];
CNB_9 = [];
NCB_9 = [];
NCNB_9 = [];
CB_10 = [];
CNB_10 = [];
NCB_10 = [];
NCNB_10 = [];
RXNCB_5 = [];
RXNCNB_5 = [];
RXNNCB_5 = [];
RXNNCNB_5 = [];
RXNCB_7 = [];
RXNCNB_7 = [];
RXNNCB_7 = [];
RXNNCNB_7 = [];
RXNCB_8 = [];
RXNCNB_8 = [];
RXNNCB_8 = [];
RXNNCNB_8 = [];
RXNCB_9 = [];
RXNCNB_9 = [];
RXNNCB_9 = [];
RXNNCNB_9 = [];
RXNCB_10 = [];
RXNCNB_10 = [];
RXNNCB_10 = [];
RXNNCNB_10 = [];

for i = 1:size(Multi_Sacc_Info,2)
    if Multi_Sacc_Info(i).Cue == 1
        times = Multi_Sacc_Info(i).RxnT(:,:);
        Cue_RxnT = cat(2, Cue_RxnT, times(1,:));
        Cue_numS = cat(2, Cue_numS, times(2,:));
        B = find(Multi_Sacc_Info(i).RxnT(3,:) == 1);
        Cue_B_AveMulti(1,i) =  mean(Multi_Sacc_Info(i).RxnT(2, B));
        Cue_B_AveMulti(2,i) =  mean(Multi_Sacc_Info(i).RxnT(1, B));
        NB = find(Multi_Sacc_Info(i).RxnT(3,:) == 0);
        Cue_NB_AveMulti(1,i) =  mean(Multi_Sacc_Info(i).RxnT(2, NB));
        Cue_NB_AveMulti(2,i) =  mean(Multi_Sacc_Info(i).RxnT(1, NB));
        if Multi_Sacc_Info(i).NumTar == 5
%             Cue_B_AveMulti_byNT(1) = sum([Cue_B_AveMulti_byNT(1) Multi_Sacc_Info(i).RxnT(2, B)]);
%             Cue_NB_AveMulti_byNT(1) = sum([Cue_NB_AveMulti_byNT(1) Multi_Sacc_Info(i).RxnT(2, NB)]);
%             Cue_B_AveMulti_byNT(6) = sum([Cue_B_AveMulti_byNT(6) Multi_Sacc_Info(i).RxnT(1, B)]);
%             Cue_NB_AveMulti_byNT(6) = sum([Cue_NB_AveMulti_byNT(6) Multi_Sacc_Info(i).RxnT(1, NB)]);
%             Cue_B_AveMulti_byNT(11) = sum([Cue_B_AveMulti_byNT(11) length(Multi_Sacc_Info(i).RxnT(1, B))]);
%             Cue_NB_AveMulti_byNT(11) = sum([Cue_NB_AveMulti_byNT(11) length(Multi_Sacc_Info(i).RxnT(1, NB))]);
            CB_5 = cat(2, CB_5, Multi_Sacc_Info(i).RxnT(2, B));
            CNB_5 = cat(2, CNB_5, Multi_Sacc_Info(i).RxnT(2, NB));
            RXNCB_5 = cat(2, RXNCB_5, Multi_Sacc_Info(i).RxnT(1, B));
            RXNCNB_5 = cat(2, RXNCNB_5, Multi_Sacc_Info(i).RxnT(1, NB));
        elseif Multi_Sacc_Info(i).NumTar == 7
%             Cue_B_AveMulti_byNT(2) = sum([Cue_B_AveMulti_byNT(2) Multi_Sacc_Info(i).RxnT(2, B)]);
%             Cue_NB_AveMulti_byNT(2) = sum([Cue_NB_AveMulti_byNT(2) Multi_Sacc_Info(i).RxnT(2, NB)]);
%             Cue_B_AveMulti_byNT(7) = sum([Cue_B_AveMulti_byNT(7) Multi_Sacc_Info(i).RxnT(1, B)]);
%             Cue_NB_AveMulti_byNT(7) = sum([Cue_NB_AveMulti_byNT(7) Multi_Sacc_Info(i).RxnT(1, NB)]);
%             Cue_B_AveMulti_byNT(12) = sum([Cue_B_AveMulti_byNT(12) length(Multi_Sacc_Info(i).RxnT(1, B))]);
%             Cue_NB_AveMulti_byNT(12) = sum([Cue_NB_AveMulti_byNT(12) length(Multi_Sacc_Info(i).RxnT(1, NB))]);
            CB_7 = cat(2, CB_7, Multi_Sacc_Info(i).RxnT(2, B));
            CNB_7 = cat(2, CNB_7, Multi_Sacc_Info(i).RxnT(2, NB));
            RXNCB_7 = cat(2, RXNCB_7, Multi_Sacc_Info(i).RxnT(1, B));
            RXNCNB_7 = cat(2, RXNCNB_7, Multi_Sacc_Info(i).RxnT(1, NB));
        elseif Multi_Sacc_Info(i).NumTar == 8
%             Cue_B_AveMulti_byNT(3) = sum([Cue_B_AveMulti_byNT(3) Multi_Sacc_Info(i).RxnT(2, B)]);
%             Cue_NB_AveMulti_byNT(3) = sum([Cue_NB_AveMulti_byNT(3) Multi_Sacc_Info(i).RxnT(2, NB)]);
%             Cue_B_AveMulti_byNT(8) = sum([Cue_B_AveMulti_byNT(8) Multi_Sacc_Info(i).RxnT(1, B)]);
%             Cue_NB_AveMulti_byNT(8) = sum([Cue_NB_AveMulti_byNT(8) Multi_Sacc_Info(i).RxnT(1, NB)]);
%             Cue_B_AveMulti_byNT(13) = sum([Cue_B_AveMulti_byNT(13) length(Multi_Sacc_Info(i).RxnT(1, B))]);
%             Cue_NB_AveMulti_byNT(13) = sum([Cue_NB_AveMulti_byNT(13) length(Multi_Sacc_Info(i).RxnT(1, NB))]);
            CB_8 = cat(2, CB_8, Multi_Sacc_Info(i).RxnT(2, B));
            CNB_8 = cat(2, CNB_8, Multi_Sacc_Info(i).RxnT(2, NB));
            RXNCB_8 = cat(2, RXNCB_8, Multi_Sacc_Info(i).RxnT(1, B));
            RXNCNB_8 = cat(2, RXNCNB_8, Multi_Sacc_Info(i).RxnT(1, NB));            
        elseif Multi_Sacc_Info(i).NumTar == 9
%             Cue_B_AveMulti_byNT(4) = sum([Cue_B_AveMulti_byNT(4) Multi_Sacc_Info(i).RxnT(2, B)]);
%             Cue_NB_AveMulti_byNT(4) = sum([Cue_NB_AveMulti_byNT(4) Multi_Sacc_Info(i).RxnT(2, NB)]);
%             Cue_B_AveMulti_byNT(9) = sum([Cue_B_AveMulti_byNT(9) Multi_Sacc_Info(i).RxnT(1, B)]);
%             Cue_NB_AveMulti_byNT(9) = sum([Cue_NB_AveMulti_byNT(9) Multi_Sacc_Info(i).RxnT(1, NB)]);
%             Cue_B_AveMulti_byNT(14) = sum([Cue_B_AveMulti_byNT(14) length(Multi_Sacc_Info(i).RxnT(1, B))]);
%             Cue_NB_AveMulti_byNT(14) = sum([Cue_NB_AveMulti_byNT(14) length(Multi_Sacc_Info(i).RxnT(1, NB))]);  
            CB_9 = cat(2, CB_9, Multi_Sacc_Info(i).RxnT(2, B));
            CNB_9 = cat(2, CNB_9, Multi_Sacc_Info(i).RxnT(2, NB));
            RXNCB_9 = cat(2, RXNCB_9, Multi_Sacc_Info(i).RxnT(1, B));
            RXNCNB_9 = cat(2, RXNCNB_9, Multi_Sacc_Info(i).RxnT(1, NB));            
        elseif Multi_Sacc_Info(i).NumTar == 10
%             Cue_B_AveMulti_byNT(5) = sum([Cue_B_AveMulti_byNT(5) Multi_Sacc_Info(i).RxnT(2, B)]);
%             Cue_NB_AveMulti_byNT(5) = sum([Cue_NB_AveMulti_byNT(5) Multi_Sacc_Info(i).RxnT(2, NB)]);
%             Cue_B_AveMulti_byNT(10) = sum([Cue_B_AveMulti_byNT(10) Multi_Sacc_Info(i).RxnT(1, B)]);
%             Cue_NB_AveMulti_byNT(10) = sum([Cue_NB_AveMulti_byNT(10) Multi_Sacc_Info(i).RxnT(1, NB)]);
%             Cue_B_AveMulti_byNT(15) = sum([Cue_B_AveMulti_byNT(15) length(Multi_Sacc_Info(i).RxnT(1, B))]);
%             Cue_NB_AveMulti_byNT(15) = sum([Cue_NB_AveMulti_byNT(15) length(Multi_Sacc_Info(i).RxnT(1, NB))]);
            CB_10 = cat(2, CB_10, Multi_Sacc_Info(i).RxnT(2, B));
            CNB_10 = cat(2, CNB_10, Multi_Sacc_Info(i).RxnT(2, NB));
            RXNCB_10 = cat(2, RXNCB_10, Multi_Sacc_Info(i).RxnT(1, B));
            RXNCNB_10 = cat(2, RXNCNB_10, Multi_Sacc_Info(i).RxnT(1, NB));            
        end
    elseif Multi_Sacc_Info(i).Cue == 0
        times = Multi_Sacc_Info(i).RxnT(:,:);
        NOCue_RxnT = cat(2, NOCue_RxnT, times(1,:));
        NOCue_numS = cat(2, NOCue_numS, times(2,:));
        B = find(Multi_Sacc_Info(i).RxnT(3,:) == 1);
        NOCue_B_AveMulti(1,i) =  mean(Multi_Sacc_Info(i).RxnT(2, B));
        NOCue_B_AveMulti(2,i) =  mean(Multi_Sacc_Info(i).RxnT(1, B));
        NB = find(Multi_Sacc_Info(i).RxnT(3,:) == 0);
        NOCue_NB_AveMulti(1,i) =  mean(Multi_Sacc_Info(i).RxnT(2, NB));
        NOCue_NB_AveMulti(2,i) =  mean(Multi_Sacc_Info(i).RxnT(1, NB));
        if Multi_Sacc_Info(i).NumTar == 5
%             NOCue_B_AveMulti_byNT(1) = sum([NOCue_B_AveMulti_byNT(1) Multi_Sacc_Info(i).RxnT(2, B)]);
%             NOCue_NB_AveMulti_byNT(1) = sum([NOCue_NB_AveMulti_byNT(1) Multi_Sacc_Info(i).RxnT(2, NB)]);
%             NOCue_B_AveMulti_byNT(6) = sum([NOCue_B_AveMulti_byNT(6) Multi_Sacc_Info(i).RxnT(1, B)]);
%             NOCue_NB_AveMulti_byNT(6) = sum([NOCue_NB_AveMulti_byNT(6) Multi_Sacc_Info(i).RxnT(1, NB)]);
%             NOCue_B_AveMulti_byNT(11) = sum([NOCue_B_AveMulti_byNT(11) length(Multi_Sacc_Info(i).RxnT(1, B))]);
%             NOCue_NB_AveMulti_byNT(11) = sum([NOCue_NB_AveMulti_byNT(11) length(Multi_Sacc_Info(i).RxnT(1, NB))]);
            NCB_5 = cat(2, NCB_5, Multi_Sacc_Info(i).RxnT(2, B));
            NCNB_5 = cat(2, NCNB_5, Multi_Sacc_Info(i).RxnT(2, NB));
            RXNNCB_5 = cat(2, RXNNCB_5, Multi_Sacc_Info(i).RxnT(1, B));
            RXNNCNB_5 = cat(2, RXNNCNB_5, Multi_Sacc_Info(i).RxnT(1, NB));
        elseif Multi_Sacc_Info(i).NumTar == 7
%             NOCue_B_AveMulti_byNT(2) = sum([NOCue_B_AveMulti_byNT(2) Multi_Sacc_Info(i).RxnT(2, B)]);
%             NOCue_NB_AveMulti_byNT(2) = sum([NOCue_NB_AveMulti_byNT(2) Multi_Sacc_Info(i).RxnT(2, NB)]);
%             NOCue_B_AveMulti_byNT(7) = sum([NOCue_B_AveMulti_byNT(7) Multi_Sacc_Info(i).RxnT(1, B)]);
%             NOCue_NB_AveMulti_byNT(7) = sum([NOCue_NB_AveMulti_byNT(7) Multi_Sacc_Info(i).RxnT(1, NB)]);
%             NOCue_B_AveMulti_byNT(12) = sum([NOCue_B_AveMulti_byNT(12) length(Multi_Sacc_Info(i).RxnT(1, B))]);
%             NOCue_NB_AveMulti_byNT(12) = sum([NOCue_NB_AveMulti_byNT(12) length(Multi_Sacc_Info(i).RxnT(1, NB))]);
            NCB_7 = cat(2, NCB_7, Multi_Sacc_Info(i).RxnT(2, B));
            NCNB_7 = cat(2, NCNB_7, Multi_Sacc_Info(i).RxnT(2, NB));
            RXNNCB_7 = cat(2, RXNNCB_7, Multi_Sacc_Info(i).RxnT(1, B));
            RXNNCNB_7 = cat(2, RXNNCNB_7, Multi_Sacc_Info(i).RxnT(1, NB));            
        elseif Multi_Sacc_Info(i).NumTar == 8
%             NOCue_B_AveMulti_byNT(3) = sum([NOCue_B_AveMulti_byNT(3) Multi_Sacc_Info(i).RxnT(2, B)]);
%             NOCue_NB_AveMulti_byNT(3) = sum([NOCue_NB_AveMulti_byNT(3) Multi_Sacc_Info(i).RxnT(2, NB)]);
%             NOCue_B_AveMulti_byNT(8) = sum([NOCue_B_AveMulti_byNT(8) Multi_Sacc_Info(i).RxnT(1, B)]);
%             NOCue_NB_AveMulti_byNT(8) = sum([NOCue_NB_AveMulti_byNT(8) Multi_Sacc_Info(i).RxnT(1, NB)]);
%             NOCue_B_AveMulti_byNT(13) = sum([NOCue_B_AveMulti_byNT(13) length(Multi_Sacc_Info(i).RxnT(1, B))]);
%             NOCue_NB_AveMulti_byNT(13) = sum([NOCue_NB_AveMulti_byNT(13) length(Multi_Sacc_Info(i).RxnT(1, NB))]);
            NCB_8 = cat(2, NCB_8, Multi_Sacc_Info(i).RxnT(2, B));
            NCNB_8 = cat(2, NCNB_8, Multi_Sacc_Info(i).RxnT(2, NB));
            RXNNCB_8 = cat(2, RXNNCB_8, Multi_Sacc_Info(i).RxnT(1, B));
            RXNNCNB_8 = cat(2, RXNNCNB_8, Multi_Sacc_Info(i).RxnT(1, NB));
        elseif Multi_Sacc_Info(i).NumTar == 9
%             NOCue_B_AveMulti_byNT(4) = sum([NOCue_B_AveMulti_byNT(4) Multi_Sacc_Info(i).RxnT(2, B)]);
%             NOCue_NB_AveMulti_byNT(4) = sum([NOCue_NB_AveMulti_byNT(4) Multi_Sacc_Info(i).RxnT(2, NB)]);
%             NOCue_B_AveMulti_byNT(9) = sum([NOCue_B_AveMulti_byNT(9) Multi_Sacc_Info(i).RxnT(1, B)]);
%             NOCue_NB_AveMulti_byNT(9) = sum([NOCue_NB_AveMulti_byNT(9) Multi_Sacc_Info(i).RxnT(1, NB)]);
%             NOCue_B_AveMulti_byNT(14) = sum([NOCue_B_AveMulti_byNT(14) length(Multi_Sacc_Info(i).RxnT(1, B))]);
%             NOCue_NB_AveMulti_byNT(14) = sum([NOCue_NB_AveMulti_byNT(14) length(Multi_Sacc_Info(i).RxnT(1, NB))]);
            NCB_9 = cat(2, NCB_9, Multi_Sacc_Info(i).RxnT(2, B));
            NCNB_9 = cat(2, NCNB_9, Multi_Sacc_Info(i).RxnT(2, NB));
            RXNNCB_9 = cat(2, RXNNCB_9, Multi_Sacc_Info(i).RxnT(1, B));
            RXNNCNB_9 = cat(2, RXNNCNB_9, Multi_Sacc_Info(i).RxnT(1, NB));
        elseif Multi_Sacc_Info(i).NumTar == 10
%             NOCue_B_AveMulti_byNT(5) = sum([NOCue_B_AveMulti_byNT(5) Multi_Sacc_Info(i).RxnT(2, B)]);
%             NOCue_NB_AveMulti_byNT(5) = sum([NOCue_NB_AveMulti_byNT(5) Multi_Sacc_Info(i).RxnT(2, NB)]);
%             NOCue_B_AveMulti_byNT(10) = sum([NOCue_B_AveMulti_byNT(10) Multi_Sacc_Info(i).RxnT(1, B)]);
%             NOCue_NB_AveMulti_byNT(10) = sum([NOCue_NB_AveMulti_byNT(10) Multi_Sacc_Info(i).RxnT(1, NB)]);
%             NOCue_B_AveMulti_byNT(15) = sum([NOCue_B_AveMulti_byNT(15) length(Multi_Sacc_Info(i).RxnT(1, B))]);
%             NOCue_NB_AveMulti_byNT(15) = sum([NOCue_NB_AveMulti_byNT(15) length(Multi_Sacc_Info(i).RxnT(1, NB))]); 
            NCB_10 = cat(2, NCB_10, Multi_Sacc_Info(i).RxnT(2, B));
            NCNB_10 = cat(2, NCNB_10, Multi_Sacc_Info(i).RxnT(2, NB));
            RXNNCB_10 = cat(2, RXNNCB_10, Multi_Sacc_Info(i).RxnT(1, B));
            RXNNCNB_10 = cat(2, RXNNCNB_10, Multi_Sacc_Info(i).RxnT(1, NB));
        end
    end
    
end


figure('Position', [100 100 300 300])
errorbar([nanmean(Cue_RxnT) nanmean(NOCue_RxnT)], [nanstd(Cue_RxnT) nanstd(NOCue_RxnT)], 'sr','LineStyle', 'none','MarkerSize', 10)
ylim([0 1500]);
set(gca, 'XTick', 1:2)
set(gca, 'XTickLabel', {'Cue','No Cue'})
ylabel('Ave Search Time (msec)')
title('Mean Search Times for Multi-Saccade Trials')

figure('Position', [100 100 300 300])
errorbar([nanmean(Cue_numS) nanmean(NOCue_numS)], [nanstd(Cue_numS) nanstd(NOCue_numS)], 'sr','LineStyle', 'none','MarkerSize', 10)
ylim([0 6]);
set(gca, 'XTick', 1:2)
set(gca, 'XTickLabel', {'Cue','No Cue'})
ylabel('# Distractors Fixated')
title('# Distractors Fixated for Multi-Saccade Trials')


Cue_B_AM_num = [mean(CB_5) mean(CB_7) mean(CB_8) mean(CB_9) mean(CB_10)];
Cue_NB_AM_num = [mean(CNB_5) mean(CNB_7) mean(CNB_8) mean(CNB_9) mean(CNB_10)];
Cue_B_AM_RxnT = [mean(RXNCB_5) mean(RXNCB_7) mean(RXNCB_8) mean(RXNCB_9) mean(RXNCB_10)];
Cue_NB_AM_RxnT = [mean(RXNCNB_5) mean(RXNCNB_7) mean(RXNCNB_8) mean(RXNCNB_9) mean(RXNCNB_10)];
NOCue_B_AM_num = [mean(NCB_5) mean(NCB_7) mean(NCB_8) mean(NCB_9) mean(NCB_10)];
NOCue_NB_AM_num = [mean(NCNB_5) mean(NCNB_7) mean(NCNB_8) mean(NCNB_9) mean(NCNB_10)];
NOCue_B_AM_RxnT = [mean(RXNNCB_5) mean(RXNNCB_7) mean(RXNNCB_8) mean(RXNNCB_9) mean(RXNNCB_10)];
NOCue_NB_AM_RxnT = [mean(RXNNCNB_5) mean(RXNNCNB_7) mean(RXNNCNB_8) mean(RXNNCNB_9) mean(RXNNCNB_10)];

Cue_B_AM_numSTD = [std(CB_5) std(CB_7) std(CB_8) std(CB_9) std(CB_10)];
Cue_NB_AM_numSTD = [std(CNB_5) std(CNB_7) std(CNB_8) std(CNB_9) std(CNB_10)];
Cue_B_AM_RxnTSTD = [std(RXNCB_5) std(RXNCB_7) std(RXNCB_8) std(RXNCB_9) std(RXNCB_10)];
Cue_NB_AM_RxnTSTD = [std(RXNCNB_5) std(RXNCNB_7) std(RXNCNB_8) std(RXNCNB_9) std(RXNCNB_10)];
NOCue_B_AM_numSTD = [std(NCB_5) std(NCB_7) std(NCB_8) std(NCB_9) std(NCB_10)];
NOCue_NB_AM_numSTD = [std(NCNB_5) std(NCNB_7) std(NCNB_8) std(NCNB_9) std(NCNB_10)];
NOCue_B_AM_RxnTSTD = [std(RXNNCB_5) std(RXNNCB_7) std(RXNNCB_8) std(RXNNCB_9) std(RXNNCB_10)];
NOCue_NB_AM_RxnTSTD = [std(RXNNCNB_5) std(RXNNCNB_7) std(RXNNCNB_8) std(RXNNCNB_9) std(RXNNCNB_10)];


figure('Position', [100 100 1200 500])
subplot(1,2,1)
errorbar(Cue_B_AM_num, Cue_B_AM_numSTD, 'sr','LineStyle', 'none','MarkerSize', 10)
hold on
errorbar(Cue_NB_AM_num, Cue_NB_AM_numSTD, 'sg','LineStyle', 'none','MarkerSize', 10)
ylim([0 5]);
legend('Target','No Target', 'Location', 'SouthEast')
set(gca, 'XTick', 1:5)
set(gca, 'XTickLabel', [5 7 8 9 10])
ylabel('# Distractors Fixated')
title('Cue Present: Ave # Saccade for MultiSaccade Trials')
subplot(1,2,2)
errorbar(Cue_B_AM_RxnT, Cue_B_AM_RxnTSTD, 'sr','LineStyle', 'none','MarkerSize', 10)
hold on
errorbar(Cue_NB_AM_RxnT, Cue_NB_AM_RxnTSTD, 'sg','LineStyle', 'none','MarkerSize', 10)
ylim([0 1200]);
legend('Target','No Target', 'Location', 'SouthEast')
set(gca, 'XTick', 1:5)
set(gca, 'XTickLabel', [5 7 8 9 10])
ylabel('Search Duration (msec)')
title('Cue Present: Search Duration for MultiSaccade Trials')

figure('Position', [100 100 1200 500])
subplot(1,2,1)
errorbar(NOCue_B_AM_num, NOCue_B_AM_numSTD, 'sr','LineStyle', 'none','MarkerSize', 10)
hold on
errorbar(NOCue_NB_AM_num, NOCue_NB_AM_numSTD, 'sg','LineStyle', 'none','MarkerSize', 10)
ylim([0 5]);
legend('Target','No Target', 'Location', 'SouthEast')
set(gca, 'XTick', 1:5)
set(gca, 'XTickLabel', [5 7 8 9 10])
ylabel('# Distractors Fixated')
title('No Cue: Ave # Saccade for MultiSaccade Trials')
subplot(1,2,2)
errorbar(NOCue_B_AM_RxnT, NOCue_B_AM_RxnTSTD, 'sr','LineStyle', 'none','MarkerSize', 10)
hold on
errorbar(NOCue_NB_AM_RxnT, NOCue_NB_AM_RxnTSTD, 'sg','LineStyle', 'none','MarkerSize', 10)
ylim([0 1200]);
legend('Target','No Target', 'Location', 'SouthEast')
set(gca, 'XTick', 1:5)
set(gca, 'XTickLabel', [5 7 8 9 10])
ylabel('Search Duration')
title('No Cue: Search Duration for MultiSaccade Trials')



figure('Position', [100 100 1200 500])
subplot(1,2,1)
errorbar(Cue_B_AM_num, Cue_B_AM_numSTD, 'sr','LineStyle', 'none','MarkerSize', 10)
hold on
errorbar(NOCue_B_AM_num, NOCue_B_AM_numSTD, 'sg','LineStyle', 'none','MarkerSize', 10)
ylim([0 5]);
legend('Cue','No Cue', 'Location', 'SouthEast')
set(gca, 'XTick', 1:5)
set(gca, 'XTickLabel', [5 7 8 9 10])
ylabel('# Distractors Fixated')
title('Cue v No Cue (target present): Ave # Saccade for MultiSaccade Trials')
subplot(1,2,2)
errorbar(Cue_B_AM_RxnT, Cue_B_AM_RxnTSTD, 'sr','LineStyle', 'none','MarkerSize', 10)
hold on
errorbar(NOCue_B_AM_RxnT, NOCue_B_AM_RxnTSTD, 'sg','LineStyle', 'none','MarkerSize', 10)
ylim([0 1200]);
legend('Cue','No Cue', 'Location', 'SouthEast')
set(gca, 'XTick', 1:5)
set(gca, 'XTickLabel', [5 7 8 9 10])
ylabel('Search Duration (msec)')
title('Cue v No Cue (target present): Search Duration for MultiSaccade Trials')

figure('Position', [100 100 1200 500])
subplot(1,2,1)
errorbar(Cue_NB_AM_num, Cue_NB_AM_numSTD, 'sr','LineStyle', 'none','MarkerSize', 10)
hold on
errorbar(NOCue_NB_AM_num, NOCue_NB_AM_numSTD, 'sg','LineStyle', 'none','MarkerSize', 10)
ylim([0 5]);
legend('Cue','No Cue', 'Location', 'SouthEast')
set(gca, 'XTick', 1:5)
set(gca, 'XTickLabel', [5 7 8 9 10])
ylabel('# Distractors Fixated')
title('Cue v No Cue (no target): Ave # Saccade for MultiSaccade Trials')
subplot(1,2,2)
errorbar(Cue_NB_AM_RxnT, Cue_NB_AM_RxnTSTD, 'sr','LineStyle', 'none','MarkerSize', 10)
hold on
errorbar(NOCue_NB_AM_RxnT, NOCue_NB_AM_RxnTSTD, 'sg','LineStyle', 'none','MarkerSize', 10)
ylim([0 1200]);
legend('Cue','No Cue', 'Location', 'SouthEast')
set(gca, 'XTick', 1:5)
set(gca, 'XTickLabel', [5 7 8 9 10])
ylabel('Search Duration')
title('Cue v No Cue (no target): Search Duration for MultiSaccade Trials')

% figure('Position', [100 100 600 500])
% plot(1:5, Cue_B_AveMulti_byNT(1:5)./Cue_B_AveMulti_byNT(11:15), 'sr','LineStyle', 'none','MarkerSize', 10)
% hold on
% plot(1:5, Cue_NB_AveMulti_byNT(1:5)./Cue_NB_AveMulti_byNT(11:15), 'sg','LineStyle', 'none','MarkerSize', 10)
% ylim([0 5]);
% set(gca, 'XTick', 1:5)
% set(gca, 'XTickLabel', [5 7 8 9 10])
% ylabel('# Distractors Fixated')
% title('Cue Present: Ave # Saccade for MultiSaccade Trials')
% 
% figure('Position', [100 100 600 500])
% plot(1:5, Cue_B_AveMulti_byNT(6:10)./Cue_B_AveMulti_byNT(11:15), 'sr','LineStyle', 'none','MarkerSize', 10)
% hold on
% plot(1:5, Cue_NB_AveMulti_byNT(6:10)./Cue_NB_AveMulti_byNT(11:15), 'sg','LineStyle', 'none','MarkerSize', 10)
% ylim([0 1200]);
% set(gca, 'XTick', 1:5)
% set(gca, 'XTickLabel', [5 7 8 9 10])
% ylabel('# Distractors Fixated')
% title('Cue Present: Ave # Saccade for MultiSaccade Trials')
% 
% figure('Position', [100 100 600 500])
% plot(1:5, NOCue_B_AveMulti_byNT(1:5)./NOCue_B_AveMulti_byNT(11:15), 'sr','LineStyle', 'none','MarkerSize', 10)
% hold on
% plot(1:5, NOCue_NB_AveMulti_byNT(1:5)./NOCue_NB_AveMulti_byNT(11:15), 'sg','LineStyle', 'none','MarkerSize', 10)
% ylim([0 5]);
% set(gca, 'XTick', 1:24)
% set(gca, 'XTickLabel', {'Cue','No Cue'})
% ylabel('# Distractors Fixated')
% title('# Distractors Fixated for Multi-Saccade Trials')
% 
% figure('Position', [100 100 600 500])
% plot(1:5, NOCue_B_AveMulti_byNT(6:10)./NOCue_B_AveMulti_byNT(11:15), 'sr','LineStyle', 'none','MarkerSize', 10)
% hold on
% plot(1:5, NOCue_NB_AveMulti_byNT(6:10)./NOCue_NB_AveMulti_byNT(11:15), 'sg','LineStyle', 'none','MarkerSize', 10)
% ylim([0 1200]);
% set(gca, 'XTick', 1:24)
% set(gca, 'XTickLabel', {'Cue','No Cue'})
% ylabel('# Distractors Fixated')
% title('# Distractors Fixated for Multi-Saccade Trials')
% 
% 
% 



% total search time as a fxn of number of distractors viewed for Cue / No Cue
Cue_Target_bynumD_viewed = zeros(2,10);
Cue_NOTarget_bynumD_viewed = zeros(2,10);
NOCue_Target_bynumD_viewed = zeros(2,10);
NOCue_NOTarget_bynumD_viewed = zeros(2,10);
RxnT_Multi = cell(1,4);

for i = 1:size(Multi_Sacc_Info,2)
    if mod(i,2) == 1 %Cue present
        for j = 1:size(Multi_Sacc_Info(i).RxnT,2)
            TP = find(Multi_Sacc_Info(i).RxnT(3,:) == 1 ); %find Target Present multi-saccade trials
            TA = find(Multi_Sacc_Info(i).RxnT(3,:) == 0 ); %find Target Absent multi-saccade trials
            RxnTs_CTP = [Multi_Sacc_Info(i).RxnT(1,TP);Multi_Sacc_Info(i).RxnT(2,TP)];
            RxnTs_CNOTP = [Multi_Sacc_Info(i).RxnT(1,TA);Multi_Sacc_Info(i).RxnT(2,TA)];
            if Multi_Sacc_Info(i).RxnT(3,j) == 1
                Cue_Target_bynumD_viewed(1,Multi_Sacc_Info(i).RxnT(2,j)) = Cue_Target_bynumD_viewed(1,Multi_Sacc_Info(i).RxnT(2,j)) + 1;
                Cue_Target_bynumD_viewed(1,Multi_Sacc_Info(i).RxnT(2,j)) = Cue_Target_bynumD_viewed(1,Multi_Sacc_Info(i).RxnT(2,j)) + 1;
            elseif Multi_Sacc_Info(i).RxnT(3,j) == 0
                Cue_NOTarget_bynumD_viewed(1,Multi_Sacc_Info(i).RxnT(2,j)) = Cue_NOTarget_bynumD_viewed(1,Multi_Sacc_Info(i).RxnT(2,j)) + 1;
            end
        end
        RxnT_Multi{1} = cat(2, RxnT_Multi{1}, RxnTs_CTP);
        RxnT_Multi{2} = cat(2, RxnT_Multi{2}, RxnTs_CNOTP);
    elseif mod(i,2) == 0 %Cue Absent
        for j = 1:size(Multi_Sacc_Info(i).RxnT,2)
            TP = find(Multi_Sacc_Info(i).RxnT(3,:) == 1 ); %find Target Present multi-saccade trials
            TA = find(Multi_Sacc_Info(i).RxnT(3,:) == 0 ); %find Target Absent multi-saccade trials
            RxnTs_NOCTP = [Multi_Sacc_Info(i).RxnT(1,TP);Multi_Sacc_Info(i).RxnT(2,TP)];
            RxnTs_NOCNOTP = [Multi_Sacc_Info(i).RxnT(1,TA);Multi_Sacc_Info(i).RxnT(2,TA)];
            if Multi_Sacc_Info(i).RxnT(3,j) == 1
                NOCue_Target_bynumD_viewed(1,Multi_Sacc_Info(i).RxnT(2,j)) = NOCue_Target_bynumD_viewed(1,Multi_Sacc_Info(i).RxnT(2,j)) + 1;
            elseif Multi_Sacc_Info(i).RxnT(3,j) == 0
                NOCue_NOTarget_bynumD_viewed(1,Multi_Sacc_Info(i).RxnT(2,j)) = NOCue_NOTarget_bynumD_viewed(1,Multi_Sacc_Info(i).RxnT(2,j)) + 1;
            end
        end
        RxnT_Multi{3} = cat(2, RxnT_Multi{3}, RxnTs_NOCTP);
        RxnT_Multi{4} = cat(2, RxnT_Multi{4}, RxnTs_NOCNOTP);
    end
end

figure
subplot(2,2,1)
bar(1:10, Cue_Target_bynumD_viewed(1,:))
subplot(2,2,2)
bar(1:10, Cue_NOTarget_bynumD_viewed(1,:))
subplot(2,2,3)
bar(1:10, NOCue_Target_bynumD_viewed(1,:))
subplot(2,2,4)
bar(1:10, NOCue_NOTarget_bynumD_viewed(1,:))

RxnT_bynumD_viewed = cell(12,10);

for h = 1:4
    for i = 1:10
        idx = find(RxnT_Multi{h}(2,:) == i);
        RxnT_bynumD_viewed{h,i} = RxnT_Multi{h}(1,idx);
        RxnT_bynumD_viewed{h+4,i} = nanmean(RxnT_Multi{h}(1,idx));
        RxnT_bynumD_viewed{h+8,i} = nanstd(RxnT_Multi{h}(1,idx));
    end
end


figure
errorbar(1:10, [RxnT_bynumD_viewed{5,:}], [RxnT_bynumD_viewed{9,:}], 'sr','LineStyle', '-','MarkerSize', 10)
hold on 
errorbar(1:10, [RxnT_bynumD_viewed{6,:}], [RxnT_bynumD_viewed{10,:}], 'sg','LineStyle', '-','MarkerSize', 10)
errorbar(1:10, [RxnT_bynumD_viewed{7,:}], [RxnT_bynumD_viewed{11,:}], 'sb','LineStyle', '-','MarkerSize', 10)
errorbar(1:10, [RxnT_bynumD_viewed{8,:}], [RxnT_bynumD_viewed{12,:}], 'sm','LineStyle', '-','MarkerSize', 10)
