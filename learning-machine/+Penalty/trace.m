function penalty_value = trace(A,lambda,gamma)

    if nargin<3
        gamma = lambda;
    end

    penalty_value = gamma * trace(A);
end

