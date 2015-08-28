function [data_train,data_test] = standard_dual(K,output,options)

    %if data contains a collection of datasets
    if iscell(output)
        
        T = numel(output);

        indices_train=cell(T,1);
        output_train=cell(T,1);
        indices_test=cell(T,1);
        output_test=cell(T,1);
        
        curr_idx = 1;
        for t = 1:T
            tmp_indices = [curr_idx:(curr_idx+numel(output{t})-1)]';
            [indices_train{t},output_train{t},indices_test{t},output_test{t}]=internal_cell_sample(tmp_indices,output{t},options); 
            curr_idx = curr_idx+numel(output{t});
        end
        
        indices_train = cell2mat(indices_train);
        indices_test = cell2mat(indices_test);
    end
    
    K_train = K(indices_train,indices_train);
    K_test = K(indices_test,indices_train);
    
    
    data_train = {K_train,output_train};
    data_test = {K_test,output_test};
end


function [indices_train,output_train,indices_test,output_test] = internal_cell_sample(indices,output,options) 

    n = numel(output);
    
    switch options.mode
        case 'ho'
            % hold out
            subsample_idx = floor(options.perc_tr*n);
            
            %avoid having an empty training set
            if subsample_idx<1
                subsample_idx=1;
            end
            
            %avoid having an empty test set
            if subsample_idx==n
                subsample_idx=n-1;
            end

            %rnd_idx = randperm(n);
            rnd_idx = 1:n;
            train_idx = rnd_idx(1:subsample_idx);
            test_idx = rnd_idx((subsample_idx+1):end);
        case 'loo'
          
            error('No leave-one-out method available');
            
    end
        
    indices_train = indices(train_idx,:);
    output_train = output(train_idx,:);
    
    indices_test = indices(test_idx,:);
    output_test = output(test_idx,:);
end
