function output_txt = customDisplay(event, x, y, countries)
    % Find the position of the selected point
    pos = get(event, 'Position');
    % Find the nearest data point
    idx = find(abs(x - pos(1)) < 1e-5 & abs(y - pos(2)) < 1e-5, 1);
    
    % Prepare the output text
    if ~isempty(idx)
        output_txt = {['Country: ', countries{idx}], ...
                      ['Avg Inflation: ', num2str(x(idx))], ...
                      ['Persistence Effect: ', num2str(y(idx))]};
    else
        output_txt = 'No Data Found'; % Fallback if no matching point is found
    end
end