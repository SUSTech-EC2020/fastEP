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
close all
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
    +"Mean Best & Std Dev & Mean Best & Std Dev & Wilcoxon \\";
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
    plotFEPBest=zeros(configuration.numRuns,numGens);
    plotFEPAvg=zeros(configuration.numRuns,numGens);
    for r=1:configuration.numRuns
        [bestx, recordedAvgY, recordedBestY]=FEP(objFunc,n,lb,ub,numGens,InitialPop);
        recordedBestY=-recordedBestY;
        recordedAvgY=-recordedAvgY;
        besty=recordedBestY(end);
        log=log+sprintf('RUN %d: Approximate optimal value=%.16f\n', r, besty);
        log=log+sprintf('RUN %d: Approximate optimum=%s\n', r, mat2str(bestx));
        resFEP(r)=besty;
        plotFEPBest(r,:)=recordedBestY;
        plotFEPAvg(r,:)=recordedAvgY;
    end
    log=log+sprintf('FINAL: Averaged approximate optimal value=%.16f (%.16f)\n\n', ...
        mean(resFEP), std(resFEP));
    latexTable=sprintf("%s & %.2g & %.2g",latexTable,mean(resFEP),std(resFEP));

    % CEP
    log=log+sprintf('[CEP Optimisation of function %s]\n',objFunc);
    resCEP=zeros(configuration.numRuns,1);
    plotCEPBest=zeros(configuration.numRuns,numGens);
    plotCEPAvg=zeros(configuration.numRuns,numGens);
    for r=1:configuration.numRuns
        [bestx, recordedAvgY, recordedBestY]=CEP(objFunc,n,lb,ub,numGens,InitialPop);
        recordedBestY=-recordedBestY;
        recordedAvgY=-recordedAvgY;
        besty=recordedBestY(end);
        log=log+sprintf('RUN %d: Approximate optimal value=%.16f\n', r, besty);
        log=log+sprintf('RUN %d: Approximate optimum=%s\n', r, mat2str(bestx));
        resCEP(r)=besty;
        plotCEPBest(r,:)=recordedBestY;
        plotCEPAvg(r,:)=recordedAvgY;
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
            decision='win';
        else
            decision='loss';
        end
    else
        decision='draw';
    end
    latexTable=sprintf("%s & %s \\\\",latexTable,decision);
    latexTable=latexTable+newline;
    
    % Plot
    figure(funcIdx)
    hold on
    plot(mean(plotFEPBest),'b', 'LineWidth', 2)
    plot(mean(plotCEPBest),'r', 'LineWidth', 2)
    legend('Best of FEP', 'Best of CEP','FontSize',20);
    set(gca,'FontSize',20)
    saveas(gcf, sprintf('figures/f%d-best',funcIdx), 'pdf') %Save figure
    close(funcIdx)
    for offset=[100 200 500]
        if (numGens>offset)
            figure(funcIdx+offset)
            hold on
            plot([offset:numGens],mean(plotFEPBest(:,offset:end)),'b', 'LineWidth', 2)
            plot([offset:numGens],mean(plotCEPBest(:,offset:end)),'r', 'LineWidth', 2)
            legend('Best of FEP', 'Best of CEP','FontSize',20);
            set(gca,'FontSize',20)
            saveas(gcf, sprintf('figures/f%d-best-offset%d',funcIdx,offset), 'pdf') %Save figure
            close(funcIdx+offset)
        end
    end
    
    figure(funcIdx)
    hold on
    plot(mean(plotFEPAvg),'b', 'LineWidth', 2)
    plot(mean(plotCEPAvg),'r', 'LineWidth', 2)
    legend('Average of FEP', 'Average of CEP','FontSize',20);
    set(gca,'FontSize',20)
    saveas(gcf, sprintf('figures/f%d-avg',funcIdx), 'pdf') %Save figure
    close(funcIdx)
    for offset=[100 200 500]
        if (numGens>offset)
            figure(funcIdx+offset)
            hold on
            plot([offset:numGens],mean(plotFEPAvg(:,offset:end)),'b', 'LineWidth', 2)
            plot([offset:numGens],mean(plotCEPAvg(:,offset:end)),'r', 'LineWidth', 2)
            legend('Average of FEP', 'Average of CEP','FontSize',20);
            set(gca,'FontSize',20)
            saveas(gcf, sprintf('figures/f%d-avg-offset%d',funcIdx,offset), 'pdf') %Save figure
            close(funcIdx+offset)
        end
    end
    
    disp("%%%%%%%%%% BEGIN PRINT LOG %%%%%%%%%%%%");
    disp(log)
    disp("%%%%%%%%%% END PRINT LOG %%%%%%%%%%%%");
    disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    disp("%%%%%%%%%% BEGIN LATEX TABLE %%%%%%%%%%%%");
    disp(latexTable)
    disp("%%%%%%%%%% END LATEX TABLE %%%%%%%%%%%%");
    disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    save(sprintf('res/f%d.mat',funcIdx));
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
