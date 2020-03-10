function [newData]=boundData(data,lb,ub)
newData=data;
indices=find(data>ub);
newData(indices)=ub;
indices=find(data<lb);
newData(indices)=lb;
end