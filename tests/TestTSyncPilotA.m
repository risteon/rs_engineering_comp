classdef TestTSyncPilotA < matlab.unittest.TestCase
    
    properties (TestParameter)
        inputs = {0, 1, 2, 3, 20, 42};
    end
    
    
    methods (Test, ParameterCombination='sequential')
        function testInputs(testCase, inputs)
            addpath ../../toolbox

            % generate test signal
            tx = signal_generator('long enough ascii text to generate a signal', 4, 64, 'A');
            
            rx = channel_model(tx, inputs);
            
            testCase.verifyEqual(t_sync_pilot_A(rx, 64), inputs);
        end
    end
    
end