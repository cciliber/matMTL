
function value = perform_experiment(experiment_info)


    value = 0.0;
    
    paramsel_info = experiment_info.paramsel_info;
    
    switch paramsel_info.type
    
        case 'ho'
            
            for idx_ho = 1:paramsel_info.n_ho

                [data_train,data_test] = experiment_info.sample.sample_func(experiment_info.data,paramsel_info);

                test_func = experiment_info.learning.train_func(data_train{:},experiment_info.parameters{:});

                value = value + experiment_info.performance.score_func(data_test{2},test_func(data_test{1}));

            end
            
            value = value/paramsel_info.n_ho;
            
        case 'loo'
            
            idx_itr=0;
            
            while true

                idx_itr = idx_itr + 1;
                
                [data_train,data_test] = experiment_info.sample.sample_func(experiment.info.data,paramsel_info,idx_itr);
                
                if numel(data_train)==0
                    break;
                end
                
                test_func = experiment_info.learning.train_func(data_train{:},parameters{:});

                value = value + experiment_info.performance.score_func(data_test{2},test_func(data_test{1}));
                
            end
            
            value = value/(idx_itr);
    end
    
end
