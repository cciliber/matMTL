

function score = auc_pr(output,prediction)


    score = 0.0;
        
    if iscell(output)
        T = 0;
        for t = 1:numel(output)
            if numel(output{t})
                score = score + Score.auc_roc(output{t},prediction{t});
                T = T + 1;
            end
        end

        if T
            score = score/T;
        end
        
        return;
    end
    
    if min(output(:))==0
        output = 2*output-1;
    end
    
    tmp_score=0.0;
    for t=1:size(output,2)
        [~,~,pr] = vl_pr(output(:,t),prediction(:,t));
        tmp_score = tmp_score+(1.0-pr.auc_pa08);
    end
    score=tmp_score/size(output,2);
    
    
%     [~,~,roc] = vl_roc(output,prediction);
%     score = 1.0-roc.auc;


end


