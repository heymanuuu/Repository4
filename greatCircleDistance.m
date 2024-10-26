function distance = greatCircleDistance(lat1, lon1, lat2, lon2)
    % 将角度转换为弧度
    lat1 = deg2rad(lat1);
    lon1 = deg2rad(lon1);
    lat2 = deg2rad(lat2);
    lon2 = deg2rad(lon2);

    % 地球半径（公里）
    R = 6371;

    % Haversine 公式
    dlon = lon2 - lon1;
    dlat = lat2 - lat1;

    a = sin(dlat/2)^2 + cos(lat1) * cos(lat2) * sin(dlon/2)^2;
    c = 2 * atan2(sqrt(a), sqrt(1 - a));

    % 计算距离
    distance = R * c;
end
