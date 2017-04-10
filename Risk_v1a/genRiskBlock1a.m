%Set Timing file
timingfile = 'risk1a';

%Set reward contingencies

cues = {'F6' 'NULL';'B6L' 'NULL';'B6H' 'NULL';'F6' 'B6L';'F6' 'B6H';'B6L' 'B6H';
        'F9' 'NULL';'B9L' 'NULL';'B9H' 'NULL';'F9' 'B9L';'F9' 'B9H';'B9L' 'B9H';
        'F9' 'NULL';'B9L' 'NULL';'B9H' 'NULL';'F3' 'B3L';'F3' 'B3H';'B3L' 'B3H'};
%cues = fieldnames(monData);
%Select which cues are used at what weight
%6S = mid cues, singly presented, 6C = mid cues, choice presentatations
%            F6 B6L B6H 6FL 6FH 6LH   F9 B9L B9H 9FL 9FH 9LH   F3 B3L B3H 3FL 3FH 3LH
cueweights = [3  3   3   1   1   1     0  0   0   0   0   0     0  0   0   0   0   0];
cuelist = find(cueweights > 0);

%Set trial timing. If no-saccade sets cue duration. If Choice sets delay
%duration. If irrelevant saccade sets both cue & delay duration.
times = [400];

%Set RF
x_RF = 6; %in degrees
y_RF = 6;

%Fixation pt +u/r
fix_x = 0; %in degrees
fix_y = 0;


%Target
t_file = 'T1';
tsize_x = 50; %in pixels
tsize_y = 50; %in pixels

%Cue
cue_gen1 = 'cue1Risk1';
cue_gen2 = 'cue2Risk1';
elem_sz = 15; %size of each individual element square, in pixels

%Placeholders (by convention, PH1 will always be at the target location.
%ph_file = 'PH1';
%ph_size_x = tsize_x; %in pixels
%ph_size_y = tsize_y;

%Reward timing beep
beep_dur = .4; %in seconds
beep_freq = 500; %in HZ

%Setup file name, open file
datev = datevec(date);
filen = strcat(timingfile,num2str(datev(1)),'_',num2str(datev(2)),'_',num2str(datev(3)),'.txt');
cfgn = strcat(timingfile,num2str(datev(1)),'_',num2str(datev(2)),'_',num2str(datev(3)),'_cfg.mat');

fid = fopen(filen,'w');
%Write the headers
generate_condition('FID',fid,'Header', 7);

%Setup the task objects

%Fixation Point
TaskObject(1).Type = 'Fix';
TaskObject(1).Arg{1} = fix_x;
TaskObject(1).Arg{2} = fix_y;

%Trial Gate TTL
TaskObject(2).Type = 'ttl';
TaskObject(2).Arg{1} = 1;

cond = 1;

for a = times
    for i = cuelist
        for j = [1 -1]
            for k = [1 -1]
                %Cue 1
                TaskObject(3).Type = 'gen';
                TaskObject(3).Arg{1} = cue_gen1;
                TaskObject(3).Arg{2} = k*x_RF;
                TaskObject(3).Arg{3} = k*y_RF;
                
                %Cue 2
                TaskObject(4).Type = 'gen';
                TaskObject(4).Arg{1} = cue_gen2;
                TaskObject(4).Arg{2} = -k*x_RF;
                TaskObject(4).Arg{3} = -k*y_RF;
                
                %Target
                TaskObject(5).Type = 'pic';
                TaskObject(5).Arg{1} = t_file;
                TaskObject(5).Arg{2} = j*x_RF;
                TaskObject(5).Arg{3} = j*y_RF;
                TaskObject(5).Arg{4} = tsize_x;
                TaskObject(5).Arg{5} = tsize_y;
               
                %Reward timing buzz
                TaskObject(6).Type = 'Snd';
                TaskObject(6).Arg{1} = 'sin';
                TaskObject(6).Arg{2} = beep_dur;
                TaskObject(6).Arg{3} = beep_freq;
                
                %Info
                Info.Stim1 = num2str(a);
                Info.Stim2 = cues{i,1}
                Info.Stim3 = cues{i,2}
                Info.Stim4 = num2str(elem_sz);
                
                generate_condition('Condition', cond, 'Block', 1, 'Frequency', cueweights(i), 'TimingFile', timingfile, 'Info', Info, 'TaskObject', TaskObject,'FID',fid);
                cond = cond + 1;
            end
        end
    end
end
fclose(fid);
copyfile(strcat(timingfile,'_cfg.mat'),cfgn)

