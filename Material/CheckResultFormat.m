function [bIsCorrect, stResultsOut] = CheckResultFormat( stResults, bVerbose )
%/* FUNCTION  Engineering Competition 2016 Result Format Checker ****************
%
%SPECIFICATION:
%
% Checks for correct format of result struct entries according to the 6
% provided OFDM signals for the Engineering Competition 2016 pre-rounds.
%
%INPUTS
%
% stResults            = result struct to be checked
%                        If a string is passed on instead of a struct this
%                        string is interpreted as a file name and the
%                        struct is loaded from this file.
% bVerbose             = if given and set to false, text output is
%                        suppressed - otherwise check results are reported.
%
%OUTPUTS
%
% bIsCorrect           = check result (true: all is well, false: error occurred)
% stResultsOut         = passed through "stResults" or result struct loaded
%                        from files (in case of "stResults" is a string)
%
%********************************************************************************/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COPYRIGHT:  (c) 2016 Rohde & Schwarz, Munich
% MODULE:     $Header$
% PROJECT:    EC2016
% LANGUAGE:   MATLAB Version 8.1.0.604 (R2013a)
% AUTHOR:     Klaus.Heller@rohde-schwarz.com, 1DC1
% SEE:        -
% History:
% $Log$
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% {

global bPrintCheckResults;

% provide missing input parameter
if ( (nargin < 2) || isempty(bVerbose) )
    bVerbose = true;
end
bPrintCheckResults = bVerbose;
if ( (nargin < 1) || isempty(stResults) )
    stResults = 'Auswertung\Examples\Results1.mat';
end

% input type
bIsCorrect = true;
if ( ischar(stResults) )
    if ( exist(stResults,'file') )
        stDataFromFile = load(stResults,'Results');
        if ( isfield(stDataFromFile,'Results') )
            stResults = stDataFromFile.Results;
        else
            MyFprintf('\nGiven file does not contain Results struct!\n\n');
            bIsCorrect = false;
        end
    else
        MyFprintf('\nSpecified file does not exist!\n\n');
        bIsCorrect = false;
    end
else
    if ( ~isstruct(stResults) )
        MyFprintf('\nInput parameter has to be a struct!\n\n');
        bIsCorrect = false;
    end
end
stResultsOut = stResults;
if ( ~bIsCorrect )
    stResultsOut = [];
    return;
end

cFailedEntries = {};

% check the Results struct entries
MyFprintf('\n\nChecking common identification header:\n');
bHeaderOK = true;
MyFprintf('   --- checking Results.Name (text string) ---\n');
[cFailedEntries, bHeaderOK] = AddFailureEntry( cFailedEntries, bHeaderOK, CheckTextString( stResults, 'Name' ), 'Name' );
MyFprintf('   --- checking Results.Address (text string) ---\n');
[cFailedEntries, bHeaderOK] = AddFailureEntry( cFailedEntries, bHeaderOK, CheckTextString( stResults, 'Address' ), 'Address' );
MyFprintf('   --- checking Results.Telephone (text string) ---\n');
[cFailedEntries, bHeaderOK] = AddFailureEntry( cFailedEntries, bHeaderOK, CheckTextString( stResults, 'Telephone' ), 'Telephone' );
MyFprintf('   --- checking Results.Email (text string) ---\n');
[cFailedEntries, bHeaderOK] = AddFailureEntry( cFailedEntries, bHeaderOK, CheckTextString( stResults, 'Email' ), 'Email' );
MyFprintf('   --- checking Results.Date (text string) ---\n');
[cFailedEntries, bHeaderOK] = AddFailureEntry( cFailedEntries, bHeaderOK, CheckTextString( stResults, 'Date' ), 'Date' );
%MyFprintf('   --- checking Results.City (text string) ---\n');
%[cFailedEntries, bHeaderOK] = AddFailureEntry( cFailedEntries, bHeaderOK, CheckTextString( stResults, 'City' ), 'City' );
if ( bHeaderOK )
    MyFprintf('common identification header is correct!\n\n');
end
bIsCorrect = bIsCorrect && bHeaderOK;

[cFailedEntries, bIsCorrect] = CheckSignalResults( cFailedEntries, bIsCorrect, stResults, 1 );
[cFailedEntries, bIsCorrect] = CheckSignalResults( cFailedEntries, bIsCorrect, stResults, 2 );
[cFailedEntries, bIsCorrect] = CheckSignalResults( cFailedEntries, bIsCorrect, stResults, 3 );
[cFailedEntries, bIsCorrect] = CheckSignalResults( cFailedEntries, bIsCorrect, stResults, 4 );
[cFailedEntries, bIsCorrect] = CheckSignalResults( cFailedEntries, bIsCorrect, stResults, 5 );
[cFailedEntries, bIsCorrect] = CheckSignalResults( cFailedEntries, bIsCorrect, stResults, 6 );

if ( bIsCorrect )
    MyFprintf('\nNo errors found, result struct format is Okay!\n\n');
else
    MyFprintf('\nResult struct format errors found in following entries:\n');
    for iCntSe = 1:length(cFailedEntries),
        MyFprintf('  * Results.%s\n',cFailedEntries{iCntSe});
    end
    MyFprintf('(for details see above)\n\n');
end

return;
% } end of CheckResultFormat

