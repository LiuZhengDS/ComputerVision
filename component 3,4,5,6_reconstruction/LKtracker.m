% Lukas Kanade Optical Flow-based Tracker:
%   The initial points in the first frames are tracked. 
%    The output of the function are the x and y co-ordinates of tracked points across frames.

% Input Arguments :
%   p       - Ground truth locations of points across frames (measurement_matrix)
%   im      - Image frame
%   sigma   - Scale parameter of the Gaussian

function [pointsx, pointsy] = LKtracker(p, im, sigma)

    % Pre-alocate point locations 
    pointsx = zeros(size(im,3),size(p,2));
    pointsy = zeros(size(im,3),size(p,2));

    % Pre-allocate for image derivatives
    It=zeros(size(im) - [0 0 1]);
    Ix=zeros(size(im) - [0 0 1]);
    Iy=zeros(size(im) - [0 0 1]);

    % Initialize the points to track
    pointsx(1,:) = p(1,:);
    pointsy(1,:) = p(2,:);

    % Calculate the Gaussian derivative
    G  = fspecial('gaussian',[1 2*ceil(3*sigma)+1],sigma);
    Gd = gaussianDer(G,sigma);

    % Calculate the derivatives with respect to x,y (spatial) and t(temporal)
    for i=1:size(im,3)-1
        Ix(:,:,i)=conv2(conv2(im(:,:,i),Gd,'same'),G','same');
        Iy(:,:,i)=conv2(conv2(im(:,:,i),Gd','same'),G,'same');
        It(:,:,i)=im(:,:,i+1)-im(:,:,i);
    end

    % Iterate through the images and for each of the tracked points in images 
    % with the image derivatives in x,y and the temporal derivative, we 
    % can solve the system of equations to obtain flow vectors.

    for num = 1:size(im,3)-1 % iterating through images
        for i = 1:size(p,2) % iterating through points
            x = min(max(round(pointsx(num,i)),8),size(im,2)-7);  %%% center of the patch
            y = min(max(round(pointsy(num,i)),8),size(im,1)-7);  %%% center of the patch

            % Make a matrix consisting of derivatives around the pixel location
            A1 = Ix(y-7:y+7,x-7:x+7,num);
            A2 = Iy(y-7:y+7,x-7:x+7,num);
            A = [A1(:),A2(:)];

            % Make b matrix consisting of derivatives in time
            b = It(y-7:y+7,x-7:x+7,num);
            b = b(:);

            % Compute the Optical Flow, v:
            v = pinv(A'*A) * A' * double(b);

            % Estimate point correspondences
            pointsx(num+1,i) = pointsx(num,i)-v(1);
            pointsy(num+1,i) = pointsy(num,i)-v(2);
        end


        %figure(1)
        %imshow(im(:,:,num),[]); hold on;
        %plot(pointsx(num,:),pointsy(num,:),'.y') %tracked points
        %plot(p(num*2-1,:),p(num*2,:),'.m')  %ground truth
        %frame = getframe;
        %writeVideo(writerObj,frame);
    end
end
