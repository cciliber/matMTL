
addpath('learning-machine');

%%

% parameters for the example

noise = 0.1;

d = 100;
T = 10;

ntr = 100;
nts = 100;


%% generate random data - General Setting

% If during training not all outputs are available for a given input point,
% training/test data must be organized in a cell array. Once cell for each
% task.

W = rand(d,T);


Xtr = cell(T,1);
Ytr = cell(T,1);
Xts = cell(T,1);
Yts = cell(T,1);

for t=1:T
   Xtr{t} = rand(ntr,d);
   Ytr{t} = Xtr{t}*W(:,t)+noise*norm(Xtr{t},'fro')*randn(size(Xtr{t},1),1);
    
   Xts{t} = rand(nts,d);
   Yts{t} = Xts{t}*W(:,t)+noise*norm(Xts{t},'fro')*randn(size(Xts{t},1),1);
    
end


%% Training and Testing - Primal
lambda = 1;
verbose = true;




% The output kernel learning modality (independent, trace, frobenius, etc.)
methods = {Train.rls_mtl('ind'),Train.rls_mtl('trace'),Train.rls_mtl('frobenius'), };


% adding also the case of a known matrix A (here just a random matrix
A = rand(T);
A = A*A'; % needs to be psd of course

tmp_train_method = Train.rls_mtl('fix');
methods{end+1} = @(X,Y,lambda) tmp_train_method(X,Y,lambda,A);
% ----------



time_methods = zeros(numel(methods),1);
scores_methods = zeros(numel(methods),1);
    
for idx_meth=1:numel(methods)
    
    % prepare the learning machine 
    lm = LearningMachine;
    
    lm.verbose = verbose;
    
    % set the output kernel learning modality
    lm.setTrain(methods{idx_meth});

    
    % call the Train/Test methods
    tic();
    lm.Train(Xtr,Ytr,lambda);
    time_methods(idx_meth)=toc();
    
    
    Ypred = lm.Test(Xts);
    scores_methods(idx_meth)=Score.mse(Yts,Ypred);
end


[scores_methods']






%% Training and Testing - Dual
% the empirical kernel matrix Ktr is the one "combining" all the training
% inputs from all tasks (this is effectively the way information is
% "shared" across tasks)

lambda = 1;
verbose = true;

% The output kernel learning modality (independent, trace, frobenius, etc.)
methods = {Train.rls_mtl_dual('ind'),Train.rls_mtl_dual('trace'),Train.rls_mtl_dual('frobenius')};%,Train.rls_mtl('sparse')};%,@okl_wrapper};

% adding also the case of a known matrix A (here just a random matrix
A = rand(T);
A = A*A'; % needs to be psd of course

tmp_train_method = Train.rls_mtl_dual('fix');
methods{end+1} = @(X,Y,lambda) tmp_train_method(X,Y,lambda,A);
% ----------

time_methods = zeros(numel(methods),1);
scores_methods = zeros(numel(methods),1);
    

% compute the kernel matrix
% In this example we use linear kernel. Of course any kernel could be used.
Xtmp = cell2mat(Xtr);
Ktr = Xtmp*Xtmp';

Kts = cell(T,1);
for idx_t=1:T
    Kts{idx_t}=Xts{idx_t}*Xtmp';
end

for idx_meth=1:numel(methods)
    
    % prepare the learning machine 
    lm = LearningMachine;
    
    lm.verbose = verbose;
    
    % set the output kernel learning modality
    lm.setTrain(methods{idx_meth});

    
    % call the Train/Test methods
    tic();
    lm.Train(Ktr,Ytr,lambda);
    time_methods(idx_meth)=toc();
    

    Ypred = lm.Test(Kts);
    scores_methods(idx_meth)=Score.mse(Yts,Ypred);
end


[scores_methods']






%% generate random data - Multi Output Setting

% If during training all the tasks' outputs are available for a given input point,
% training/test data can be organized in a cell array. This often allows
% for more efficient computations.

W = rand(d,T);

Xtr = rand(ntr,d);
Ytr = Xtr*W+noise*norm(Xtr,'fro')*rand(ntr,T);

Xts = rand(nts,d);
Yts = Xts*W+noise*norm(Xts,'fro')*rand(nts,T);




%% Training and Testing - Primal
lambda = 1;
verbose = true;

% The output kernel learning modality (independent, trace, frobenius, etc.)
methods = {Train.rls_mtl('ind'),Train.rls_mtl('trace'),Train.rls_mtl('frobenius')};%,Train.rls_mtl('sparse')};%,@okl_wrapper};

time_methods = zeros(numel(methods),1);
scores_methods = zeros(numel(methods),1);
    
for idx_meth=1:numel(methods)
    
    % prepare the learning machine 
    lm = LearningMachine;
    
    lm.verbose = verbose;
    
    % set the output kernel learning modality
    lm.setTrain(methods{idx_meth});

    tic();
    % Usage of train/test methods is identical
    lm.Train(Xtr,Ytr,lambda);
    time_methods(idx_meth)=toc();
    
    
    Ypred = lm.Test(Xts);
    scores_methods(idx_meth)=Score.mse(Yts,Ypred);
end


[scores_methods']



%% Training and Testing - Dual
lambda = 1;
verbose = true;

% The output kernel learning modality (independent, trace, frobenius, etc.)
methods = {Train.rls_mtl_dual('ind'),Train.rls_mtl_dual('trace'),Train.rls_mtl_dual('frobenius')};%,Train.rls_mtl('sparse')};%,@okl_wrapper};

time_methods = zeros(numel(methods),1);
scores_methods = zeros(numel(methods),1);

Ktr = Xtr*Xtr';
Kts = Xts*Xtr';    

for idx_meth=1:numel(methods)
    
    % prepare the learning machine 
    lm = LearningMachine;
    
    lm.verbose = verbose;
    
    % set the output kernel learning modality
    lm.setTrain(methods{idx_meth});

    tic();
    % Usage of train/test methods is identical
    lm.Train(Ktr,Ytr,lambda);
    time_methods(idx_meth)=toc();
    
    
    Ypred = lm.Test(Kts);
    scores_methods(idx_meth)=Score.mse(Yts,Ypred);
end


[scores_methods']





