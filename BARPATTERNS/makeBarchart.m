
x = [53.23 33.06 85.48 48.39 92.74 83.8 95.87; 54.84 54.03 64.52 59.68 69.35 63.71 75.81];
% x = [53.23 33.06 85.48  95.87; 54.84 54.03 64.52  75.81];
% xLabels = {'F_{qls','Fqlt','Fqts','Fqls & Fqlt', 'Fqls & Fqts', 'Fqts & Fqlt', 'Fqls & Fqts & Fqlt'}
x = x';
h = bar(x);
set(gca, 'xTickLabel', xLabels);
xlabel('Feature Combination');
ylabel('Accuracy %');
set(gca, 'FontSize', 16)
legend(h,[{'Using Ground Truth Object Tracks'} ; {'Using Automatic Object Tracks'}])
set(gcf,'color','w')
grid on;


% % Generate figure and remove ticklabels
close all;
% x = [53.23 33.06 85.48  95.87; 54.84 54.03 64.52  75.81];
xLabels = {'$F_{1}$','$F_{2}$','$F_{3}$','$F_{1} \& F_{2}$', '$F_{1} \& F_{3}$', '$F_{2} \& F_{3}$', '$F_{1} \& F_{2} \& F_{3}$'}
% xLabels = {'$F_{1}$','$F_{2}$','$F_{3}$','$F_{1}$ \& $F_{2}$ \& $F_{3}$'}
x = x';
h = bar(x);
set(gca, 'xticklabel', []) %Remove tick labels
% % Get tick mark positions
xTicks = get(gca, 'xtick');
ax = axis; %Get left most x-position
HorizontalOffset = 0.1;
% % Reset the ytick labels in desired font

% % Reset the xtick labels in desired font 

verticalOffset = 0.6;
for xx = 1:length(xTicks)
%Create text box and set appropriate properties
     text(xTicks(xx), -5 , xLabels{xx},...
         'HorizontalAlignment','Right','interpreter', 'latex', 'FontSize',26);   
end
