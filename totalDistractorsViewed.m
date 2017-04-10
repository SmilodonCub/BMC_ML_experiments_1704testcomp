%find the total across multiple BHV viewedDistractor totals

numMostDistracting = 40;
mostDistracting = cell(1, numMostDistracting);
%imsize = zeros(157,168,3);

%% 
totalviewedDistractorsBFly = zeros(1,size(viewedDistractorsBFly{1}.distMap,1));
totalPresentedDistractors = zeros(1,size(viewedDistractorsBFly{1}.arrayMap,1));

for aa = 1 : size(viewedDistractorsBFly,2)
    newVals = cell2mat( values ( viewedDistractorsBFly{aa}.distMap ) );
    totalviewedDistractorsBFly = totalviewedDistractorsBFly + newVals;
    newArrayVals = cell2mat( values ( viewedDistractorsBFly{aa}.arrayMap ) );
    totalPresentedDistractors = totalPresentedDistractors + newArrayVals;
end

normalizedViewedDistractor = 100*totalviewedDistractorsBFly./totalPresentedDistractors;

%%

keySet =   D;
valueSet = totalviewedDistractorsBFly;
totalDistractorsMapObj = containers.Map(keySet,valueSet);

%%

[ sums, sumsIDX ] = sort( normalizedViewedDistractor,'ascend' );

scrsz = get(0,'ScreenSize');
fig = figure('Position',[1 scrsz(4)/8 scrsz(3)*3/4 scrsz(4)*3/4]);

for bb = 1:numMostDistracting
%     disp( D( sumsIDX( bb ) ) )
%     disp( sums( bb ) )
    subplot( 5, 8, bb )
    targetImageTag = D( sumsIDX( bb ) );
    charTargetImageTag = char( targetImageTag );
    targetImageName = charTargetImageTag(3:(end-4));
    percentStr = num2str(sprintf('%.1f',sums(bb)));
    title( [targetImageName '  ' percentStr '%'] )
    hold on
    im=imread( char( targetImageTag ) );
    imshow( im )
end

titleaxes = axes('Position', [ 0.05 0.15 0.05 0.5 ] );
text( 0.5, 0, 'Most likely to be Viewed', 'Rotation', 90, 'FontName', 'Comic Sans MS', 'FontSize', 30, 'Color', 'r' )
box off
axis off

tightfig( fig )

%%

descendingDistractorTags = cell(size(viewedDistractorsBFly{1}.arrayMap,1),1);

for cc = 1:size(viewedDistractorsBFly{1}.arrayMap,1)
    descendingDistractorTags(cc) = D( sumsIDX( cc ) );
end
