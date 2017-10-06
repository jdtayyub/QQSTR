function [ relation ] = recSpatialRelation( rec1, rec2 )
  %CUBESPATIALRELATION Returns the spatial relation of the two cubes in 3D.
  %   INPUT: 
  %     rec1 - is the first rectangle dimension as point (x,y) and width, heigth:
  %     {x, y, width, height}
  %     rec2 - is the second cube dimension as point (x,y) and width, heigth:
  %     {x, y, width, height}
  %
  %   OUTPUT:
  %     relation - Spatial Relation RCC-3 of the two rectabgles given as follows:
  %     1 for DC or Disconnected
  %     2 for PO or PartOf 
  %     3 for P or Part

  inPoints1 = 0;
  inPoints2 = 0;

  points1 = getRecPoints(rec1);
  points2 = getRecPoints(rec2);

  for i=1:size(points1,1)
    inPoints1 = inPoints1 + inRectangle(rec1,points2(i,:));  
    inPoints2 = inPoints2 + inRectangle(rec2,points1(i,:));
  end

  inPoints = max([inPoints1, inPoints2]);

  if(inPoints == 0)
    relation = 1;
  elseif(inPoints < 3)
        relation = 2;
      else
        relation = 3;
  end

end

