function y=dsnonspec(x)
%=========================================================================   
% dsnonspec
%=========================================================================   
% y=dsnonspec(x)
% Returns the nonspecifity uncertainty measure for of a Dempster-Shafer
% structure x. For further information on this uncertainty measure, see
% references.
%
% Input: 
% x: Dempster-Shafer structure to be reduced
%
% Output:
% y: Nonspecifity
%
% Usage:
% lambda=dsstruct([2,3,1])
% dss=dsodf('expinv',10000,lambda)
% y=dsnonspec(dss)
% =========================================================================
% Copyright (c) Philipp Limbourg, University of Duisburg-Essen
% www.uni-duisburg-essen.de/informationslogistik/
%=========================================================================
% Reference : Klir GJ: Uncertainty and Information : Foundations of
% Generalized Information Theory. Wiley-IEEE Press (2005).
% Copyright (c) Philipp Limbourg, University of Duisburg-Essen
% www.uni-duisburg-essen.de/informationslogistik/
%=========================================================================
y=x.ds(:,3).*log2(1+(abs(x.ds(:,2)-x.ds(:,1))));
y=sum(y);