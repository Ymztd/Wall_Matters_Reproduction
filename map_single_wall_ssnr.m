function map_single_wall_ssnr()
    % 单墙场景参数设置
    xT = -5;
    xR = 5;
    wall = -2.4;
    xRef = 7.5;%为了复现论文，找的一个参考点，恢复系数c
    thresholdDB = 6;
    l2 = xR-wall;% 静态直达路径中，墙到 RX 的距离

    Fref = (xRef-wall)*abs(xRef-xR)/l2;%计算参考点的 F。该点在墙右侧且 y = 0，TX 到墙的距离可约掉
    C = 10^(thresholdDB/20)*Fref;
    [X,Y] = meshgrid(-12:0.025:12,-10:0.025:10);
    F = single_wall_metric(X,Y,xT,xR,wall);% 定义一个中间量F = (d1*d2*d3)/(l1*l2)

    ssnrDB = 20*log10(C./max(F,eps));%式 (10)：线性 SSNR = (C/F)^2，转换为 dB 后为 20*log10(C/F)
    f = figure('Color','w','Position',[100 100 760 475]);
    ax = axes(f);
    imagesc(ax,X(1,:),Y(:,1),ssnrDB);
    set(ax,'YDir','normal','Layer','top');
    colormap(ax,jet(256));
    caxis(ax,[0 12.5]);
    cb = colorbar(ax);
    cb.Ticks = 1:2:11;
    ylabel(cb,'SSNR (dB)');
    hold(ax,'on');
    contour(ax,X,Y,F,[Fref Fref],'k--','LineWidth',3);
    plot(ax,[wall wall],[-10 10],'r--','LineWidth',2.5);
    plot(ax,xT,0,'k^','MarkerSize',16,'MarkerFaceColor','w');
    plot(ax,xR,0,'ks','MarkerSize',16,'MarkerFaceColor','w');
    text(ax,xT,-0.8,'TX','Color','w','FontWeight','bold','HorizontalAlignment','center');
    text(ax,xR,-0.8,'RX','Color','w','FontWeight','bold','HorizontalAlignment','center');
    text(ax,wall+0.35,-9,'Wall','Color','w','FontWeight','bold');
    text(ax,3.2,7.4,{'6 dB sensing','boundary'},'Color','w');
    axis(ax,[-12 12 -10 10]);
    xlabel(ax,'x Distance (m)');
    ylabel(ax,'y Distance (m)');
    box(ax,'on');
    fprintf('C = %.4f m, reference SSNR = %.4f dB\n',C,20*log10(C/Fref));

    save_reproduction(f,mfilename);
end
