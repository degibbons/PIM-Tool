%% matGraph graphs the data of the currently selected frame
function [] = matGraph(newFrame)
global D;
global A;
global F;
set(0, 'currentfigure', F.fig2); % Set the current figure to be the heat map
if isfield(F,'h')&&isfield(F,'hStrings')   % If the heat map and Weight Texts exist, delete them
    delete(F.h);
    delete(F.hStrings);
end
F.h = imagesc(D.data(:,:,newFrame)); % Graph the new heat map for the desired frame
colormap(jet); % Set the heat map color scheme to 'Jet'
colorbar; % Display the color bar on the right side of the map
highestNum = max(max(max(D.data))); % Use the highest pressure of all the frames to 
caxis([0,highestNum]); % determine the highest number displayed by the color bar and make sure 
hold on; % the color scheme is consistent across all frames
A.CurFrameNum = newFrame; % Set the new current frame
end
