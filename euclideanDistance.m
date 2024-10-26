function euclideanDist = euclideanDistance(pos1, pos2)
    % input:
    % pos1: XYZ coordinates of the first position (1x3 array)
    % pos2: XYZ coordinates of the second position (1x3 array)
    % output:
    % d: Euclidean distance between two locations (km)

    % Calculate Euclidean distance
    euclideanDist = sqrt((pos1(1) - pos2(1))^2 + (pos1(2) - pos2(2))^2 + (pos1(3) - pos2(3))^2);
end
