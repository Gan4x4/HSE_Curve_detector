classdef ClearContur < handle
    %CLEARCONTUR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        img = 0;
        neighbours = [-1,1;-1,0;-1,-1;0,-1;1,-1;1,0;1,1;0,1];
        boundary  = [];
        cleared = [];
        all_finded = {};
        max_iter = 10000;
        shift = [];
        autoFirstPoint = [];
    end
    
    
    methods(Static)
        
        function res = IsLast(P,List)
            res = false;
            if isempty(List) || isempty(P)
                return;
            end
            if List(end,:) == P
                res = true;
            end
        end
        
        function res = AlreadyInList(P,List)
            res = false;
            if isempty(List) 
                return;
            end    
            
            if iscell(List)
            for i = 1:1:length(List)
               if isequal(List{i},P) 
                    res = true;
                    return;
               end
            end    
            else
                [res location] = ismember(P,List,'rows');
            end
        end
        
       function img = ConturToBWImage(b)
            assert(ndims(b) == 2);    
            [min_b i_min] = min(b);
            [max_b i_max] = max(b);
            shift = min_b-2; % First but pixel indexing started from 1 and second to get a bounding coridor 
            img = zeros(max_b-min_b+3,'uint8');  
            for  i = 1:1:size(b,1)
               k= b(i,:);
               img(k(1)-shift(1),k(2)-shift(2)) = 1; 
            end
       end
        
    end     
    
    
    
    
    
    methods
        
        
        
        function [new from] = FindNext(obj,around,from)
          start = 1;
            if (~ isequal(from,around))
                for  j =1:1:8 
                    if (around(1)+obj.neighbours(j,1)==from(1) && (around(2)+obj.neighbours(j,2))==from(2))
						start=j;
                    end
                end
            end
            
            for j = 1:1:8
				ind = start + j;
				if ind > 8 
                    ind = ind -8;
                end;
				ny=around(1)+obj.neighbours(ind,1);
				nx=around(2)+obj.neighbours(ind,2);
				%if (nx >= 0 && ny >= 0 && nx <= size(obj.img,1) && ny <= size(obj.img,2) )
                assert(nx >= 0 && ny >= 0);
                
						if obj.GetImgPoint(ny,nx) == 1  
							new = [ny,nx];
							return;
                        
                        end;
						from=[ny,nx];
                %end; 
             end
        end
        
        function res = GetInitFromPoint(obj,P)
            res = [];
            for j = 2:2:size(obj.neighbours,1)
                ny = P(1) + obj.neighbours(j,1);
                nx = P(2) + obj.neighbours(j,2);
                if obj.GetImgPoint(ny,nx) == 0 
                    res = [ny,nx];
                end
            end
        end
               
        
        
        function [around from] = GetFirstPoints(obj)
            %around = obj.autoFirstPoint;
            %from = [obj.autoFirstPoint(1)-1 obj.autoFirstPoint(2)]; 
             [~, x] = max(obj.img(2,:));
             x = x + obj.shift(2);
             y = obj.shift(1)+2;
             around = [y x];
             y = y-1;
             from = [y x];
             
        end
            
        
        
        function max_contur = Trace(obj)
             % function max_contur = Trace(obj,first_point,fromP)
            Jacobs_points = [];
            [P PrevP] = obj.GetFirstPoints();
            first_point = P; 
            i=0;
            %{
            if nargin == 1 
                P = obj.boundary(1,:);
                PrevP = obj.GetInitFromPoint(P);
            else
                P = first_point;
                if nargin == 2 
                    PrevP = obj.GetInitFromPoint(P);    
                else
                    P = first_point;
                    PrevP = fromP;
                end
            end;
%}
            
            assert(obj.GetImgPoint(first_point(1),first_point(2)) == 1,'First point not in the boundary');
            assert(~ isempty(PrevP));
            can_stop = false;
            new = [];
            while (can_stop == false)
                trunc = false;
                if (~ obj.AlreadyInList(P,obj.cleared)) 
                    obj.cleared = [obj.cleared ; P];
                elseif ~ isequal(P,first_point)
                    while ~ obj.IsLast(P,obj.cleared)
                        new = [new; obj.cleared(end,:)];
                        obj.cleared(end,:) = [];
                        trunc = true;
                    end
                    
                end
                
                if (~ trunc) && (~ isempty(new))
                    if (~ obj.AlreadyInList(new,obj.all_finded)) 
                            obj.all_finded = [obj.all_finded  {new}];
                    end
                    new = [];
                end
                %colormap([0 0 0; 1 1 1; 1 0 0 ;0 0 1]);
                %image(obj.ToImage(obj.img,obj.cleared,PrevP));
                %image(obj.ToImage(obj.cleared,PrevP));
                %input(int2str(i));

                [P PrevP] = obj.FindNext(P,PrevP);
                if P == first_point 
                    if obj.AlreadyInList(PrevP,Jacobs_points)
                        can_stop = true;
                    else
                        Jacobs_points = [Jacobs_points; PrevP];
                    end
                end

                if i > obj.max_iter 
                    'Reached max iter'
                    can_stop =true;
                end
                i=i+1;
            end
            obj.all_finded = [obj.all_finded  obj.cleared];
            max_contur = obj.cleared;
        end
        
        
        function NeighbourCount(img,x,y)
        
        end
        
 %{       
        function img = ToImage(obj,fon,contur,PrevP)
            img = fon;
            for i = 1:1:size(contur,1)
                k = contur(i,:);
               img(k(1),k(2)) = 2; 
            end
            if nargin == 4 
                img(PrevP(1),PrevP(2)) = 3; 
            end
        end
   %}     
     
        function img = ToImage(obj,contur,PrevP)
            img = obj.img;
            for i = 1:1:size(contur,1)
                k = contur(i,:);
                img(k(1)-obj.shift(1),k(2)-obj.shift(2)) = 2; 
            end
            if nargin == 3 
                img(PrevP(1)-obj.shift(1),PrevP(2)-obj.shift(2)) = 3; 
            end
        end
 
        
        function CheckYX(obj,y,x)
            assert(y > 0,'Y Less 0');
            assert(x > 0,'X Less 0');
            assert(y <= size(obj.img,1),'Y above max');
            assert(x <= size(obj.img,2),'X above max');
        end
        
        function res = GetImgPoint(obj,y,x)
            obj.CheckYX(y-obj.shift(1),x-obj.shift(2));
            res = obj.img(y-obj.shift(1),x-obj.shift(2));
        end
        
        function SetImgPoint(obj,y,x,value)
            obj.CheckYX(y-obj.shift(1),x-obj.shift(2));
            obj.img(y-obj.shift(1),x-obj.shift(2)) = value;
        end
        
        
       % function GetAutoFirstPoint()
        
            
            
       % end
       
       
       
       
        function obj = ClearContur(b)
        
            assert(ndims(b) == 2);
            obj.boundary = b;
            [min_b i_min] = min(b);
            [max_b i_max] = max(b);
            obj.shift = min_b-2; % First but pixel indexing started from 1 and second to get a bounding coridor 
            obj.autoFirstPoint = b(i_min(1,:)); 
            obj.img = zeros(max_b-min_b+3,'uint8');  
            for  i = 1:1:size(b,1)
               k= b(i,:);
               %obj.img(k(1)-shift(1),k(2)-shift(2)) = 1; 
               SetImgPoint(obj,k(1),k(2),1);
            end
            %plot(obj.img);

        end
        
        
        
        
        
    end
    
end

