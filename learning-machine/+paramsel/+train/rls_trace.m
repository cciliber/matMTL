

function [test_func,params] = rls_trace(IN,Y,lambda)


    [n,d]=size(IN);

    P = eye(n)-ones(n)/n;
    Yc = P*Y;
    
    T = size(Y,2);
    
    if n~=d
        
        X = IN;
        
        Xc = P*X;


        cvx_begin sdp
            variable W(d,T);
            variable A(T,T) symmetric;
            variable C(d,d) symmetric;
            
            minimize(pow_pos(norm(Yc-Xc*W,'fro'),2) + lambda*(trace(C)+trace(A)) );
            
            subject to
                [A W';W C] >= 0;
        cvx_end
        
        
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
    params.A=A;
end

