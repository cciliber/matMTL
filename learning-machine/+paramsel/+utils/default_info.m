

function problem_info = default_info()

    paramsel_info.type='ho';
    paramsel_info.n_ho = 10;
    paramsel_info.tr_perc=0.65;
   
    problem_info.paramsel_info=paramsel_info;
    
    problem_info.learning.train_func=@paramsel.train.rls;
    problem_info.sample.sample_func=@paramsel.sample.standard;
    
    problem_info.performance.score_func=@paramsel.score.mse;

    
end