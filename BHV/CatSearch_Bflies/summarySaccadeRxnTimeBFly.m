numStd = 4;

scrsz = get(0,'ScreenSize');
fig = figure('Position',[1 scrsz(4)/8 scrsz(3)*7/8 scrsz(4)/2]);

saccadeInfoDataLabels = {'Cued', 'Uncued', 'Interleaved'};

for mm = 1:size(saccadeInfoDataBFly,2)

xvals = unique(saccadeInfoDataBFly{mm}.saccadeInfo(:,9));
saccadeBySet = zeros(length(xvals),4);


for nn = 1:length(xvals)
    bearSacRxnT = cat(1, saccadeInfoDataBFly{mm}.saccadeInfo(~isnan(saccadeInfoDataBFly{mm}.saccadeInfo(:,1))...
        & saccadeInfoDataBFly{mm}.saccadeInfo(:,9) == xvals(nn),1),...
        saccadeInfoDataBFly{mm}.saccadeInfo(~isnan(saccadeInfoDataBFly{mm}.saccadeInfo(:,2))...
        & saccadeInfoDataBFly{mm}.saccadeInfo(:,9) == xvals(nn),2));
    saccadeBySet(nn,1) = mean(bearSacRxnT);
    saccadeBySet(nn,2) = std(bearSacRxnT);
    bearSacRxnT(bearSacRxnT>=(saccadeBySet(nn,1) + numStd*saccadeBySet(nn,2))) = NaN;
    saccadeBySet(nn,1) = nanmean(bearSacRxnT);
    saccadeBySet(nn,2) = nanstd(bearSacRxnT)/sqrt(length(bearSacRxnT));
    NObearSacRxnT = cat(1, saccadeInfoDataBFly{mm}.saccadeInfo(~isnan(saccadeInfoDataBFly{mm}.saccadeInfo(:,4))...
        & saccadeInfoDataBFly{mm}.saccadeInfo(:,9) == xvals(nn),4),...
        saccadeInfoDataBFly{mm}.saccadeInfo(~isnan(saccadeInfoDataBFly{mm}.saccadeInfo(:,5))...
        & saccadeInfoDataBFly{mm}.saccadeInfo(:,9) == xvals(nn),5));
    saccadeBySet(nn,3) = mean(NObearSacRxnT);
    saccadeBySet(nn,4) = std(NObearSacRxnT);
    NObearSacRxnT(NObearSacRxnT>=(saccadeBySet(nn,3) + numStd*saccadeBySet(nn,4))) = NaN;
    saccadeBySet(nn,3) = nanmean(NObearSacRxnT);
    saccadeBySet(nn,4) = nanstd(NObearSacRxnT)/sqrt(length(NObearSacRxnT));
    ttest2(bearSacRxnT,NObearSacRxnT, 0.01, 'both', 'unequal')  %h = ttest2(x,y,alpha,tail,vartype)
end

subp = subplot(1,3,mm);
% s1 = scatter(saccadeInfoData{mm}.saccadeInfo((saccadeInfoData{mm}.saccadeInfo(:,1) > 0),9)-0.3,...
%     saccadeInfoData{mm}.saccadeInfo((saccadeInfoData{mm}.saccadeInfo(:,1) > 0),1),'ob');
% hold on
% s2 = scatter(saccadeInfoData{mm}.saccadeInfo((saccadeInfoData{mm}.saccadeInfo(:,2) > 0),9)-0.15,...
%     saccadeInfoData{mm}.saccadeInfo((saccadeInfoData{mm}.saccadeInfo(:,2) > 0),2), 'oc');
% s3 = scatter(saccadeInfoData{mm}.saccadeInfo((saccadeInfoData{mm}.saccadeInfo(:,4) > 0),9)+0.3,...
%     saccadeInfoData{mm}.saccadeInfo((saccadeInfoData{mm}.saccadeInfo(:,4) > 0),4), 'or');
% s4 = scatter(saccadeInfoData{mm}.saccadeInfo((saccadeInfoData{mm}.saccadeInfo(:,5) > 0),9)+0.15,...
%     saccadeInfoData{mm}.saccadeInfo((saccadeInfoData{mm}.saccadeInfo(:,5) > 0),5), 'om');
e1 = errorbar(xvals, saccadeBySet(:,1), saccadeBySet(:,2), 'sk','MarkerSize', 15,'LineWidth',1.5);
hold on
e2 = errorbar(xvals, saccadeBySet(:,3), saccadeBySet(:,4), '^k','MarkerSize', 15,'LineWidth',1.5);
%legend('B imm fix', 'B multi fix', 'NoB imm fix', 'NoB multi fix', 'Location', 'BestOutside')
title(saccadeInfoDataLabels{mm}, 'FontSize', 15)
xlim([0 10])
ylim([0 1200])
subpPos = get( subp, 'Position');
set( subp, 'Position', [subpPos(1) subpPos(2) subpPos(3) subpPos(4)-0.1 ] )
if mm == 3
%     legend( [ s1 s3 e1 e2 ], 'Target Present (TP)', 'Target Absent (TA)',...
%         'TP Mean', 'TA Mean', 'Location', 'NorthWest')
    legend( [ e1 e2 ],...
        'TP Mean', 'TA Mean', 'Location', 'NorthEast')
    legend boxoff
