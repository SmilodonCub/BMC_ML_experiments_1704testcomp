%learnedTargetFigure


learnedTargets_TBear = { 'TBear_110R_crop_8000';
    'TBear_129R_crop_8000';
    'TBear_142R_crop_8000';
    'TBear_146R_crop_8000';
    'TBear_165R_crop_8000';
    'TBear_194R_crop_8000';
    'TBear_20R_crop_8000';
    'TBear_212R_crop_8000';
    'TBear_36R_crop_8000';
    'TBear_63R_crop_8000' };

learnedTargets_BFly = { 'TBFly_actiaslu';
    'TBFly_aneamart';
    'TBFly_argyreus';
    'TBFly_butrflyb';
    'TBFly_butter13';
    'TBFly_butter20';
    'TBFly_butter22';
    'TBFly_butter25';
    'TBFly_butter42';
    'TBFly_butter48'};

randomDistractors1 = {'DBFly_wheelc34';
    'DBFly_pancake4';
    'DBFly_banana6';
    'DBFly_skigoggl';
    'DBFly_box5';
    'DBFly_fotsto23';
    'DBFly_bupes8';
    'DBFly_girldol8';
    'DBFly_doll2';
    'DBFly_doll36'};

randomDistractors2 = {'DBear_coffper9';
    'DBear_fan39';
    'DBear_cushio91';
    'DBear_sagrabuq';
    'DBear_turkey10';
    'DBear_powedcas';
    'DBear_antcar48';
    'DBear_endtab33';
    'DBear_lincart3';
    'DBear_spacehe2'};

learnedTargets = cat(2, learnedTargets_TBear, learnedTargets_BFly);
learnedTargetsandDistractors = cat(2,learnedTargets_TBear, learnedTargets_BFly, randomDistractors1, randomDistractors2)';
catLabel = {'Teddy Bear','Butterfly'};

%%

for bbb = 1:size(learnedTargets,2)
    scrsz = get(0,'ScreenSize');
    fig = figure('Position',[1 scrsz(4)/8 scrsz(3)*3/4 scrsz(4)/2]);
    
    for bb = 1:size(learnedTargets,1)
        subp = subplot( 2, 5, bb );
        targetname_split = regexp(learnedTargets{ bb,bbb }, '_', 'split');
        targetImageName = targetname_split(2);
        pos = get( subp, 'Position' );
        %targetLabel = [ targetname_split{2} '\_' targetname_split{3} '\_' targetname_split{4} ];
        hold on
        imname = [ learnedTargets{ bb,bbb } '.bmp' ];
        im=imread( imname );
        imshow( im )
        targetLabelAxes = axes('Position', [ pos(1) pos(2) pos(3) pos(4)/3 ] );
        %text( 0.15, 0.5, targetImageName )
        box off
        axis off
    end
    
    titleax = axes('Position', [ 0.43 0.9 0.5 0.1 ]);
    headertitle = ['Learned ' catLabel{bbb} ' Target Set'];
    text( 0, 0.9, headertitle , 'FontSize', 20)
    box off
    axis off
    
    tightfig( fig )
end

%%

num_rows = 4;
num_cols = 8;

scrsz2 = get(0,'ScreenSize');
fig = figure('Position',[1 scrsz2(4)/8 scrsz2(3) scrsz2(4)*7/8]);





for bb = 1:num_cols
    subplot( num_rows, num_cols, bb );
    targetname_split = regexp(learnedTargetsandDistractors{ 1,bb }, '_', 'split');
    targetImageName = targetname_split(2);
    %pos = get( subp, 'Position' );
    %targetLabel = [ targetname_split{2} '\_' targetname_split{3} '\_' targetname_split{4} ];
    imname = [ learnedTargetsandDistractors{ 1,bb } '.bmp' ];
    im=imread( imname );
    imshow( im )
    hold on
    %targetLabelAxes = axes('Position', [ pos(1) pos(2) pos(3) pos(4)/3 ] );
    %text( 0.15, 0.5, targetImageName )
    box off
    axis off
end

a = 1;
for bbb = 9:8+num_cols
    subplot( num_rows, num_cols, bbb );
    targetname_split = regexp(learnedTargetsandDistractors{ 2,a }, '_', 'split');
    targetImageName = targetname_split(2);
    %pos = get( subp, 'Position' );
    %targetLabel = [ targetname_split{2} '\_' targetname_split{3} '\_' targetname_split{4} ];
    imname = [ learnedTargetsandDistractors{ 2,a } '.bmp' ];
    im=imread( imname );
    imshow( im )
    hold on
    %targetLabelAxes = axes('Position', [ pos(1) pos(2) pos(3) pos(4)/3 ] );
    %text( 0.15, 0.5, targetImageName )
    box off
    axis off
    a = a+1;
end

c = 1;
for bbb = 17:16+num_cols
    subplot( num_rows, num_cols, bbb );
    targetname_split = regexp(learnedTargetsandDistractors{ 3,c }, '_', 'split');
    targetImageName = targetname_split(2);
    %pos = get( subp, 'Position' );
    %targetLabel = [ targetname_split{2} '\_' targetname_split{3} '\_' targetname_split{4} ];
    imname = [ learnedTargetsandDistractors{ 3,c } '.bmp' ];
    im=imread( imname );
    imshow( im )
    hold on
    %targetLabelAxes = axes('Position', [ pos(1) pos(2) pos(3) pos(4)/3 ] );
    %text( 0.15, 0.5, targetImageName )
    box off
    axis off
    c = c+1;
end

% d = 1;
% for bbb = 19:18+num_cols
%     subplot( num_rows, num_cols, bbb );
%     targetname_split = regexp(learnedTargetsandDistractors{ 4,d }, '_', 'split');
%     targetImageName = targetname_split(2);
%     %pos = get( subp, 'Position' );
%     %targetLabel = [ targetname_split{2} '\_' targetname_split{3} '\_' targetname_split{4} ];
%     imname = [ learnedTargetsandDistractors{ 4,d } '.bmp' ];
%     im=imread( imname );
%     imshow( im )
%     hold on
%     %targetLabelAxes = axes('Position', [ pos(1) pos(2) pos(3) pos(4)/3 ] );
%     %text( 0.15, 0.5, targetImageName )
%     box off
%     axis off
%     d = d+1;
% end

titleax = axes('Position', [ 0.43 0.9 0.5 0.1 ]);
%headertitle = ['Learned ' catLabel{bbb} ' Target Set'];
%text( 0, 0.9, headertitle , 'FontSize', 20)
box off
axis off

tightfig(fig)

