NUM_SAMPLES=100;
for type = 1:4
    if type == 1
        h = 0.95;
        i = 1.05;
        m = 0;
        typename = 'hyperbolic';
    elseif type == 2
        h = 1.05;
        i = 1.05;
        m = 0.5;
        typename = 'spiral';
    elseif type == 3
        h = 1;
        i = 1;
        m = 0.5;
        typename = 'concentric';
    else
        h = 1.05;
        i = 1.05;
        m = 0;
        typename = 'starburst';
    end
    trans = 2;
    numdots = 25;
    foldername = strcat(num2str(trans), 'r_', num2str(numdots), 'd_', typename, '_200dist\');
    mkdir(foldername)
    for n = 1:500
        x = 2;
        for j = 1.0:1.0:1.0
            attr = 'name';
            attr_value = 'dots_data';
            k = num2str(j);
            file_name = ['spiral_' k '.h5'];
            hdf5write(file_name, attr, attr_value);
            
            c = 2;
            % 1 hyperbolic a=0.95 / b=1.05 / θ=0. 
            % 2 spiral pattern, a=1.05 / b=1.05 / θ=5. 
            % 3 concentric pattern, a=1 / b=1 / θ=5. 
            % 4 "starburst" pattern, a=1.05 / b=1.05 / θ=0
            %need to run 3 and 4
            for a = h
                for b = i
                    for theta = m
                        for num_trans = [trans]
                            for num_dots = [numdots]
                                current_s = struct('a',a,'b',b,'theta',theta/pi, 'num_trans', num_trans, 'num_dots', num_dots);
                                x_array = zeros(NUM_SAMPLES, 2, num_dots*2^num_trans);
                                for i = 1:NUM_SAMPLES
                                    [e, x] = dots(current_s.a,current_s.b,current_s.theta,current_s.num_trans,current_s.num_dots);
                                    x_array(i,:,:) = x;
            %                         dots_s(c) = struct('e',e,'x',x_array);
                                end
                                x_dset = hdf5.h5array(x_array);
                                    e_dset = hdf5.h5array(e);
                            
                                path_name = [num2str(a) '/' num2str(b) '/' num2str(theta) '/' num2str(num_trans) '/' num2str(num_dots)];
                                hdf5write(file_name, [path_name '/e'], e_dset, 'WriteMode', 'append');
                                hdf5write(file_name, [path_name '/x'], x_dset, 'WriteMode', 'append');
                                c = c+1;
            
                            end
                        end
                    end
                end
            end
        end
        %%
        numPoints = 200;

        % Generate random points between -1 and 1 for both dimensions
        xRand = -1 + 2 * rand(1, numPoints);
        yRand = -1 + 2 * rand(1, numPoints);
        %saveas(fig, 'test.jpg')
        %p = scatter(x(1,:),x(2,:), 'filled', 'MarkerFaceColor', 'b', 'MarkerFaceAlpha', 0.02, SizeData=10);
        if n == 1
            %figure;
        end
        p1 = scatter(x(1,:),x(2,:), 'filled', 'MarkerFaceColor', 'b', SizeData=10);
        hold on;
        p2 = scatter(xRand, yRand, 'filled', 'MarkerFaceColor', 'b', SizeData=10);
        hold off;

        
        %p.facealpha("flat") 
        p = gobjects(2, 1);
        p(1) = p1;
        p(2) = p2;
        xLimit = [-1, 1];
        yLimit = [-1, 1];
        combinedX = [];
        combinedY = [];
        for i = 1:numel(p)
            xData = p(i).XData;
            yData = p(i).YData;
            
            % Add points within the specified area
            indicesToAdd = (xData >= xLimit(1) & xData <= xLimit(2) & yData >= yLimit(1) & yData <= yLimit(2));
            combinedX = [combinedX, xData(indicesToAdd)];
            combinedY = [combinedY, yData(indicesToAdd)];
        end
        combinedPlot = scatter(combinedX, combinedY, 'filled', 'MarkerFaceColor', 'b', 'SizeData', 10);
        fig = figure('visible', 'off');
        ax = axes;
        copyobj(combinedPlot, ax)
        set(gca, "Visible", "off")
        
        %figure;
        %figname = strcat('/3r_50d_spiral/', num2str(n), ".jpg");
  
        saveas(fig, [pwd strcat('\', foldername, num2str(n), '.jpg')]); 
        clear p x c;
        %saveas(p, num2str(n), "jpg")
    end
    
    
    %figure
end
close;
msgbox('Your code has finished executing!', 'Execution Complete', 'modal');
clear;
beep;