clear all
%get the png file of OCT image
[FileName,FilePath] = uigetfile('*.png','Select slo Image');
sloImage = imread(FileName);
SLOFig=figure ('units','normalized','outerposition',[0 0 1 1]);
%creating axis with the image size for slo image, for spectralis, this is
%usualy 1536 x 1536
axis([1 1536 1 1536]);
axis on;
handles.axis=gca;
hAx  = gca;
% set the axes to full screen
set(hAx,'Unit','normalized','Position',[0 0 1 1]);
set(gcf,'ButtonDownFcn',{@axes1_ButtonDownFcn});
%displat the image and ask to mark at least 12 points, this number can be
%changed to any wanted number
imshow(sloImage);
dim = [0.4 0.75 .1 .2];
str = 'Please mark 12 BMO points';
msg=annotation('textbox',dim,'String',str,'FitBoxToText','on',...
    'color',[1 0 0],'FontSize',20,'units','normalized');
hold on;
% title('Please mark 12 BMO points','FontSize', 24),hold on


BMOs=nan(12,2);
for i=1:size(BMOs,1)
    BMO=ginput(1);
    BMOCenterplot=plot(BMO(1,1),BMO(1,2),'Marker','.','MarkerSize',10,'color','r');
    BMOs(i,:)=BMO;
end
x=BMOs(:,1);
% x=x';
y=BMOs(:,2);
%calling the fit_ellipse function to plot ellipse on the ONH points to
%calculate diameter of ONH
ellipse_t=fit_ellipse(x,y);

[pathstr,name,ext] = fileparts(FileName);
newfilename = fullfile(FilePath, name);
BMOCenter=[ellipse_t.X0_in ellipse_t.Y0_in];
%save all data including the ellipse parameters as a mat file
save([newfilename 'BMOs.mat'],'BMOs','sloImage','ellipse_t','BMOCenter')
delete(msg)
saveas(gcf , [newfilename 'sloImageBMOsMarked.png']);
msg=(msgbox('Data saved...Thank you!','Save Complete'));
pause(2);
delete(msg)
% close all

