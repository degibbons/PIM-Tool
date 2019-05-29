function [] = drawMask(ply,polyCoor)
global F;
global A;
for i = 1:length(ply)
    if isvalid(ply{1,i})
        if isa(ply{1,i},'impoint')
            try
                delete(F.refPts)
            catch
            end
            if isfield(A,'color')
                F.refPts = scatter(polyCoor{1,(i*2-1)},polyCoor{1,(i*2)},'MarkerEdgeColor',A.color);
            else
                F.refPts = scatter(polyCoor{1,(i*2-1)},polyCoor{1,(i*2)});
            end
        elseif ~isa(ply{1,i},'impoint')
            if isfield(A,'color')
                F.pgon{1,i} = plot(polyCoor{1,(i*2-1)},polyCoor{1,(i*2)},'Color',A.color);
            else
                F.pgon{1,i} = plot(polyCoor{1,(i*2-1)},polyCoor{1,(i*2)});
            end
        end
    end
end
end