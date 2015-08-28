
function score = individual_accuracy(output,prediction)

    score = 0.0;
        
    if iscell(output)
        T = 0;
        for t = numel(output)
            if numel(output{t})
                
                score = score + sum(output{t}~=sign(prediction{t}))/numel(output{t});
                T = T + 1;
            end
        end

        if T
            score = score/T;
        end
        
        return;
    else
       
        for t=1:size(output,2)
           score = score + sum(output(:,t)~=sign(prediction(:,t)))/size(output,1); 
        end
        
        score = score/size(output,2);
        
    end
    
    
end