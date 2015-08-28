
function score = accuracy(output,prediction)

    score = 0.0;
        
    if iscell(output)
        output = [output{:}];
        prediction = [prediction{:}];
    end
    
    [~,idx] = max(prediction,[],2);

    if min(output(:))<0
        output = 0.5*(output+1);
    end
    
    [~,ex] = max(output,[],2);
    num_observations = length(ex);
    num_classes = size(output,2);
    C = accumarray([ex,idx],ones(num_observations,1),[num_classes,num_classes]);
    
    score = 1.0-sum(diag(C))/sum(C(:));
end