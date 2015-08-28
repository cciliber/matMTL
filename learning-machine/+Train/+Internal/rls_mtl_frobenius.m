function [A,Ai,da,UA] = internal_rls_mtl_frobenius(W,lambda,gamma)

    [d,T] = size(W);

    if nargin<3
        gamma = lambda;
    end
    
    [~,da,UA] = svd(W);
    if(T>d)
        da = [da; zeros(T-d,T)];
    end
    
    da = nthroot((0.5*lambda/gamma)*diag(da).^2+1e-8,3);
    A = UA*diag(da)*UA';
    dai = da;
    dai(dai>0)=dai(dai>0).^-1;
    dai(dai<0)=0;
    Ai = UA*diag(dai)*UA';

end
