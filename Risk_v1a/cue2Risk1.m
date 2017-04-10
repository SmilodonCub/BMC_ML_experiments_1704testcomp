function out = genMon2(TrialRecord)

%x = xi;
%y = yi;
sqs = str2num(TrialRecord.CurrentConditionInfo.Stim4);
%sqs = 10
sz = [3*sqs, sqs];

rgb = [0.13220,0.79862+.021,0.40873;% Green
    0.76851+.001,0.70803,0.16674;%Yellow
    0.96489+.02,0.51984,0.86063+.02;%Purple
    0.43120,0.665092+.08,0.91589+.075;%Blue
    0.66419+.035,0.66978+.04,0.66453+.04;%Gray
    0,0,0];%Black
stim  = TrialRecord.CurrentConditionInfo.Stim3;
%stim = 'B6L'
colors = 4*ones(1,11);
switch stim
    case {'F6'}
        colors(6) = 1;
    case {'B6L'}
        colors(5) = 1;
        colors(7) = 2;
    case {'B6H'}
        colors(4) = 1;
        colors(8) = 2;
    case {'F9'}
        colors(9) = 1;
    case {'B9L'}
        colors(8) = 1;
        colors(10) = 2;
    case {'B9H'}
        colors(7) = 1;
        colors(11) = 2;
    case {'F3'}
        colors(3) = 1;
    case {'B3L'}
        colors(2) = 1;
        colors(4) = 2;
    case {'B3H'}
        colors(1) = 1;
        colors(5) = 2;
    case {'NULL'}
        colors = 6*ones(1,11);
    otherwise
        colors = 1*ones(1,11);
end

sqr = [];
for level = fliplr(1:11)
    next = makesquare2(sz,rgb(colors(level),:),1);
    sqr = [sqr; next];
end

imwrite(sqr,strcat(stim,'low.bmp'))

out = sqr;
info = stim;
