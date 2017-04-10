% List of Event Codes for Landolt_C

disp('*****************************************************************');
disp('Loading Landolt_C Event Codes...');

TRIAL_START_LC     = 	1;		%Start Trial
FIX_ON_LC          = 	2;   	%Fixation ON
FIX_OFF_LC         = 	4;		%Fixation OFF
FIX_NOT_LC         =    5;      %Fixation not aquired
FIX_ACH_LC         = 	6;		%Fixation acquired
FIX_BREAK_LC       = 	7;		%Fixation break
FIX_FBR_LC         =    8;		%Fixation FakeBreak Eye is both in fixwindow and in target; used as "filler" in delsac.
%9 ML reserved; start trial x3
CUE_ON_LC           =   10;     %LC Cue On
CUE_OFF_LC          =   11;     %LC Cue Off
CUE_MISS_LC         =   12;     %LC Cue missed
CUE_BREAK_LC        =   13;     %LC Cue fixation broken
CUE_ACH_LC        = 	14;		%Target acquired
%18 ML reserved; end trial x3
%TO2 is reserved for the TTL, which will give events 1 and 100.
MAX_RT_LC          = 	17;		%Max RT exceeded
T_ARRAY_ON_LC          = 	21;		%Target  ON
T_ARRAY_OFF_LC         = 	22;		%Target OFF
T_ARRAY_MISS_LC        =    23;     %Target array missed 
T_ARRAY_BREAK_LC       =    24;     %Target array 
TARGET_ACH_LC          =    25;     %Target met 
BUZZ_ON_LC          =   96;     %Buzz ON
BUZZ_OFF_LC         =   97;     %Buzz OFF
LICK_ON_LC          =	98;		%Lick ON
LICK_OFF_LC         = 	99;		%Lick OFF
TRIAL_END_LC        = 	100;	%End of trial


disp('--> Event Codes Loaded :-)');
disp('*****************************************************************');
