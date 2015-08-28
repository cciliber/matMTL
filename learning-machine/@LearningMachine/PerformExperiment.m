

function mean_error = PerformExperiment(obj,input,output,params,options)

    if nargin<4
        options = obj.options;
    end

    
    switch options.mode
        
    
        case 'ho'

            mean_error = zeros(options.n_ho,1);
            
            for idx_ho = 1:options.n_ho

                % split train and test data
                [data_train,data_test] = options.Sample(input,output);

                obj.Train(data_train{:},params{:});
                
                mean_error(idx_ho) = options.Score(data_test{2},obj.Test(data_test{1}));
                
                obj.internal_Test = [];
            end
            
            mean_error = mean(mean_error);%+1*std(mean_error);
            
        case 'loo'
            
            idx_itr=0;
            
            seed = rng;
            
            mean_error = [];
            while true

                idx_itr = idx_itr + 1;
                
                [data_train,data_test] = options.Sample(inputs,outputs,idx_itr,seed);
                
                if numel(data_train)==0
                    break;
                end
                
                obj.Train(data_train{:},params{:});
                
                mean_error(end+1) = options.Score(data_test{2},obj.Test(data_test));
                
                obj.internal_Test = [];
            end
            
            mean_error = mean(mean_error);%+1*std(mean_error);
    end

end
