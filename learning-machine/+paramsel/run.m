

function [best_params,best_value] = run(problem_info)

    import paramsel.*

    %fallbacks for the score and sample functions
    problem_info = utils.fallback_info(problem_info);
        
    %explore the list of parameters and choose the best one
    best_value = -1;
    best_params = {};

    for tmp_p = problem_info.paramsel_info.params_path
        
        p = tmp_p{1};
        experiment_info = problem_info;
        experiment_info.parameters=p;
        
        value = perform_experiment(experiment_info);

        if best_value>value || best_value < 0
           best_value = value;
           best_params = p;
        end
        
        for tmp_p=[p{:}];
            if numel(tmp_p)==1
                fprintf('%f ',tmp_p);
            end
        end
                
        fprintf('val: %f  best: %f\n',value,best_value); 
    end

end


