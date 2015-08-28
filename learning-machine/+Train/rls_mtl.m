

function [test_func,params] = rls_mtl(X,Y,type,varargin)
                    
    %check if the generation property has been called
    if ischar(X)
        type = X;
        test_func = @(X,Y,varargin)Train.rls_mtl(X,Y,type,varargin{:});
        return;
    end


    %check if is multi-label or generic multi-task 
    if iscell(X)
        [test_func,params] = internal_cell(X,Y,type,varargin{:}); 
    else
        [test_func,params] = internal_mat(X,Y,type,varargin{:});
    end
    
end
    
%%


function [test_func,params] = internal_cell(X,Y,type,varargin)


    T = numel(X);
    d = size(X{1},2);
    n = cellfun(@(Y)size(Y,1),Y);

    lambda = varargin{1};
    
    A = eye(T);
    Xmat = cell2mat(X);
    sqrtA = A;
    
    n = size(Xmat,1);
    
    XY = cellfun(@(X,Y)(1.0/numel(Y))*X'*Y,X,Y,'UniformOutput',false);
    
    if(size(XY,2)>1)
        XY = cell2mat(XY');
    else
        XY = cell2mat(XY);
    end

    I = eye(T);
    bigC = zeros(d*T);
    for t=1:T
        bigC = bigC + (1.0/numel(Y{t}))*kron(I(:,t)*I(t,:),X{t}'*X{t});     
    end
    
    
    if(exist(['+Penalty/' type]))
        penalty = @(A) feval(['Penalty.' type],A,varargin{:});
    else
        penalty = @(A)0;
    end
    
    
    loss = @(w,A,W)    sum(cell2mat(cellfun(@(X,Y,w)(1.0/numel(Y))*sum((Y-X*w).^2),X,Y,w,'UniformOutput',false)) ) + lambda*T*trace(A\(W'*W)) + T*penalty(A);
    
    
    
    max_itr = 10000;
    curr_loss = Inf;
    prev_loss = Inf;
    loss_thresh = 1e-4;

    W = zeros(d,T);
    
    t1 = clock;
    tlost = 0;
    for idx_itr = 1:max_itr

        %solve wrt W
        Wp = W;
    
        sqrtAxI = kron(sqrtA,eye(d));
        H = sqrtAxI*bigC*sqrtAxI;
        
        R = chol(H+ T*lambda*eye(d*T));
        w = R\(R'\(sqrtAxI*XY));

        W = reshape(sqrtAxI*w,d,T);

        w = mat2cell(W,d,ones(1,T))';
        
        Ap = A;
        
        %check if the function exists
        if(exist(['+Train/+Internal/rls_mtl_' type]))
            [A,~] = feval(['Train.Internal.rls_mtl_' type],W,varargin{:});
        else
            break;
        end
        
        sqrtA = sqrtm(A);
        
        

        curr_loss = loss(w,A,W);
        
       
        
        if norm(curr_loss-prev_loss)/sqrt(norm(curr_loss)*norm(prev_loss)) < loss_thresh
            break;
        end

        prev_loss = curr_loss;

        
        if norm(W-Wp,'fro')/sqrt(norm(W,'fro')*norm(Wp,'fro'))<1e-02 && norm(A-Ap,'fro')/sqrt(norm(A,'fro')*norm(Ap,'fro'))<1e-02
            break;
        end
        
     
    end

    
    params.W=W;
    params.A=A;
    
    test_func = @(Xtest)Train.rls_test(Xtest,W);

end



%%
function [test_func,params] = internal_mat(X,Y,type,varargin)

    [n,d] = size(X);

    lambda = varargin{1};

    if iscell(Y)
        Y = [Y{:}];
    end
    
    T = size(Y,2);
   
    XY = X'*[X,Y];
    
    XX = XY(:,1:d);
    XY = XY(:,(d+1):end);
    
    U=eye(T);
    da=ones(T,1);
    A=eye(T);

    max_cnt = 1000;
    
    W = zeros(d,T);
    
    [V,D] = eig(XX);
    D = max(diag(D),0);
    
    for idx_itr=1:max_cnt; 
        
        Wp = W;

        XYU = XY*U;
        WU = zeros(d,T);
        for t=1:T
            tmp_d = (da(t)*D+(n*T)*lambda);
            WU(:,t) = diag(tmp_d)\(V'*XYU(:,t));
        end
        
        W = V*WU*diag(da)*U';

        WW = W'*W;
        [U1,D1] = eig(WW);
        sqrtWW = U1*sqrt(D1)*U1';
        
        Ap = A;

        
        %check if the function exists
        if(exist(['+Train/+Internal/rls_mtl_' type]))
            [A,~,da,U] = feval(['Train.Internal.rls_mtl_' type],sqrtWW,varargin{:});
        else
            break;
        end
        
        if norm(W-Wp,'fro')/sqrt(norm(W,'fro')*norm(Wp,'fro'))<1e-02 && norm(A-Ap,'fro')/sqrt(norm(A,'fro')*norm(Ap,'fro'))<1e-02
            break;
        end
        
    end
        
    params = struct;
    params.W=W;
    params.A=A;
    params.n_itr=idx_itr;
    
    test_func = @(Xtest)Train.rls_test(Xtest,W);

end



