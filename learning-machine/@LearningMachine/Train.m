

function Train(obj,inputs,outputs,varargin)

    [obj.internal_Test,obj.internal_params] = obj.internal_Train(inputs,outputs,varargin{:});

end
