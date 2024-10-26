function calculateDelays(selectedSatNames, F, G, senderName, receiverName, outputFileName)
    % input:
    % selectedSatNames: List of selected satellite names
    % F: Sender's XYZ coordinates (1x3 vector)
    % G: Receiver's XYZ coordinates (1x3 vector)
    % senderName: Name of the sender (e.g., ground station)
    % receiverName: Name of the receiver (e.g., ground station)
    % outputFileName: File path to save the delay information
    % output:
    % Writes delay information to the file with satellite names and delays.

    % Speed of light (km/s)
    c = 299792.458;

    % Initialize delay time list
    numSats = length(selectedSatNames);  % 获取选定卫星的个数
    %disp(numSats);
    delays = zeros(numSats + 1, 1);      % 多一个位置用于存储发送器到第一个卫星的延迟

    % 打开文件以写入数据
    fileID = fopen(outputFileName, 'w');

    % 获取第一个卫星的坐标，并计算发送器到该卫星的距离
    [satPos1X, satPos1Y, satPos1Z] = getSelectedSatXYZ(selectedSatNames{1});
    %fprintf('%.4f %.4f %.4f\n',satPos1X, satPos1Y, satPos1Z);
    distance = euclideanDistance(F, [satPos1X, satPos1Y, satPos1Z]); % 计算F到第一个卫星的距离
   %fprintf('%.6f\n', distance);
    delays(1) = distance / c;                 % 计算延迟

    % 将sender到第一个卫星的延迟写入文件
    fprintf(fileID, '%s %s %.2f\n', senderName, selectedSatNames{1}, delays(1));

    % 计算卫星之间的延迟并写入文件
    for i = 1:(numSats - 1)
        [satPos1X, satPos1Y, satPos1Z] = getSelectedSatXYZ(selectedSatNames{i});     % 当前卫星坐标
        [satPos2X, satPos2Y, satPos2Z] = getSelectedSatXYZ(selectedSatNames{i + 1}); % 下一个卫星坐标
       
        distance = euclideanDistance([satPos1X, satPos1Y, satPos1Z], [satPos2X, satPos2Y, satPos2Z]);       % 计算两个卫星之间的距离
        delays(i + 1) = distance / c;                         % 计算延迟
        %fprintf('%.6f\n', distance);
        % 将卫星间的延迟写入文件
        fprintf(fileID, '%s %s %.2f\n', selectedSatNames{i}, selectedSatNames{i + 1}, delays(i + 1));
    end

    % 获取最后一个卫星的坐标，并计算最后一个卫星到接收器的距离
    [satPosLastX, satPosLastY, satPosLastZ] = getSelectedSatXYZ(selectedSatNames{numSats});
    distance = euclideanDistance([satPosLastX, satPosLastY, satPosLastZ], G); % 计算最后一个卫星到G的距离
    %fprintf('%.6f %.6f %.6f %.6f\n',satPosLastX, satPosLastY, satPosLastZ, distance);
    delays(numSats + 1) = distance / c;          % 计算延迟

    % 将最后一个卫星到接收器的延迟写入文件
    fprintf(fileID, '%s %s %.2f\n', selectedSatNames{numSats}, receiverName, delays(numSats + 1));

    % 关闭文件
    fclose(fileID);
end
