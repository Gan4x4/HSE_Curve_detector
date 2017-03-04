function test_suite = test_CornerDetectorRJ73
initTestSuite;
end

function C = setup
    t_curve = [1 1; 2 1; 3 1 ; 4 1;  6 1; 1 6; 1 5 ;1 2];
    C = CornerDetectorRJ73(t_curve,0.5);
    C.Show();
end

function teardown(C)
%    clear(C);
end


function test_GetCornerStrength(C)
% it' a cosinus of angle 
    cos90 = C.GetCornerStrength(1,1);
    assertEqual(cos90,0);
    cos0 = C.GetCornerStrength(3,2);
    assertEqual(cos0,-1);
    cos45 = C.GetCornerStrength(5,1);
    assertElementsAlmostEqual(cos45,sqrt(2)/2);
end

function test_GetC(C)
% it' a cosinus of angle 
    cos90 = C.GetC(1,1);
    assertEqual(cos90,0);
    cos0 = C.GetC(3,2);
    assertEqual(cos0,-1);
    cos45 = C.GetC(5,1);
    assertElementsAlmostEqual(cos45,sqrt(2)/2);
end


function test_N(C)
    assertEqual(C.N,8);
end

function GetBestK(C)

end

