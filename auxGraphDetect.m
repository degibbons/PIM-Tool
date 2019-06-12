function [] = auxGraphDetect(varargin)
global F;
global A;
global S;
if isfield(F,'tf') || isfield(F,'pp')
if strcmp(get(F.tf,'Visible'),get(F.pp,'Visible'))&& strcmp(get(F.tf,'Visible'),'on')
    if get(S.cb(5),'Value') == 1
        figure(F.tf);
        F.tfPlot = plot(1:A.frames,A.totForce);
        hold on;
        try
            delete(F.curFrame_tf);
        catch
        end
        F.curFrame_tf = plot(A.CurFrameNum,A.totForce(A.CurFrameNum),'MarkerFaceColor','m',...
            'Marker','p','MarkerEdgeColor','k','MarkerSize',12);
        title('Total Force');
        xlabel('Frame');
        ylabel('Force [N]');
        figure(F.pp);
        F.ppPlot = plot(1:A.frames,A.maxPressures);
        hold on;
        try
            delete(F.curFrame_pp);
        catch
        end
        F.curFrame_pp = plot(A.CurFrameNum,A.maxPressures(A.CurFrameNum),'MarkerFaceColor','m',...
            'Marker','p','MarkerEdgeColor','k','MarkerSize',12);
        title('Peak Pressure');
        xlabel('Frame');
        ylabel('Force [kPa]');
        figure(F.fig2);
    elseif get(S.cb(5),'Value') == 0
        figure(F.tf);
        try
            delete(F.curFrame_tf);
        catch
        end
        F.tfPlot = plot(1:A.frames,A.totForce);
        title('Total Force');
        xlabel('Frame');
        ylabel('Force [N]');
        figure(F.pp);
        try
            delete(F.curFrame_pp);
        catch
        end
        F.ppPlot = plot(1:A.frames,A.maxPressures);
        title('Peak Pressure');
        xlabel('Frame');
        ylabel('Force [kPa]');
        figure(F.fig2);
    end
elseif xor(strcmp(get(F.tf,'Visible'),'on'),strcmp(get(F.pp,'Visible'),'on'))
    if strcmp(get(F.tf,'Visible'),'on')
        if get(S.cb(5),'Value') == 1
            figure(F.tf);
            F.tfPlot = plot(1:A.frames,A.totForce);
            hold on;
            try
                delete(F.curFrame_tf);
            catch
            end
            F.curFrame_tf = plot(A.CurFrameNum,A.totForce(A.CurFrameNum),'MarkerFaceColor','m',...
                'Marker','p','MarkerEdgeColor','k','MarkerSize',12);
            title('Total Force');
            xlabel('Frame');
            ylabel('Force [N]');
            figure(F.fig2);
        elseif get(S.cb(5),'Value') == 0
            figure(F.tf);
            try
                delete(F.curFrame_tf);
            catch
            end
            F.tfPlot = plot(1:A.frames,A.totForce);
            title('Total Force');
            xlabel('Frame');
            ylabel('Force [N]');
            figure(F.fig2);
        end
    elseif strcmp(get(F.pp,'Visible'),'on')
        if get(S.cb(5),'Value') == 1
            figure(F.pp);
            F.ppPlot = plot(1:A.frames,A.maxPressures);
            hold on;
            try
                delete(F.curFrame_pp);
            catch
            end
            F.curFrame_pp = plot(A.CurFrameNum,A.maxPressures(A.CurFrameNum),'MarkerFaceColor','m',...
                'Marker','p','MarkerEdgeColor','k','MarkerSize',12);
            title('Peak Pressure');
            xlabel('Frame');
            ylabel('Force [kPa]');
            figure(F.fig2);
        elseif get(S.cb(5),'Value') == 0
            figure(F.pp);
            try
                delete(F.curFrame_pp);
            catch
            end
            F.ppPlot = plot(1:A.frames,A.maxPressures);
            title('Peak Pressure');
            xlabel('Frame');
            ylabel('Force [kPa]');
            figure(F.fig2);
        end
    end
end
end