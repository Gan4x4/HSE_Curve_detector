clear;
close all;
%path(path,'D:\works\Лекции\Статьи\Гостев\Poligonal Approximation\MatLab_libs\');
tst = test_plot('noise/rectangle.bmp');
%tst = [3 2 ; 3 -5 ;-6 -4; -5 2 ; 1 4]
%tst = [[3 2] ; [2 - 5]; [-6 -1]];
cc = ClearContur(tst);
B = cc.Trace();
%B = tst;
colormap([0 0 0; 1 1 1; 1 0 0 ;0 0 1]);
image(B);

%t0 = clock;
split = ApproximationSplit(B,15);
split.ShowBoundary();
%{
split.ClearPolygon();
split.CreateFixedPointPoligon(10);
split.ShowAll();
split.ClearPolygon();

figure;
split.CreateFixedPointPoligon(15);
split.ShowAll();
split.ClearPolygon();

figure;
%}
split.SetEpsilon(1);
split.CreateFixedPointPoligon(0);
split.ShowAll();
split.ClearPolygon();


%{
figure;
dp = ApproxDouglasPecker(B,1);
dp.ShowBoundary();
dp.Do();
dp.ShowAll();
dp.ClearPolygon();

%}





