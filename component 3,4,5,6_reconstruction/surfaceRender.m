% function [] = surfaceRender(pointcloud, M, Mean, img)
% project every point on the surface to the main view (camera plane) as reconstructed from sfm,
% and use the projected coordinates to find RGB (texture) colour of the related points.

% Inputs:
% - pointcloud: reconstructed point clould
% - M: transformation matrix of the main view (camera plane) where all
% - points are projected
% - Mean: Mean values of the main view (this will be used during coordinates (de)normalization) 
% - img: corresponding image of main view
%
% Outputs:
% - None
function [] = surfaceRender(pointcloud, M1, MeanFrame1, img)


    % (X,Y,Z) of the point cloud
    % eliminate the (X,Y,Z)=(0,0,0) situation and same (overlap) points situation 
    pointcloud = unique(pointcloud', 'rows')';
    
    X = pointcloud(1,:)';
    Y = pointcloud(2,:)';
    Z = pointcloud(3,:)';

    % Cross product of two vectors (X and Y)
    % The cross product a × b is defined as a vector c 
    % that is perpendicular (orthogonal) to both a and b, 
    % with a direction given by the right-hand rule and a magnitude 
    % equal to the area of the parallelogram that the vectors span.
    viewdir = cross(M1(2,:), M1(1,:));
    viewdir = viewdir/sum(abs(viewdir));
    % sum(viewdir)=1
    viewdir = viewdir';
    % this is for searching direction based on the first camera (image)
    
    % % Centre point cloud around zero and use dot product to remove points
    % % behind the mean
    m  = [mean(X);mean(Y);mean(Z)]; 
    X0 = [X Y Z];
    X1 = repmat(viewdir', size(X0,1), 1);
    Xm = repmat(m', size(X0,1), 1);

    % Remove the points where the dot product between the mean subtracted points
    % (given by ‘X0 - Xm’) and the viewing direction is negative
    Xmean = X0-Xm;
    indices = find(sum(Xmean.*X1, 2)<0);
    X(indices) = [];
    Y(indices) = [];
    Z(indices) = [];

    % Grid to create surface on using meshgrid.
    % You can define the size of the grid (e.g., -500:500) 
    ti = -500:500;
    [qx,qy] = meshgrid(ti, ti);

    % Surface generation using TriScatteredInterp
    % You can also use scatteredInterpolant instead.
    % Please check the detailed usage of these functions
    F  = TriScatteredInterp([X,Y],Z);
    qz = F(qx,qy); 
    % show(qz) % pre-see teddy bear

    % Note: qz contains NaNs because some points in Z direction may not defined
    % This will lead to NaNs in the following calculation.

    % Reshape (qx,qy,qz) to row vectors for next step
    qxrow = reshape(qx,[1,numel(qx)]);
    qyrow = reshape(qy,[1,numel(qy)]);
    qzrow = reshape(qz,[1,numel(qz)]);
    q = [qxrow;qyrow;qzrow];

    % Transform to the main view using the corresponding motion / transformation matrix, M
    q_xy = M1 * q;

    % All transformed points are normalized by mean values in advance, we have to move
    % them to the correct positions by adding corresponding mean values of each dimension.
    q_x = q_xy(1,:) + MeanFrame1(1);
    q_y = q_xy(2,:) + MeanFrame1(2);

    % Remove NaN values in q_x and q_y
    q_x(isnan(q_x))=1;
    q_y(isnan(q_x))=1;
    q_x(isnan(q_y))=1;
    q_y(isnan(q_y))=1;

    figure(2);
    
    q_x_int = ceil(q_x);
    q_y_int = ceil(q_y);
    if(size(img,3)==3)
        
        % Select the corresponding r,g,b image channels
        imgr = img(:,:,1);
        imgg = img(:,:,2);
        imgb = img(:,:,3);

        % Color selection from image according to (q_y, q_x) using sub2ind
        Cr = imgr(sub2ind(size(imgr), q_y_int, q_x_int));
        Cg = imgg(sub2ind(size(imgr), q_y_int, q_x_int));
        Cb = imgb(sub2ind(size(imgr), q_y_int, q_x_int));

        qc(:,:,1) = reshape(Cr,size(qx));
        qc(:,:,2) = reshape(Cg,size(qy));
        qc(:,:,3) = reshape(Cb,size(qz));
    else 
        
        % If grayscale image, we only have 1 channel
        C  = img(sub2ind(size(img), q_y_int, q_x_int));
        qc = reshape(C,size(qx));
        colormap gray
    end

    % Display surface
    surf(qx, qy, qz, qc);
     
    % Render parameters
    axis( [-500 500 -500 500 -500 500] );
    daspect([1 1 1]);
    rotate3d;

    shading flat;
end
