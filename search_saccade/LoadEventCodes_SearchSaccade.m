% List of Event Codes

disp('*****************************************************************');
disp('Loading SearchSaccade Event Codes...');

TRIAL_START_SS     = 	1;		%Start Trial
FIX_ON_SS          = 	2;   	%Fixation ON
FIX_OFF_SS         = 	4;		%Fixation OFF
FIX_NOT_SS         =    5;      %Fixation not aquired
FIX_ACH_SS         = 	6;		%Fixation acquired
FIX_BREAK_SS       = 	7;		%Fixation break
FIX_FBR_SS         =    8;		%Fixation FakeBreak Eye is both in fixwindow and in target; used as "filler" in delsac.
%9 ML reserved; start trial x3
TARG_ACH_SS        = 	14;		%Target acquired
TAR_MISS_SS        = 	15;		%Target missed
TAR_BREAK_SS       = 	16;		%Target fixation break
MAX_RT_SS          = 	17;		%Max RT exceeded
%18 ML reserved; end trial x3
%TO2 is reserved for the TTL, which will give events 1 and 100.
T_ARRAY_ON_SS          = 	21;		%Target 1 ON
T_ARRAY_OFF_SS         = 	22;		%Target 1 OFF
BUZZ_ON_SS          =   96;     %Buzz ON
BUZZ_OFF_SS         =   97;     %Buzz OFF
LICK_ON_SS          =	98;		%Lick ON
LICK_OFF_SS         = 	99;		%Lick OFF
TRIAL_END_SS        = 	100;	%End of trial


disp('--> Event Codes Loaded :-)');
disp('*****************************************************************');
