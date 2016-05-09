classdef TestCyclicPrefixAdding < matlab.unittest.TestCase
    
    properties (TestParameter)
        inputs = {[ 1; 2; 3; 4], [1 5; 2 6; 3 7; 4 8]};
        outputs = {[ 4; 1; 2; 3; 4], [ 4 8; 1 5; 2 6; 3 7; 4 8]};
    end
    
    
    methods (Test, ParameterCombination='sequential')
        function testSimpleOutput(testCase, inputs, outputs)
            import matlab.unittest.qualifications.Verifiable
            
            verifyEqual(testCase, inputs, outputs);            
        end
    end
    
end