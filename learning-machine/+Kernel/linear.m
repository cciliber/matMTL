function K = linear(input,varargin)

    if iscell(input)
        input = cell2mat(input);
    end
    
    K = input*input';

end