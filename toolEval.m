function [drawType] = toolEval
global R;
toolType = R.bg.SelectedObject.String;
switch toolType
    case 'Straight Line'
        drawType = 1;
    case 'Free Hand'
        drawType = 2;
    case 'Rectangle'
        drawType = 3;
    case 'Ellipse'
        drawType = 4;
    case 'Point Marker'
        drawType = 5;
end
end