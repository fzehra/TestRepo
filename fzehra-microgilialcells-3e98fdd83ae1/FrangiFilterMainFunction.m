%%  calculate Frangi's filter
%% edited in 05.11.2014

clc
clear all
close all

% read the image

I=(double(imread('LPS_CTL_PLoS_6animals.lif - 602_1 - C=2.tif')));
figure, imagesc(I);

 
%% calculate medialness for different scales 
scales=[ 2 3  4 5];
Tres=FrangiMeadialnessAtAScale (I,scales,0.8);
figure, imagesc(double(Tres))
