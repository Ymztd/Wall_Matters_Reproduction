function F = single_wall_metric(X,Y,xT,xR,wall)
    left = X < wall;
    right = X > wall;
    F = zeros(size(X));  % Limiting value on the idealized wall.
    F(left) = (wall-X(left))/(wall-xT) .* ...
        (1+(Y(left)./(xR-X(left))).^2) .* hypot(X(left)-xT,Y(left));
    F(right) = (X(right)-wall)/(xR-wall) .* ...
        (1+(Y(right)./(X(right)-xT)).^2) .* hypot(X(right)-xR,Y(right));
end
