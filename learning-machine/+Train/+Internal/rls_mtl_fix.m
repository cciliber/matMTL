function [A,Ai,da,UA] = internal_rls_mtl_fix(W,lambda,A)
   
    [d,T] = size(W);

    if nargin<3
        A = eye(T);
    end
    
    [UA,da] = eig(A);
    da = max(diag(da),0);
    dai = da;
    dai(dai>0)=dai(dai>0).^-1;
    Ai = UA*diag(dai)*UA';

end
