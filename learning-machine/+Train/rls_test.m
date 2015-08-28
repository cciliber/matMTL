
function Ypred = rls_test(INtest,W,b)
    
    if iscell(INtest)

        T = numel(INtest);

        if nargin<3
            b = zeros(1,T);
        end
       
        Ypred = cell(T,1);

        for t = 1:T
            Ypred{t} = INtest{t}*W(:,t)+ones(size(INtest{t},1),1)*b(t);        
        end

    else
        if nargin<3
            b = zeros(1,size(W,2));
        end
        
        Ypred = INtest*W+ones(size(INtest,1),1)*b;
    end
end
