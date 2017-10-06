function [ answer ] = inCube( cube, point )
%INRECTANGLE Summary of this function goes here
%   INPUT:
%     cube given as [x y z w h d]
%     point given as [x y z]
%   Output:
%     answer given as 1 if point in block or zero if point outside block

%get extreme corners of cube

corner1 = cube(1:3) + cube(4:6)/2; %format [x y z x+w y+h z+d]
corner2 = cube(1:3) - cube(4:6)/2;
cube(4:6) = corner1; cube(1:3) = corner2;



  if ( point(1) >= cube(1) && point(1) <= cube(4) ) 
    if ( point(2) >= cube(2) && point(2) <= cube(5) ) 
      if ( point(3) >= cube(3) && point(3) <= cube(6) )
            
          answer = 1;
          return;
            
      end
    end    
  end

  answer = 0;
   
end

