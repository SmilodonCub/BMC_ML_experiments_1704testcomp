%first distractor viewed

clear firstdistractorViewedMapObj
clear firstdistractorArrayMapObj

%%
% task_folder  = 'C:\monkeyLogic\Experiments\categorical_search\CatSearch_Exemplar';
% category = 'BFly';
% %[ T D ] = ListSortImages( task_folder );
% [T, D] = CatSearchListSortImages( task_folder, category );

 task_folder  = 'C:\monkeyLogic\Experiments\categorical_search\specific_search2';
 [T, D] = ListSortImages( task_folder );

%%
if ~exist('firstdistractorMapObj', 'var')
    keySet =   D;
    arrayKeySet = D;
    valueSet = zeros(1,length(D));
    valueArraySet = zeros(1,length(D));
    firstdistractorViewedMapObj = containers.Map(keySet,valueSet);
    firstdistractorArrayMapObj = containers.Map(arrayKeySet,valueArraySet);
end

BHV_TAbutton_MultiArray_NovelBear
%%

num1st = 0;

    for ii = 1:size(BHV.ObjectsFixated,2) %for all 500 trials
        firstD = 0;
        for jj = 1:size(BHV.ObjectsFixated{ii}) %for all TaskObjects fixated within that trial
            try
                object = BHV.ObjectsFixated{ii}(jj);
                splitObject = regexp( object, '[(,)]', 'split');
                keyObject = [ char(splitObject{1}(2)) '.bmp' ];
                if isKey( firstdistractorViewedMapObj, keyObject )
                    firstdistractorViewedMapObj( keyObject ) = firstdistractorViewedMapObj( keyObject ) + 1;
                    firstD = 1;
                    num1st = num1st + 1;
                    disp('got a first distractor')
                    disp(keyObject)
                    disp(ii)
                end
            catch err
                %disp( err )
                %disp( BHV.ObjectsFixated{ii}(jj) )
            end
            if firstD
                disp('1st')
                break
            end
        end
    end
    
disp(num1st)

%%
textFileColumn = 5; %the column in the text file for this task where Distractor TaskObjects start to get listed.


for kk = 1:size(BHV.TrialError,1)
    %kk
    if BHV.TrialError(kk) == 0
        for ll = textFileColumn:length(BHV.TaskObject(BHV.ConditionNumber(kk),:))
            %ll
            try
                object = BHV.TaskObject{BHV.ConditionNumber(kk),ll};
                splitObject = regexp( object, '[(,)]', 'split');
                %splitObject
                keyObject = [ char(splitObject(2)) '.bmp' ];
                %keyObject
                if isKey( firstdistractorArrayMapObj, keyObject )
                    firstdistractorArrayMapObj( keyObject ) = firstdistractorArrayMapObj( keyObject ) + 1;
                end
            catch err
                %disp( err )
                %disp( BHV.ObjectsFixated{ii}(jj) )
            end
        end
    end
end