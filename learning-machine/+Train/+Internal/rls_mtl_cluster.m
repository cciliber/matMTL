function [A,Ai,da,UA] = internal_rls_mtl_cluster(W,lambda,mu,alpha,bwr,r)

    if nargin<3
        alpha = 1e-6;
        bwr = 1e-6;
        mu = 1e-2;
        r = 15;
    end
    
    

    
    [~,T] = size(W);

    beta=alpha/bwr;
    gamma=min(alpha*(((r-1)/bwr) + T - r+1),T*beta);
    

    P = eye(T)-ones(T)/T;

    wb = W*P;
    %[~,~,L]=wcn(W*P,alpha,beta,gamma);

    % wcn from jacob08

    % Preprocessing
    [U,S,V] = svd(wb);
    ss = size(S);
    if ss(2)>1
        S = diag(S);
    end
    s = flipud(S);
    m = length(s);
    nvp = length(wb(1,:)) - m;
    s2 = s.*s;
    s2beta2 = s2/(beta^2);
    s2alpha2 = s2/(alpha^2);

    b = s2beta2(1);

    palpha = 0;
    pbeta = 1;
    chidx = pbeta;
    chval = 2;

    partition = ones(1,m);

    %% Find minimum
    found = 0;
    nustar = 0;
    while (pbeta < length(s2beta2)) || (palpha < length(s2alpha2))
        % Update partition, a, b
        a = b;
        %as=[as b];
        partition(chidx) = chval;
        if ((pbeta < length(s2beta2)) && (palpha < length(s2alpha2) ) && (s2beta2(pbeta+1) > s2alpha2(palpha+1))) || (pbeta >= length(s2beta2) && (palpha < length(s2alpha2)))
            palpha = palpha+1;
            chidx = palpha;
            chval = 3;
            b = s2alpha2(palpha);
        else
            pbeta = pbeta+1;
            chidx = pbeta;
            chval = 2;
            b = s2beta2(pbeta);
        end
        % Compute nustar
        np = length(find(partition == 1));
        ssi = sum(s(partition == 2));
        nm = length(find(partition == 3)) + nvp;
        snsden = (gamma - alpha*nm - beta*np);
        if ~ssi % The dual function is linear in nu
            if snsden <= 0 % Dual either increasing or constant => go on.
                continue;
            else % Decreasing => maximum was on the left
                nustar = a;
                found = 1;
                break;
            end
        end
        if ~snsden % The derivative is strictly positive
            continue;
        end
        sqrtnustar = ssi / snsden;
        if sqrtnustar < 0 % The derivative is strictly positive
            continue;
        end
        nustar = sqrtnustar^2;
        if (nustar < b)
            found = 1;
            % If nustar is on the left, it must be at a
            if (nustar <= a)
                    nustar = a;
            end
            % Otherwise it is in ]a,b[ and we found the minimum
            break;
        end
    end

    if ~found
        nustar = b;
        %error('c-norm computation failed, no maximum found\n');
    end
    %% Compute the norm, its gradient and the optimal metric
    wnorm = 2*sqrt(nustar)*ssi+nustar*(nm*alpha+np*beta-gamma)+sum(s2(partition==3))/alpha+sum(s2(partition==1))/beta;
    L = zeros(m,1);
    L(partition == 1) = beta;
    L(partition == 2) = s(partition == 2)/sqrt(nustar);
    L(partition == 3) = alpha;
    dwcnsigma = 2*s./L;
    if nvp
        L = [alpha*ones(nvp,1);L];
    end
    L = flipud(L);
    dwcnsigma = flipud(dwcnsigma);
    addr = ss(1)-length(dwcnsigma);
    addc = ss(2)-length(dwcnsigma);
    if addr
        dwcnsigmam = [diag(dwcnsigma) ; zeros(addr,ss(2))];
    elseif addc
        dwcnsigmam = [diag(dwcnsigma) zeros(ss(1),addc)];
    else
        dwcnsigmam = diag(dwcnsigma);
    end
    dwcn = U*dwcnsigmam*V';
    % ----------------
    
    
    L(end)=0;
    L(1:end-1)=L(1:end-1).^(-1);
    L=diag(L);

    Ai = mu*(ones(T)/T + P*V*L*V'*P);
    A = eye(T)/Ai;
    [UA,da] = eig(A);
    da = diag(da);
end
