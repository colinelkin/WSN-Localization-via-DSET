function y=dsevalmc(fhandle,x, mcIT, optimizer,corr, isvectorfun, varargin)
%=========================================================================
% dsevalmc
%=========================================================================
% y=dsevalmc(fhandle,x, mcIT, optimizer,corr, varargin)
% Propagate Dempster-Shafer structures through arbitrary functions y=f(x).
% Samples from the cross product of all focals
%
% Input:
% fhandle: Function handle or function name.
% x: Array of function parameters.
% mcIT: Number of Monte-Carlo samples
% optimizer (optional): Optimizer to use (default: dsbound)
% corr (optional): |x| times |x| Correlation matrix to use.
% isvectorfun (optional): If 1, fhandle will be evaluated
% simultaneously (default, large speedup). Fhandle must be able to process input vectors. If 0, fhandle will be evaluated
% subsequently.
% varargin: Parameters passed to the function specified by fhandle
%
% Output:
% y: Result of propagating x through f(x)
%
% Usage:
% myfn=inline('sqrt(x(:,1).^2.+x(:,2).^2)','x')
% mu=dsstruct([2,3,1])
% dss1=dsodf('norminv',200,mu)
% dss2=dsodf('norminv',500,mu)
% correlations=[1,0.5;0.5,1]
% y_independent=dsevalmc(myfn,[dss1,dss2],10000)
% y_dependent=dsevalmc(myfn,[dss1,dss2],10000,'dsbound',correlations)
% dscdf(y_independent)
% figure
% dscdf(y_dependent)
%=========================================================================
% Copyright (c) Philipp Limbourg, University of Duisburg-Essen
% www.uni-duisburg-essen.de/informationslogistik/
%=========================================================================
global thres;
if iscell(x)
    mult=length(x);
else
    mult=1;
    x={x};
end
for i=1:mult
    len(i)=length(x{i});
end
doestr=[];
ind=[];
temp=0;
temp2=0;
usedependency=1;
% if (isstr(fhandle))
%     fhandle=inline(strcat(fhandle,'(x)'));
% end
if nargin<4 | isempty(optimizer)
    optimizer='dsbound';
end
if nargin<5| isempty(corr)
    usedependency=0;
end
if nargin<6
    isvectorfun=1;
end
for j=1:mult
    for i=1:len(j)
        sample(i,j)=size(x{j}(i).ds,1);
    end
end
for k=1:mult
    for i=1:len(k)
        ptemp=x{k}(i).ds;
        [a,b]=sort(ptemp(:,1)+ptemp(:,2));
        ptemp=ptemp(b,:);
        ptemp(1,4)=ptemp(1,3);
        ptemp(1,5)=0;
        for j=2:size(ptemp,1)
            ptemp(j,4)=ptemp(j-1,4)+ptemp(j,3);
            ptemp(j,5)=ptemp(j-1,4);
        end
        x{k}(i).ds=ptemp;
    end
end

if usedependency==0
    randnos=rand(mcIT,max(len));
else
    randnos=zeros(mcIT,max(len));
    stepsize=min(mcIT, 10000)
    for i=1:stepsize:mcIT
        try
            randnos(i:min(mcIT, i+stepsize-1),:)=copularnd('Gaussian',corr,stepsize);
        catch
            randnos(i:min(mcIT, i+stepsize-1),:)=gaussiancopula(corr,stepsize);
        end
    end
end
for nP=1:mult
    tempEvalVec=zeros(mcIT,len(nP));
    for i=1:len(nP)
        rvec=[randnos(:,i);2000];
        rvec(:,2)=[1:length(rvec)]';

        rvec=sortrows(rvec,1);
        lb=x{nP}(i).ds(:,5);
        ub=x{nP}(i).ds(:,4);
        count=1;
        for j=1:length(lb)
            for k=count:mcIT+1
                if (rvec(k,1)>=ub(j))
                    count=k;
                    break;
                end
                tempEvalVec(rvec(k,2),i)=j;
            end

        end
        toEvalVec{nP}=tempEvalVec;
    end
end

for nP=1:mult
    lb=zeros(mcIT,len(nP));
    ub=zeros(mcIT,len(nP));
    mass=zeros(mcIT,len(nP));
    for i=1:len(nP)
        lb(:,i)=x{nP}(i).ds(toEvalVec{nP}(:,i),1);
        ub(:,i)=x{nP}(i).ds(toEvalVec{nP}(:,i),2);
        mass(:,i)=x{nP}(i).ds(toEvalVec{nP}(:,i),3);
    end
    ytemp=dsstruct;
    if isvectorfun==1
    ytemp.ds=feval(optimizer,fhandle, lb,ub,mass,varargin{:});
    else
        ytemp.ds=zeros(mcIT,3);
        for i=1:mcIT
            ytemp.ds(i,:)=feval(optimizer,fhandle, lb(i,:),ub(i,:),mass(i,:),varargin{:});            
        end
    end
    % for i=1:mcIT
    %     toEval=toEvalVec(i,:);
    %     curprob=1;
    %     curpar=zeros(len,3);
    %     for j=1:len
    %     curpar(j,:)=x(j).ds(toEval(j),1:3);
    %     end
    %     y.ds(i,:)=feval(optimizer,fhandle, curpar);
    % %     c(1,1)=dsCopulaFrank(x(1).ds(toEval(1),4),x(2).ds(toEval(2),4),s);
    % %     c(2,2)=dsCopulaFrank(x(1).ds(toEval(1),5),x(2).ds(toEval(2),5),s);
    % %     c(1,2)=dsCopulaFrank(x(1).ds(toEval(1),4),x(2).ds(toEval(2),5),s);
    % %     c(2,1)=dsCopulaFrank(x(1).ds(toEval(1),5),x(2).ds(toEval(2),4),s);
    % %
    % %     y.ds(i,3)=[c(1,1)-c(1,2)-c(2,1)+c(2,2)];
    % end

    ytemp.ds(:,3)=1/mcIT;

    y{nP}=dsnorm(ytemp);
end
if length(y)==1
    y=y{1};
end
end