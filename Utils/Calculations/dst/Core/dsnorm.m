function [y,a,b]=dsnorm(y)
%=========================================================================   
% dsnorm
%=========================================================================   
% y=dsnorm(x) 
% Normalizes a Dempster-Shafer structure x. Normalizes masses to 1 and
% interchanges lower_bound & upper_bound, if lower_bound>upper_bound.
%
% Input: 
% x: Dempster-Shafer structure to be normalized
%
% Output:
% y: Normalized Dempster-Shafer structure
%
% Usage:
% foo=dsstruct
% foo.ds=[3,2,1]
% bar=dsnorm(foo)
%=========================================================================
% Copyright (c) Philipp Limbourg, University of Duisburg-Essen
% www.uni-duisburg-essen.de/informationslogistik/
%=========================================================================
vec=y.ds(:,1)>y.ds(:,2);
a=0;
b=0;
if sum(vec)>0
    a=1;
end
temp=y.ds(find(vec),1);
y.ds(find(vec),1)=y.ds(find(vec),2);
y.ds(find(vec),2)=temp;
s=sum(y.ds(:,3));
if s~=1
    b=1;
end
y.ds(:,3)=y.ds(:,3)/s;

