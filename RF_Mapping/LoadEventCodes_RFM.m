% List of Event Codes

disp('*****************************************************************');
disp('Loading RFM Event Codes...');

TRIAL_START_RFM     = 	1;		%Start Trial
FIX_ON_RFM          = 	2;   	%Fixation ON
FIX_OFF_RFM         = 	4;		%Fixation OFF
FIX_NOT_RFM         =    5;      %Fixation not aquired
FIX_ACH_RFM         = 	6;		%Fixation acquired
FIX_BREAK_RFM       = 	7;		%Fixation break
FIX_FBR_RFM         =    8;		%Fixation FakeBreak Eye is both in fixwindow and in target; used as "filler" in delsac.
%9 ML reserved; start trial x3
TARG_ACH_RFM        = 	14;		%Target acquired
TAR_MISS_RFM        = 	15;		%Target missed
TAR_BREAK_RFM       = 	16;		%Target fixation break
MAX_RT_RFM          = 	17;		%Max RT exceeded
%18 ML reserved; end trial x3
%TO2 is reserved for the TTL, which will give events 1 and 100.
TARG_ON_RFM          = 	21;		%Target  ON
TARG_OFF_RFM         = 	22;		%Target OFF
BUZZ_ON_RFM          =   96;     %Buzz ON
BUZZ_OFF_RFM         =   97;     %Buzz OFF
LICK_ON_RFM          =	98;		%Lick ON
LICK_OFF_RFM         = 	99;		%Lick OFF
TRIAL_END_RFM        = 	100;	%End of trial


disp('--> Event Codes Loaded :-)');
disp('*****************************************************************');
