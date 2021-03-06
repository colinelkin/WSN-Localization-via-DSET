function erg=dswmix(x,w)
%=========================================================================   
% dswmix
%=========================================================================   
% y=dswmix(x,w) 
% 
% Weighted mixture
%
% Input:
% x: Array of Dempster-Shafer structures. 
% w (optional): Array of weights. If empty,
% w:=[1,...,1]
%
% Output:
% y: Aggregation function
%
% Usage: Aggregating two exponential cdfs with different weights
% lambda1=dsstruct([2,3,1])
% dss1=dsodf('expinv',1000,lambda1);
% lambda2=dsstruct([5,6,1])
% dss2=dsodf('expinv',1000,lambda2);
% w=[1,5];
% y=dswmix([dss1,dss2],w)
% dscdf(y)
%=========================================================================
% Reference : Ferson, S., V. Kreinovich, et al. (2003). Constructing
% Probability Boxes and Dempster-Shafer Structures. Albuquerque, Sandia
% National Laboratories.
% Link      : http://citeseer.ist.psu.edu/660030.html
% Copyright (c) Philipp Limbourg, University of Duisburg-Essen
% www.uni-duisburg-essen.de/informationslogistik/
%=========================================================================
erg=dsstruct;
if nargin<2
    w=ones(1,length(x));
end
for i=1:length(x)
    x(i).ds(:,3)=...
    x(i).ds(:,3)*w(i);
    erg.ds=[erg.ds;x(i).ds];
end
erg=dsnorm(erg);
%erg=dsred(erg);
