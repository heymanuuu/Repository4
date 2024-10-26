function [satellite_names, satellite_lat, satellite_lon, satellite_alt] = getSatLLA()
    % 创建 STK 应用程序实例
    app = actxGetRunningServer('STK11.application');
    root = app.Personality2;

    % 获取所有卫星的路径
    result = root.ExecuteCommand('ShowNames * Class Satellite');
    satellite_paths = strsplit(result.Item(0), ' '); 

    % 提取卫星名称
    satellite_names = cell(size(satellite_paths));
    for i = 1:length(satellite_paths)
        tokens = regexp(satellite_paths{i}, '/Scenario/[^/]+/Satellite/([^/]+)', 'tokens');
        if ~isempty(tokens)
            satellite_names{i} = tokens{1}{1};
        end
    end

    % 过滤掉空值并去重
    satellite_names = satellite_names(~cellfun('isempty', satellite_names));
    satellite_names = unique(satellite_names);

    % 获取每颗卫星的LLA
    current_time = ' "23 Sep 2024 04:02:00.000"';
    num_sats = length(satellite_names);
    satellite_lat = zeros(num_sats, 1);
    satellite_lon = zeros(num_sats, 1);
    satellite_alt = zeros(num_sats, 1);
    
    for i = 1:num_sats
        command = sprintf('Position */Satellite/%s %s', satellite_names{i}, current_time);
        result = root.ExecuteCommand(command);
    
        % 提取LLA
        LLA = strsplit(result.Item(0));
        if length(LLA) >= 8 % Ensure correct number of elements
            satellite_lat(i) = str2double(LLA{1});
            satellite_lon(i) = str2double(LLA{2});
            satellite_alt(i) = str2double(LLA{3}); % Correct index for altitude
        end
    end
end
