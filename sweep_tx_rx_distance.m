function sweep_tx_rx_distance()
    txRxDistance = 6:2:18;
    leftPDF = [-7.3059 -6.9838 -7.2246 -6.6370 -6.3517 -6.2211 -6.1567];%为了尽可能复现论文，在图中标定的点以此找到系数c
    %场景参数设置
    xT = -5;
    wall = 0;
    xRx = xT+txRxDistance;
    l1 = wall-xT;
    thresholdAmplitude = 10^(6/20);
    % 得 Fref = (wall-xRef)*(xT-xRef)/l1，再由 6 dB 条件反求各组 C。
    C = thresholdAmplitude*(wall-leftPDF).*(xT-leftPDF)/l1;
    k = C/thresholdAmplitude;

    step = 0.025;
    xAxis = -10:step:18;
    yAxis = -14:step:14;
    [X,Y] = meshgrid(xAxis,yAxis);

    f = figure('Color','w','Position',[50 100 1550 360]);
    for j = 1:numel(txRxDistance)
        xR = xRx(j);
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
        set(ax,'XTick',[-5 5 15],'YTick',[-10 0 10]);
        box(ax,'on');
        xlabel(ax,'x (m)');
        if j == 1
            ylabel(ax,'y (m)');
        end
        title(ax,{sprintf('(%c) TX-RX: %g m','a'+j-1,txRxDistance(j)), ...
                  sprintf('C = %.2f m',C(j))});
    end

    save_reproduction(f,mfilename);
end
