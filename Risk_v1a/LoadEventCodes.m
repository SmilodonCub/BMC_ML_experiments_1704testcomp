% List of Event Codes

disp('*****************************************************************');
disp('Loading Event Codes...');

TRIAL_START_CD     = 	1;		%Start Trial
FIX_ON_CD          = 	2;   	%Fixation ON
FIX_OFF_CD         = 	4;		%Fixation OFF
FIX_ACH_CD         = 	6;		%Fixation acquired
FIX_BREAK_CD       = 	7;		%Fixation break
FIX_FBR_CD         =    8;		%Fixation FakeBreak Eye is both in fixwindow and in target; used as "filler" in delsac.
%9 ML reserved; start trial x3
RBAR_ON_CD         = 	10;		%Right bar ON
RBAR_OFF_CD        = 	11;		%Right bar OFF
LBAR_ON_CD         = 	12;		%Left bar ON
LBAR_OFF_CD        = 	13;		%Left bar OFF
TARG_ACH_CD        = 	14;		%Target acquired
TAR_MISS_CD        = 	15;		%Target missed
TAR_BREAK_CD       = 	16;		%Target fixation break
MAX_RT_CD          = 	17;		%Max RT exceeded
%18 ML reserved; end trial x3
%TO2 is reserved for the TTL, which will give events 1 and 100.
%TO2_ON_CD          = 	19;		%Task Object 2 ON
%TO2_OFF_CD         = 	21;		%Task Object 2 OFF
CUE1_ON_CD          = 	19;		%Cue 1 ON
CUE1_OFF_CD         = 	20;		%Cue 1 OFF
TAR1_ON_CD          = 	21;		%Target 1 ON
TAR1_OFF_CD         = 	22;		%Target 1 OFF
DIS1_ON_CD          = 	23;		%Distractor 1 ON
DIS1_OFF_CD         = 	24;		%Distractor 1 OFF
CUE2_ON_CD          = 	25;		%Cue 2 ON
CUE2_OFF_CD         = 	26;		%Cue 2 ON
TAR2_ON_CD          = 	27;		%Target 2 ON
TAR2_OFF_CD         = 	28;		%Target 2 OFF
DIS2_ON_CD          = 	29;		%Distractor 2 ON
DIS2_OFF_CD         = 	30;		%Distractor 2 OFF
CUE3_ON_CD          = 	31;		%Cue 3 ON
CUE3_OFF_CD         = 	32;		%Cue 3 OFF
TAR3_ON_CD          = 	33;		%Target 3 ON
TAR3_OFF_CD         = 	34;		%Target 3 OFF
DIS3_ON_CD          = 	35;		%Distractor 3 ON
DIS3_OFF_CD         = 	36;		%Distractor 3 OFF
CUE4_ON_CD          = 	37;		%Cue 4 ON
CUE4_OFF_CD         = 	38;		%Cue 4 OFF
TAR4_ON_CD          = 	39;		%Target 4 ON
TAR4_OFF_CD         = 	40;		%Target 4 OFF
DIS4_ON_CD          = 	41;		%Distractor 4 ON
DIS4_OFF_CD         = 	42;		%Distractor 4 OFF
CUE5_ON_CD          = 	43;		%Cue 5 ON
CUE5_OFF_CD         = 	44;		%Cue 5 OFF
TAR5_ON_CD          = 	45;		%Target 5 ON
TAR5_OFF_CD         = 	46;		%Target 5 OFF
DIS5_ON_CD          = 	47;		%Distractor 5 ON
DIS5_OFF_CD         = 	48;		%Distractor 5 OFF
CUE6_ON_CD          = 	49;		%Cue 6 ON
CUE6_OFF_CD         = 	50;		%Cue 6 OFF
TAR6_ON_CD          = 	51;		%Target 6 ON
TAR6_OFF_CD         = 	52;		%Target 6 OFF
DIS6_ON_CD          = 	53;		%Distractor 6 ON
DIS6_OFF_CD         = 	54;		%Distractor 6 OFF
BUZZ_ON_CD          =   96;     %Buzz ON
BUZZ_OFF_CD         =   97;     %Buzz OFF
LICK_ON_CD          =	98;		%Lick ON
LICK_OFF_CD         = 	99;		%Lick OFF
TRIAL_END_CD        = 	100;	%End of trial


disp('--> Event Codes Loaded :-)');
disp('*****************************************************************');
