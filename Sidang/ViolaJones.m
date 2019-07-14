clc;
clear;
close all;

    videofiles = dir(['Data', '/', '*.mp4']);
    nfiles = length(videofiles);
    i = 2
% for i=1:nfiles
    vid = VideoReader(['Data','/',videofiles(i).name]);
    vidname = strsplit(vid.Name,'.mp4');
    numdetected = 0;
    disp(strcat('processing-',vid.name,'...'));

    vidWidth = vid.Width;
    vidHeight = vid.Height;
    
    FaceDetector = vision.CascadeObjectDetector('FrontalFaceCART','UseROI',true,'MergeThreshold',8,'MinSize',[53 53]);

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
            numdetected = numdetected + 1;
            szbox = size(bboxes{x},[1]);
            for y = 1:szbox
                %crop gambar
%                 disp(strcat('saving detected image (',num2str(x),')...'));
                Icropped = imcrop(I,bboxes{x}(y,:));
                imwrite(Icropped,strcat('Data\Train\',vidname{1},'\',vidname{1},'_',num2str(numdetected),'.png'));
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

%         %export video
%         disp(strcat('exporting video-',num2str(h),'....'));
%         newVid = VideoWriter(strcat('Dataset3\coba-',num2str(h),'.mp4'),'MPEG-4');
%         newVid.FrameRate = 24;
%         newVid.Quality = 100;
%         open(newVid)
%             for i = 1:numFrames 
%                 writeVideo(newVid,mov(i));
%             end;
%         close(newVid)
% end
disp('done');
close