% run the main.m to test

% to test two different dataset, you need to change file path manually
% we have set two different path "commented" in reconstruction_demo.m

% in line 7 and 8
% line 7: castle
% line 8: teddy bear
% you can choose which one you want to test and comment the other one.

% for castle dataset, you can just run recomnstruction_demo();
% to get results

% !!!
% for teddy bear dataset, you need to change a detail surfaceRender.m;
% surfaceRender.m line 30:
% viewdir = cross(M1(1,:), M1(2,:));
% to
% viewdir = cross(M1(2,:), M1(1,:));
% to obtain correct direction
