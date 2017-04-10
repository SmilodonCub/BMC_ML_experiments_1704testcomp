% List of Event Codes for specific_search_training

disp('*****************************************************************');
disp('Loading specific_search_training Event Codes...');

TRIAL_START     = 	1;		%Start Trial
FIX_ON          = 	2;   	%Fixation ON
FIX_OFF         = 	4;		%Fixation OFF
FIX_NOT         =    5;      %Fixation not aquired
FIX_ACH         = 	6;		%Fixation acquired
FIX_BREAK       = 	7;		%Fixation break
FIX_FBR         =    8;		%Fixation FakeBreak Eye is both in fixwindow and in target; used as "filler" in delsac.
%9 ML reserved; start trial x3
TAR_ON          =   10;     %Target on
TAR_OFF         =   11;     %Target off
TAR_NOT         =   12;     %Target not aquired
TARG_ACH        = 	14;		%Target acquired
TAR_MISS       = 	15;		%Target missed
TAR_BREAK       = 	16;		%Target fixation break
MAX_RT          = 	17;		%Max RT exceeded
%18 ML reserved; end trial x3
%TO2 is reserved for the TTL, which will give events 1 and 100.
T_ARRAY_ON         = 	21;		%Target array ON
T_ARRAY_OFF         = 	22;		%Target array OFF
T_ARRAY_NON         =   23;     %Target in Array not aquired
T_ARRAY_MISS        =   24;     %Target in Array Missed
T_ARRAY_BREAK       =   25;     %Target in Array not held sufficiently long
T_ARRAY_ACH         =   26;     %Target in Array acquired & held sifficiently long
BUZZ_ON          =   96;     %Buzz ON
BUZZ_OFF         =   97;     %Buzz OFF
LICK_ON          =	98;		%Lick ON
LICK_OFF         = 	99;		%Lick OFF
TRIAL_END        = 	100;	%End of trial


disp('--> Event Codes Loaded :-)');
disp('*****************************************************************');
