classdef ApproxDouglasPecker < approx
    %APPROXDOUGLASPECKER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        
         function obj = ApproxDouglasPecker(B,tolerance)
            obj =  obj@approx(B,0);
            %obj.SetCache();
            obj.current_epsilon = 10;
            obj.epsilon = tolerance;
            obj.name = 'DouglasPecker or Split';
            
        end
        
        function Do(obj)
             time0 = tic;
             list = douglas_peucker(obj.boundary, obj.epsilon);
             for i = 1:1:length(list)
                obj. InsertPointIntoPlygon(i,list(i));
             end
             obj.work_time = toc(time0) ;
        end
        
        
    end
    
end

