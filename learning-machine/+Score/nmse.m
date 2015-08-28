
function score = nmse(output,prediction)

    score = [];
    if iscell(output)
        T = 0;

        curr_idx = 1;
        for t=1:numel(output)
            
            if numel(output{t}) 
                T = T + 1;
                if iscell(prediction)
                    score = [score;internal_nmse(output{t},prediction{t})];
                else
                    score = [score;internal_nmse(output{t},prediction(curr_idx:(curr_idx+numel(output{t})-1),t))];
                    curr_idx = curr_idx+numel(output{t});
                end
            end
        end
        
        score = mean(score);
        
        return;
    end
    
    score = ((output-prediction).^2)./var(output,0,1);
    score = mean(score);

end

function score = internal_nmse(output,prediction)
    score = ((output-prediction).^2)./var(output,0,1);
end

% 
% function score = nmse(output,prediction)
% 
%     score = 0.0;
%     if iscell(output)
%         T = 0;
%         for t=1:numel(output)
%             if numel(output{t}) 
%                 T = T + 1;
%                 score = score + Score.nmse(output{t},prediction{t});
%             end
%         end
%         
%         if T
%             score = score/T;
%         end
%         
%         return;
%     end
% 
%     score = mean(mean((output-prediction).^2,1)./var(output,0,1));
% 
% end



