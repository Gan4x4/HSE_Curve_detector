classdef Approximation < Curve
    %APPROXIMATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        polygon = 0;
        points = 10
        epsilon = 0;
        current_epsilon = 0;
        info_size = [120 200];
        work_time = 0;
        name = 'No Name';
    end
    
    methods
        
        function obj=Approximation(B,n)
            obj = obj@Curve(B);
            obj.points=n;
        end
        
        
        function SetEpsilon(obj,e)
            obj.epsilon = e;
            obj.SetCurrentEpsilon(e+1);
        end
        
        function SetCurrentEpsilon(obj,e)
            obj.current_epsilon = e;
        end
        
        function ClearPolygon(obj)
            obj.polygon = 0;
        end
        
        function ret = IsCanFinish(obj)
      
            ret = false;
            if (obj.epsilon > 0) && (obj.epsilon >= obj.current_epsilon)
                ret = true;
            end
            
            if (obj.points > 0) && (length(obj.polygon) >= obj.points) 
                ret = true; 
            end
            
            if length(obj.boundary) <= (length(obj.polygon -3 )) 
                ret = true;
            end
            
        end
        
        
         function ret = InsertPointIntoPlygon(obj,ind,p_num)
            max_ind = size(obj.polygon,1)+1;
            assert(ind <= max_ind);
            p=obj.PointWithNum(p_num) ;
            if obj.polygon == 0
                obj.polygon = p;
                ret = true;
            elseif size(obj.polygon,1) == (ind -1)
                obj.polygon =  [obj.polygon ;p];
            else
                obj.polygon = [obj.polygon(1:ind,:) ; p ; obj.polygon(ind+1:size(obj.polygon,1),:)] ;
            end
            if max_ind == size(obj.polygon,1)
                ret= true;
            end
         end
        
% Show functions        
         
        function ShowBoundary(obj)
          %h=obj.Show();
          Approximation.ShowPolygon(obj.boundary,obj.closed,'r'); 
          %set(h, 'Color', 'r');
        end
         
        
        function  ShowInfo(obj)
          set(gca,'Units','pixels');
          r = get(gca,'Position');
          f = get(gcf,'Position');
          f(3) = f(3) +obj.info_size(1); 
          set(gcf,'Position',f);
          c = uicontrol('Style','text','Position',[(r(1)+r(3)+10) r(2) obj.info_size(1) obj.info_size(2)],'String','Info');  
           cur = ClearContur.ConturToBWImage(obj.boundary);
           clr_poly = [obj.polygon(:,1) obj.polygon(:,2)]; % but polygon has third column for init point num
           curve = struct('Perimeter',0,'Area',0);
           poly = struct('Perimeter',0,'Area',0);
           curve.Perimeter = approx.Perimeter(obj.boundary);
           curve.Area = polyarea(obj.boundary(:,1),obj.boundary(:,2));
           poly.Perimeter = approx.Perimeter(obj.polygon);
           poly.Area = polyarea(obj.polygon(:,1), obj.polygon(:,2));
           dA = abs(curve.Area-poly.Area);
           dApercent = (dA/curve.Area)*100;
           dP = abs(curve.Perimeter-poly.Perimeter);
           dPpercent = (dP/curve.Perimeter)*100;
           hd = HausdorffDist(obj.boundary,clr_poly);
           obj.name
           str = {
              ['Init curve size:' int2str(length(obj.boundary))]
              ['Ploygon size: ' int2str(length(obj.polygon))]
              ['Work time: ' num2str(obj.work_time,3)]
              ['Epsilon: ' num2str(obj.epsilon)]
              ['Points limit: ' int2str(obj.points)]
              'Accuracy:'
              ['Area defect:' int2str(dA) ' (' int2str(dApercent) '%)']
              ['Pirimetr defect:' int2str(dP) ' (' int2str(dPpercent) '%)']
              ['HausdorffDist:' num2str(hd,3)]
              };
          set(c,'String',str);
          
        end
        
        
        
        
    end
    
end

