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

%pick a behavioral file to read manually:
BHV = bhv_read();

%   link to all teh infos on MonkeyLogic .bhv files:
%   http://www.brown.edu/Research/monkeylogic/behavioraldata.html
%   i find the descriptions are a little vague unless you are familiar with
%   all the task components

%   BHV.MagicNUmber <-> BHV.ScreenBackgroundColor are, for the most part, the
%   field population of the MonkeyLogic mainmenu and are also stored in the
%   configuration file that supported that particular run of trials

%   BHV.Stimuli stores all the images used. Movies were stored for the .bhv
%   files I included. one could recreate the trial with this info +
%   BHV.AnalogData, or this might be easier:

%   > pick a .bhv to view the behavioral summary
behavioralsummary
%   > pick a trial by clicking on a trial number in either the upper
%   summary graph or lower left hand panel.
%   > timeline will show all task relevant stimuli & x/y eye position
%   > play will show a movie of the trial, however the background for some
%   reason doesn't reference the background color used in the task &
%   defaults to black. this requires a slight change to the monkeylogic 
%   behaviorsummary function. you can then make & save movies of the trials
%   from the summary window.
%   3 ISSUES: 1)just noticed something looks messed up with the Reation Time
%   plot & I need to think about that. 2)there is an odd black box that
%   appears just below fixation in the stimulus window of the
%   behavioralsummary plot....don't know why because it doesn't appear in
%   the display screen(s). 3)the behavioralsummary & timeline displays are
%   not using the correct labels for the eventmarkers, although the numbers
%   are correct

%BHV.TrialError 
%   each trial is given 1 TrialError number e.g. 0 == Correct, 3 = Break
%   Fixation ... these are all defined by MonkeyLogic (see
%   http://www.brown.edu/Research/monkeylogic/timingscripts.html#trialerrors)
%   and asigned in the timing file
%   TrialError is a good way to parse out all correct trials
correct_trials = find(BHV.TrialError==0);
num_correct = length(correct_trials);

%   BHV.AnalogData.EyeSignal holds the analog data aquired for each trial

%   BHV.ReactionTime  At the moment, ReactionTime is the moment the subject
%   breaks fixation (after the initial hold fixation time). this is set in the
%   task timing file using the EyeJoyTrack fxn. Have to have a think if this
%   is the best way to define reaction time for this task ( maybe it should be
%   the moment the bear is first fixated?


%   event markers
%   BHV.CodeNumbers/Times give the eventmarkers used during each trial & the
%   timestamps. eventmarkers are specified in the task timing file & there can
%   be as many as the user asigns & different ones/amounts across trials
%   more on eventmarkers: http://www.brown.edu/Research/monkeylogic/timingscripts.html#eventmarker

%   BHV.VariableChanges
%   variables that can be changed before/during a task from the default value
%   defined in the timing file are handled by the editable fxn. whenever
%   changes are made, they will be reflected w/ the trial#'s that the change
%   applies to & the values.
%   for instance, for the search task I generally start with a target hold
%   time of 600-500ms. however, if the subject is loosing motivation, I might
%   lower the time to, say, 250ms just to keep the gears turning. The BHV
%   field VariableChanges is a good way to parse through trials for a specific
%   setting for any 'editable' variable.
%   1 ISSUE: the reward_dur is not used for any of my MonkeLogic tasks & I
%   cannot for the life of me figure out where to change this to reflect the
%   actual reward given during a task (right now it's defined in the timing
%   file)