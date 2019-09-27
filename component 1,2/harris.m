function [r, c, sigmas] = harris(im, loc)
%function R111 = harris(im, loc)
    % inputs: 
    % im: double grayscale image
    % loc: list of interest points from the Laplacian approximation
    % outputs:
    % [r,c,sigmas]: The row and column of each point is returned in r and c
    %              and the sigmas 'scale' at which they were found
    
    % Calculate Gaussian Derivatives at derivative-scale. 
    % NOTE: The sigma is independent of the window size (which dependes on the Laplacian responses).
    % Hint: use your previously implemented function in assignment 1 

    %   
    %im = im2double( rgb2gray( im ) );
    img111 = im;
    im = ( rgb2gray( im ) );
    sig = 3;
    Ix =  ImageDerivatives ( im , sig , 'x' );
    Iy =  ImageDerivatives ( im , sig , 'y' );

    % Allocate an 3-channel image to hold the 3 parameters for each pixel
    init_M = zeros(size(Ix,1), size(Ix,2), 3);

    % Calculate M for each pixel
    init_M(:,:,1) = Ix.^2;
    init_M(:,:,2) = Iy.^2;
    init_M(:,:,3) = Ix.*Iy;
    size(init_M);
    % Allocate R 
    R = zeros(size(Ix,1), size(Ix,2), 2);

    % Smooth M with a gaussian at the integration scale sigma.
    % Keep only points from the list 'loc' that are coreners. 
    for l = 1 : size(loc,1)
        sigma = loc(l,3); % The sigma at which we found this point	
        if ((l>1) && sigma~=loc(l-1,3)) || (l==1)
            M = imfilter(init_M, fspecial('gaussian', ceil(sigma*6+1), sigma), 'replicate', 'same');
        end
        % Compute the cornerness R at the current location location
        trace = M(loc(l,2), loc(l,1),1) + M(loc(l,2), loc(l,1),2);
        det = M(loc(l,2), loc(l,1),1) * M(loc(l,2), loc(l,1),2) + M(loc(l,2), loc(l,1),3)^2;
        R(loc(l,2), loc(l,1), 1) = det - 0.05 * trace^2;
	% Store current sigma as well
        R(loc(l,2), loc(l,1), 2) = sigma;
    end
    % Display corners
    
%     figure
%     imshow(R(:,:,1),[0,1]);

    % Set the threshold 
    threshold = max(max(R(:,:,1)))*0.01;
    % Find local maxima
    % Dilation will alter every pixel except local maxima in a 3x3 square area.
    % Also checks if R is above threshold

    % Non max supression	
    R(:,:,1) = ((R(:,:,1)>threshold) & ((imdilate(R(:,:,1), strel('square', 3))==R(:,:,1)))) ; 
    % Return the coordinates and sigmas
    [r,c] = find(R(:,:,1)==1);
    
    sigmas = [];
    for i=1:size(r)
        sigmas = [sigmas; R(r(i), c(i),2)];
    end
    
    %figure;
    %imshow((img)/255.0, [0,1]); hold on; % for balck white plot
    %imshow(img111); hold on;
    %circle(c,r,2*sigmas+1); hold off;
end


% function h = circle(in_x, in_y, in_r)
%     for i = 1:size(in_x,1)
%         x = in_x(i);
%         y = in_y(i);
%         r = in_r(i);
%         
%         th = 0:pi/50:2*pi;
%         xunit = r * cos(th) + x;
%         yunit = r * sin(th) + y;
%         h = plot(xunit, yunit);
%     end
% end