%/* SUB-FUNCTION ********************************************************************
function MyFprintf( varargin )
% Wrapper function for "fprintf" which only produces print output ig global
% variable "bPrintCheckResults" is set to true
%************************************************************************************/
% {
global bPrintCheckResults;
if ( bPrintCheckResults )
    fprintf(varargin{:});
end
return
% } End of AddFailureEntry

%/* SUB-FUNCTION ********************************************************************
function [cFailedEntries, bIsCorrect] = CheckSignalResults( cFailedEntries, bIsCorrect, stResults, iSignalNumber )
% Utility function which optionally adds a failure message to the failure cell
% > cFailedEntries  :  cell of failure messages
% > bIsCorrect      :  current overall failure state
% > stResults       :  struct to be checked
% > iSignalNumber   :  signal number (1...6)
%************************************************************************************/
% {
sSignalEntry = sprintf('Signal%i',iSignalNumber);
MyFprintf('\n\nChecking %s results:\n',sSignalEntry);
stSignal = stResults.(sSignalEntry);
bSignalOK = true;
% FFT size is only checked for Signal6
if ( iSignalNumber == 6 )
    MyFprintf('   --- checking Results.%s.FFTSize (one of 32, 64 or 128) ---\n',sSignalEntry);
    [cFailedEntries, bSignalOK] = AddFailureEntry( cFailedEntries, bSignalOK, CheckFftLength( stSignal, 'FFTSize' ), [sSignalEntry,'FFTSize'] );
end
% Modulation Type is checked for all Signals
MyFprintf('   --- checking Results.%s.ModulationType (one of BPSK, QPSK or 8PSK) ---\n',sSignalEntry);
[cFailedEntries, bSignalOK] = AddFailureEntry( cFailedEntries, bSignalOK, CheckModulation( stSignal, 'ModulationType' ), [sSignalEntry,'ModulationType'] );
% SFO is checked for Signal5 and Signal6
if ( ~isempty(intersect([5 6],iSignalNumber)) )
    MyFprintf('   --- checking Results.%s.NormalizedSamplingFrequencyOffset_fa (real scalar value) ---\n',sSignalEntry);
    [cFailedEntries, bSignalOK] = AddFailureEntry( cFailedEntries, bSignalOK, CheckScalarValue( stSignal, 'NormalizedSamplingFrequencyOffset_fa' ), [sSignalEntry,'NormalizedSamplingFrequencyOffset_fa'] );
end
% CFO is checked for Signal4, Signal5 and Signal6
if ( ~isempty(intersect([4 5 6],iSignalNumber)) )
    MyFprintf('   --- checking Results.%s.NormalizedCarrierFrequencyOffset_fa (real scalar value) ---\n',sSignalEntry);
    [cFailedEntries, bSignalOK] = AddFailureEntry( cFailedEntries, bSignalOK, CheckScalarValue( stSignal, 'NormalizedCarrierFrequencyOffset_fa' ), [sSignalEntry,'NormalizedCarrierFrequencyOffset_fa'] );
end
% abs(CTF) is checked for Signal2, Signal3, Signal4, Signal5 and Signal6
if ( ~isempty(intersect([2 3 4 5 6],iSignalNumber)) )
    MyFprintf('   --- checking Results.%s.MagChannelTransferFunction (real positive vector of length 32, 64 or 128) ---\n',sSignalEntry);
    [cFailedEntries, bSignalOK] = AddFailureEntry( cFailedEntries, bSignalOK, CheckAbsCtf( stSignal, 'MagChannelTransferFunction' ), [sSignalEntry,'MagChannelTransferFunction'] );
end
% I/Q-Imbalance is only checked for Signal6
if ( iSignalNumber == 6 )
    MyFprintf('   --- checking Results.%s.IQImbalance (complex scalar value) ---\n',sSignalEntry);
    [cFailedEntries, bSignalOK] = AddFailureEntry( cFailedEntries, bSignalOK, CheckScalarValue( stSignal, 'IQImbalance', true ), [sSignalEntry,'IQImbalance'] );
end
% SNR is checked for Signal2, Signal3, Signal4, Signal5 and Signal6
if ( ~isempty(intersect([2 3 4 5 6],iSignalNumber)) )
    MyFprintf('   --- checking Results.%s.SNR (real scalar value) ---\n',sSignalEntry);
    [cFailedEntries, bSignalOK] = AddFailureEntry( cFailedEntries, bSignalOK, CheckScalarValue( stSignal, 'SNR' ), [sSignalEntry,'SNR'] );
end
% Transmitted Text is checked for all Signals
MyFprintf('   --- checking Results.%s.SignalContent (text string) ---\n',sSignalEntry);
[cFailedEntries, bSignalOK] = AddFailureEntry( cFailedEntries, bSignalOK, CheckTextString( stSignal, 'SignalContent' ), [sSignalEntry,'SignalContent'] );
% solution of city riddle is checked for all Signals
MyFprintf('   --- checking Results.%s.City (text string) ---\n',sSignalEntry);
[cFailedEntries, bSignalOK] = AddFailureEntry( cFailedEntries, bSignalOK, CheckTextString( stSignal, 'City' ), [sSignalEntry,'City'] );
if ( bSignalOK )
    MyFprintf('%s results are correct!\n\n',sSignalEntry);
end
bIsCorrect = bIsCorrect && bSignalOK;
return
% } End of CheckSignalResults

