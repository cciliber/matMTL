

function [test_func,params] = rls(IN,Y,lambda)


    [n,d]=size(IN);

    P = eye(n)-ones(n)/n;
    Yc = P*Y;
    
    if n~=d
        
        X = IN;
        
        Xc = P*X;

        R = chol(Xc'*Xc + lambda*eye(d));
        W = R\(R'\(Xc'*Yc));
        b = mean(Y,1) - mean(X,1)*W;
        
    else
        
        K = IN;
        
        Kc = P*K*P;
        
        R = chol(Kc + lambda*eye(n));
        W = R\(R'\Yc);
        b = mean(Y,1) - (1.0/n)*ones(1,n)*K*W;
        
    end

    test_func = @(INtest) INtest*W+ones(size(INtest,1),1)*b;
    
    params.W=W;
    params.b=b;
end

