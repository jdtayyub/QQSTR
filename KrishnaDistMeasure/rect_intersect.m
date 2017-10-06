function intersect = rect_intersect(r1,r2)
global template_size;


tr1 = [r1(1) r1(2) r1(1)+r1(3) r1(2)+r1(4)];
tr2 = [r2(1) r2(2) r2(1)+r2(3) r2(2)+r2(4)];

intersect(1) = max(tr1(1), tr2(1));
intersect(2) = max(tr1(2), tr2(2));
intersect(3) = min(tr1(3), tr2(3));
intersect(4) = min(tr1(4), tr2(4));


intersect(3) = intersect(3) - intersect(1);
intersect(4) = intersect(4) - intersect(2); 