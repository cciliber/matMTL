
classdef LinearKernel < handle
    

    properties (SetAccess = private, GetAccess = public)
        kernel = [];
        kerpar = [];
        kerpar_path = 0;
        train_input = [];
        regpar_path = [];
        T = [];
        
        extra_params = {};
    end

    properties (SetAccess = private, GetAccess = private)
    end
    
    
    methods
        function obj = LinearKernel(varargin)
            obj.extra_params = cell(numel(varargin),1);
            
            for i=1:numel(varargin)
               obj.extra_params{i} = varargin{i}
            end
        end

        function init(obj,input,varargin)
            if iscell(input)
                obj.T = numel(input);
                input = cell2mat(input);
            end
            
            obj.compute(input,input);
            
            obj.train_input = input;
        end
        
        function compute(obj,X1,X2)
            
            if iscell(X1)
                X1 = cell2mat(X1);
            end
            
            if nargin<3
                X2 = obj.train_input;
            end
            
            obj.kernel = X1*X2';
        end
        
        function update_parameter(obj,kerpar)
            
        end
        
        
        function compute_regpar_path(obj,n_regpar)
            tmp_regpar = paramsel.utils.span_regpar(obj.kernel,n_regpar);
            
            
            tmp_regpar = {[tmp_regpar tmp_regpar/obj.T tmp_regpar*obj.T]};
            %tmp_regpar = [tmp_regpar/obj.T];
            %tmp_regpar = [tmp_regpar*obj.T];
            
            for i=1:numel(obj.extra_params)
               tmp_regpar{end+1} = obj.extra_params{i}; 
            end
            
            obj.regpar_path = paramsel.utils.generate_params_path(tmp_regpar);
        end
    end
    
end