end

end

titleAxes = axes('Position', [0 0 1 1]);
text(0.4, 0.95, 'BFlies: Effect of Set size on Rxn Time','FontSize',20)
text(0.5, 0.05, 'Set Size','FontSize',15)
text(0.09,0.25, 'Saccade Reaction Time (msec)', 'Rotation', 90,'FontSize', 15)
box off
axis off

tightfig(fig)

%% immediate saccade
fig2 = figure('Position',[1 scrsz(4)/8 scrsz(3)*7/8 scrsz(4)/2]);

for mm = 1:size(saccadeInfoDataBFly,2)

xvals = unique(saccadeInfoDataBFly{mm}.saccadeInfo(:,9));
imsaccadeBySet = zeros(length(xvals),4);

for nn = 1:length(xvals)
    imbearSacRxnT = saccadeInfoDataBFly{mm}.saccadeInfo(~isnan(saccadeInfoDataBFly{mm}.saccadeInfo(:,1))...
        & saccadeInfoDataBFly{mm}.saccadeInfo(:,9) == xvals(nn),1);
    imsaccadeBySet(nn,1) = mean(imbearSacRxnT);
    imsaccadeBySet(nn,2) = std(imbearSacRxnT);
    imbearSacRxnT(imbearSacRxnT>=(imsaccadeBySet(nn,1) + numStd*imsaccadeBySet(nn,2))) = NaN;
    imsaccadeBySet(nn,1) = nanmean(imbearSacRxnT);
    imsaccadeBySet(nn,2) = nanstd(imbearSacRxnT)/sqrt(length(imbearSacRxnT));
    imNObearSacRxnT = saccadeInfoDataBFly{mm}.saccadeInfo(~isnan(saccadeInfoDataBFly{mm}.saccadeInfo(:,4))...
        & saccadeInfoDataBFly{mm}.saccadeInfo(:,9) == xvals(nn),4);
    imsaccadeBySet(nn,3) = mean(imNObearSacRxnT);
    imsaccadeBySet(nn,4) = std(imNObearSacRxnT);
    imNObearSacRxnT(imNObearSacRxnT>=(imsaccadeBySet(nn,3) + numStd*imsaccadeBySet(nn,4))) = NaN;
    imsaccadeBySet(nn,3) = nanmean(imNObearSacRxnT);
    imsaccadeBySet(nn,4) = nanstd(imNObearSacRxnT)/sqrt(length(imNObearSacRxnT));
    ttest2(imbearSacRxnT,imNObearSacRxnT, 0.01, 'both', 'unequal')  %h = ttest2(x,y,alpha,tail,vartype)
end

subp = subplot(1,3,mm);
% s1 = scatter(saccadeInfoData{mm}.saccadeInfo((saccadeInfoData{mm}.saccadeInfo(:,1) > 0),9)-0.25,...
%     saccadeInfoData{mm}.saccadeInfo((saccadeInfoData{mm}.saccadeInfo(:,1) > 0),1),'ob');
% hold on
% s3 = scatter(saccadeInfoData{mm}.saccadeInfo((saccadeInfoData{mm}.saccadeInfo(:,4) > 0),9)+0.25,...
%     saccadeInfoData{mm}.saccadeInfo((saccadeInfoData{mm}.saccadeInfo(:,4) > 0),4), 'or');
e1 = errorbar(xvals, imsaccadeBySet(:,1), imsaccadeBySet(:,2), 'sk','MarkerSize', 15,'LineWidth',1.5);
hold on
e2 = errorbar(xvals, imsaccadeBySet(:,3), imsaccadeBySet(:,4), '^k','MarkerSize', 15,'LineWidth',1.5);
%legend('B imm fix', 'B multi fix', 'NoB imm fix', 'NoB multi fix', 'Location', 'BestOutside')
title(saccadeInfoDataLabels{mm}, 'FontSize', 15)
xlim([0 10])
ylim([100 600])
subpPos = get( subp, 'Position');
set( subp, 'Position', [subpPos(1) subpPos(2) subpPos(3) subpPos(4)-0.1 ] )
if mm == 3
    legend( [ e1 e2 ],...
        'TP Mean', 'TA Mean', 'Location', 'NorthEast')
    legend boxoff
