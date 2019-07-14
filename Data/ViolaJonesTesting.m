clc;clear;close all;
%     h = 20;
for h=1:20
    disp(strcat('Processing Image-',num2str(h),'....'));
    vid = VideoReader(strcat(num2str(h),'.mp4'));

    vidWidth = vid.Width;
    vidHeight = vid.Height;
    
    FaceDetector = vision.CascadeObjectDetector('FrontalFaceCART','UseROI',true,'MergeThreshold',11,'MinSize',[53 53]);

    mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);

    %Read every frames
    frames = {};
    numFrames = get(vid,'NumberOfFrames');


        for x = 1:numFrames
        frames{x} = read(vid,x);
        CurrentFrame = frames{x};
        I = CurrentFrame;
        bboxes{x} = step(FaceDetector, I, [470 63 400 267]);
        if ~isempty(bboxes{x})
            szbox = size(bboxes{x},[1]);
            for y = 1:szbox
                %crop gambar
%                 disp(strcat('saving detected image (',num2str(x),')...'));
                Icropped = imcrop(I,bboxes{x}(y,:));
                imwrite(Icropped,strcat('Dataset3\T13_',num2str(h),'\frame-',num2str(x),'-',num2str(y),'.png'));
            end
        end
        IFaces = insertObjectAnnotation(I, 'rectangle', bboxes{x}, 'Face');
        mov(x).cdata = IFaces;       
        end
       
%         %show video
%         disp('showing figure...');
%         
%         hf = figure;
%         set(hf,'position',[400 200 vidWidth vidHeight]);
%         movie(hf,mov,2,vid.FrameRate);

        %export video
        disp(strcat('exporting video-',num2str(h),'....'));
        newVid = VideoWriter(strcat('Dataset3\coba-',num2str(h),'.mp4'),'MPEG-4');
        newVid.FrameRate = 24;
        newVid.Quality = 100;
        open(newVid)
            for i = 1:numFrames 
                writeVideo(newVid,mov(i));
            end;
        close(newVid)
end
disp('done');
close