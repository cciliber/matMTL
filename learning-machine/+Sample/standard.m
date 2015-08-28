function [data_train,data_test] = standard(input,output,options)

    %if data contains a collection of datasets
    if iscell(input)
        T = numel(input);
        data_train{1}=cell(T,1);
        data_train{2}=cell(T,1);
        data_test{1} =cell(T,1);
        data_test{2} =cell(T,1);
        
        for t = 1:T
           [tmp_train,tmp_test]=Sample.standard(input{t},output{t},options); 
        
           data_train{1}{t} = tmp_train{1};
           data_train{2}{t} = tmp_train{2};
           
           data_test{1}{t} = tmp_test{1};
           data_test{2}{t} = tmp_test{2};
        end
        
        return;
    end
    
    [n,d] = size(input);
    
    switch options.mode
        case 'ho'
            % hold out
            subsample_idx = floor(options.perc_tr*n);
            
            %avoid having an empty training set
            if subsample_idx<1
                subsample_idx=1;
            end
            
            %avoid having an empty validation set
            if subsample_idx==n
                subsample_idx=n-1;
            end

            rnd_idx = randperm(n);
            train_idx = rnd_idx(1:subsample_idx);
            test_idx = rnd_idx((subsample_idx+1):end);
        case 'loo'
            % leave-one out

            %if the loo has been completed, return void vectors
            if idx>n
               data_train = [];
               data_test = [];
               return;
            end

            train_idx = idx;
            test_idx = [1:(idx-1),(idx+1):n];
    end
        
    if ~options.primal
       input = input(:,train_idx);
    end
    
    data_train{1} = input(train_idx,:);
    data_train{2} = output(train_idx,:);
    
    data_test{1} = input(test_idx,:);
    data_test{2} = output(test_idx,:);

end




