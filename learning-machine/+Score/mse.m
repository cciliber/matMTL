
function score = mse(output,prediction)

    score = 0.0;
    if iscell(output)
        T = 0;
        
        
        curr_idx = 1;
        for t=1:numel(output)
            if numel(output{t}) 
                T = T + 1;
                if iscell(prediction)
                    score = score + Score.mse(output{t},prediction{t});
                else
                    score = score + Score.mse(output{t},prediction(curr_idx:(curr_idx+numel(output{t})-1),t));
                    curr_idx = curr_idx+numel(output{t});
                end
            end
        end
        
        if T
            score = score/T;
        end
        
        return;
    end

    score = mean(mean((output-prediction).^2,1));

end