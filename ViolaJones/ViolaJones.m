function [outputArg1,outputArg2] = ViolaJones(inputArg1,inputArg2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    faceDetector = vision.CascadeObjectDetector;
    I = imread('visionteam.jpg');
    bboxes = step(faceDetector, I);
    IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Face');
    figure, imshow(IFaces), title('Detected faces');
%     outputArg1 = inputArg1;
%     outputArg2 = inputArg2;
end

