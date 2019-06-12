function [] = polyCoordinateMap(plyIndex,polyX,polyY)
global A;
y = plyIndex*2;
x = y-1;
A.polyCoor{:,x} = polyX;
A.polyCoor{:,y} = polyY;
end