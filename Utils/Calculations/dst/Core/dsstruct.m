function y=dsstruct(x)
%=========================================================================   
% dsstruct
%=========================================================================   
% y=dsstruct(x) returns a Dempster-Shafer structure with BPA x. 
%
% Input: 
% x (optional): A N-3 array containing [lower_bound,upper_bound,mass]
% 
% Output:
% y: a new Dempster-Shafer structure
% Example: 
% 
% dss=dsstruct([2,3,0.5;3,4,0.5])
% 
% If the sum of masses is not 1, masses will be normalized. If
% lower_bound>upper_bound, they will be interchanged.
%=========================================================================
% Copyright (c) Philipp Limbourg, University of Duisburg-Essen
% www.uni-duisburg-essen.de/informationslogistik/
%=========================================================================
y.ds=[];
if nargin>0
y.ds=x;
[y,a,b]=dsnorm(y);
%if a>0
%  disp(sprintf('Warning, lower bound > upper bound for some elements: BPA normalized'));
%end
%if b>0
%  disp(sprintf('Warning, mass <>1: BPA normalized'));
%end
end