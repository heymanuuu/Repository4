function blocked = checkAllObstacles(sat1, sat2, allSatPositions, radius_threshold)
    % 输入:
    % sat1: 第1颗卫星的3D坐标 [x, y, z]
    % sat2: 第2颗卫星的3D坐标 [x, y, z]
    % allSatPositions: 所有卫星的3D坐标矩阵，每行是一个卫星 [x, y, z]
    % radius_threshold: 判断障碍物遮挡的距离阈值
    %
    % 输出:
    % blocked: 布尔值，true表示至少有一个卫星阻挡，false表示无障碍物阻挡
    
    blocked = false; % 默认无障碍物
    numSats = size(allSatPositions, 1); % 获取卫星总数
    
    % 循环检查所有其他卫星
    for i = 1:numSats
        obstacle = allSatPositions(i, :);
        
        % 如果障碍物卫星等于sat1或sat2，则跳过
        if isequal(obstacle, sat1) || isequal(obstacle, sat2)
            continue; % 跳过当前最近卫星和上一颗最近卫星
        end
        
        % 调用 ObstacleCheck 函数检查该卫星是否阻挡
        if ObstacleCheck(sat1, sat2, obstacle, radius_threshold)
            blocked = true;  % 如果找到障碍物，直接返回 true
            disp(['卫星 ', num2str(obstacle), ' 是障碍物，阻挡了 ', num2str(sat1), ' 和 ', num2str(sat2)]);
            return;  % 有障碍物，终止检测
        end
    end
    
    % 如果循环结束没有检测到障碍物，blocked 保持为 false
end
