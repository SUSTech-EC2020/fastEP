% CEP
% REFERENCE: [Yao1999Evolutionary]
% Yao, Xin, Yong Liu, and Guangming Lin. "Evolutionary programming made 
% faster." IEEE Transactions on Evolutionary computation 3.2 (1999): 82-102.
%
% Author: Jialin Liu
% Email: liujl@sustech.edu.cn
% Website: http://www.liujialin.tech/
% Feb 2019; Last revision: 9-Mar-2020

function [apprx, appry]=CEP(funcName,n,lb,ub,nbGens,initialPop)
warning on MATLAB:divideByZero
if nargin < 2
  error('input_example :  not enough input')
end
% Pass the variables
tau=1/sqrt(2*sqrt(n));
taup=1/sqrt(2*n);
q=10; % same as in [Yao1999Evolutionary]
initialEta=3; % same as in [Yao1999Evolutionary]
mu=100; % same as in [Yao1999Evolutionary]
% Generate the initial population
if nargin == 3
	population=initialPop;
else
    population=lb+(ub-lb).*rand(mu,n); % individuals
    population=boundData(population,lb,ub);
end
eta=initialEta*ones(mu,n); % standard deviations for Gaussian mutations
% Evaluate the population
k=1; % generation number
numEvals=0; % evaluation number
fitnessParent=zeros(mu,1);
fitnessOffspring=zeros(mu,1);
for i=1:mu
    fitnessParent(i)=evaluate(funcName,population(i,:));
    numEvals=numEvals+1;
end
while (k<nbGens)
    % Reproduction
    offspring=population+eta.*randn(mu,n); % offspring
    offspring=boundData(offspring,lb,ub);
    etaOffspring=eta.*exp(taup*randn(mu,n)+tau*randn(mu,n)); % update eta
    % Evaluate offspring
    for i=1:mu
        fitnessOffspring(i)=evaluate(funcName,offspring(i,:));
        numEvals=numEvals+1;
    end
    % Pairwise comparison (round robin tournament selection)
    numWins=zeros(1,2*n); % parents, offspring
    fitnessVector=[fitnessParent; fitnessOffspring];
    individualList=[population; offspring];
    etaList=[eta; etaOffspring];
    for i=1:2*mu
        selected=randi(n,1,q);
        wins=find(fitnessVector(selected)>fitnessVector(i));
        numWins(i)=length(wins);
    end
    [~,indices]=sort(numWins,'descend');
    % Update
    winners=indices(1:mu);
    population=individualList(winners,:);
    fitnessParent=fitnessVector(winners);
    eta=etaList(winners,:);
    k=k+1;
end
apprx=population(1,:);
appry=fitnessParent(1);
end

function y=evaluate(funcName,x)
eval(sprintf('objective=@%s;',funcName)); % Do not delete this line
%% TODO: below to implement your own fitness function
%------------- BEGIN CODE --------------
objValue=objective(x); 
y=objValue;
%------------- END OF CODE --------------
end
