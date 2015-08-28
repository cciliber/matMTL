function [test_spl,params] = rls_mtl_sparse(X,Y,lambda,gamma,eta)

    if nargin<4
        gamma=lambda;
    end

    if nargin<5
        eta = gamma;
    end

    fro2 = @(M)pow_pos(norm(M,'fro'),2);
    l1 = @(M)norm(M(:),1);
    
    [n,d] = size(X);
    T = size(Y,2);

    Xc = X-ones(size(X,1),1)*mean(X,1);
    Yc = Y-ones(size(Y,1),1)*mean(Y,1);
    
    Xc = X;
    Yc = Y;

    cvx_quiet(true);
    cvx_begin
        variable W(d,T);
        variable A(T,T);
        variable C(d,d);

        minimize( fro2(Yc-Xc*W) + n*(lambda*trace(C) + gamma*(l1(A)) + eta*fro2(A)) );

        subject to
            [A W'; W C] == semidefinite(d+T,d+T);
    cvx_end
    cvx_quiet(true);
    
    b = mean(Y,1) - mean(X,1)*W;
    b = zeros(1,T);

    test_spl = @(Xtest) Xtest*W+ones(size(Xtest,1),1)*b;
    
    params.W=W;
    params.b=b;
    params.A=A;
end
