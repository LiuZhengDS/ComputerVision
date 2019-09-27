%  Apply normalized 8-point RANSAC algorithm to find best matches
% Input:
%     -directory: where to load images
% Output:
%     -C: coordinates of interest points
%     -D: descriptors of interest points
%     -Matches:Matches (between each two consecutive pairs, including the last & first pair)

function [C, D, Matches] = ransac_match(directory)
    Files=dir(strcat(directory, '*.png'));
    n = length(Files);

    % Initialize coordinates C and descriptors D
    C ={};
    D ={};
    % Load all features (coordinates and descriptors of interest points)
    % As an example, we concatenate the haraff and hesaff sift features
    % You can also use features extracted from your own Harris function.
    for i=1:n
        disp('image num');
        i
        [coord_haraff,desc_haraff,~,~] = loadFeatures(strcat(directory, '/',Files(i).name, '.haraff.sift'));
        [coord_hesaff,desc_hesaff,~,~] = loadFeatures(strcat(directory, '/',Files(i).name, '.hesaff.sift'));
        
        coord= [coord_haraff coord_hesaff];
        desc = [desc_haraff desc_hesaff];
        
        C{i} = coord(1:2, :);
        D{i} = desc;
    end

    % Initialize Matches (between each two consecutive pairs)
    Matches={};

    for i=1:n
        
        if i == n
            next = 1;
        else
            next = i + 1;
        end
        
        coord1 = C{i};
        desc1  = D{i};
        
        coord2 = C{next};
        desc2  = D{next};
        
        disp('Matching Descriptors');drawnow('update')
        % Find matches according to extracted descriptors using vl_ubcmatch
        [matches, ~] = vl_ubcmatch(desc1, desc2);
        disp(strcat(int2str(size(matches,2)), ' matches found'));drawnow('update');
        
        % Obatain X,Y coordinates of matches points
        match1 = coord1(1:2,matches(1,:));
        match2 = coord2(1:2,matches(2,:));
        
        % Find inliers using normalized 8-point RANSAC algorithm
        [~, inliers] = estimateFundamentalMatrix(match1,match2);
        drawnow('update')
        Matches{i} = matches(:,inliers);
        
    end

end
