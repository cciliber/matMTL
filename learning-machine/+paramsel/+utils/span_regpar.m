function [regpar] = span_regpar(K,n_regpar)

    n = size(K,1);

    %if false 
    if n<5000;
        eigvals = eig(K);

        lmax = max(eigvals);

        lmin = max(min(lmax*1e-05, min(eigvals)), 200*sqrt(eps));
    else
        lmax = trace(K);

        lmin = max(min(lmax*1e-05,1e-6), 1e-8);
    end

    powers = linspace(0,1,n_regpar);
    regpar = lmin.*(lmax/lmin).^(powers);
    

end


