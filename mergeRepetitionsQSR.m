function [ mergedRelation ] = mergeRepetitionsQSR( qsrSequence )
%MERGEREPETITIONSQSR Takes a single relation frame by frame sequence in
%format [objectPair relation frames relation frames ... ] and output the
%sequence by merging consecutive repeating relations and removing
%repetitions. CLEAN UP FUNCTION
%   INPUT
%     qsr - In format [objectPair relation frames relation frames ... ]
%   OUTPUT
%     mergedRelation - In format [objectPair relation frames relation frames ... ]

qsrSequence = cell2mat(qsrSequence);

qsrSeqReshaped = reshape(qsrSequence(2:end),2,length(qsrSequence(2:end))/2)';
newQsrSeqReshaped = [];
prevID = 0;
ctr = 1;
for k = 1:size(qsrSeqReshaped,1)
  ID = qsrSeqReshaped(k,1);
  
  if ID~=0
    if ID==prevID

      newQsrSeqReshaped(ctr-1,2) = newQsrSeqReshaped(ctr-1,2) + qsrSeqReshaped(k,2);

    else
      newQsrSeqReshaped(ctr,:) = qsrSeqReshaped(k,:);
      prevID = ID;
      ctr = ctr+1;

    end
  end
  
end

newQsrSeqReshaped = reshape(newQsrSeqReshaped',1,[]);
newQsrSeqReshaped = [qsrSequence(1) newQsrSeqReshaped];
mergedRelation = num2cell(newQsrSeqReshaped);

end