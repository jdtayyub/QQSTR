function [ relation ] = blockSpatialRelation( cube1, cube2 )
  %CUBESPATIALRELATION Returns the spatial relation of the two cubes in 3D.
  %   INPUT: 
  %     cube1 - is the first cube dimension as point (x,y,z) and width, heigth, depth:
  %     {x, y, z, width, height, depth}
  %     cube2 - is the second cube dimension as point (x,y,z) and width, heigth, depth:
  %     {x, y, z, width, height, depth}
  %
  %   OUTPUT:
  %     relation - Spatial Relation RCC-3 of the two cubes given as follows:
  %     1 for DC or Disconnected
  %     2 for PO or PartOf 
  %     3 for P or Part

  inPoints1 = 0;
  inPoints2 = 0;

  points1 = getBlockPoints(cube1);
  points2 = getBlockPoints(cube2);

  for i=1:size(points1,1)
    inPoints1 = inPoints1 + inBlock(cube1,points2(i,:));  
    inPoints2 = inPoints2 + inBlock(cube2,points1(i,:));
  end

  inPoints = max([inPoints1, inPoints2]);

  if(inPoints == 0)
    relation = 1;
  elseif(inPoints < 5)
        relation = 2;
      else
        relation = 3;
  end

end

