classdef ApproximationSplit < Approximation
    %APP_SPLIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        max_distance = 0;
        cache_criterium = 0
        
       
    end
    
    methods (Static)
        
    end
    
    methods
        
        function obj = ApproximationSplit(B,n)
            obj = obj@Approximation(B,n);
            
            obj.SetCache();
            obj.current_epsilon = 10;
           
        end
        
        function obj = SetCache(obj )
             dim = size(obj.boundary,1);
             obj.cache_criterium = ones(dim,dim,dim,'single');
             obj.cache_criterium = obj.cache_criterium * (-1);
            
        end
        
        function [n point_num] = FindMaxNormal(obj,a,b)
            max_normal = 0;
            point_num = 0;
            %next_point =  app_split.GetNextPointNum(obj.boundary,a);
            next_point = obj.GetPointNum(a);
            %j=0;
            %m = size(obj.boundary,1);  
            while (next_point ~= b)
                
               normal = GetNormal(obj,a,b,next_point);
               if (max_normal < normal)
                   max_normal = normal;
                   point_num = next_point;
               end
               next_point = obj.GetPointNum(next_point+1);
               %GetNextPointNum(obj.boundary,next_point);
               
            end
            n = max_normal;
            
        end
          
        function [normal point_num point_after] = FindAbsMaxNormal(obj)
            normal = 0;
            point_num =0;
            point_after =0;
            for i = 1:1:size(obj.polygon,1)
                %np = app_split.GetNextPointNum(obj.polygon,i);
                np = obj.GetPointNum(i+1,obj.polygon);
                [n p] = obj.FindMaxNormal(obj.polygon(i,3),obj.polygon(np,3));
                if (n > normal) && (p ~= 0)
                    normal = n;
                    point_num =  p;
                    point_after = i;
                end
            end
            %assert(point_num > 0,int2str(point_num));
        end
        
        function  CreateFixedPointPoligon(obj,n)
            time0 = tic;
            if obj.max_distance == 0
                [a b c] = obj.get_max_distance();
                obj.max_distance = [a b c];
            end
            obj.points= n;
            first = obj.max_distance(2);
            second = obj.max_distance(3);
            obj.InsertPointIntoPlygon(0,first);
            obj.InsertPointIntoPlygon(1,second);
            [n new_point] = FindMaxNormal(obj,first,second);
            ind = 1;
            if obj.InsertPointIntoPlygon(ind,new_point)
                ind = 3;
            else
                ind = 2;
            end
            [n new_point] = FindMaxNormal(obj,second,first);
            obj.InsertPointIntoPlygon(ind,new_point);
            i = 1;
            while not(obj.IsCanFinish())
               [normal new_point point_after] = obj.FindAbsMaxNormal();
               if new_point ~= 0
                    obj.InsertPointIntoPlygon(point_after,new_point);
                    obj.SetCurrentEpsilon(normal);
                    i = i +1;
               else
                   break;
               end
               %obj.ShowAll();
               %input(int2str(i));
            end
            obj.work_time = toc(time0) ;
        end
        
       
        
        function d = get_distance(obj,a,b)
             a = obj.Point(a);
             b = obj.Point(b);
             d = Approximation.GetEuclidDistance(a,b);
             %d=((a(1)-b(1))^2+(a(2)-b(2))^2)^0.5;
        end
        
        
        
        function res=GetNormal(obj,an,bn,cn)
           
           if (obj.cache_criterium(an,bn,cn)) ~= -1
               res =  obj.cache_criterium(an,bn,cn);
           else
                a = obj.Point(an);
                b = obj.Point(bn);
                c = obj.Point(cn);
           
                if (a(1) == b(1)) 
                    res = abs(c(1) - a(1));
                elseif (a(2) == b(2))
                    res = abs(c(2) - a(2));
                else
                
                    k1 = (a(2)-b(2))/(a(1)-b(1));
                    b1 = (b(2)*a(1)-b(1)*a(2))/(a(1)-b(1)); 
                    k2 = -1/k1;
                    b2 = c(2)-k2*c(1); 
                    matrix = [-k1 1; -k2 1];
                    vector = [b1 ; b2];
                
                    if abs(det(matrix)) ~= Inf
                        result = matrix\vector;
                        res = obj.GetEuclidDistance(c,result);
                    else
                        res = 0 ;
                        'matrix is singular, set result to zero '
                        a
                        b
                        c
                    end
                end
                    obj.cache_criterium(an,bn,cn) = res;
           end
           
        end
        
        function show_point(obj,n)
            a = obj.point(n);
            hold on;
            plot(a(1),a(2));
        end
        
        function show_line(obj,a,b,color)
            a = obj.Point(a);
            b = obj.Point(b);
            hold on;
            x = [a(1) b(1)];
            y = [a(2) b(2)];
            h = plot(x,y);
            if nargin == 4  
                set(h, 'Color', color);
            end
        end
          
        
        
        
        function [m,first,second] = get_max_distance(obj)
            m=0;
            first = 0;
            second = 0;
            len = length(obj.boundary);
        for i = 1:1:len
            for j = (i+1):1:len
               
                cd = obj.get_distance(i,j);
                if ( cd > m ) 
                    m = cd;
                    first = i;
                    second = j;
                end
            end
        end
               
        end
        
        
    end
    
    
    
    
    
end

