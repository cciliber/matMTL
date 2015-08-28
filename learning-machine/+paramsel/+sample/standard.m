function [data_train,data_test] = standard(data,paramsel_info,idx)

    %if data contains a collection of datasets
    if iscell(data{1})
        T = numel(data{1});
        data_train{1}=cell(T,1);
        data_train{2}=cell(T,1);
        data_test{1} =cell(T,1);
        data_test{2} =cell(T,1);
        
        for t = 1:T
           [tmp_train,tmp_test]=paramsel.sample.standard({data{1}{t},data{2}{t}},paramsel_info); 
        
           data_train{1}{t} = tmp_train{1};
           data_train{2}{t} = tmp_train{2};
           
           data_test{1}{t} = tmp_test{1};
           data_test{2}{t} = tmp_test{2};
        end
        
        return;
    end
    
    [n,d] = size(data{1});
    
    if nargin<3
        % hold out
        subsample_idx = floor(paramsel_info.tr_perc*n);

        rnd_idx = randperm(n);
        train_idx = rnd_idx(1:subsample_idx);
        test_idx = rnd_idx((subsample_idx+1):end);
    else
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
%         
%     if n==d
%        data{1} = data{1}(:,train_idx);
%     end
%     
    data_train{1} = data{1}(train_idx,:);
    data_train{2} = data{2}(train_idx,:);
    
    data_test{1} = data{1}(test_idx,:);
    data_test{2} = data{2}(test_idx,:);

end




