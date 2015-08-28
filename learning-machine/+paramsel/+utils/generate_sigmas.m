
function sigmas = generate_sigmas(D,n_sigmas)
    
    n = size(D,1);

    M = sort(D(tril(true(n),-1)));
    firstPercentile = round(0.01*numel(M)+0.5);
    sigmamin = sqrt(M(firstPercentile));
    clear M;

	sigmamax = sqrt(max(D(:)));

    if sigmamin <= 0
        sigmamin = eps;
    end
    
	
    q = (sigmamax/sigmamin)^(1/(n_sigmas-1));
    
    sigmas = sigmamin*q.^((1:n_sigmas)-1);
    
end