function plotPathOnMap(satellite_lat, satellite_lon, selectedSatNames, senderLat, senderLon, receiverLat, receiverLon)
    % 绘制所有卫星的经纬度在世界地图上
    figure;
    % Set the map extent
    latlim = [-30 55]; % Latitude range
    lonlim = [-50 15]; % Longitude range
    worldmap(latlim, lonlim); % 创建世界地图
    load coastlines; % 加载海岸线数据
    plotm(coastlat, coastlon); % 绘制海岸线
      % Set the latitude and longitude scale display and font size
    setm(gca, 'FontSize', 18, 'FontWeight', 'bold', 'MLabelParallel', 'north');
    setm(gca, 'MLabelLocation', 30, 'PLabelLocation', 20); % Specify the latitude and longitude scale display interval
    %Bold map border
    setm(gca, 'Frame', 'on', 'FLineWidth', 4);
    
    % 绘制所有卫星的浅蓝色实心点
    h1 = scatterm(satellite_lat, satellite_lon, 30, [0.5, 0.8, 1], 'filled'); % 浅蓝色

    % 遍历选定的卫星，获取其经纬度并标记为绿色实心点，并用线连接
    hold on;
    selLatitudes = [];
    selLongitudes = [];
    for i = 1:length(selectedSatNames)
        [selLatitude, selLongitude] = getSelectedSatLLA(selectedSatNames{i});
        h2 = scatterm(selLatitude, selLongitude, 50, 'g', 'filled'); % 绿色实心点
        selLatitudes = [selLatitudes; selLatitude];
        selLongitudes = [selLongitudes; selLongitude];
    end
    
    % 用线将选定的子扇形卫星连接起来
    h4 = plotm(selLatitudes, selLongitudes, '-g', 'LineWidth', 3); % 用绿色线条连接
    
    % 绘制sender和receiver的红色实心点
    h3 = scatterm(senderLat, senderLon, 100, 'r', 'filled'); % 发送端，红色实心点
    scatterm(receiverLat, receiverLon, 100, 'r', 'filled'); % 接收端，红色实心点
    
    % 标注sender和receiver
    textm(senderLat, senderLon, '', 'Color', 'r', 'FontSize', 12);
    textm(receiverLat, receiverLon, '', 'Color', 'r', 'FontSize', 12);

    % 获取第一个和最后一个卫星的经纬度
    [firstSatLat, firstSatLon] = getSelectedSatLLA(selectedSatNames{1});
    [lastSatLat, lastSatLon] = getSelectedSatLLA(selectedSatNames{end});
    
    % 用线将sender连接到第一个卫星
    plotm([senderLat, firstSatLat], [senderLon, firstSatLon], '-g', 'LineWidth', 3);

    % 用线将receiver连接到最后一个卫星
    plotm([receiverLat, lastSatLat], [receiverLon, lastSatLon], '-g', 'LineWidth', 3);

    % 创建图例
    legend([h1, h2, h3, h4], {'Starlink Satellites', 'ASSP Satellites', 'London/Rio', 'ASSP Routing'}, 'Location', 'best', 'FontSize', 14, 'FontWeight', 'bold');
    % Set DPI and save the image
    set(gcf, 'PaperUnits', 'inches');
    %set(gcf, 'PaperPosition', [0 0 5 7]); % Set the image size to 8:7 rectangle
    set(gca, 'LineWidth', 3); % Adjust the width of the coordinate axis
    set(gca, 'Box', 'on');
    % 保存图像到文件，指定DPI
    %print('-dpdf', '-r1000', 'C:\Users\434g\Desktop\Paper4\routing\111.pdf');
end
