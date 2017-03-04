classdef Curve < handle
    %COMTUR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        boundary = 0;
        closed = true;
    end
    
    
    methods(Static)
       
        function d = GetEuclidDistance(a,b)
            d=((a(1)-b(1))^2+(a(2)-b(2))^2)^0.5;
        end    
        
        function perimeter = Perimeter(curve,closed)
            
            
            if ( (size(curve,1) >= 2) && (size(curve,2) >= 2))
                curve = [curve(:,1) curve(:,2)];
                if (nargin == 1) 
                    % by default mean that curve is closed
                    closed = true; 
                end
                if (size(curve,1) == 2)
                    % for line of two point
                    closed = false;
                end
                
                if closed
                    perimeter = approx.GetEuclidDistance(curve(1,:),curve(end,:));
                else
                    perimeter = 0;
                end
                for i = 1:1:length(curve)-1
                    perimeter = perimeter + approx.GetEuclidDistance(curve(i,:),curve(i+1,:));
                end
            else
                perimeter = false;
            end

        end
        
        function res=ShowPolygon(poly,clsd,style)
            if nargin == 2
                style = '';
            end
            x=poly(:,1);
            y=poly(:,2);
            if clsd
                x=[x;x(1)];
                y=[y;y(1)];
            end
            res=plot(x,y,style);
        end
    
        
    end

    
    methods
        
        function obj=Curve(B)
            obj.boundary = B;
        end
        
        
        
        function Show(obj)
            Curve.ShowPolygon(obj.boundary,obj.closed); 
        end
        
        function n=GetPointNum(obj,num,curve)
            n = num;
            if nargin == 2 
                curve = obj.boundary; 
            end
            l = length(curve);
            if obj.closed
                if n > l || n < 0
                    n = mod(num,l); 
                end
            else 
                n = l;
            end
            if n == 0
                   n = l;
            end
            %assert(n <= l);   
        end
                
         function p = Point(obj,num,curve)
            if nargin == 2 
                curve = obj.boundary; 
            end
            n = obj.GetPointNum(num,curve); 
            p = curve(n,:);
         end
         
         function p = PointWithNum(obj,num,curve)
             if nargin == 2 
                curve = obj.boundary; 
            end
            p = [Point(obj,num,curve) num];
         end
             
                 
        
          function distance = GetDistance(obj,a,b)
            % a and b int's point number in sequence
            ap = obj.Point(a);
            bp = obj.Point(b);
            distance = approx.GetEuclidDistance(ap,bp);
        end
        
        
        
    end
    
end

