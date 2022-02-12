function y=dsavgwidth(x)
%=========================================================================   
% dsavgwidth
%=========================================================================   
% y=dsavgwidth(x)
% Returns the average width uncertainty measure for of a Dempster-Shafer
% structure x. It is the cummulative width of all focal elements weighted
% by their mass. For further information on this uncertainty measure, see
% references.
%
% Input: 
% x: Dempster-Shafer structure to be reduced
%
% Output:
% y: Aggregated uncertainty
%
% Usage:
% lambda=dsstruct([2,3,1])
% dss=dsodf('expinv',10000,lambda)
% y=dsavgwidth(dss)
% =========================================================================
% Copyright (c) Philipp Limbourg, University of Duisburg-Essen
% www.uni-duisburg-essen.de/informationslogistik/
%=========================================================================
% Reference : Limbourg P, Savic R, Petersen J, Kochs H-D: Fault Tree
% Analysis in an Early Design Stage using the Dempster-Shafer Theory of
% Evidence. In: Terje Aven JEV (ed) European Conference on Safety and
% Reliability – ESREL 2007, pp. 713-722. Taylor and Francis, Stavanger, Norway (2007).
% Link      : http://iit.uni-duisburg.de/forschung/veroeffentlichungsdateien/2007/LSKP07.pdf
% Copyright (c) Philipp Limbourg, University of Duisburg-Essen
% www.uni-duisburg-essen.de/informationslogistik/
%=========================================================================
y=x.ds(:,3).*abs(x.ds(:,2)-x.ds(:,1));
y=sum(y);