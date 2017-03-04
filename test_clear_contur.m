close all;
clear;
%b=[10,10;10,11;10,12;9,12;11,12];
%plot(b(:,1),b(:,2));
%I = test_plot('good/rectangle.bmp');
I = test_plot('noise/rectangle.bmp');
cb = ClearContur(I);
%figure;
%grid on;
%axes;
%set(figure_handle,'CurrentAxes',axes_handle)
%imshow(cb.img,[0,1],'InitialMagnification','fit');

colormap([0 0 0; 1 1 1; 1 0 0 ;0 0 1]);
image(cb.img);
%cb.img(3,3) = 2;
%n=input('Press any key');
cb.Trace();
%colormap([0 0 0; 1 1 1; 1 0 0 ;0 0 1]);
%image(cb.ToImage(cb.img,cb.cleared,PrevP));
%image(cb.cleared);
%hold on;
%plot(cb.cleared(:,2), cb.cleared(:,1), 'r', 'LineWidth', 2)
%cb.ToImage;
%image(cb.img);
%colormap([0,0,0;1,1,1]);