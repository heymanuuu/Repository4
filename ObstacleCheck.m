function isBlocked = ObstacleCheck(sat1, sat2, obstacle, radius_threshold)
    % 输入:
    % sat1: 第1颗卫星的3D坐标 [x, y, z]
    % sat2: 第2颗卫星的3D坐标 [x, y, z]
    % obstacle: 障碍物的3D坐标 [x, y, z]
    % radius_threshold: 判断障碍物遮挡的距离阈值
    %
    % 输出:
    % isBlocked: 布尔值，true表示障碍物在通信路径上，false表示无障碍物
    
    % 转换为列向量并确保大小一致
    sat1 = reshape(sat1, [], 1);
    sat2 = reshape(sat2, [], 1);
    obstacle = reshape(obstacle, [], 1);
    
    % 计算卫星之间的向量
    satVec = sat2 - sat1;
    
    % 计算障碍物到卫星1的向量
    obsVec = obstacle - sat1;
    
    % 计算卫星之间的向量的叉积
    crossProd = cross(satVec, obsVec);
    
    % 计算障碍物到卫星连线的垂直距离
    d_obs = norm(crossProd) / norm(satVec);
    
    % 判断障碍物是否在连线上并在指定范围内
    % 判断障碍物是否位于两颗卫星之间
    dot1 = dot(obsVec, satVec);
    dot2 = dot(obstacle - sat2, satVec);
    
    if d_obs < radius_threshold && dot1 > 0 && dot2 < 0
        isBlocked = true;  % 有障碍物遮挡
    else
        isBlocked = false; % 无障碍物
    end
end
