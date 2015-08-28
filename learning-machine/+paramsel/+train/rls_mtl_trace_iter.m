
function [test_func,params] = rls_mtl_trace_iter(X,Y,lambda,gamma)

    if nargin<4
        gamma = lambda;
    end

    d = size(X{1},2);
    T = numel(X);

    U = cell(T,1);
    D = cell(T,1);
    XY = cell(T,1);
    n = cell(T,1);
    
    for t=1:T
        %center the data
        Xc = bsxfun(@minus,X{t},mean(X{t}));
        Yc = bsxfun(@minus,Y{t},mean(Y{t}));
        
        Xc = X{t};
        Yc = Y{t};
        
        n{t} = size(Xc,1);
        
        [U{t},Dt]=eig(Xc'*Xc);
        D{t} = max(diag(Dt),0);
        XY{t} = Xc'*Yc;
    end
    
    max_itr = 100;
    max_w_itr = 100;

    
    b = zeros(1,T);
    
    A = eye(T);
    Ai = A;
        
    W = zeros(d,T);

    for idx_itr = 1:max_itr

        %solve wrt W
        Wp = W;
        
        for idx_w_itr = 1:max_w_itr
            Wpp = W;

            for t = 1:T
                tmp_d = (D{t}+n{t}*lambda*Ai(t,t));
                %tmp_d(tmp_d<1e-7)=0;
                tmp_d(tmp_d>0) = tmp_d(tmp_d>0).^-1;
                W(:,t) = U{t}*diag(tmp_d)*U{t}'*(XY{t} - n{t}*lambda*W(:,[1:(t-1),(t+1):T])*Ai([1:(t-1),(t+1):T],t));
            end
            
            if norm(W-Wpp,'fro')<1e-8
                break;
            end
        end


        Ap = A;
        [V,S] = eig(W'*W);%+1e-8*eye(T));
        A = sqrt(lambda/gamma)*V*sqrt(S)*V';
        Ai = pinv(A);

        %display([norm(W-Wp,'fro') norm(A-Ap,'fro')]);
        
        if norm(W-Wp,'fro')<1e-2 && norm(A-Ap,'fro')<1e-2
            break;
        end

    end

    
    for t=1:T
        b(t) =  mean(Y{t}) - mean(X{t})*W(:,t);
        b(t) = 0;
    end
   
    
    params.W=W;
    params.b=b;
    params.A=A;
    
    test_func = @(Xtest)test_rls_mtl_trace_itr(Xtest,W,b);

end


function Ypred = test_rls_mtl_trace_itr(Xtest,W,b)
    

    if iscell(Xtest)

        T = numel(Xtest);

        Ypred = cell(T,1);

        for t = 1:T
            Ypred{t} = Xtest{t}*W(:,t)+ones(size(Xtest{t},1),1)*b(t);        
        end

    else 
        Ypred = Xtest*W+ones(size(Xtest,1),1)*b;
    end
end


