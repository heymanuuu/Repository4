function calculateAccess(root, selectedSatNames, sender, receiver)
    % satellites: Nx2 matrix of satellite names as strings (e.g., ["Satellite1", "Satellite2"; "Satellite2", "Satellite3"; ...])
    % scenario: an active STK scenario object
    % Iterate over each pair of satellites
    [~, numCols] = size(selectedSatNames);
    disp(numCols);
    root.ExecuteCommand(['Access */Place/', sender, ' */Satellite/',selectedSatNames{1}]);
    disp(['Access */Place/', sender, ' */Satellite/',selectedSatNames{1}]);
    root.ExecuteCommand(['Access */Place/', receiver, ' */Satellite/',selectedSatNames{ numCols}]);
    disp(['Access */Place/', receiver, ' */Satellite/',selectedSatNames{ numCols}]);
    for i = 1:(numCols-1)
        sat1 = selectedSatNames{i};
        sat2 = selectedSatNames{i+1};   
        disp(['Access */Satellite/',sat1, ' */Satellite/',sat2]);
        root.ExecuteCommand(['Access */Satellite/',sat1, ' */Satellite/',sat2]);     
    end
end
