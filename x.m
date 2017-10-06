
function  combs = x()
  numObjs = 20;
  combs = {};
  count = 0;
  for i = 1 : numObjs
    count = count + 1;
    combs{count,1} = i;
    sizeCombs = size(combs,1)-1;
    disp(sizeCombs);
    for j=1 : sizeCombs
      comb = cat(2,combs{j},i);
      count = count + 1;
      combs{count,1} = comb;
    end


  end
end