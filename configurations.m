% Configurations
%
% Author: Jialin Liu
% Email: liujl@sustech.edu.cn
% Website: http://www.liujialin.tech/
% Feb 2019; Last revision: 9-Mar-2020
%

addpath('./benchmark/');
addpath('./utils/');
addpath('./optimisers/');
% load benchmark
benchmarkInfo;
% Number of repetitions
configuration.numRuns=50;
configuration.funcIndices=[1:11,13];%length(benchmark);
configuration.generations=[1500, 2000, 5000, 5000, 20000, 1500, 3000, ...
    9000, 5000, 1500, 2000, 100, 100];
