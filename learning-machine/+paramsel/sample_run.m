
function value = sample_run()

    n = 1000;
    d = 10;
    T = 3;

    %random model
    X = rand(n,d);
    W = rand(d,T);
    
    Y = X*W + 0.9*randn(n,T);
    
    problem_info = paramsel.utils.default_info();
    
    lambdas = linspace(0,1,100).^20;
    problem_info.paramsel_info.params_path = paramsel.utils.generate_params_path({lambdas});
    
    problem_info.data = {X,Y};

    [best_params,best_value] = paramsel.run(problem_info); 
    
    display([best_params{:} best_value]);

end