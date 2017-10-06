function [ output_args ] = test( qsr, labels, vidId )


for i = 1: size(qsr,1)
  if(i<32)
    csvwrite(['qsrFiles/subject1-' labels{i} '-' vidId(i,1:end) '.csv'], qsr{i})
    continue
  end
  if(i<63)
        csvwrite(['qsrFiles/subject2-' labels{i} '-' vidId(i,1:end) '.csv'], qsr{i})
        continue
  end
  if(i<94)
      csvwrite(['qsrFiles/subject3-' labels{i} '-' vidId(i,1:end) '.csv'], qsr{i})
      continue
  end
  if(i<125)
      csvwrite(['qsrFiles/subject4-' labels{i} '-' vidId(i,1:end) '.csv'], qsr{i})
      continue
  end
end

end

