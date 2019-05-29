%% Evaluate type of draw tool selected
function [] = eval_draw(ply,maskIndex)
global A;
global D;
% global F;

for i = maskIndex
    if isvalid(ply{1,i})
        vis = get(ply{1,i},'Visible');
        if  strcmp(vis,'on')
            pos = getPosition(ply{1,i});
            sz = size(D.data);
            if isa(ply{1,i},'impoly') || isa(ply{1,i},'imfreehand')
                pos = [pos;pos(1,1),pos(1,2)]; %#ok<AGROW>
                A.BW = poly2mask(pos(:,1),pos(:,2),sz(1,1),sz(1,2));
                polyCoordinateMap(i,pos(:,1),pos(:,2));
                %             A.polyX = pos(:,1);
                %             A.polyY = pos(:,2);
            elseif isa(ply{1,i},'imellipse')
                v = getVertices(ply{1,i});
                A.BW = poly2mask(v(:,1),v(:,2),sz(1,1),sz(1,2));
                polyCoordinateMap(i,v(:,1),v(:,2));
                %             A.polyX = v(:,1);
                %             A.polyY = v(:,2);
            elseif isa(ply{1,i},'imrect')
                w = pos(1,3);
                h = pos(1,4);
                new_pos = [pos(1,1),pos(1,2);pos(1,1),pos(1,2)+h;pos(1,1)+w,pos(1,2)+h;pos(1,1)+w,pos(1,2)];
                new_pos_closed = [new_pos;new_pos(1,1),new_pos(1,2)];
                polyCoordinateMap(i,new_pos_closed(:,1),new_pos_closed(:,2));
                %             A.polyX = new_pos_closed(:,1);
                %             A.polyY = new_pos_closed(:,2);
                pos = new_pos;
                A.BW = poly2mask(pos(:,1),pos(:,2),sz(1,1),sz(1,2));

            end
        end
    end
end
end
