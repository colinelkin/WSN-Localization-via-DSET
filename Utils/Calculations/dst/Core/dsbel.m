function y=dsbel(x)
%=========================================================================   
% dsbel
%=========================================================================   
% y=dsbel(x) 
% 
% Belief function
%
% Input:
% x: Dempster-Shafer structure. 
%
% Output:
% y: Plottable belief function [x,Bel(-inf,x)]
%
% Example:
%
% lambda=dsstruct([2,3,1])
% x=dsodf('expinv',1000,lambda);
% y=dsbel(x)
% plot(y(:,1),y(:,2))
%=========================================================================
% Reference : Ferson, S., V. Kreinovich, et al. (2003). Constructing
% Probability Boxes and Dempster-Shafer Structures. Albuquerque, Sandia
% National Laboratories.
% Link      : http://citeseer.ist.psu.edu/660030.html
% Copyright (c) Philipp Limbourg, University of Duisburg-Essen
% www.uni-duisburg-essen.de/informationslogistik/
%=========================================================================
y(:,1)=x.ds(:,2);
y(:,2)=x.ds(:,3);
y=sortrows(y,1);
for i=2:size(x.ds,1)
    y(i,2)=y(i-1,2)+y(i,2);
end