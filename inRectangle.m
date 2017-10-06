function [ answer ] = inRectangle( rectangle, point )
%INRECTANGLE Summary of this function goes here
%   rectangle given as [x y x+w y+h]
%   point given as [x y]

rectangle(1,3) = rectangle(1,1) + rectangle(1,3);
rectangle(1,4) = rectangle(1,2) + rectangle(1,4);

  if ( point(1,1) >= rectangle(1,1) && point(1,1) <= rectangle(1,3) ) 
    if ( point(1,2) >= rectangle(1,2) && point(1,2) <= rectangle(1,4) ) 
            
           answer = 1;
           return;
            
    end
  end

  answer = 0;
   
end

