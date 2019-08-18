function [A,Ai,da,UA] = internal_rls_mtl_trace_fro(W,lambda,gamma1,gamma2)

    [d,T] = size(W);

    if nargin<3
        gamma1 = lambda;
    end
    
    if nargin<4
        gamma2 = gamma1;
    end
    
    [~,da,UA] = svd(W);
    if(T>d)
        da = [da; zeros(T-d,T)];
    end
    
    da = diag(da).^2 + 1e-8;
    for i = 1:T
        c = [gamma2 0 gamma1 lambda*da(i)];
        r = roots(c);
        r(imag(r)~=0) = [];
        da(i) = r
    end
        
    A = UA*diag(da)*UA';
    dai = da;
    dai(dai>0)=dai(dai>0).^-1;
    Ai = UA*diag(dai)*UA';

end
