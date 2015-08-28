
function score = auc_roc(Ytest,Ypred)


    score = 0.0;
        
    if iscell(Ytest)
        T = 0;
        for t = 1:numel(Ytest)
            if numel(Ytest{t})
                score = score + paramsel.score.auc_roc(Ytest{t},Ypred{t});
                T = T + 1;
            end
        end

        if T
            score = score/T;
        end
        
        return;
    end
    
    
    [~,~,roc] = vl_roc(Ytest,Ypred);
    score = 1.0-roc.auc;
end