clc;clear;close all;
vid = VideoReader('Sample.mp4');

vidWidth = vid.Width;
vidHeight = vid.Height;

mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);

%Read every frames
frames = {};
numFrames = get(vid,'NumberOfFrames');
for k=1:numFrames
    frames{k} = read(vid,k);
end

%Filter Viola-Jones
for x = 1:numFrames
    CurrentFrame = uint8(frames{x});
    faceDetector = vision.CascadeObjectDetector;
    I = CurrentFrame;
    bboxes = step(faceDetector, I);
    IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Face');
    mov(x).cdata = IFaces;
%     figure, imshow(IFaces), title('Detected faces');
end

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