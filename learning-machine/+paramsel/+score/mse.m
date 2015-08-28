
function score = mse(Ytest,Ypred)

    score = (1.0/numel(Ytest))*norm(Ytest-Ypred,'fro')^2;

end