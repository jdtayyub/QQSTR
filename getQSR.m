function [ qsr ] = getQSR( varargin )
%GETQSR Caculated the QSR happening with every pair of input argument
%   INPUT
%      varargin - receieve all object tracks
%   OUTPUT
%     qsr - a matrix of dimension objectsPair x frames will be returned
%     where each row will show qsr of a single pair of objects in the
%     scene. Number of rows would be determined by nCr where n is the
%     number of objects and r is 2 for pairs. 
%     First column gives a number representing the combination of objects.
%     for example 12 means the relations for object 1 and 2 and so on.

% fprintf('Number of arguments: %d\n',nargin);
%    celldisp(varargin)
   
global objects;
obj = {};
   qsr = zeros(nchoosek(nargin,2), size(varargin{1},1)+1);
   count = 1;
   for i = 1 : nargin
     for j = i+1 : nargin
       qsr(count,1) = str2num([num2str(i) num2str(j)]); 
       obj = [obj ;{[num2str(i)  '-' num2str(j)]}];
       for k = 1 : size(varargin{1},1)
         qsr(count,k+1) = recSpatialRelation(varargin{i}(k,:),varargin{j}(k,:));
       end
       count = count + 1;
     end
     
   end
   objects = [objects ; {obj}];
end

