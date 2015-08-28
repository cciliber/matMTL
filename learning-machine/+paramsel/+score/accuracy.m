
function score = accuracy(Ytest,Ypred)

    score = 0.0;
        
    if iscell(Ytest)
        T = 0;
        for t = numel(Ytest)
            if numel(Ytest{t})
                
                score = score + sum(Ytest{t}~=sign(Ypred{t}))/numel(Ytest{t}));
                T = T + 1;
            end
        end

        if T
            score = score/T;
        end
        
        return;
    end
    
    %normalize Ypred between 0 and 1;
    [~,idx] = max(Ypred>0,[],2);

    if min(Ytest(:))<0
        Ytest = 0.5*(Ytest+1);
    end
    
    [~,ex] = max(Ytest,[],2);
    num_observations = length(ex);
    num_classes = size(Ytest,2);
    C = accumarray([ex,Ypred>0],ones(num_observations,1),[num_classes,num_classes]);
    
    score = 1.0-sum(diag(C))/sum(C(:));
end