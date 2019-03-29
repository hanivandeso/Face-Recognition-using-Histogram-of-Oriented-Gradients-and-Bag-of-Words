clc;clear;close all;
vid = VideoReader('Sample Edited.mp4');

vidWidth = vid.Width;
vidHeight = vid.Height;

mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);

%Read every frames
frames = {};
numFrames = get(vid,'NumberOfFrames');
for k=1:numFrames
    frames{k} = read(vid,k);
    cropped{k} =imcrop(frames{k},[676.5 130.5 208 258]);
    %current ideal head position
    %[459.5 120.5 433 276]
    
    %current best head position
    %[676.5 130.5 208 258]
end

detect={};
%Filter Viola-Jones
for x = 1:numFrames
    CurrentFrame = uint8(cropped{x});
    faceDetector = vision.CascadeObjectDetector;
    I = CurrentFrame;
    bboxes{x} = step(faceDetector, I);
    if ~isempty(bboxes{x})
        %crop gambar
        A = imcrop(CurrentFrame,bboxes{x});
        
        %save gambar
        imwrite(A,strcat('frame-',num2str(x),'.png'));
%         detect=[detect bboxes{x}];
    end
    IFaces = insertObjectAnnotation(I, 'rectangle', bboxes{x}, 'Face');
    mov(x).cdata = IFaces;
%     figure, imshow(IFaces), title('Detected faces');
end

% %cropped detected frames
% sz(detect,2);
% for y = 1:sz
%     A = imcrop(frames{k},[]);
% end

%show video
hf = figure;
set(hf,'position',[400 200 vidWidth vidHeight]);

movie(hf,mov,2,vid.FrameRate);

%export video
newVid = VideoWriter('coba.mp4','MPEG-4');
newVid.FrameRate = 24;
newVid.Quality = 100;
open(newVid)
    for i = 1:numFrames
        writeVideo(newVid,mov(i));
    end;
close(newVid)

close