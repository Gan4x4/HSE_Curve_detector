function test_suite = test_Curve_class
initTestSuite;
end

function C = setup
    t_curve = [1 1; 2 3; 5 7 ; 4 9 ];
    C = Curve(t_curve);
end

function teardown(C)
%    clear(C);
end


function testGetDistanceMethod(C)
    assertEqual(C.GetDistance(1,2),sqrt(5));
    assertEqual(C.GetDistance(1,1),0);
    
end

function testCurvePointMethod(C)
    assertEqual(C.Point(1), [1 1]);
    assertEqual(C.Point(0), [4 9]);
    assertEqual(C.Point(5), [1 1]);
    assertEqual(C.Point(-1), [5 7]);
    assertFalse(isequal(C.Point(0), [1 1]));
end

function testGetEuclidDistance(C)
    
    assertEqual(C.GetEuclidDistance([1,1],[2,3]),sqrt(5));
    assertEqual(C.GetEuclidDistance([1,1],[1,1]),0);
    assertEqual(C.GetEuclidDistance([-1,1],[1,1]),2);
    assertFalse(C.GetEuclidDistance([-1,1],[1,1]) == 1);

end

function testPerimeter(C)
    assertEqual(C.Perimeter([1,1]),false);
    assertEqual(C.Perimeter([1;1;2;3]),false);
    assertEqual(C.Perimeter([]),false);
    square = [1,1; 2,1 ; 2 2; 1 2];
    assertEqual(C.Perimeter(square),4);
    triangle = [1,1; 3,1 ; 2 2 ];
    assertEqual(C.Perimeter(triangle),2*sqrt(2)+2);
    line = [-1 1 ; 1 1];
    assertEqual(C.Perimeter(line),2);
    assertEqual(C.Perimeter(line,true),2);
    curve = [-1 1 ; 1 1 ; 1 3];
    assertEqual(C.Perimeter(curve,true),4+sqrt(8));
    assertEqual(C.Perimeter(curve,false),4);
    

end
