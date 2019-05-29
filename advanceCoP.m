%% advanceCoP recalculates the current Center of Pressure for the current frame
function [] = advanceCoP(CoPdata,curFrame,curGraph,visCondition)
global F;
set(0, 'currentfigure', curGraph); % Set the current figure to be the heat map
X_cp = CoPdata(:,3); %Take note: the order of the X & Y columns in the data file is reversed
Y_cp = CoPdata(:,2);
delete(F.curCoP); %Delete the previously current Center of Pressure data because the frame has changed
hold on;
F.curCoP = plot(2*X_cp(curFrame),2*Y_cp(curFrame),'MarkerFaceColor','r',...
    'Marker','p','MarkerEdgeColor','k','MarkerSize',15); % Graph the new center of pressure

if visCondition == 1 % If the Center of Pressure checkbox is checked,
    set(F.CoPline,'Visible','on') % Set the visibilty to ON
    set(F.curCoP,'Visible','on')
elseif visCondition == 0 % If the Center of Pressure checkbox is unchecked,
    set(F.CoPline,'Visible','off') % Set the visibility to OFF
    set(F.curCoP,'Visible','off')
end
end
