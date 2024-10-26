function selectedSatNames = SegProjSelDetection(nSubsectors, angles, F, G, O, OF, n, earth_radius, radius_threshold, total_radius, satPositions, satellite_names)
% 逐个子扇形处理
 for i = 1:nSubsectors
    angle1 = angles(i);
    angle2 = angles(i + 1);

    % 当前子扇形的两个边界向量
    % 在OF和OG之间均匀分割夹角
    V1 = cos(angle1) * OF / norm(OF) + sin(angle1) * cross(n, OF) / norm(cross(n, OF)); % 第一个边界向量
    V2 = cos(angle2) * OF / norm(OF) + sin(angle2) * cross(n, OF) / norm(cross(n, OF)); % 第二个边界向量

    % 将边界向量放大到地球半径
    P1 = earth_radius * V1 / norm(V1);
    P2 = earth_radius * V2 / norm(V2);

    % 存储边界向量与地表的交点
    boundary_points(i, 1, :) = P1;
    boundary_points(i, 2, :) = P2;

    % 输出边界向量
    fprintf('子扇形 %d:\n', i);
    fprintf('  边界向量 1 (x, y, z): (%.6f, %.6f, %.6f)\n', V1(1), V1(2), V1(3));
    fprintf('  边界向量 2 (x, y, z): (%.6f, %.6f, %.6f)\n', V2(1), V2(2), V2(3));

    % XYZ转经纬度
    [lat1, lon1] = xyzToLatLon(P1);
    [lat2, lon2] = xyzToLatLon(P2);
    
    % 输出经纬度
    fprintf('  边界 1 交点 (纬度, 经度): (%.6f, %.6f)\n', lat1, lon1);
    fprintf('  边界 2 交点 (纬度, 经度): (%.6f, %.6f)\n', lat2, lon2);
 end

