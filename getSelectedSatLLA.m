function [selLatitude, selLongitude] = getSelectedSatLLA(selSatName)
    % 获取当前运行的 STK 应用程序
    uiApplication = actxGetRunningServer('STK11.Application');
    root = uiApplication.Personality2;
    scenario = root.CurrentScenario;

    % 构建获取卫星位置的命令
    command = sprintf('Position */Satellite/%s "23 Sep 2024 04:02:00.000"', selSatName);
    
    % 执行命令以获取卫星的位置信息
    position = root.ExecuteCommand(command);
    
    % 从返回的结果中解析经纬度
    positionData = strsplit(char(position.Item(0)));
   %disp(position.Item(0));
    selLatitude = str2double(positionData{1});
    selLongitude = str2double(positionData{2});
    
    % 输出经纬度信息
    %fprintf('selectedSatLatitude: %f°, selectedSatLongitude: %f°\n', selLatitude, selLongitude);
end
