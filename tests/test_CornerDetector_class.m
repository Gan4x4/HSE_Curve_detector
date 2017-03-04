function test_suite = test_CornerDetector_class
    initTestSuite;
end

function C = setup
    t_curve = [1 1; 2 1; 3 1 ; 4 1;  6 1; 1 6; 1 5 ;1 2];
    C = CornerDetector(t_curve);
    C.Show();
end

function teardown(C)
%    clear(C);
end

function testGetScalar(C)
    s1=C.GetScalar(3,1,3,5);
    assertEqual(s1,-6);
    s2=C.GetScalar(1,6,1,4);
    assertEqual(s2,0);
    s3=C.GetScalar(5,1,5,6);
    assertEqual(s3,25);
end
