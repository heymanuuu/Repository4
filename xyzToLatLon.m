function [latitude, longitude] = xyzToLatLon(P)
    x = P(1);
    y = P(2);
    z = P(3);
    % 计算纬度
    latitude = atan2(z, sqrt(x^2 + y^2)) * (180 / pi); % 转换为度
    % 计算经度
    longitude = atan2(y, x) * (180 / pi); % 转换为度
end
