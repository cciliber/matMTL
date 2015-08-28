function [A,Ai,da,UA] = internal_rls_mtl_nuc(W,lambda,gamma)

    [d,T] = size(W);

    if nargin<3
        gamma = lambda;
    end
    
    [~,da,UA] = svd(W);
    da = [da, zeros(T,T-d)];
    
    da = diag(da).^2;

    
    %solve by optimtoolbox
    options = optimset('Algorithm','interior-point');
    options = optimset(options,'GradObj','on','GradConstr','on');
    %options = optimset(options,'Display','iter');
    options = optimset(options,'Display','none');

    lb = zeros(numel(WS),1);
    a0 = ones(numel(WS),1);

    [da,~,~,~] = fmincon(@(a)nuc_function(a,(lambda/gamma)*da,size(W,1)),a0,[],[],[],[],lb,[],[],options);

    A = UA*diag(da)*UA';
    dai = da;
    dai(dai>0)=dai(dai>0).^-1;
    Ai = UA*diag(dai)*UA';

end


function [f,fg] = nuc_function(a,b,T)

    norm_a = norm(a);
    
    f = sum(b./a) + 2*sqrt(T)*sum(a) + 4*T*norm_a;
    
    if nargout>1
        bcell = num2cell(b);
        acell = num2cell(a);
        fg = cellfun(@(acell,bcell)(-bcell/(acell^2) + 2*sqrt(T) + 4*T*acell/norm_a),acell,bcell);
    end

end
