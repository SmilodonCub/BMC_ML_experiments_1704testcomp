cues = {'F6' 'NULL';'B6L' 'NULL';'B6H' 'NULL';'F6' 'B6L';'F6' 'B6H';'B6L' 'B6H';
        'F9' 'NULL';'B9L' 'NULL';'B9H' 'NULL';'F9' 'B9L';'F9' 'B9H';'B9L' 'B9H';
        'F9' 'NULL';'B9L' 'NULL';'B9H' 'NULL';'F3' 'B3L';'F3' 'B3H';'B3L' 'B3H'};
TrialRecord.CurrentConditionInfo.Stim4 = '25';

for i = 1:18
    TrialRecord.CurrentConditionInfo.Stim2 = cues{i,1}
    TrialRecord.CurrentConditionInfo.Stim3 = cues{i,2}
    %subplot(2,1,1);image(cue1risk1(TrialRecord));
    %subplot(2,1,2);image(cue2risk1(TrialRecord));
    %figure;
    %image(cue1risk1(TrialRecord));
    %figure;
    %image(cue2risk1(TrialRecord));
    cue1risk1(TrialRecord)
    cue2risk1(TrialRecord)
end