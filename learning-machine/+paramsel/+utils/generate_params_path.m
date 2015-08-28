
function params_path = generate_params_path(param_ranges,current_params,params_path)
    
    import paramsel.*

    if nargin<2
        current_params={};
    end
    
    if nargin<3
        params_path={};
    end
    

    if numel(param_ranges)>0
        last_position = numel(current_params)+1;
        for p=param_ranges{1}
            current_params{last_position}=p;
            params_path=utils.generate_params_path(param_ranges(2:end),current_params,params_path);       
       end
    else
        params_path{end+1}=current_params;
    end
    

end