end

end

titleAxes = axes('Position', [0 0 1 1]);
text(0.4, 0.95, 'BFlies: Immediate Fixation Rxn Times','FontSize',20)
text(0.5, 0.05, 'Set Size','FontSize',15)
text(0.09,0.25, 'Saccade Reaction Time (msec)', 'Rotation', 90,'FontSize', 15)
box off
axis off


%% ratio immediate saccades to multiple fixations
fig3 = figure('Position',[1 scrsz(4)/8 scrsz(3)*7/8 scrsz(4)/2]);
for mm = 1:size(saccadeInfoDataBFly,2)

xvals = unique(saccadeInfoDataBFly{mm}.saccadeInfo(:,9));
saccadeBySetLength = zeros(length(xvals),6);


for nn = 1:length(xvals)
    imbearSacRxnT = saccadeInfoDataBFly{mm}.saccadeInfo(~isnan(saccadeInfoDataBFly{mm}.saccadeInfo(:,1))...
        & saccadeInfoDataBFly{mm}.saccadeInfo(:,9) == xvals(nn),1);
    saccadeBySetLength(nn,1) = length(imbearSacRxnT);
    imNObearSacRxnT = saccadeInfoDataBFly{mm}.saccadeInfo(~isnan(saccadeInfoDataBFly{mm}.saccadeInfo(:,4))...
        & saccadeInfoDataBFly{mm}.saccadeInfo(:,9) == xvals(nn),4);
    saccadeBySetLength(nn,2) = length(imNObearSacRxnT);
    multibearSacRxnT = saccadeInfoDataBFly{mm}.saccadeInfo(~isnan(saccadeInfoDataBFly{mm}.saccadeInfo(:,2))...
        & saccadeInfoDataBFly{mm}.saccadeInfo(:,9) == xvals(nn),2);
    saccadeBySetLength(nn,3) = length(multibearSacRxnT);
    multiNObearSacRxnT = saccadeInfoDataBFly{mm}.saccadeInfo(~isnan(saccadeInfoDataBFly{mm}.saccadeInfo(:,5))...
        & saccadeInfoDataBFly{mm}.saccadeInfo(:,9) == xvals(nn),5);
    saccadeBySetLength(nn,4) = length(multiNObearSacRxnT);
    saccadeBySetLength(nn,5) = saccadeBySetLength(nn,1)/(saccadeBySetLength(nn,1)+saccadeBySetLength(nn,3));
    saccadeBySetLength(nn,6) = saccadeBySetLength(nn,2)/(saccadeBySetLength(nn,2)+saccadeBySetLength(nn,4));
end


subRatio = subplot(1,3,mm);
bar(xvals,saccadeBySetLength(:,5:6)*100,'grouped')
%legend('B imm fix', 'B multi fix', 'NoB imm fix', 'NoB multi fix', 'Location', 'BestOutside')
title(saccadeInfoDataLabels{mm}, 'FontSize', 15)
xlim([0 10])
ylim([0 100])
subRatioPos = get( subRatio, 'Position');
set( subRatio, 'Position', [subRatioPos(1) subRatioPos(2) subRatioPos(3) subRatioPos(4)-0.1 ] )
% if mm == 3
%     legend( [ s1 s3 e1 e2 ], 'Target Present (TP)', 'Target Absent (TA)',...
%         'TP Mean', 'TA Mean', 'Location', 'NorthWest')
%     legend boxoff
% end

end

titleAxes = axes('Position', [0 0 1 1]);
text(0.35, 0.95, 'BFlies: Percent of Correct Immediate Fixation Trials','FontSize',20)
text(0.5, 0.05, 'Set Size','FontSize',15)
text(0.09,0.25, 'Immediate Fixations (%)', 'Rotation', 90,'FontSize', 15)
box off
axis off
