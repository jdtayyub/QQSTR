function [ relation ] = cubeSpatialRelation( c1 , c2  )
%CUBESPATIALRELATION Returns the spatial relation of the two cubes in 3D.
%   INPUT:
%     c1 - is the first cube dimension as point (x,y,z) and width, heigth, depth:
%     {x, y, width, height, depth}
%     c1 - is the first cube dimension as point (x,y,z) and width, heigth, depth:
%     {x, y, width, height, depth}%

%   OUTPUT:
%     relation - Spatial Relation RCC-3 of the two Cubes given as follows:
%     1 for DC or Disconnected
%     2 for PO or PartOf
%     3 for P or Part

inPoints1 = 0;
inPoints2 = 0;

points1 = getCubePoints(c1);
points2 = getCubePoints(c2);

points1xR = min(points1(:,1)):max(points1(:,1));
points1yR = min(points1(:,2)):max(points1(:,2));
points1zR = min(points1(:,3)):max(points1(:,3));

points2xR = min(points2(:,1)):max(points2(:,1));
points2yR = min(points2(:,2)):max(points2(:,2));
points2zR = min(points2(:,3)):max(points2(:,3));

for i=1:size(points1,1)
  inPoints1 = inPoints1 + inCube(c1,points2(i,:));
  inPoints2 = inPoints2 + inCube(c2,points1(i,:));
end

inPoints = max([inPoints1, inPoints2]);

if(inPoints == 0)
  if isempty(intersect(points1xR,points2xR)) && isempty(intersect(points1yR,points2yR)) && isempty(intersect(points1zR,points2zR))
    relation = 1;
  else
    relation = 2;
  end
elseif(inPoints == 8)
  relation = 3;
else
  relation = 2;
end

end


