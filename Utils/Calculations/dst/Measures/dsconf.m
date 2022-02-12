function y=dsconf(x,conf)
%=========================================================================   
% dsconf
%=========================================================================   
% y=dsconf(x,conf) 
% 
% Confidence value of the Dempster-Shafer structure x
%
% Input:
% x: Dempster-Shafer structure
% conf: Confidence value (0<=conf<1)
%
% Output:
% y: Confidence (lower & upper bound)
%
% Usage:
% lambda=dsstruct([2,3,1])
% dss=dsodf('expinv',1000,lambda)
% y_med=dsconf(dss,0.5)
% y_5=dsconf(dss,0.05)
% y_95=dsconf(dss,0.95)
%=========================================================================
% Copyright (c) Philipp Limbourg, University of Duisburg-Essen
% www.uni-duisburg-essen.de/informationslogistik/
%=========================================================================
down(:,1)=x.ds(:,1);
down(:,2)=x.ds(:,3);
down=sortrows(down,1);
down(:,2)=cumsum(down(:,2));
up(:,1)=x.ds(:,2);
up(:,2)=x.ds(:,3);
up=sortrows(up,1);
up(:,2)=cumsum(up(:,2));
y=[];
y(1)=down(min(find(down(:,2)>=conf)),1);
y(2)=up(min(find(up(:,2)>=conf)),1);