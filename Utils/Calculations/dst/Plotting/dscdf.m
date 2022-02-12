function dscdf(x,varargin)
%=========================================================================   
% dscdf
%=========================================================================   
% dscdf(x) 
% 
% Plots Bel(-inf,x) and Pl(-inf,x), the analogon to a cdf of x. Good for
% visualization of a BPA
%
% Input:
% x: Dempster-Shafer structure
% varargin: Arbitrary number of commands passed through to the matlab
% "plot" function. See "help plot" for further documentation".
%
% Output:
% none
%
% Usage:
% lambda=dsstruct([2,3,1])
% x=dsodf('expinv',1000,lambda)
% dscdf(x,'color','green','linewidth',3)
%=========================================================================
% Copyright (c) Philipp Limbourg, University of Duisburg-Essen
% www.uni-duisburg-essen.de/informationslogistik/
%=========================================================================
down(:,1)=x.ds(:,1);
down(:,2)=x.ds(:,3);
down=sortrows(down,1);
up(:,1)=x.ds(:,2);
up(:,2)=x.ds(:,3);
up=sortrows(up,1);
for i=2:size(x.ds,1)
    down(i,2)=down(i-1,2)+down(i,2);
    up(i,2)=up(i-1,2)+up(i,2);    
end
[xa,xb]=stairs([down(1,1);down(:,1);up(size(up,1),1)],[0;down(:,2);1]);
[xc,xd]=stairs([down(1,1);up(:,1)],[0;up(:,2)]);
%plot(xa,xb,'--k',xc,xd,'k','linewidth',1.5);
hold on;
plot(xa,xb,'--k','linewidth',1.5,varargin{:});
plot(xc,xd,'-k','linewidth',1.5,varargin{:});
%xlabel('x','FontSize',12,'fontweight','bold');
%ylabel('p([0,x])','FontSize',12,'fontweight','bold');
    set(gca,'fontsize',12)
xlim([down(1,1)-up(size(up,1),1)*0.02,up(size(up,1),1)*1.02]);
% xlim([0-100000*0.02,100000]);
ylim([-0.0,1.02]);
%legend('Pl([0,x])','Bel([0,x])',4);
legend('Pl','Bel',4);
