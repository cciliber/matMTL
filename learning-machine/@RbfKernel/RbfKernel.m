
classdef RbfKernel < handle
    

    properties (SetAccess = private, GetAccess = public)
        kernel = [];
        kerpar = [];
        kerpar_path = [];
        regpar_path = [];
        train_input = [];
        distances = [];
        
        extra_params = {};
    end

    properties (SetAccess = private, GetAccess = private)
    end
    
    
    methods
        function obj = RbfKernel(varargin)
            obj.extra_params = cell(numel(varargin),1);
            
            for i=1:numel(varargin)
               obj.extra_params{i} = varargin{i}
            end
        end

        function init(obj,input,varargin)
            if iscell(input)
                input = cell2mat(input);
            end
            
            obj.train_input = input;
            
            obj.compute_distances(input,input);
            
            if nargin>2
                obj.compute_kerpar_path(varargin{1});
            end
            
        end
        
        function compute(obj,X1,X2)

            if iscell(X1)
                X1 = cell2mat(X1);
            end

            if nargin<3
                X2 = obj.train_input;
            end
            
            obj.compute_distances(X1,X2);
            
            obj.kernel = exp(-obj.distances/(obj.kerpar^2));
        end
        
        function update_parameter(obj,kerpar)
            obj.kerpar = kerpar;
            obj.kernel = exp(-obj.distances/(obj.kerpar^2));
        end
        
        function compute_distances(obj,X1,X2)
            if (nargin ~= 3)
               error('Not enough input arguments');
            end

            if (size(X1,2) ~= size(X2,2))
               error('X1 and X2 should be of same dimensionality');
            end

            aa=sum(X1'.*X1',1); bb=sum(X2'.*X2',1); ab=X1*X2'; 
            %d = sqrt(abs(repmat(aa',[1 size(bb,2)]) + repmat(bb,[size(aa,2) 1]) - 2*ab));
            obj.distances = (abs(repmat(aa',[1 size(bb,2)]) + repmat(bb,[size(aa,2) 1]) - 2*ab));
        end

        
        function compute_kerpar_path(obj,n_kerpar)

            n = size(obj.distances,1);
            D = sort(obj.distances(tril(true(n),-1)));
            
            firstPercentile = round(0.01*numel(D)+0.5);
            sigmamin = sqrt(D(firstPercentile));
            sigmamax = sqrt(max(max(obj.distances)));
 
            if sigmamin <= 0
                sigmamin = eps;
            end
            
            if sigmamax <= 0
                sigmamax = eps;
            end	
            q = (sigmamax/sigmamin)^(1/(n_kerpar-1));
            obj.kerpar_path = sigmamin*(q.^(n_kerpar:-1:0));
            
        end
        
        
        function compute_regpar_path(obj,n_regpar)
            tmp_regpar = {paramsel.utils.span_regpar(obj.kernel,n_regpar)};
            
            for i=1:numel(obj.extra_params)
               tmp_regpar{end+1} = obj.extra_params{i}; 
            end
            
            obj.regpar_path = paramsel.utils.generate_params_path(tmp_regpar);
        end
        
        
        
    end
    
end

