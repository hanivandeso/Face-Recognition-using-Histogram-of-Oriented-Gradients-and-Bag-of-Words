clc;clear;close all;
vid = VideoReader('Sample.mp4');

vidWidth = vid.Width;
vidHeight = vid.Height;

mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);

frames = zeros(vidHeight,vidWidth,3,5);
numFrames = get(vid,'NumberOfFrames');
for k=1:numFrames
    frames(:,:,:,k) = read(vid,k);
end

% R = squeeze(frames(:,:,1,:));
% G = squeeze(frames(:,:,2,:));
% B = squeeze(frames(:,:,3,:));
% 
% R_back = uint8(mode(R,3));
% G_back = uint8(mode(G,3));
% B_back = uint8(mode(B,3));
%  
% Background = cat(3,R_back,G_back,B_back);

close;