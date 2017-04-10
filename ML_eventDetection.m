function [ saccade_test ] = ML_eventDetection( data, screen_size, screen_dimentions, ...
    viewing_distance, blinkVelocityThreshold, blinkAccThreshold, peakDetectionThreshold,...
    minFixDur, minSaccadeDur )
%ML_eventDetection pass parameters to Adaptive Event Detection fxns to
%detect saccades in-line of data collection for ML tasks where 

%--------------------------------------------------------------------------
% 
%--------------------------------------------------------------------------

global ETparams

%--------------------------------------------------------------------------
% Init parameters
%--------------------------------------------------------------------------


ETparams.data = data;
ETparams.screenSz = screen_size;
ETparams.screenDim = screen_dimentions;
ETparams.viewingDist = viewing_distance;
ETparams.samplingFreq = sampling_frequency;
ETparams.blinkVelocityThreshold = blinkVelocityThreshold;             % if vel > 1000 degrees/s, it is noise or blinks
ETparams.blinkAccThreshold = blinkAccThreshold;               % if acc > 100000 degrees/s^2, it is noise or blinks
ETparams.peakDetectionThreshold = peakDetectionThreshold;              % Initial value of the peak detection threshold. 
ETparams.minFixDur = minFixDur; % in seconds
ETparams.minSaccadeDur = minSaccadeDur; % in seconds

%--------------------------------------------------------------------------
% Begin detection
%--------------------------------------------------------------------------

% Process data 
%use just the detectSaccade?
eventDetection

saccade_test = find(ETparams.data ~= 0);


end