% 逐个子扇形处理
 for i = 1:nSubsectors
    angle1 = angles(i);
    angle2 = angles(i + 1);

    % 当前子扇形内卫星
    inSectorSatNames = {};
    distances = [];

    % 当前子扇形的两个边界向量
    % 在OF和OG之间均匀分割夹角
    V1 = cos(angle1) * OF / norm(OF) + sin(angle1) * cross(n, OF) / norm(cross(n, OF)); % 第一个边界向量
    V2 = cos(angle2) * OF / norm(OF) + sin(angle2) * cross(n, OF) / norm(cross(n, OF)); % 第二个边界向量

    % 计算每颗卫星的投影点
    for j = 1:size(satPositions, 1)
        sat = satPositions(j, :);
        satDir = sat - O; % 从地心到卫星的向量
        dist_to_plane = abs(dot(satDir, n) / norm(n)); % 计算垂直距离

        % 投影到平面
        if dist_to_plane <= total_radius
            proj_point = sat - dist_to_plane * n / norm(n); % 投影点
            
            % 计算地心到投影点的向量
            satToProj = proj_point - O;

            % 计算地心到投影点向量与V1、V2的夹角
            angleToV1 = acos(dot(satToProj, V1) / (norm(satToProj) * norm(V1)));
            angleToV2 = acos(dot(satToProj, V2) / (norm(satToProj) * norm(V2)));

            % 计算V1与V2的夹角
            angleV1V2 = acos(dot(V1, V2) / (norm(V1) * norm(V2)));

            % 判断是否在子扇形内
            if angleToV1 <= angleV1V2 && angleToV2 <= angleV1V2
                distances = [distances; dist_to_plane]; % 存储垂直距离
                inSectorSatNames{end+1} = satellite_names{j};
            end
        end
    end

    % 选择垂直距离最短的卫星
    if ~isempty(distances)
        [~, idx] = min(distances);
        selectedSatNames{i} = inSectorSatNames{idx};
    else
        selectedSatNames{i} = '无';
    end
    
    % 对于第一个子扇形，与sender做障碍物检测
    if i == 1
       %obstacleDetected = true; % 初始化障碍物检测为true以便进入循环
       %while obstacleDetected && ~isempty(inSectorSatNames)
        currentSatPos = satPositions(strcmp(satellite_names, selectedSatNames{i}), :);
          % 首先检查视距 (LOS)
         if groundLOSCheck(F, currentSatPos, earth_radius)
            disp(['子扇形 ', num2str(i), ' 选择的卫星与sender有视距']);
            % 调用 checkAllObstacles 检查是否有障碍物
            if checkAllObstacles(F, currentSatPos, satPositions, radius_threshold)
                disp(['当前子扇形 ', num2str(i), ' 选择的卫星与sender之间有障碍物']);

                % 排除当前卫星，重新选择
                distances(idx) = []; % 删除当前最近卫星的距离
                inSectorSatNames(idx) = []; % 删除当前最近卫星
                
                % 如果还有其他候选卫星，选择下一个最近的卫星
                if ~isempty(distances)
                    [~, idx] = min(distances); % 选择下一个最近卫星
                    selectedSatNames{i} = inSectorSatNames{idx};
                else
                    selectedSatNames{i} = '无';
                    disp(['子扇形 ', num2str(i), ' 没有可用的卫星']);
                    break;
                end
            else
                disp(['子扇形 ', num2str(i), ' 选择的卫星与sender之间没有障碍物']);
                obstacleDetected = false; % 没有检测到障碍物，退出循环
            end
         else
            disp(['子扇形 ', num2str(i), ' 选择的卫星与sender没有视距']);
         end 
       %end
    end
    
    
    % 对于第2到第n个子扇形，前一个子扇形做障碍物检测
    % 对于第n个子扇形，与receiver做障碍物检测
    if i >= 2 && i < nSubsectors
       % obstacleDetected = true; % 初始化障碍物检测为true以便进入循环
       % while obstacleDetected && ~isempty(inSectorSatNames)
            % 提取当前和前一个子扇形的卫星位置
            currentSatPos = satPositions(strcmp(satellite_names, selectedSatNames{i}), :);
            previousSatPos = satPositions(strcmp(satellite_names, selectedSatNames{i - 1}), :);
           % disp(size(currentSatPos));
           % disp(size(previousSatPos));        
         % 首先检查视距 (LOS)
         if LOSCheck(previousSatPos, currentSatPos, earth_radius)
            disp(['子扇形 ', num2str(i), ' 选择的卫星与前一个子扇形有视距']);
            % 调用 checkAllObstacles 检查是否有障碍物
            if checkAllObstacles(previousSatPos, currentSatPos, satPositions, radius_threshold)
                disp(['当前子扇形 ', num2str(i), ' 选择的卫星与前一个子扇形之间有障碍物']);

                % 排除当前卫星，重新选择
                distances(idx) = []; % 删除当前最近卫星的距离
                inSectorSatNames(idx) = []; % 删除当前最近卫星
                
                % 如果还有其他候选卫星，选择下一个最近的卫星
                if ~isempty(distances)
                    [~, idx] = min(distances); % 选择下一个最近卫星
                    selectedSatNames{i} = inSectorSatNames{idx};
                else
                    selectedSatNames{i} = '无';
                    disp(['子扇形 ', num2str(i), ' 没有可用的卫星']);
                    break;
                end
            else
                disp(['子扇形 ', num2str(i), ' 选择的卫星与前一个子扇形之间没有障碍物']);
                obstacleDetected = false; % 没有检测到障碍物，退出循环
            end
         else
            disp(['子扇形 ', num2str(i), ' 选择的卫星与前一个子扇形没有视距']);
         end
       % end
    end
    
     if i == nSubsectors
      %  obstacleDetected = true; % 初始化障碍物检测为true以便进入循环
       % while obstacleDetected && ~isempty(inSectorSatNames)
          currentSatPos = satPositions(strcmp(satellite_names, selectedSatNames{i}), :);
          previousSatPos = satPositions(strcmp(satellite_names, selectedSatNames{i - 1}), :);
          % 首先检查视距 (LOS)
           if LOSCheck(previousSatPos, currentSatPos, earth_radius) && groundLOSCheck(G, currentSatPos, earth_radius)
            disp(['子扇形 ', num2str(i), ' 选择的卫星与前一个子扇形和地面节点皆有视距']);
            % 调用 checkAllObstacles 检查是否有障碍物
            if checkAllObstacles(previousSatPos, currentSatPos, satPositions, radius_threshold) && checkAllObstacles(G, currentSatPos, satPositions, radius_threshold)
                disp(['当前子扇形 ', num2str(i), ' 选择的卫星与前一个子扇形或地面节点之间有障碍物']);

                % 排除当前卫星，重新选择
                distances(idx) = []; % 删除当前最近卫星的距离
                inSectorSatNames(idx) = []; % 删除当前最近卫星
                
                % 如果还有其他候选卫星，选择下一个最近的卫星
                if ~isempty(distances)
                    [~, idx] = min(distances); % 选择下一个最近卫星
                    selectedSatNames{i} = inSectorSatNames{idx};
                else
                    selectedSatNames{i} = '无';
                    disp(['子扇形 ', num2str(i), ' 没有可用的卫星']);
                    break;
                end
            else
                disp(['子扇形 ', num2str(i), ' 选择的卫星与前一个子扇形之间和地面节点之间皆没有障碍物']);
                obstacleDetected = false; % 没有检测到障碍物，退出循环
            end
          else
            disp(['子扇形 ', num2str(i), ' 选择的卫星与前一个子扇形或地面节点没有视距']);
          end
       % end           
     end     
         
  end

end
