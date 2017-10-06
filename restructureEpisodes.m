function [ restEp ] = restructureEpisodes( e )
%RESTRUCTUREEPISODES Summary of this function goes here
%   Detailed explanation goes here

restEp = {};
xEp = {};
rE = [];
threshold = 8; % Frame consistency for relation  - noise smoothing technique

for i = 1: size(e,1)
  for j = 1: size(e,2)    
    
    objects = num2str(e{i,j}{1});
    for k = 2: 3 :size(e{i,j},2)
      rE = [rE ; [str2num(objects(1)) str2num(objects(2)) cell2mat(e{i,j}(k:k+2))]];
   
    end
   
  end
  
  restEp = [restEp; rE];
  rE = [];
end

% threshold = 8;
% sRe = [];
% temp = -1;
% for i = 1 : size(restEp,1)
%   rE = restEp{i}
%   for j = 1: size(rE, 1)
%     diff = rE(j,5) - rE(j,4);
%     if(diff < threshold)
%       if(size(sRe,1) == 0)
%         temp = temp + diff;
%       else
%         sRe(end,5) = sRe(end,5) + diff; 
%       end
%     else
%       sRe = [sRe; rE(j,:)]
%       if(temp ~= -1)
%         sRe(end,5) = sRe(end,5) + temp;
%         temp = -1;
%       end
%     end
%   end
%   
%   cSrE = sRe(1,:);
%   for j = 2: size(sRe,1)
%     if(sRe(j,1) == cSrE(end,1) && sRe(j,2) == cSrE(end,2))
%       if(sRe(j,3) == cSrE(end,3))
%         cSrE(end, 5) = sRe(j,5);
%       else
%         cSrE = [cSrE; sRe(j,:)];
%       end
%     else
%       cSrE = [cSrE; sRe(j,:)];
%     end
%   end
%   
%   xEp = [xEp; cSrE];
%   sRe = [];
% end
% 


end

