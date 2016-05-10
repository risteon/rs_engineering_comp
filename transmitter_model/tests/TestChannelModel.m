classdef TestChannelModel < matlab.unittest.TestCase
    
    properties (TestParameter)
        inputs = {[ 1; 2; 3; 4], [1 5; 2 6; 3 7; 4 8]};
        outputs = {[ 4 1 2 3 4], [ 4 1 2 3 4 8 5 6 7 8]};
    end
    
    
    methods (Test, ParameterCombination='sequential')
        function testInputs(testCase, inputs, outputs)
            addpath ../toolbox

            testCase.verifyEqual(channel_model(inputs), inputs);
        end
    end
    
    methods (Test)
        function testDelay(testCase)
            addpath ../toolbox

            sample_input = [ 1 4+3j 2 2.2 -5.3 ];
            testCase.verifyEqual(channel_model(sample_input, 1.0), [0 sample_input]);
            testCase.verifyEqual(channel_model(sample_input, 42), [zeros(1, 42) sample_input]);
        end
    end
    
end