%% recalCoP recalculates the center of pressure matrix after using the Change Selected to Zero button
function [newCoPmat] = recalCoP(data,frames)
newCoPmat_X = zeros(frames,1);
newCoPmat_Y = zeros(frames,1);
top_x = 0;
top_y = 0;
bottom_x = 0;
bottom_y = 0;
for i = 1:frames % Iterate across all frames
    for j = 1:95 % Iterate across all rows
        for k = 1:64 % Iterate across all columns
            top_x = top_x + (0.25 * data(j,k,i) * (0.25 + 0.5 * (k - 1))); % Multiply each weight by the area of the pressure unit
            bottom_x = bottom_x + (0.25 * data(j,k,i)); % and the distance from zero on the X-axis. The bottom number excludes the distance
        end
    end
    newCoPmat_X(i,1) = top_x/bottom_x; % Find the weighted centroid of the pressures along the X-axis
    top_x = 0;
    bottom_x = 0;
end
for a = 1:frames % Iterate across all frames
    for b = 1:64 % Iterate across all columns
        for c = 1:95 % Iterate across all rows
            top_y = top_y + (0.25 * data(c,b,a) * (0.25 + 0.5 * (c - 1))); % Multiply each weight by the area of the pressure unit
            bottom_y = bottom_y + (0.25 * data(c,b,a)); % and the distance from zero on the Y-axis. The bottom number excludes the distance
        end
    end
    newCoPmat_Y(a,1) = top_y/bottom_y; % Find the weighted centroid of the pressures along the Y-axis
    top_y = 0;
    bottom_y = 0;
end
newCoPmat = [zeros(frames,1),newCoPmat_Y,newCoPmat_X,zeros(frames,2)]; % Return the new Center of Pressure matrix
end

