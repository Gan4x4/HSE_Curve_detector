classdef CornerDetectorRJ73 < CornerDetector
    %CORNERDETECTORRJ75 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        k = 0.05;
        mink = 2;
        step = 0.001;
        %corners = [];
        c=[];
        bestK = [];
    end
    
    methods
              
        
        function obj = CornerDetectorRJ73(b,k)
            obj =  obj@CornerDetector(b);
            if nargin == 2 
                obj.k = k;
            end
            obj.name = 'Rosenfeld and Johnston 73';
            assert(obj.k <= obj.N());
            MatrixSecondDim =round(obj.k*obj.N()); 
            assert(MatrixSecondDim >= obj.mink);
            obj.c=ones(obj.N(),MatrixSecondDim)*2;
            obj.bestK = ones(obj.N(),1)*-1;
        end
        
        function n=N(obj)
           n = size(obj.boundary,1); 
        end
        
        function res = GetCornerStrength(obj,p,i)
            assert(i ~= 0);
            a = p-i;
            b = p+i;
            res = (obj.GetScalar(p,a,p,b))/((obj.GetDistance(a,p)*obj.GetDistance(p,b)));
        end
        
        
        function c=GetC(obj,i,m)
            try
            if (obj.c(i,m)>1)
                obj.c(i,m)=obj.GetCornerStrength(i,m);
            end
            c = obj.c(i,m);
            assert(c<=1);
            catch err
                i
                m
            end
        
        end
        function [m i]=GetM(obj,m0,i)
            
            if m0 == 0
                k=obj.GetK(0);
                m = round(k*obj.N());
                i=0;
            else
                m=m0;
                while (m0 == m)
                    k=obj.GetK(i);
                    assert(k > 0); 
                    m = round(k*obj.N());
                    i=i+1;
                end
            end
            assert(m > 0);
        end
        
        function k=GetK(obj,i)
            k=obj.k-obj.GetStep()*i;
            assert(k > 0); 
        end
        
        function s=GetStep(obj)
            s = obj.step;
        end
        
        function bestK = GetBestK(obj,p)
            i=0;
            c0=-2; % Becouse wi do not have do ... while loop
            c1=-1;
            m = 0;
            while ((c0 < c1 ) && ((m > 2) || (m==0)))
                c0 = c1;
                [m i]=obj.GetM(m,i);
                bestK = obj.GetK(i);
                c1 = (obj.GetC(p,m));
            end
            assert(bestK > 0);
            assert(bestK < obj.N());
        end
                
        
        function corner = isCorner(obj,i)
            curr_pi = i;
            assert(obj.bestK(curr_pi) > -1);
            n = round(obj.bestK(curr_pi)*obj.N());
            c0 = obj.GetC(curr_pi,n);
            stp=round(n/2);
            corner = true;
            for j = -stp:1:stp;
                curr_p = obj.GetPointNum(j+curr_pi);
                if curr_p == curr_pi
                    continue;
                end
                p = round(obj.bestK(curr_p)*obj.N());
                c1 = obj.GetC(curr_p,p);
                if c0 <= c1
                    corner = false;
                    break;
                end
            end
        end
                
        function FillBestK(obj)
            for i=1:1:obj.N()
               obj.bestK(i) =  obj.GetBestK(i); 
            end
            
        end
        
        function corners = SelectionProc(obj)
            
            obj.FillBestK();
            %obj.corners = [];
            for i = 1:1:obj.N();
               curr_pi = obj.GetPointNum(i);
               corner = obj.isCorner(curr_pi);
               if (corner)
                   obj.corners = [obj.corners curr_pi];
               end
            end
            %obj.polygon = [obj.boundary(corners,:)];  
        end
        
    end
    
end

