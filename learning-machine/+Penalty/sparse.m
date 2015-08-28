function penalty_value = sparse(A,lambda,gamma,eta)
    
    if nargin<3
        gamma = 0.1*lambda;
    end
    
    if nargin<4
        eta = 3*gamma;
    end
    

    penalty_value = gamma*norm(A(:),1) + eta*trace(A);
end

