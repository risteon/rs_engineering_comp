classdef TestChannelModel < matlab.unittest.TestCase
    
    properties (TestParameter)
        inputs = {[ 9 3.2 3 1 3 -100 3+1j], [ 1 1 1 1 1 1 1]};
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
        
        function testConvolution(testCase)
            addpath ../toolbox

            sample_input = [ 1 4+3j 2 2.2 -5.3 ];
            testCase.verifyEqual(channel_model(sample_input, 0.0, [0 0 1]), [0 0 sample_input]);
            testCase.verifyEqual(channel_model(sample_input, 0.0, [0 2]), [0 2*sample_input]);
        end
        
        function testFrequencyOffset(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            
            addpath ../toolbox

            sample_input = [ 1 1 1 ];
            actual_output = channel_model(sample_input, 0.0, 1, 0.25);
            expected_output = [1 1j -1];
            
            testCase.verifyThat(actual_output, IsEqualTo(expected_output, ...
                'Within', RelativeTolerance(4*eps)));
        end
    end
    
end