function isLOS = LOSCheck(sat1, sat2, earth_radius)
    % 输入: 
    % sat1: 第1颗卫星的3D坐标 [x, y, z]
    % sat2: 第2颗卫星的3D坐标 [x, y, z]
    % earth_radius: 地球半径 (单位: km)
    %
    % 输出:
    % isLOS: 布尔值，true表示有视距，false表示被地球遮挡
    
    % 地心到卫星的向量
    r1 = sat1;
    r2 = sat2;
    
    % 计算卫星间的向量
    satVec = r2 - r1;
    
    % 最近点到地心的距离
    crossProd = cross(r1, r2);
    d = norm(crossProd) / norm(satVec);
    
    % 判断是否被地球遮挡
    if d >= earth_radius
        isLOS = true;  % 无遮挡，有视距
    else
        isLOS = false; % 被地球遮挡，无视距
        disp(d);
    end
end
