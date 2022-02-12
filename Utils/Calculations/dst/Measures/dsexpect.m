function y=dsexpect(x)
%=========================================================================   
% dsexpect
%=========================================================================   
% y=dsexpect(x) 
% 
% Expected value of the Dempster-Shafer structure x
%
% Input:
% x: Dempster-Shafer structure
%
% Output:
% y: Expected value (lower & upper bound)
%
% Usage:
% lambda=dsstruct([2,3,1])
% dss=dsodf('norminv',1000,lambda)
% y=dsexpect(dss)
%=========================================================================
% Copyright (c) Philipp Limbourg, University of Duisburg-Essen
% www.uni-duisburg-essen.de/informationslogistik/
%=========================================================================
y=sum([x.ds(:,1).*x.ds(:,3),x.ds(:,2).*x.ds(:,3)]);
