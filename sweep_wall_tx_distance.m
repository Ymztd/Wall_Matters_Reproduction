function sweep_wall_tx_distance()
    wallToTx = [9.5 9 7 5 3 1 0.5];
    C = [33.22 18.74 8.39 6.38 7.70 16.85 32.73]; % m
    %场景参数设置
    xT = -5;
    xR = 5;
    % 将墙到 TX 的相对距离换成墙的横坐标，供单墙模型计算穿墙路径。
    walls = xT+wallToTx;
    % 由 20*log10(C/F) = 6 解出 F 的阈值 k。
    % 目的是直接画 F = k(j) 的等值线，得到第 j 组的 6 dB 覆盖边界。
    k = C/10^(6/20);

    step = 0.025;
    xAxis = -16:step:16;
    yAxis = -14:step:14;
    [X,Y] = meshgrid(xAxis,yAxis);

    f = figure('Color','w','Position',[50 100 1550 360]);
    for j = 1:numel(walls)
        wall = walls(j);
        F = single_wall_metric(X,Y,xT,xR,wall);

        ax = subplot(1,7,j);
        contour(ax,X,Y,F,[k(j) k(j)], ...
            'LineColor',[0.16 0.34 0.45],'LineWidth',2.5);
        hold(ax,'on');
        plot(ax,[wall wall],yAxis([1 end]),'r--','LineWidth',1.5);
        plot(ax,xT,0,'k^','MarkerSize',4,'MarkerFaceColor','b');
        plot(ax,xR,0,'ks','MarkerSize',4,'MarkerFaceColor','r');
        text(ax,xT-0.5,0.8,'TX','HorizontalAlignment','right','FontSize',16);
        text(ax,xR+0.5,0.8,'RX','HorizontalAlignment','left','FontSize',16);
        hold(ax,'off');
        axis(ax,'equal');
        axis(ax,[xAxis([1 end]) yAxis([1 end])]);
        set(ax,'XTick',[-10 0 10],'YTick',[-10 0 10]);
        box(ax,'on');
        xlabel(ax,'x (m)');
        if j == 1
            ylabel(ax,'y (m)');
        end
        title(ax,{sprintf('(%c) Wall-TX: %g m','a'+j-1,wallToTx(j)), ...
                  sprintf('C = %.2f m',C(j))});
    end

    save_reproduction(f,mfilename);
end
