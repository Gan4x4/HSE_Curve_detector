function R = test_plot( im )
if nargin == 0 
    im = 'noise/rectangle.bmp'; 
end
I = imread(im);
%imshow(I);
%BW = im2bw(I, graythresh(I));
%BW = im2bw(I,0.5);

BW = ~I;
%figure;
%imshow(BW);
B = bwboundaries(BW,8,'noholes');

[~, Index] = sort(cellfun('length', B), 'ascend');
B = B(Index);
R = B{end};

%{
input(int2str(length(B)));
for i = 0:1:15
    U = B{end-i};
    plot(U(:,2), U(:,1));
    input(int2str(length(U)));
end


%hold on;
boundary = get_boundary(B);
%plot(boundary(:,2), boundary(:,1));
R=boundary;
%}
end

function ret = get_boundary(B)
ret = 0;
s1=0;
smax = 0;
for k = 1:length(B)
    boundary = B{k};
    cs = size(boundary,1);
    if cs > smax 
        smax = cs;
    end
    if cs > s1 & cs <= smax
        ret = boundary;
        s1= cs;
    end
end



end
