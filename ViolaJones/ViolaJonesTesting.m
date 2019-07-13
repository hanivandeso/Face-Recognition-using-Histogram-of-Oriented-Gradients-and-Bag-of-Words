clc;clear;close all;

for h=1:2
    h
    vid = VideoReader(strcat(num2str(h),'.mp4'));

    vidWidth = vid.Width;
    vidHeight = vid.Height;

    LefteyeDetector = vision.CascadeObjectDetector('LeftEye');
    RighteyeDetector = vision.CascadeObjectDetector('RightEye');
%     PairofeyeDetectorS = vision.CascadeObjectDetector('EyePairSmall');
%     PairofeyeDetectorB = vision.CascadeObjectDetector('EyePairBig');
    FaceLBPDetector = vision.CascadeObjectDetector('FrontalFaceLBP','UseROI',true);
    ProfileFaceDetector = vision.CascadeObjectDetector('ProfileFace','UseROI',true);

    mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);

    %Read every frames
    frames = {};
    numFrames = get(vid,'NumberOfFrames');

%Filter Viola-Jones

%     for x = 1:numFrames
%         CurrentFrame = uint8(cropped{x});
%         faceDetector = vision.CascadeObjectDetector;
%         I = CurrentFrame;
%         bboxes{x} = step(faceDetector, I);
%         if ~isempty(bboxes{x})
%             szbox = size(bboxes{x},[1]);
%             for y = 1:szbox
%                 %crop gambar
%                 I = imcrop(CurrentFrame,bboxes{x}(y,:));                        
%                 Leftbboxes = step(LefteyeDetector, I);
%                 Rightbboxes = step(RighteyeDetector, I);
%                 % validasi ada mata kiri gak
%                 if (~isempty (Leftbboxes) & ~isempty(Rightbboxes))
%                     %save gambar
%                     imwrite(I,strcat(num2str(h),'_eye\frame-',num2str(x),'-',num2str(y),'.png')); 
%                 end
%             end
%         end
%         IFaces = insertObjectAnnotation(I, 'rectangle', bboxes{x}, 'Face');
%         mov(x).cdata = IFaces;
%     end

       for x = 1:numFrames
       frames{x} = read(vid,x);
       CurrentFrame = frames{x};
       I = CurrentFrame;
%        bboxes{x} = step(FaceLBPDetector, I, [676.5 130.5 208 258]);
       bboxes{x} = step(ProfileFaceDetector, I, [470 130 400 205]);
       if ~isempty(bboxes{x})
           szbox = size(bboxes{x},[1]);
           for y = 1:szbox
               %crop gambar
               disp(strcat('saving detected image (',num2str(x),')...'));
               Icropped = imcrop(CurrentFrame,bboxes{x}(y,:));
               imwrite(Icropped,strcat('Profile',num2str(h),'\frame-',num2str(x),'-',num2str(y),'.png')); 
           end
       end
       IFaces = insertObjectAnnotation(I, 'rectangle', bboxes{x}, 'Face');
       mov(x).cdata = IFaces;
       
       end
   
       
       
        %show video
        disp('showing figure...');
        hf = figure;
        set(hf,'position',[400 200 vidWidth vidHeight]);
        movie(hf,mov,2,vid.FrameRate);
        

        %export video
        disp(strcat('exporting video :',num2str(h),' ..'));
        newVid = VideoWriter(strcat('coba-',num2str(h),'.mp4'),'MPEG-4');
        newVid.FrameRate = 24;
        newVid.Quality = 100;
        open(newVid)
            for i = 1:numFrames 
                writeVideo(newVid,mov(i));
            end;
        close(newVid)
    
end


% %show video
% hf = figure;
% set(hf,'position',[400 200 vidWidth vidHeight]);
% 
% movie(hf,mov,2,vid.FrameRate);

% %export video
% newVid = VideoWriter('coba.mp4','MPEG-4');
% newVid.FrameRate = 24;
% newVid.Quality = 100;
% open(newVid)
%     for i = 1:numFrames 
%         writeVideo(newVid,mov(i));
%     end;
% close(newVid)

disp('done');

close