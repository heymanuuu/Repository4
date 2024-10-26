function [satellite_names, satellite_x, satellite_y, satellite_z] = getSatXYZ()
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

    % 获取每颗卫星的xyz坐标
    current_time = ' "23 Sep 2024 04:02:00.000"';
    num_sats = length(satellite_names);
    satellite_x = zeros(num_sats, 1);
    satellite_y = zeros(num_sats, 1);
    satellite_z = zeros(num_sats, 1);
    
    for i = 1:num_sats
        command = sprintf('Position */Satellite/%s %s', satellite_names{i}, current_time);
        disp(command);
        result = root.ExecuteCommand(command);
    
        % 提取xyz
        Cartesian = strsplit(result.Item(0));
        if length(Cartesian) >= 8 % Ensure correct number of elements
            satellite_x(i) = str2double(Cartesian{7});
            satellite_y(i) = str2double(Cartesian{8});
            satellite_z(i) = str2double(Cartesian{9}); % Correct index for z
        end
    end
end
