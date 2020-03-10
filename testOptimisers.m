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
configuration

numFunc=length(configuration.funcIndices);
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
    numGens=configuration.generations(funcIdx);
    latexTable=sprintf("%s $f_{%d}$ & %.d",latexTable,funcIdx,numGens);
    
    %FEP
    fprintf('[FEP Optimisation of function %s]\n',objFunc);
    resFEP=zeros(1,configuration.numRuns);
    for r=1:configuration.numRuns
        [apprx, appry]=FEP(objFunc,functionInfo.dimension, ...
            functionInfo.bounds(1),functionInfo.bounds(2), ...
            numGens);
        fprintf('RUN %d: Approximate optimal value=%.16f\n', r, appry);
        fprintf('RUN %d: Approximate optimum=%s\n', r, mat2str(apprx));
        resFEP(r)=appry;
    end
    fprintf('FINAL: Averaged approximate optimal value=%.16f (%.16f)\n\n', ...
        mean(resFEP), std(resFEP));
    latexTable=sprintf("%s & %.2g & %.2g",latexTable,mean(resFEP),std(resFEP));

    %CEP
    fprintf('[CEP Optimisation of function %s]\n',objFunc);
    resCEP=zeros(1,configuration.numRuns);
    for r=1:configuration.numRuns
        [apprx, appry]=CEP(objFunc,functionInfo.dimension, ...
            functionInfo.bounds(1),functionInfo.bounds(2), ...
            numGens);
        fprintf('RUN %d: Approximate optimal value=%.16f\n', r, appry);
        fprintf('RUN %d: Approximate optimum=%s\n', r, mat2str(apprx));
        resCEP(r)=appry;
    end
    fprintf('FINAL: Averaged approximate optimal value=%.16f (%.16f)\n\n', ...
        mean(resCEP), std(resCEP));
    latexTable=sprintf("%s & %.2g & %.2g",latexTable,mean(resCEP),std(resCEP));
    
    % t-test
    [h,p,ci,stats]=ttest2(resFEP,resCEP,'Alpha',0.05);
    hValues(funcIdx)=h;
    latexTable=sprintf("%s & %.2g \\\\",latexTable,p);
    latexTable=latexTable+newline;
end

% Complete and display the table
latexTable=latexTable+"\hline"+newline+"\end{tabular}"+newline+"\end{table}";
disp("%%%%%%%%%% BEGIN LATEX TABLE %%%%%%%%%%%%");
disp(latexTable)
disp("%%%%%%%%%% END LATEX TABLE %%%%%%%%%%%%");
