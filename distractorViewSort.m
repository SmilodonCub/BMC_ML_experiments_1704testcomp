clear distractorViewedMapObj
clear distractorArrayMapObj

%%
task_folder  = 'C:\monkeyLogic\Experiments\categorical_search\CatSearch_Exemplar';
category = 'Bear';
%[ T D ] = ListSortImages( task_folder );
[T, D] = CatSearchListSortImages( task_folder, category );

%%
if ~exist('distractorMapObj', 'var')
    keySet =   D;
    arrayKeySet = D;
    valueSet = zeros(1,length(D));
    valueArraySet = zeros(1,length(D));
    distractorViewedMapObj = containers.Map(keySet,valueSet);
    distractorArrayMapObj = containers.Map(arrayKeySet,valueArraySet);
end

%%

for ii = 1:size(BHV.ObjectsFixated,2)
    for jj = 1:size(BHV.ObjectsFixated{ii})
        try
        object = BHV.ObjectsFixated{ii}(jj);
        splitObject = regexp( object, '[(,)]', 'split');
        keyObject = [ char(splitObject{1}(2)) '.bmp' ];
        if isKey( distractorViewedMapObj, keyObject )
            distractorViewedMapObj( keyObject ) = distractorViewedMapObj( keyObject ) + 1;
        end
        catch err
            %disp( err )
            %disp( BHV.ObjectsFixated{ii}(jj) )
        end
    end
end

%%

for kk = 1:size(BHV.TrialError,1)
    %kk
    if BHV.TrialError(kk) == 0
        for ll = 5:length(BHV.TaskObject(BHV.ConditionNumber(kk),:))
            %ll
            try
                object = BHV.TaskObject{BHV.ConditionNumber(kk),ll};
                splitObject = regexp( object, '[(,)]', 'split');
                %splitObject
                keyObject = [ char(splitObject(2)) '.bmp' ];
                %keyObject
                if isKey( distractorArrayMapObj, keyObject )
                    distractorArrayMapObj( keyObject ) = distractorArrayMapObj( keyObject ) + 1;
                end
            catch err
                %disp( err )
                %disp( BHV.ObjectsFixated{ii}(jj) )
            end
        end
    end
end