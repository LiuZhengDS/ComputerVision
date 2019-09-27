% This function gives a demo of the Lucas Kanade Optical Flow-based tracker (Not required in the project).
% This demo shows how to track the initial points given in the first frame. 
% If interested, you can do self-study to understand this part.

function demo_LKtracker()
	% Load ground truth points
	Points = importdata('model_house/measurement_matrix.txt');

	for num = 1:101
    		imageLoc = ['model_house/frame' num2str(num, '%08d') '.jpg'];
    		im = double(imread(imageLoc))/255;
    		if num == 1
        		Imf=zeros(size(im,1),size(im,2),101);
    		end
    		Imf(:,:,num)=im;
	     	%imshow(im);
	     	%hold on 
	     	%plot(Points(num*2-1,:),Points(num*2,:),'b.');
	     	%pause(0.1)
	end

	% Track points
	[pointsx,pointsy]=LKtracker(Points,Imf,1);

	% Save tracked points which are used in the SfM part (Lab 4).
	save('Xpoints','pointsx')
	save('Ypoints','pointsy')
end
