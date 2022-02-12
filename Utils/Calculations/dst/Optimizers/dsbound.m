function y=dsbound(fhandle,xlo,xhi,mass,varargin)
%=========================================================================   
% dsbound
%=========================================================================   
% y=dsbound(fhandle,xlo,xhi,mass,varargin) 
% 
% Propagates focal elements through a function. Used by Monte-Carlo
% propagation algorithm. Most simple and fastest "optimization routine".
% Only for monotonous increasing functions.
% Evaluates f(min(a,b)) and f(max(a,b)) boundary function values. Can
% process one focal element or a vector of focal elements at once.
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
% Usage: Propagating through the function f
% fhandle=inline('x(:,1)+x(:,2)','x');
% lambda=dsstruct([2,3,1]);
% x1=dsodf('expinv',100,lambda);
% x2=dsodf('expinv',100,lambda);
% xlo=[x1.ds(:,1),x2.ds(:,1)];
% xhi=[x1.ds(:,2),x2.ds(:,2)];
% mass=[x1.ds(:,3),x2.ds(:,3)];
% y=dsbound(fhandle,xlo,xhi,mass);
%=========================================================================
% Copyright (c) Philipp Limbourg, University of Duisburg-Essen
% www.uni-duisburg-essen.de/informationslogistik/
%=========================================================================
y=zeros(size(xlo,1),3);
    a=feval(fhandle,xlo,varargin{:});
    b=feval(fhandle,xhi,varargin{:});  
    c=prod(mass')';      
    y(:,1)=min(a,b);
    y(:,2)=max(a,b);    
y(:,3)=c;
%x = fmincon(inline('prod(x)'),[2;4],A,b)