classdef TestCyclicPrefixAdding < matlab.unittest.TestCase
    
    properties (TestParameter)
        inputs = {[ 1; 2; 3; 4], [1 5; 2 6; 3 7; 4 8]};
        outputs = {[ 4 1 2 3 4], [ 4 1 2 3 4 8 5 6 7 8]};
    end
    
    
    methods (Test, ParameterCombination='sequential')
        function testSimpleOutput(testCase, inputs, outputs)
            addpath ../transmitter_model
            import matlab.unittest.qualifications.Verifiable
            
            verifyEqual(testCase, cyclic_prefix_adding(inputs), outputs);            
        end
    end
    
end