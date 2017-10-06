function [ output_args ] = drawBlock( block, color )
%DRAWBLOCK Draws a wireframe of a block
%   Detailed explanation goes here
%   INPUT
%     block - block given in format (x,y,z,w,h,d)
%     color - line color

points = getBlockPoints(block);

%Add additional lines to complete cubic shape
points = [points; points(1,:); points(4,:); points(5,:); points(8,:); points(7,:); points(2,:); points(3,:); points(6,:)];

plot3(points(:,1),points(:,2),points(:,3), color);

grid on;
xlabel('x');
ylabel('y');
zlabel('z');
axis([0 max(points(:,1))+1 0 max(points(:,2))+1 0 max(points(:,3))+1]);

end