%/* SUB-FUNCTION ********************************************************************
function [bIsCorrect] = CheckTextString( stResults, sStructFieldName )
% Utility function which checks a given struct entry for a valid string.
% > stResults       :  struct to be checked
% > sStructFieldName:  name of the struct entry to be checked
%************************************************************************************/
% {
bIsCorrect = true;
if ( isfield(stResults,sStructFieldName) )
    sStringIn = stResults.(sStructFieldName);
    if ( isempty(sStringIn) || ~ischar(sStringIn) )
        MyFprintf('\n>>> ERROR: Entry %s is no valid text string!\n\n',sStructFieldName);
        bIsCorrect = false;
    end
else
    MyFprintf('\n>>> ERROR: Entry %s does not exist!\n\n',sStructFieldName);
    bIsCorrect = false;
end
return
% } End of CheckTextString

%/* SUB-FUNCTION ********************************************************************
function [bIsCorrect] = CheckScalarValue( stResults, sStructFieldName, bComplexVal )
% Utility function which checks a given struct entry for a valid scalar value.
% > stResults       :  struct to be checked
% > sStructFieldName:  name of the struct entry to be checked
% > bComplexVal     :  false -> real scalar (default), true -> complex scalar
%************************************************************************************/
% {
bIsCorrect = true;
if ( isfield(stResults,sStructFieldName) )
    fScalarIn = stResults.(sStructFieldName);
    if ( isempty(fScalarIn) || ~isfinite(fScalarIn) )
        MyFprintf('\n>>> ERROR: Entry %s is no finite scalar value!\n\n',sStructFieldName);
        bIsCorrect = false;
    else
        if ( (nargin < 3) || isempty(bComplexVal) )
            bComplexVal = false;
        end
        if ( bComplexVal )
            if ( isreal(fScalarIn) )
                MyFprintf('\n>>> ERROR: Entry %s is no complex scalar value!\n\n',sStructFieldName);
                bIsCorrect = false;
            end
        else
            if ( ~isreal(fScalarIn) )
                MyFprintf('\n>>> ERROR: Entry %s is no real scalar value!\n\n',sStructFieldName);
                bIsCorrect = false;
            end
        end
    end
else
    MyFprintf('\n>>> ERROR: Entry %s does not exist!\n\n',sStructFieldName);
    bIsCorrect = false;
end
return
% } End of CheckScalarValue

