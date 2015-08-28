function lambdas = span_params(IN,n_params)

    [n,d] = size(IN);
    if n~=d || norm(IN - IN','fro')>1e-6
       K = IN'*IN; 
    else
       K = IN;
    end

    eigvals = eig(K);
    eigvals = sort(eigvals,'descend');

    % maximum eigenvalue
    lmax = eigvals(1);

    lmin = max(min(lmax*1e-05, eigvals(end)), 200*sqrt(eps));

    powers = linspace(0,1,n_params);
    lambdas = lmin.*(lmax/lmin).^(powers);
    
end


