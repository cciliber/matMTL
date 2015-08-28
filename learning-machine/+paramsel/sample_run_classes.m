
function value = sample_run_classes()

    import paramsel.*;

    n = 1000;
    d = 10;
    T = 3;

    %random model
    X = rand(n,d);
    W = rand(d,T);
    
    Y = X*W + 0.9*randn(n,T);
    
    paramsel_options = LearningOptions;
    
    lambdas = linspace(0,1,100).^20;
    params_path = paramsel.utils.generate_params_path({lambdas});

    
    lm = LearningMachine;
    lm.setTrain(@paramsel.train.rls);
    
    best_params = lm.ParameterSelection(X,Y,paramsel_options,params_path);
    
    display([best_params{:} best_value]);

end