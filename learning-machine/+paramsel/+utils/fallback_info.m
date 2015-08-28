
function info = fallback_info(info)

    if ~isfield(info,'sample') || ~isfield(info.sample,'sample_func')
        info.sample.sample_func=@paramsel.sample.standard;
    end
    
    if ~isfield(info,'performance') || ~isfield(info.performance,'score_func')
        info.performance.score_func=@paramsel.score.mse;
    end



end