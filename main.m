% 创建 STK 应用程序实例
app = actxGetRunningServer('STK11.application');
root = app.Personality2;

% 更新的代码框架
[~, satellite_x, satellite_y, satellite_z] = getSatXYZ();
[satellite_names, satellite_lat, satellite_lon, satellite_alt] = getSatLLA();


% 卫星坐标矩阵
satPositions = [satellite_x, satellite_y, satellite_z];

O = [0, 0, 0]; % 地心

sender = 'London';
receiver = 'Rio_De_Janeiro';
senderLat = 51.500;
senderLon = -0.117;
receiverLat = 0.000;  
receiverLon = 0.000;
% 两个地表点F和G
F = [3978640.282523 -8101.411156 4968362.457285];
G = [6378000.137000    0.000000    0.000000];

% 构造平面法向量
OF = F - O;
OG = G - O;
n = cross(OF, OG); % 平面法向量

% $设置子扇形$
nSubsectors = 6;
theta = acos(dot(OF, OG) / (norm(OF) * norm(OG))); % F和G间的夹角
angles = linspace(0, theta, nSubsectors + 1); % 子扇形角度分布

earth_radius = 6371000;
additional_radius = 1300000;
total_radius = earth_radius + additional_radius;
radius_threshold = 10;%考虑卫星体长

% 结果存储
projSatNames = cell(nSubsectors, 1);
selectedSatNames = cell(nSubsectors, 1);

selectedSatNames = SegProjSelDetection(nSubsectors, angles, F, G, O, OF, n, earth_radius, radius_threshold, total_radius, satPositions, satellite_names);

% 输出每个子扇形内选择的卫星
disp('每个子扇形内选择的卫星:');
for i = 1:nSubsectors
    fprintf('子扇形 %d: %s\n', i, selectedSatNames{i});
end
%[~, numCols] = size(selectedSatNames);
%disp(numCols);

%calculateAccess(root, selectedSatNames, sender, receiver);
%clearAccess(root, selectedSatNames, sender, receiver);

plotPathOnMap(satellite_lat, satellite_lon, selectedSatNames, senderLat, senderLon, receiverLat, receiverLon);

%calculateDelays(selectedSatNames, F, G, sender, receiver, "C:\Users\434g\Desktop\delays.txt");

distanceFG = greatCircleDistance(senderLat, senderLon, receiverLat, receiverLon);
