classdef CornerDetector < Curve
    %CORNERDETECTOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        name = 'No Name';
        polygon = [];
        corners = [];
    end
    
    methods
         function obj = CornerDetector(b)
            obj=obj@Curve(b);
         end
         
         function scalar = GetScalar(obj,a1,a2,b1,b2)
            v1 = obj.Point(a2) -  obj.Point(a1);
            v2 = obj.Point(b2) -  obj.Point(b1);
            scalar = dot(v1,v2);
         end
         
         function r = ShowCorners(obj)
             corners_co = obj.boundary(obj.corners,:);
             r = obj.ShowPolygon(corners_co,false,'ko');
             %set(r,'MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',10);
             
         end
         
         function r = ShowCorner(obj,i)
             p = obj.Point(i);
             plot(p(1),p(2),'o');
             
             %set(r,'MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',10);
             
         end
         
        
    end
    
end

