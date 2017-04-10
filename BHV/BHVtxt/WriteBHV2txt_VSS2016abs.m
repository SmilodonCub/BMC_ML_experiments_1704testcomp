function WriteBHV2txt_VSS2016abs( filename, BHV, saccades_hist, imm_sacc_rxnt )
%WriteBHV2txt_VSS2016abs add a block of txt to the specified fid (file i.d.) that
%includes the relavent fields for VSS abstract preliminary analysis:
%   1) Condition (.txt) File 
%   2) BHV File 
%   3) Fixation Object (target/dist.)
%   4) Number of Correct trials & % correct (block)
%   5) Number of Correct Target Present trials & % correct
%   6) Percent Immediate Fixation Target Present
%   7) Number of Correct Target Absent trials & % correct
%   8) Percent Immediate Fixation Target Absent
%   9) Table: Reaction times correct trial immediate saccades, Reaction
%   times correct trials w/ multiple array object viewings


%Reaction times correct trials w/ multiple-array object viewings & &
%   number of objects viewed

%filepath = 'C:\monkeylogic\BHV\BHVtxt\';
%fullfilename = [ filepath filename ];

fid = fopen( filename, 'w+' );

num_Tpres = 0;
num_NOT = 0;
for i = 1:size(BHV.AnalogData,2)
    hazbear = BHV.InfoByCond{BHV.ConditionNumber(i)}.ifBear;
    if hazbear == '1'
        num_Tpres = num_Tpres + 1;
    elseif hazbear == '0'
        num_NOT = num_NOT + 1;
    end
end

    

if  BHV.TaskObject{ 1,2 }( 1 ) == 'p'
    fprintf( fid, '%s\n', 'Cue Present at Fixation' );
elseif BHV.TaskObject{ 1,2 }( 1 ) == 'S'
    fprintf( fid, '%s\n', 'No Cue at Fixation' );
else
    fprintf( fid, '%s\n', 'SNAFU' );
end

viewed_distractors_Bear = sum(saccades_hist(3:end,1));
viewed_distractors_NOBear = sum(saccades_hist(3:end,2));
num_Tpres;
num_NOT;
correct_Bear = sum(saccades_hist(:,1));
correct_Bear_prcnt = 100*correct_Bear/num_Tpres;
Bear_immsacc_ratio = 100*(num_Tpres - viewed_distractors_Bear)/num_Tpres;
correct_TA = sum(saccades_hist(:,2));
correct_TA_prcnt = 100*correct_TA/num_NOT;
NOBear_immsacc_ratio = 100*(num_NOT - viewed_distractors_NOBear)/num_NOT;
imm_sacc_rxnt(isnan(imm_sacc_rxnt)) = [];
mean_imm_sacc = mean(imm_sacc_rxnt);
sd_imm_sacc = std(imm_sacc_rxnt);

fprintf( fid, '%s\n', BHV.DataFileName );
fprintf( fid, '%s\n', BHV.ConditionsFile );
fprintf( fid, '%s\n', [ '# Correct Trials: ' num2str( BHV.NumCorrect ) '  Performance: ' num2str( 100 * BHV.NumCorrect / length(BHV.TrialNumber) ) '%' ] );
fprintf( fid, '%s\n', [ '# Correct Target Present Trials: ' num2str(correct_Bear) '  Performance: ' num2str( correct_Bear_prcnt ) '%' ] );
fprintf( fid, '%s\n', [ 'Immediate Saccades Target Present: ' num2str( Bear_immsacc_ratio ) '%' ] );
fprintf( fid, '%s\n', [ '# Correct Target Absent Trials: ' num2str(correct_TA) '  Performance: ' num2str( correct_TA_prcnt ) '%' ] );
fprintf( fid, '%s\n', [ 'Immediate Saccades Target Absent: ' num2str( NOBear_immsacc_ratio ) '%' ] );
fprintf( fid, '%s\n', [ 'Mean Target Present Reaction Time for Immediate Saccades: ' num2str(mean_imm_sacc) '  stdev: ' num2str(sd_imm_sacc) ] );
fprintf( fid, '%s\n', ' ' );
fprintf( fid, '%s\n', 'Reaction Times Target Present for Immediate Saccades');
for i = 1:length( imm_sacc_rxnt )
    fprintf( fid, '%d\n', imm_sacc_rxnt(i) );
end



fclose( fid );

end

