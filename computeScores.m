function [ tp, p, r, meanF1, acc ] = computeScores( c, obj )
%COMPUTESCORES Computing various measurement scores
%   INPUT
%     confMat - A m x m confusion matrix with m classes
%   OUTPUT
%     tp - True Positives
%     p - Precision
%     r - Recall
%     meanF1 = mean F1 score

cNorm = bsxfun(@rdivide, c,sum(c,2))%Normalizing confusion matrix

tp = sum(diag(c))
p = diag(bsxfun(@rdivide, diag(c),sum(c))) %precision
r = bsxfun(@rdivide, diag(c),sum(c,2)) %recall
f1 =  (p.*r) ./ (p+r);
meanF1 = mean(f1)
acc = sum(diag(c)) / sum(sum(c))%accuracy

% imagesc(cNorm) 
% colormap(jet) 
% colorbar 
drawConfMat(cNorm);

set(gca, 'XTick',[1:size(obj,1)],'XTickLabel',obj);
set(gca,  'YTick',[1:size(obj,1)],'YTickLabel',obj);
set(gca,'FontSize',5)

end

