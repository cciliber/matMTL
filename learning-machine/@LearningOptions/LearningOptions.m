classdef LearningOptions < handle
    
    properties
        primal=[];
        mode = '';
        n_ho = [];
        perc_tr = [];
        internal_Sample = [];
        internal_Score = [];
        n_kerpar = [];
        n_regpar = [];
        validation_set = {};
    end
    
    methods
        % Constructor
        function obj = LearningOptions()
            obj.primal=true;
            obj.mode = 'ho';
            obj.n_ho = 10;
            obj.perc_tr = 0.65;
            obj.internal_Sample = @Sample.standard;
            obj.internal_Score = @Score.mse;
            obj.n_kerpar = 0;
            obj.n_regpar = 10;
        end
        
        function [data_train,data_test] = Sample(obj,input,output)
            
            [data_train,data_test] = obj.internal_Sample(input,output,obj);
            
        end
        
        function score = Score(obj,output,prediction)
            
            score = obj.internal_Score(output,prediction);
            
        end
        
        
        function setValidation(obj,input,output)
            obj.mode = 'fixed';
            obj.validation_set{input,output};
        end
        
    end
    
end

