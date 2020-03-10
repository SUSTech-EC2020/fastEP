% Test file
% Used for testing your optimiser
%
% Author: Jialin Liu
% Email: liujl@sustech.edu.cn
% Website: http://www.liujialin.tech/
% Feb 2019; Last revision: 9-Mar-2020

%% There is not need to edit this file, unless you want to provide/test 
%% different optimisers.
clc
clear all
% load configuration and benchmark
configurations

numFunc=length(configuration.funcIndices);

log="";
% Prepare a table for illustrating results
latexTable="\begin{table}\scriptsize"+newline+"\begin{tabular}{ccccccc";
latexTable=latexTable+"}"+newline+"\hline";
latexTable=latexTable+newline...
    +"\multirow{2}{*}{Function} & \multirow{2}{*}{\#Gens}" ...
    +"& \multicolumn{2}{c}{FEP} & \multicolumn{2}{c}{CEP} & FEP-CEP \\";
latexTable=latexTable+newline+" & & " ...
    +"Mean Best & Std Dev & Mean Best & Std Dev & $t$-test \\";
latexTable=latexTable+newline+"\hline"+newline;

% Save h values for t-test
hValues=zeros(1,numFunc);

% Loop over functions
for funcIdx=configuration.funcIndices
    functionInfo=benchmark(funcIdx);
    objFunc=functionInfo.funcName{1};
    n=functionInfo.dimension;
    lb=functionInfo.bounds(1);
    ub=functionInfo.bounds(2);
    numGens=configuration.generations(funcIdx);
    latexTable=sprintf("%s $f_{%d}$ & %.d",latexTable,funcIdx,numGens);
    
    % Initialise population
    mu=100;
    InitialPop=lb+(ub-lb).*rand(mu,n); % individuals
    InitialPop=boundData(InitialPop,lb,ub);
   
    % FEP
    log=log+sprintf('[FEP Optimisation of function %s]\n',objFunc);
    resFEP=zeros(configuration.numRuns,1);
    toPlot1=zeros(configuration.numRuns,numGens);
    for r=1:configuration.numRuns
        [apprx, appry, recordedFit]=FEP(objFunc,n,lb,ub,numGens,InitialPop);
        log=log+sprintf('RUN %d: Approximate optimal value=%.16f\n', r, -appry);
        log=log+sprintf('RUN %d: Approximate optimum=%s\n', r, mat2str(apprx));
        resFEP(r)=-appry;
        toPlot1(r,:)=-recordedFit;
    end
    log=log+sprintf('FINAL: Averaged approximate optimal value=%.16f (%.16f)\n\n', ...
        mean(resFEP), std(resFEP));
    latexTable=sprintf("%s & %.2g & %.2g",latexTable,mean(resFEP),std(resFEP));

    % CEP
    log=log+sprintf('[CEP Optimisation of function %s]\n',objFunc);
    resCEP=zeros(configuration.numRuns,1);
    toPlot2=zeros(configuration.numRuns,numGens);
    for r=1:configuration.numRuns
        [apprx, appry, recordedFit]=CEP(objFunc,n,lb,ub,numGens,InitialPop);
        log=log+sprintf('RUN %d: Approximate optimal value=%.16f\n', r, -appry);
        log=log+sprintf('RUN %d: Approximate optimum=%s\n', r, mat2str(apprx));
        resCEP(r)=-appry;
        toPlot2(r,:)=-recordedFit;
    end
    log=log+sprintf('FINAL: Averaged approximate optimal value=%.16f (%.16f)\n\n', ...
        mean(resCEP), std(resCEP));
    latexTable=sprintf("%s & %.2g & %.2g",latexTable,mean(resCEP),std(resCEP));
    
    % t-test
    [h,p,ci,stats]=ttest2(resFEP,resCEP,'Alpha',0.05);
    hValues(funcIdx)=h;
%     latexTable=sprintf("%s & %.2g \\\\",latexTable,p);
%     latexTable=latexTable+newline;
    
    % Test
    [p,h]=ranksum(resCEP,resFEP);
    if(h==1)
        if(mean(resFEP)<mean(resCEP))
            decision='w';
        else
            decision='l';
        end
    else
        decision='d';
    end
    latexTable=sprintf("%s & %s \\\\",latexTable,decision);
    latexTable=latexTable+newline;
    
    % Plot
    figure(funcIdx)
    hold on
    plot(mean(toPlot1),'b', 'LineWidth', 2)
    plot(mean(toPlot2),'r', 'LineWidth', 2)
    legend('Best of FEP', 'Best of CEP');
    saveas(gcf, sprintf('figures/f%d',funcIdx), 'pdf') %Save figure
    for offset=[100 200 500]
        figure(funcIdx+offset)
        hold on
        plot([offset:numGens],mean(toPlot1(:,offset:end)),'b', 'LineWidth', 2)
        plot([offset:numGens],mean(toPlot2(:,offset:end)),'r', 'LineWidth', 2)
        legend('Best of FEP', 'Best of CEP');
        saveas(gcf, sprintf('figures/f%d-offset%d',funcIdx,offset), 'pdf') %Save figure
    end
end

% Print hValues
hValues

% Complete and display the table
latexTable=latexTable+"\hline"+newline+"\end{tabular}"+newline+"\end{table}";

disp("%%%%%%%%%% BEGIN PRINT LOG %%%%%%%%%%%%");
disp(log)
disp("%%%%%%%%%% END PRINT LOG %%%%%%%%%%%%");
disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
disp("%%%%%%%%%% BEGIN LATEX TABLE %%%%%%%%%%%%");
disp(latexTable)
disp("%%%%%%%%%% END LATEX TABLE %%%%%%%%%%%%");
