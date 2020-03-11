% CEP
% REFERENCE: [Yao1999Evolutionary]
% Yao, Xin, Yong Liu, and Guangming Lin. "Evolutionary programming made 
% faster." IEEE Transactions on Evolutionary computation 3.2 (1999): 82-102.
%
% Author: Jialin Liu
% Email: liujl@sustech.edu.cn
% Website: http://www.liujialin.tech/
% Feb 2019; Last revision: 9-Mar-2020

function [bestx, recordedAvgY, recordedBestY]=FEP(funcName,n,lb,ub,nbGens,initialPop)
warning on MATLAB:divideByZero
if nargin < 5
  error('input_example :  not enough input')
end
epsilon=10^(-3);
% Pass the variables
tau=1/sqrt(2*sqrt(n));
taup=1/sqrt(2*n);
q=10; % same as in [Yao1999Evolutionary]
initialEta=3; % same as in [Yao1999Evolutionary]
mu=100; % same as in [Yao1999Evolutionary]
% Generate the initial population
if nargin == 6
	population=initialPop;
else
    population=lb+(ub-lb).*rand(mu,n); % individuals
    population=boundData(population,lb,ub);
end
eta=initialEta*ones(mu,n); % standard deviations for Gaussian mutations
eta=boundData(eta,epsilon);
% Evaluate the population
k=1; % generation number
numEvals=0; % evaluation number
recordedBestY=zeros(1,nbGens);
fitnessParent=zeros(mu,1);
fitnessOffspring=zeros(mu,1);
for i=1:mu
    fitnessParent(i)=evaluate(funcName,population(i,:));
    numEvals=numEvals+1;
end
[bestSoFarFit, bestSoFar]=max(fitnessParent);
bestSoFarX=population(bestSoFar,:);
recordedBestY(k)=max(fitnessParent);
recordedAvgY(k)=mean(fitnessParent);
while (k<nbGens)
    % Reproduction
    offspring=population+eta.*cauchy(mu,n); % offspring
    offspring=boundData(offspring,lb,ub);
    commonRnd=randn(mu,1).*ones(1,n);
    etaOffspring=eta.*exp(taup*commonRnd+tau*randn(mu,n)); % update eta
    etaOffspring=boundData(etaOffspring,epsilon);
    % Evaluate offspring
    for i=1:mu
        fitnessOffspring(i)=evaluate(funcName,offspring(i,:));
        numEvals=numEvals+1;
    end
    % Pairwise comparison (round robin tournament selection)
    numWins=zeros(1,2*mu); % parents, offspring
    fitnessVector=[fitnessParent; fitnessOffspring];
    individualList=[population; offspring];
    etaList=[eta; etaOffspring];
    for i=1:2*mu
        tmp=randperm(2*mu);
        opponents=tmp(1:q);
        wins=find(fitnessVector(opponents)<fitnessVector(i));
        numWins(i)=length(wins);
    end
    [sortedNumWins,sortedNumWinsIndices]=sort(numWins,'descend');
    winners=sortedNumWinsIndices(1:mu);
    threshold=sortedNumWins(mu);
    if threshold~=numWins(winners(end))
        error("Bug here.")
    end
    ties=find(numWins==threshold);
    numTies=length(ties);
    % Break ties
    if numTies>1
        startReplaced=find(winners==ties(1));
        tmp=randperm(numTies);
        selectedTies=tmp(1:mu-startReplaced+1);
        winners(startReplaced:end)=ties(selectedTies);
    end
    % Update
    population=individualList(winners,:);
    fitnessParent=fitnessVector(winners);
    eta=etaList(winners,:);
    [bestSoFarFit, bestSoFar]=max(fitnessVector);
    bestSoFarX=individualList(bestSoFar,:);
    k=k+1;
    recordedBestY(k)=max(fitnessParent);
    recordedAvgY(k)=mean(fitnessParent);
end
[~, idx]=max(fitnessParent);
bestx=population(idx,:);
end

function y=evaluate(funcName,x)
eval(sprintf('objective=@%s;',funcName)); % Do not delete this line
%% TODO: below to implement your own fitness function
%------------- BEGIN CODE --------------
objValue=objective(x); 
y=-objValue;
%------------- END OF CODE --------------
end
