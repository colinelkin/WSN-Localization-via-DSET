function erg=dsopt(fhandle,paramsl,paramsu,paramsm,varargin)
%=========================================================================   
% dsopt
%=========================================================================   
% y=dsopt(fhandle,x) 
% 
% Propagates focal elements through a function. Used by Monte-Carlo
% propagation algorithm. Time-consuming and
% accurate "optimization routine" for complex nonlinear functions.
% Requires Matlabs Optimization toolbox routine fmincon.
%
% Input:
% fhandle: Function handle or function name y=f(x). 
% xlo:  Single focal element: lower bound of parameter vector.
%       Focal element vector: matrix containing the lower bounds of the
%       parameter vector.
% xhi:  Single focal element: upper bound of parameter vector.
%       Focal element vector: matrix containing the upper bounds of the
%       parameter vector.
% mass: Single focal element: Mass of parameter vector.
%       Focal element vector: Vector of masses.
% vargin: Parameters of function fhandle
%
% Output:
% y: Focal element(s) propagated through f
%
% Usage: Propagating through Rosenbrock's "banana" function
% banana = inline('100.*(x(:,2)-x(:,1).^2).^2+(sqrt(2)-x(:,1)).^2','x');
% mu=dsstruct([0.1,0.1,1]);
% sigma=dsstruct([0.1,0.1,1]);
% x1=dsodf('norminv',100,mu,sigma);
% x2=dsodf('norminv',100,mu,sigma);
% xlo=[x1.ds(:,1),x2.ds(:,1)];
% xhi=[x1.ds(:,2),x2.ds(:,2)];
% mass=[x1.ds(:,3),x2.ds(:,3)];
% y=dsopt(banana,xlo,xhi,mass);
%=========================================================================
% Copyright (c) Philipp Limbourg, University of Duisburg-Essen
% www.uni-duisburg-essen.de/informationslogistik/
%=========================================================================
erg=[0,0,0];
warning off all;
for i=1:size(paramsl,1)
[x,erg(i,1)] = fmincon(fhandle,paramsl(i,:),[],[],[],[],paramsl(i,:),paramsu(i,:),[],optimset('display','off'),varargin{:});
funstr=strcat('-',char(fhandle));
if isempty(findstr(funstr,'('))
    funstr=strcat(funstr,'(x)');
end
myfun=inline(funstr);
[x,y] = fmincon(myfun,paramsu(i,:),[],[],[],[],paramsl(i,:),paramsu(i,:),[],optimset('display','off'),varargin{:});
erg(i,2)=-y;
erg(i,3)=prod(paramsm(i,:));
end
end