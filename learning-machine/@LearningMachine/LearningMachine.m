
classdef LearningMachine < handle
    
    properties
        verbose = true; 
    end

    properties (SetAccess = private, GetAccess = public)
        internal_params = [];
        hyperparameters = {};
    end

    properties (SetAccess = private, GetAccess = private)
        options = [];
        paramsel_options = [];
        
        internal_Train = [];
        internal_Test = [];
    end
    
    
    methods
        function obj = LearningMachine()
            obj.options = LearningOptions;
            obj.paramsel_options = LearningOptions;
        end
         
        best_hparams = ParameterSelection(obj,input,output,params_path,paramsel_options);
        error = PerformExperiment(obj,input,output,params,options);
        
        Train(obj,input,output,varargin);
        prediction = Test(obj,input);

        function setTrain(obj,train_func)
            obj.internal_Train = train_func;
        end
        
        function setHyperparameters(obj,hyperparameters)
            obj.hyperparameters = hyperparameters;
        end
    end
    
end

