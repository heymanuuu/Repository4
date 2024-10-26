function hasLineOfSight = groundLOSCheck(P, S, R_earth)
    % P: 地表节点的坐标 (1x3 向量)
    % S: 卫星的坐标 (1x3 向量)
    % R_earth: 地球半径
    
    % 转换为列向量
    P = P(:);
    S = S(:);
    
    % 计算地表节点到地心的向量
    O_P = -P;  % 从地表节点到地心的向量
    
    % 计算地表节点到卫星的向量
    D = S - P;  % 从地表节点到卫星的向量
    
    % 计算这两个向量的点积
    dotProduct = dot(O_P, D);
    
    % 计算地表节点到地心的向量长度
    length_O_P = norm(O_P);
    
    % 计算地表节点到卫星的向量长度
    length_D = norm(D);
    
    % 计算夹角的余弦值
    cosTheta = dotProduct / (length_O_P * length_D);
    Theta_rad = acos(cosTheta);  % 反余弦函数，返回的是弧度
    Theta_deg = rad2deg(Theta_rad);  % 将弧度转换为角度
    %fprintf('夹角为 %.4f度\n', Theta_deg);
    % 判断夹角
    if cosTheta > 0
        % 夹角小于90度，连线穿过地球，无视距
        hasLineOfSight = false;
    else
        % 夹角大于或等于90度，连线没有穿过地球，有视距
        hasLineOfSight = true;
    end
end