%/* SUB-FUNCTION ********************************************************************
function [bIsCorrect] = CheckModulation( stResults, sStructFieldName )
% Utility function which checks a given struct entry for a valid modulation.
% > stResults       :  struct to be checked
% > sStructFieldName:  name of the struct entry to be checked
%************************************************************************************/
% {
bIsCorrect = CheckTextString(stResults,sStructFieldName);
if ( bIsCorrect )
    sModulationIn = stResults.(sStructFieldName);
    cModulations = {'BPSK','QPSK','8PSK'};
    if ( isempty(intersect(cModulations,sModulationIn)) )
        MyFprintf('\n>>> ERROR: Entry %s (%s) is none of the valid modulations %s or %s or %s!\n\n',sStructFieldName,sModulationIn,cModulations{1},cModulations{2},cModulations{3});
        bIsCorrect = false;
    end
end
return
% } End of CheckModulation

%/* SUB-FUNCTION ********************************************************************
function [bIsCorrect] = CheckFftLength( stResults, sStructFieldName )
% Utility function which checks a given struct entry for a valid FFT size.
% > stResults       :  struct to be checked
% > sStructFieldName:  name of the struct entry to be checked
%************************************************************************************/
% {
bIsCorrect = CheckScalarValue(stResults,sStructFieldName);
if ( bIsCorrect )
    iFftLenIn = stResults.(sStructFieldName);
    vFftLengths = [32 64 128];
    if ( isempty(intersect(vFftLengths,iFftLenIn)) )
        MyFprintf('\n>>> ERROR: Entry %s (%i) is none of the valid FFT lengths %i or %i or %i!\n\n',sStructFieldName,iFftLenIn,vFftLengths(1),vFftLengths(2),vFftLengths(3));
        bIsCorrect = false;
    end
end
return
% } End of CheckFftLength

%/* SUB-FUNCTION ********************************************************************
function [bIsCorrect] = CheckAbsCtf( stResults, sStructFieldName )
% Utility function which checks a given struct entry for a valid CTF magnitude vector
% > stResults       :  struct to be checked
% > sStructFieldName:  name of the struct entry to be checked
%************************************************************************************/
% {
bIsCorrect = true;
if ( isfield(stResults,sStructFieldName) )
    fAbsCtfIn = stResults.(sStructFieldName);
    if ( isempty(fAbsCtfIn) || ~all(isfinite(fAbsCtfIn)) )
        MyFprintf('\n>>> ERROR: Vector of entry %s contains not finite values!\n\n',sStructFieldName);
        bIsCorrect = false;
    else
        iLenCtf = length(fAbsCtfIn);
        vCtfLengths = [32 64 128];
        if ( isempty(intersect(vCtfLengths,iLenCtf)) )
            MyFprintf('\n>>> ERROR: Vector lenght of entry %s (%i) is none of the valid CTF lengths %i or %i or %i!\n\n',sStructFieldName,iLenCtf,vCtfLengths(1),vCtfLengths(2),vCtfLengths(3));
            bIsCorrect = false;
        else
            if ( ~isreal(fAbsCtfIn) )
                MyFprintf('\n>>> ERROR: Vector of entry %s contains complex values!\n\n',sStructFieldName);
                bIsCorrect = false;
            end
            if ( min(fAbsCtfIn) < 0 )
                MyFprintf('\n>>> ERROR: Vector of entry %s contains negative values!\n\n',sStructFieldName);
                bIsCorrect = false;
            end
        end
    end
else
    MyFprintf('\n>>> ERROR: Entry %s does not exist!\n\n',sStructFieldName);
    bIsCorrect = false;
end
return
% } End of CheckAbsCtf

%/* SUB-FUNCTION ********************************************************************
function [cFailedEntries, bIsCorrect] = AddFailureEntry( cFailedEntries, bIsCorrect, bCheckOkay, sStructFieldName )
% Utility function which optionally adds a failure message to the failure cell
% > cFailedEntries  :  cell of failure messages
% > bIsCorrect      :  current overall failure state
% > bCheckOkay      :  add failure message if false
% > sStructFieldName:  name of the wrong struct entry
%************************************************************************************/
% {
bIsCorrect = bIsCorrect && bCheckOkay;
if ( ~bCheckOkay )
    cFailedEntries = [cFailedEntries; sStructFieldName];
end
return
% } End of AddFailureEntry
