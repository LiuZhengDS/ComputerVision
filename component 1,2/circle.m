function h = circle(in_x, in_y, in_r)
    for i = 1:size(in_x,1)
        x = in_x(i);
        y = in_y(i);
        r = in_r(i);
        
        th = 0:pi/50:2*pi;
        xunit = r * cos(th) + x;
        yunit = r * sin(th) + y;
        h = plot(xunit, yunit);
    end
end