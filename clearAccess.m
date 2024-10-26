function clearAccess(root, selectedSatNames, sender, receiver)
    % satellites: Nx2 matrix of satellite names as strings (e.g., ["Satellite1", "Satellite2"; "Satellite2", "Satellite3"; ...])
    % scenario: an active STK scenario object
    % Iterate over each pair of satellites
    [~, numCols] = size(selectedSatNames);
    root.ExecuteCommand(['ClearAccess */Place/', sender, ' */Satellite/',selectedSatNames{1}]);
    disp(['ClearAccess */Place/', sender, ' */Satellite/',selectedSatNames{1}]);
    root.ExecuteCommand(['ClearAccess */Place/', receiver, ' */Satellite/',selectedSatNames{ numCols}]);
    disp(['ClearAccess */Place/', receiver, ' */Satellite/',selectedSatNames{ numCols}]);
    for i = 1:(numCols-1)
        sat1 = selectedSatNames{i};
        sat2 = selectedSatNames{i+1};   
        disp(['ClearAccess */Satellite/',sat1, ' */Satellite/',sat2]);
        root.ExecuteCommand(['ClearAccess */Satellite/',sat1, ' */Satellite/',sat2]);     
    end
end
