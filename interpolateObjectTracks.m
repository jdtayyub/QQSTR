function [ recs ] = interpolateObjectTracks( recs )
%INTEROLATEOBJECTTRACKS Interpolates or extends the ractangle tracks of
%objects which are either 0 or NaN.
%   INPUT - 
%     recs - a cell array of frame x 4 matrices providing the rectangles in [x y w h] format
%     for each frame of the video for each object.
%   OUTPUT -
%     interRecs - recs like cell array with all 0 or NaN track entries
%     either interpolated or extended


for i = 1: size(recs,1)
  for j = 1: size(recs{i},1)
    if(recs{i}(j,1) == 0)
      for k = j: size(recs{i},1)
        if(recs{i}(k,1) ~= 0)
          if(j ~= 1)
            recs{i}(j:k-1,1) = linspace(recs{i}(j-1,1),recs{i}(k,1),abs(j-k));
            recs{i}(j:k-1,2) = linspace(recs{i}(j-1,2),recs{i}(k,2),abs(j-k));
            recs{i}(j:k-1,3) = linspace(recs{i}(j-1,3),recs{i}(k,3),abs(j-k));
            recs{i}(j:k-1,4) = linspace(recs{i}(j-1,4),recs{i}(k,4),abs(j-k));
            break;
          else
            recs{i}(j:k,:) = repmat(recs{i}(k,:),k-j+1,1);
            break;
          end
        end
      end
      if(k == size(recs{i},1))
        recs{i}(j:k,:) = repmat(recs{i}(j-1,:),k-j+1,1);
      end
    end
  end
end

end

