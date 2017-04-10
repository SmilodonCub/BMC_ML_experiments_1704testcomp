%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                                            
%       _____    ____   ____  ____      ____ 
%  ___|\     \  |    | |    ||    |    |    |
% |    |\     \ |    | |    ||    |    |    |
% |    | |     ||    |_|    ||    |    |    |
% |    | /_ _ / |    .-.    ||    |    |    |
% |    |\    \  |    | |    ||    |    |    |
% |    | |    | |    | |    ||\    \  /    /|
% |____|/____/| |____| |____|| \ ___\/___ / |
% |    /     || |    | |    | \ |   ||   | / 
% |____|_____|/ |____| |____|  \|___||___|/  
%   \(    )/      \(     )/      \(    )/    
%    '    '        '     '        '    '     
%  
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%append .bhv files with some semi-processed data for further analysis

% (1) time to fixate the target (on TP trials), 

% (2) the object initially fixated (most likely the target on TP trials, 
% but this might also be a target-similar distractor on TA trials), 
% the order in which objects are fixated (probably most informative on TA trials), 

% (4) initial saccade latency,

% (5) accuracy.

% (6) time fixation was held befor saccade to a target



%select & read a .bhv file
BHV = bhv_read();
%get the name (str) of the condition file (.txt) that was used for this
%.bhv. this is necessary for files with no info on the target names & pos
cond_file = BHV.ConditionsFile;



%find correct trials & a bear target was present
% correct_idx = find(BHV.TrialError == 0);
% num_correct = length(correct_idx);





correct = 0;
incorrect = 0;
for i = 1:size(BHV.AnalogData,2)%num_correct
%     test_fix_aqrd_time = BHV.CodeTimes{i}(BHV.CodeNumbers{i}==6);
%     test_target_aqrd_time = BHV.CodeTimes{i}(BHV.CodeNumbers{i}==14);
    %if BHV.TrialError(BHV.ConditionNumber(i)) == 0
    if BHV.TrialError(i) == 0
        correct = correct + 1;
        hazbear = BHV.InfoByCond{BHV.ConditionNumber(i)}.ifBear;
        fix_aqrd_time = BHV.CodeTimes{i}(BHV.CodeNumbers{i}==6);%BHV.CodeTimes{correct_idx(i)}(BHV.CodeNumbers{correct_idx(i)}==6);
        target_aqrd_time = BHV.CodeTimes{i}(BHV.CodeNumbers{i}==14);%BHV.CodeTimes{correct_idx(i)}(BHV.CodeNumbers{correct_idx(i)}==14);
        data = cat(1, BHV.AnalogData{i}.EyeSignal(fix_aqrd_time:target_aqrd_time,1:2)', ...
            1:size(BHV.AnalogData{i}.EyeSignal(fix_aqrd_time:target_aqrd_time,1:2)',2));
        [ A B ] =  fixation_detection_BHV(data', 2.5,2.4,50,14,14);
        BHV.Fixations{i} = { A B };
        %figure
        fixfig = figure(1);
        set(fixfig, 'Position', [50 50 800 800])
        plot(BHV.AnalogData{i}.EyeSignal(fix_aqrd_time:target_aqrd_time,1)',BHV.AnalogData{i}.EyeSignal(fix_aqrd_time:target_aqrd_time,2)','co')
        set(gca,'Fontsize',20)
        hold on
        axis([-15 15 -15 15])
        title([ 'Trial: ', num2str(i), '  BHV: ', num2str(BHV.TrialNumber(i)) , '  Correct', num2str(correct)],'FontSize', 18)
        plot(A(:,1),A(:,2),'r+')
        if hazbear == '1'
            text(A(:,1),A(:,2),num2str(A(:,7)),'HorizontalAlignment','Left','VerticalAlignment','Bottom','FontSize',20,'Color','r')
            text(B(:,1),B(:,2),num2str((1:(size(B,1)))'),'HorizontalAlignment','Right','VerticalAlignment','Top','FontSize',20,'Color','r')
            text( 3, 0, 'BEAR','FontSize',20,'Color','r')
        elseif hazbear == '0'
            text(A(:,1),A(:,2),num2str(A(:,7)),'HorizontalAlignment','Left','VerticalAlignment','Bottom','FontSize',20,'Color','b')
            text(B(:,1),B(:,2),num2str((1:(size(B,1)))'),'HorizontalAlignment','Right','VerticalAlignment','Top','FontSize',20,'Color','b')
            text( 3, 0, 'NO BEAR','FontSize',20,'Color','b')
        end
%         hold on
%         plot(B(:,1),B(:,2),'bs')
%         text(B(:,1),B(:,2),num2str(B(:,7)),'HorizontalAlignment','Right','VerticalAlignment','Top','FontSize',20,'Color','b')
        pause(1)
        clf
    elseif BHV.TrialError(i) ~= 0
        incorrect = incorrect + 1;
    end
% plot(list_of_out_points(:,1),list_of_out_points(:,2),'go')
% legend('Raw Data','Fixations (t1, t2, minDur)','Fixations (t1, 3s, minDur)','Points out of analysis (t1,t2,minDur)','Location','Best')
% title(['Raw Data and Fixations  (t1=',num2str(t1),', t2=',num2str(t2),', minDur=',num2str(minDur),')'],'FontSize',20)
% xlabel('Horizontal Coordinate','Color','k','FontSize',20)
% ylabel('Vertical Coordinate','Color','k','FontSize',20)
% axis('equal')
% %plot screen outline
% screen=[0,0;maxx,0;maxx,maxy;0,maxy;0,0]; %sreen region
% hold on
% plot(screen(:,1),screen(:,2),'-r')

end





