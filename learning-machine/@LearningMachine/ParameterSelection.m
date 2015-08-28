

function best_hparams = ParameterSelection(obj,input,output,params_path,paramsel_options)
    
    % Fallback for paramsel options
    if nargin<5
        if isempty(obj.paramsel_options)
            if isempty(obj.options)          
                error('Provide parameters selection options!');
            else
                paramsel_options = obj.options;
            end
        else
            paramsel_options = obj.paramsel_options; 
        end
    end
    
    
    % prepare for whatever it needs to be preprocessed.
    %obj.Preprocess();
        
    best_error = -1;
    best_hparams = {};

    for tmp_p = params_path
        
        params = tmp_p{1};
        
        curr_error = obj.PerformExperiment(input,output,params,paramsel_options);
        
        if best_error>curr_error || best_error < 0
           best_error = curr_error;
           best_hparams = params;
        end
        
        
        if obj.verbose
            for print_p=[params{:}];
                if numel(print_p)==1
                    fprintf('%f ',print_p);
                end
            end

            fprintf('err: %f  best: %f\n',curr_error,best_error); 
        end
            
    end
    
    obj.hyperparameters = best_hparams;
    
    %Train with the best parameters!
    obj.Train(input,output,obj.hyperparameters{:});
    
end


