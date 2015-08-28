

function [test_func,params] = rls_mtl_dual(K,Y,type,varargin)
                    
    %check if the generation property has been called
    if ischar(K)
        type = K;
        test_func = @(K,Y,varargin)Train.rls_mtl_dual(K,Y,type,varargin{:});
        return;
    end

    if iscell(K)
        error('K must be a matrix');
    end
    
    %check if is multi-label or generic multi-task 
    if iscell(Y)
        [test_func,params] = internal_cell(K,Y,type,varargin{:}); 
    else
        [test_func,params] = internal_mat(K,Y,type,varargin{:});
    end
    
end
    
%%
function [test_func,params] = internal_cell(K,Y,type,varargin)

    lambda = varargin{1};
            
    n = size(K,1);
    T = numel(Y);
    
    y = zeros(n,1);
    indices = zeros(n,1);
    weightMat = zeros(n,1);
    curr_idx = 1;
    Mask = [];
    bigY = [];
    I = eye(T);
    for t=1:T
        weightMat(curr_idx:(curr_idx-1+numel(Y{t}))) = (1/sqrt(numel(Y{t})))*ones(numel(Y{t}),1);
        indices(curr_idx:(curr_idx-1+numel(Y{t}))) = t*ones(numel(Y{t}),1);
        y(curr_idx:(curr_idx-1+numel(Y{t}))) = Y{t};
        
        Mask = [Mask; (1.0/sqrt(numel(Y{t}))) * I(t*ones(numel(Y{t}),1),:)];
        bigY = [bigY; repmat(Y{t},1,T)];
        
        curr_idx = curr_idx+numel(Y{t});
    end
    weightMat = diag(weightMat);
    
    
    A = eye(T);
    C = zeros(n,T);
    
    if(exist(['+Penalty/' type]))
        penalty = @(A) feval(['Penalty.' type],A,varargin{:});
    else
        penalty = @(A)0;
    end

    loss = @(C,A,CKC) norm(Mask.*(bigY-K*C),'fro')^2 + lambda*T*trace(A\CKC) + T*penalty(A);
    
%     
%     [V,D] = eig(K);
%     D = max(diag(D),0);
%     sqrtD = diag(sqrt(D));
%     sqrtK = V*sqrtD*V';
    
    prev_err = zeros(2,1);
    prev_err(1) = Inf;
    prev_err(2) = Inf;
    curr_err = zeros(2,1);
    
    err_thresh = 1e-8;
    max_itr = 1000;
    err_itr = zeros(max_itr,1);

    curr_loss = Inf;
    prev_loss = Inf;
    loss_thresh = 1e-8;

    
    tlost = 0;
    
    t1 = clock;
    for idx_itr = 1:max_itr

        %solve wrt C
        Cp = C;
        
        R = chol(weightMat*(K.*A(indices,indices))*weightMat+T*lambda*eye(n));
        
        c = weightMat*(R\(R'\(weightMat*y)));
        C = diag(c)*A(indices,:);
        
        
        %sqrtKC = sqrtK*C;
        CKC = C'*(K*C);
        [V,D] = eig(0.5*(CKC+CKC'));
        sqrtCKC = V*diag(sqrt(max(0,diag(D))))*V';
        
        
        tic;
        curr_loss = loss(C,A,CKC);
        tlost = tlost+toc;
        
        tic;
        if curr_loss>prev_loss + 1
        [curr_loss prev_loss-curr_loss];
            ciao = 3;
        end
        
        if norm(curr_loss-prev_loss)/sqrt(norm(curr_loss)*norm(prev_loss)) < loss_thresh
            break;
        end

        prev_loss = curr_loss;
        
        
        Ap = A;

        %check if the function exists
        if(exist(['+Train/+Internal/rls_mtl_' type]))
            [A,~,~,~] = feval(['Train.Internal.rls_mtl_' type],sqrtCKC,varargin{:});
        else
            break;
        end
        
        
        
        
        
        
%         %fprintf('%s: %e %e\n',type,curr_err(1),curr_err(2));
%         %display([norm(C-Cp,'fro') norm(A-Ap,'fro')]);
        
        curr_err(1) = norm(C-Cp,'fro');
        curr_err(2) = norm(A-Ap,'fro');
       
        
        if norm(K*(C-Cp),'fro')/sqrt(norm(K*C,'fro')*norm(K*Cp,'fro'))<1e-02 && norm(A-Ap,'fro')/sqrt(norm(A,'fro')*norm(Ap,'fro'))<1e-02
            break;
        end
        
        prev_err = curr_err;
%         
    end
    ttot = etime(clock,t1);
    
    %display(['exit. tlost = ' num2str(tlost) ' ' num2str(ttot)]);
    
    
    params.C=C;
    params.A=A;
    params.err = err_itr(1:idx_itr);
    params.n_itr = idx_itr;
    
    test_func = @(Ktest)Train.rls_test(Ktest,C);

end




%%
function [test_func,params] = internal_mat(K,Y,type,varargin)

    lambda = varargin{1};
    
    [n,T] = size(Y);
   
    U=eye(T);
    da=ones(T,1);
    A=eye(T);

    max_cnt = 1000;
    
    err_itr = zeros(max_cnt,1);
    
    
    C = zeros(n,T);
    
    [V,D] = eig(K);
    D = max(diag(D),0);
    sqrtD = diag(sqrt(D));
    
    
    for idx_itr=1:max_cnt; 
        
        Cp = C;

        YU = Y*U;
        CU = zeros(n,T);
        for t=1:T
            tmp_d = (da(t)*D+(n*T)*lambda);
            CU(:,t) = diag(tmp_d)\(V'*YU(:,t));
        end

        C = V*CU*diag(da)*U';
        
        
        CtKC = U*diag(da)*CU'*diag(D)*CU*diag(da)*U';
        [U1,D1] = eig(CtKC);
        sqrtCtKC = U1*sqrt(D1)*U1';
        
        Ap = A;

        
        %check if the function exists
        if(exist(['+Train/+Internal/rls_mtl_' type]))
            [A,~,da,U] = feval(['Train.Internal.rls_mtl_' type],sqrtCtKC,varargin{:});
        else
            break;
        end
        
        if norm(C-Cp,'fro')/sqrt(norm(C,'fro')*norm(Cp,'fro'))<1e-04 && norm(A-Ap,'fro')/sqrt(norm(A,'fro')*norm(Ap,'fro'))<1e-04
            break;
        end

    end
        
    params.C=C;
    params.A=A;
    params.n_itr=idx_itr;
    
    test_func = @(Ktest)Train.rls_test(Ktest,C);

end




