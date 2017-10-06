function [d, d_c1, d_c2, d_c3, d_c4, d_c5, d_c6] = relative_topological_measure(r1,r2)
% This function computes a quantitative measure of region based distances between   object 2 (with bounding boxes r2)  and object 1 (with bounding boxes r1) 

% This code is Copyright University of Leeds 2011, for use within the VIGIL project of Minds Eye. All other use requires permission from the University of Leeds. All modifications of this code must be notified back to the University of Leeds for possible incorporation into future versions of the software.
% Main author: Muralikrishna Sridhar. Email: krishna@comp.leeds.ac.uk

%This code is an implementation (initial version) of distance measure introduced in the paper 
%Muralikrishna Sridhar, Anthony Cohn, Hogg David C, From Video to RCC8: exploiting a Distance Based Semantics to Stabilise the Interpretation of Mereotopological Relations,  Proc. COSIT (2011) (In Press). The latest version will be released soon. 
%http://www.comp.leeds.ac.uk/krishna//cosit11.pdf


%Compute per two BB's only
r1 = r1(1,:);
r2 = r2(1,:);

%initialize to zero
d_c1 = 0; d_c2 = 0; d_c3 = 0; d_c4 = 0; d_c5 = 0; d_c6 = 0;
intersect = rect_intersect(r1,r2);
if intersect(3)<=0 intersect(3)=0; end; 
if intersect(4)<=0 intersect(4)=0; end;


P1.x = [r1(1) r1(1) + r1(3) r1(1) + r1(3) r1(1)];
P2.x = [r2(1) r2(1) + r2(3) r2(1) + r2(3) r2(1)];
P1.y = [r1(2) r1(2)  r1(2) + r1(4) r1(2) + r1(4)];
P2.y = [r2(2) r2(2)  r2(2) + r2(4) r2(2) + r2(4)];

d1 = min(abs(r2(1)-r1(1)),r1(4));
d2 = min(abs(r2(2)-r1(2)),r1(3));
d3 = min(abs(r2(1)+r2(3)-r1(1)-r1(3)),r1(4));
d4 = min(abs(r2(2)+r2(4)-r1(2)-r1(4)),r1(3));
d1 = min(abs(r2(1)-r1(1)),r2(4));
d2 = min(abs(r2(2)-r1(2)),r2(3));
d3 = min(abs(r2(1)+r2(3)-r1(1)-r1(3)),r2(4));
d4 = min(abs(r2(2)+r2(4)-r1(2)-r1(4)),r2(3));


d_c2 = min(intersect(3),intersect(4));   %% Overlapping

if intersect(3)<=0 || intersect(4)<=0             %% DC
        d_c1 = min_dist_between_two_polygons(P1,P2,0);
        d_c5  = min(r1(3),r1(4));  d_c6  = min(r2(3),r2(4));
elseif abs(intersect(3)-r1(3))<10^-3 && abs(intersect(4)-r1(4))<10^-3 %% r1 inside r2
        d_c3 = min_dist_between_two_polygons(P1,P2,0);
        d_c6  = max([d1,d2,d3,d4]);
elseif abs(intersect(3)-r2(3))<10^-3 && abs(intersect(4)-r2(4))<10^-3 %% r2 inside r1
        d_c4 =  min_dist_between_two_polygons(P1,P2,0);
        d_c5  = max([d1,d2,d3,d4]);
else
        d_c6 = max(min(abs(r1(1) - r2(1)),r2(4)),min(abs(r1(2) - r2(2)),r2(3)));
        d_c5 = max(min(abs(r1(1) + r1(3) - r2(1) - r2(3)),r1(4)),min(abs(r1(2) + r1(4) - r2(2) - r2(4)),r1(3)));
end
dd = 0; 
dd1 = 1; 
d_c1 = (d_c1+dd)/(100+dd);
d_c5 = (d_c5+dd)/(min([r1(3),r1(4)])+dd);
d_c6 = (d_c6+dd)/(min([r2(3),r2(4)])+dd);
d_c4 = (d_c4)/((.5*(abs(min([r1(3),r1(4)]) - min([r2(3),r2(4)]))))+dd1);
d_c3 = (d_c3)/((.5*(abs(min([r1(3),r1(4)]) - min([r2(3),r2(4)]))))+dd1);
d_c2 = (d_c2+dd)/(min(min([r1(3),r1(4)]),min([r2(3),r2(4)]))+dd);

d = d_c1 + d_c5 + d_c6 - d_c2 - d_c3 - d_c4;

d = 10*(d + 1.5);

% bigrec = max(min([r1(3),r1(4)]), min([r2(3),r2(4)]));
% smallrec = min(min([r1(3),r1(4)]), min([r2(3),r2(4)]));


% Uncomment for visualization. 
  subplot(1,1,1);imagesc(ones(700,1280));
  rectangle('position',r2(1,1:4));hold on;
  rectangle('position',r1(1,1:4));
  text(100,200,num2str(d),'fontsize',17);hold off;
  pause(.5);
  disp('');




