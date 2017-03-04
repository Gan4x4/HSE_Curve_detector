clear;
close all;
tst = test_plot('noise/rectangle.bmp');
cc = ClearContur(tst);
B = cc.Trace();
%colormap([0 0 0; 1 1 1; 1 0 0 ;0 0 1]);
%image(B);
RJ73 = CornerDetectorRJ73(B);
RJ73.Show();
RJ73.SelectionProc();
hold on;
RJ73.ShowCorners();


%RJ73.ShowPolygon(RJ73.polygon,true);