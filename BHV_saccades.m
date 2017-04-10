%clear all, close all, clc
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


global ETparams
%--------------------------------------------------------------------------
% Read behavioral file & pull relevent analog data to ETdata struct
%--------------------------------------------------------------------------

%read a BHV file
BHV = bhv_read();

%to look at all trials
% num_trials = size(BHV.AnalogData, 2);
% for i = 1:num_trials
%     ETdata(i).X = BHV.AnalogData{i}.EyeSignal(:,1)';
%     ETdata(i).Y = BHV.AnalogData{i}.EyeSignal(:,2)';
% end
 

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
ETparams.screenSz = [1024 768];
ETparams.screenDim = [0.4064 0.3048];
ETparams.viewingDist = 0.32;
ETparams.samplingFreq = 1000;
ETparams.blinkVelocityThreshold = 1000;           % if vel > 1000 degrees/s, it is noise or blinks
ETparams.blinkAccThreshold = 100000;             % if acc > 100000 degrees/s^2, it is noise or blinks
ETparams.peakDetectionThreshold = 100;              % Initial value of the peak detection threshold. 
ETparams.minFixDur = 0.01; % in seconds
ETparams.minSaccadeDur = 0.010; % in seconds


%--------------------------------------------------------------------------
% Process eye-movement data from BHV file
%--------------------------------------------------------------------------
%event detection algorithm accompanying the article
%Nyström, M. & Holmqvist, K., 
%"An adaptive algorithm for fixation, saccade, and glissade detection in eye-tracking data". 
%Behavior Research Methods
%source code can be found: http://www.humlab.lu.se/en/person/MarcusNystrom
 
eventDetection

%--------------------------------------------------------------------------
% Look at trial by trial saccades
%--------------------------------------------------------------------------

for i = 1:num_correct
     figure(1); 
     plot(ETparams.data(i).velOrg) %(1:size(ETparams.data(i),2)),
     hold on
     plot(ETparams.data(i).vel, 'Color', 'r', 'LineWidth', 2)
     for ii = 1:size(ETparams.saccadeInfo,3)
         if ETparams.saccadeInfo(1,i,ii).start ~= 0,
              line([( ETparams.saccadeInfo(1,i,ii).start*1000)...
                  ( ETparams.saccadeInfo(1,i,ii).start*1000)], ...
                  [0 60], 'Color', [0 1 0], 'LineWidth', 2)
              line([( ETparams.saccadeInfo(1,i,ii).end*1000)...
                  ( ETparams.saccadeInfo(1,i,ii).end*1000)], ...
                  [0 60], 'Color', [0 1 0], 'LineWidth', 2)
         end
     end
     axis([ 0 2500 0 100 ]);
     pause(0.5)
     clf
end

% for i = 1:num_correct
%      figure(1); 
%      plot((ETparams.data(i).fixTime-100):ETparams.data(i).targetTime,...
%          ETparams.data(i).vel)
%      hold on
%      for ii = 1:size(ETparams.saccadeInfo,3)
%          if ETparams.saccadeInfo(1,i,ii).start
%               line([( ETparams.saccadeInfo(1,i,ii).start*1000+ETparams.data(i).fixTime-100)...
%                   ( ETparams.saccadeInfo(1,i,ii).start*1000+ETparams.data(i).fixTime-100)], ...
%                   [0 60], 'Color', [0 1 0])
%               line([( ETparams.saccadeInfo(1,i,ii).end*1000+ETparams.data(i).fixTime-100)...
%                   ( ETparams.saccadeInfo(1,i,ii).end*1000+ETparams.data(i).fixTime-100)], ...
%                   [0 60], 'Color', [0 1 0])
%          end
%      end
%      axis([ 0 3000 0 80 ]);
%      pause(0.5)
%      clf
% end

%--------------------------------------------------------------------------
% Object fixation vector
%--------------------------------------------------------------------------

%for each detected saccade
%  get the x,y position info
%  is the position in a task object?
%     if yes:
%        
