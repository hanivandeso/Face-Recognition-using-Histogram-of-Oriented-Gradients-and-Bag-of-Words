clc;clear;close all;
vid = VideoReader('Sample.mp4');

vidWidth = vid.Width;
vidHeight = vid.Height;

mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);

frames = {};
numFrames = get(vid,'NumberOfFrames');
for k=1:numFrames
    frames{k} = read(vid,k);
end

R = frames{1}(:,:,1);
G = frames{1}(:,:,2);
B = frames{1}(:,:,3);
 
R_back = uint8(mode(R,3));
G_back = uint8(mode(G,3));
B_back = uint8(mode(B,3));
 
Background = cat(3,R_back,G_back,B_back);

for x = 1:numFrames
    CurrentFrame = uint8(frames{x});
    
    % Mengkonversi citra menjadi grayscale
    Background_gray = rgb2gray(Background);
    CurrentFrame_gray = rgb2gray(CurrentFrame);
    
    % Pengurangan citra grayscale
    Subtraction = (double(Background_gray)-double(CurrentFrame_gray));
    
    Min_S = min(Subtraction(:));
    Max_S = max(Subtraction(:));
    Subtraction = ((Subtraction-Min_S)/(Max_S-Min_S))*255;
    Subtraction = uint8(Subtraction);
    
    % Mengkonversi citra menjadi biner menggunakan metode Otsu
    Subtraction = ~im2bw(Subtraction,graythresh(Subtraction));
    % Operasi Morfologi
    bw = imfill(Subtraction,'holes');
    bw = bwareaopen(bw,10);
    
    % Pembuatan masking dan proses cropping
    [row,col] = find(bw==1);
    h_bw = imcrop(CurrentFrame,[min(col) min(row) max(col)-min(col) max(row)-min(row)]);
    
    [a,b] = size(bw);
    mask = false(a,b);
    mask(min(row):max(row),min(col):max(col)) = 1;
    mask =  bwperim(mask,8);
    mask = imdilate(mask,strel('square',3));
    R = CurrentFrame(:,:,1);
    G = CurrentFrame(:,:,2);
    B = CurrentFrame(:,:,3);
    R(mask) = 255;
    G(mask) = 0;
    B(mask) = 0;
    
    RGB = cat(3,R,G,B);
    mov(x).cdata = RGB;
end;

%show figure
% hf = figure;
% set(hf,'position',[400 200 vidWidth vidHeight]);
% movie(hf,mov,2,vid.FrameRate);

%export video
newVid = VideoWriter('Background Subs.mp4','MPEG-4');
newVid.FrameRate = 24;
newVid.Quality = 100;
open(newVid)
    for i = 1:numFrames
        writeVideo(newVid,mov(i));
    end;
close(newVid)

close

