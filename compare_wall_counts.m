function compare_wall_counts()
    %场景参数设置
    TX = [-5, 0];
    RX = [7, 0];

    wallLayouts = {0, [0 4]};
    titles = {'One wall', 'Two walls'};

    gammaDb = 6;
    gammaAmp = 10^(gammaDb/20);

    singlePoint = [-6.64, 0];

    pointsDouble = [-6.5 0; -3.1 0; 2 2.7; 2 -2.7; 5.8 0; 8.2 0];
    pointNames = {'A','B','C','D','E','F'};

    step = 0.025;

    xAxis = -9.4:step:15;
    yAxis = -12.5:step:12.5;

    [X,Y] = meshgrid(xAxis,yAxis);

    f = figure('Color','w', ...
        'Position',[100 100 1100 520]);

    for j = 1:2

        walls = wallLayouts{j};

        F = coverageMetric(X,Y,TX,RX,walls);

        if j == 1

            k = coverageMetric( ...
                singlePoint(1),singlePoint(2), ...
                TX,RX,walls);

            c = gammaAmp*k;

            fprintf('\n========== ONE WALL ==========\n');
            fprintf('k = %.6f\n',k);
            fprintf('c = %.6f\n',c);

        else

            fprintf('\n========== TWO WALLS ==========\n');

            nPoints = size(pointsDouble,1);
            Fpoints = coverageMetric(pointsDouble(:,1),pointsDouble(:,2),TX,RX,walls);
            cPoints = gammaAmp*Fpoints;

            k = mean(Fpoints);
            c = gammaAmp*k;

            residuals = Fpoints-k;

            fprintf('Point    x        y        F        c_i\n');

            for i = 1:nPoints
                fprintf('%s     %7.3f  %7.3f  %8.4f  %8.4f\n', ...
                    pointNames{i}, ...
                    pointsDouble(i,1), ...
                    pointsDouble(i,2), ...
                    Fpoints(i),cPoints(i));
            end

            fprintf('\nFitted k = %.6f\n',k);
            fprintf('Fitted c = %.6f\n',c);

            RMSE = sqrt(mean(residuals.^2));
            relativeRMSE = RMSE/max(abs(k),eps);

            fprintf('RMSE of F = %.6f\n',RMSE);
            fprintf('Relative RMSE = %.2f%%\n', ...
                relativeRMSE*100);

            regionNames = {'Left','Middle','Right'};

            for r = 1:3
                idx = (2*r-1):(2*r);
                cRegion = mean(cPoints(idx));

                fprintf('%s region fitted c = %.6f\n', ...
                    regionNames{r},cRegion);
            end

            if relativeRMSE > 0.05
                warning(['Six boundary points are not consistent ' ...
                         'with a single coefficient c. ' ...
                         'The propagation model may need revision.']);
            end

        end

        ax = subplot(1,2,j);
        hold(ax,'on');

        if j == 1
            boundaryColor = [0.32 0.43 0.58];
        else
            boundaryColor = [0.95 0.38 0.05];
        end

        contour(ax,X,Y,F,[k k], ...
            'LineColor',boundaryColor, ...
            'LineWidth',2.5);

        for w = walls
            plot(ax,[w w],[yAxis(1) yAxis(end)], ...
                'r--','LineWidth',1.5);
        end

        plot(ax,TX(1),TX(2),'k^', ...
            'MarkerFaceColor','b','MarkerSize',16);

        plot(ax,RX(1),RX(2),'ks', ...
            'MarkerFaceColor','r','MarkerSize',16);

        text(ax,TX(1),-1.4,'TX', ...
            'HorizontalAlignment','center');

        text(ax,RX(1),-1.4,'RX', ...
            'HorizontalAlignment','center');

        title(ax,sprintf('%s | c = %.3f',titles{j},c), ...
            'FontSize',15);

        xlabel(ax,'x Distance (m)');
        ylabel(ax,'y Distance (m)');

        axis(ax,'equal');
        xlim(ax,[xAxis(1),xAxis(end)]);
        ylim(ax,[yAxis(1),yAxis(end)]);

        xticks(ax,[-5 0 5 10 15]);
        yticks(ax,[-10 0 10]);

        box(ax,'on');
        hold(ax,'off');

    end

    save_reproduction(f,mfilename);
end

function F = coverageMetric(X,Y,TX,RX,walls)

    nodes = [TX(1),sort(walls),RX(1)];
    staticProduct = prod(abs(diff(nodes)));

    Dtx = legProduct(X,Y,TX,walls);
    Drx = legProduct(X,Y,RX,walls);

    F = Dtx.*Drx./staticProduct;

end

function P = legProduct(X,Y,device,walls)

    xD = device(1);
    yD = device(2);

    R = hypot(X-xD,Y-yD);

    [~,idx] = sort(abs(walls-xD));
    walls = walls(idx);

    P = ones(size(X));
    previous = zeros(size(X));

    for i = 1:numel(walls)

        w = walls(i);

        crosses = (X-w).*(xD-w) < 0;

        t = zeros(size(X));
        t(crosses) = (w-xD)./(X(crosses)-xD);

        segment = R(crosses).* ...
            (t(crosses)-previous(crosses));

        P(crosses) = P(crosses).*segment;

        previous(crosses) = t(crosses);
    end

    finalSegment = R.*(1-previous);

    P = P.*finalSegment;
end
