function finalOutput = phaseEqualizer_v1(field,nphasesPparam,nblocksP)

%% Phase noise estimation (Pfau)

%  Ideal QAM symbols
PAM4Symbols=[-1, -1/3, 1/3, 1];
[InPhaseCoordinates, QuadratureCoordinates]=ndgrid(PAM4Symbols,PAM4Symbols);
QAMSymbols = InPhaseCoordinates(:) +1i*QuadratureCoordinates(:); % modulation.constellation
% QAMSymbols = modConstellation;

% assert(filterSpan < 4096);
% Deleting extra samples due to filtering
%field = field(filterSpan+1:end);

% Input signals are 1 sample per symbol
signal_D = field; %fieldX
% signal_yD = IY + 1i * QY; %fieldY

signal_D = signal_D / 3 / mean(abs(signal_D)) * 0.25*(sqrt(2)+2*sqrt(10)+sqrt(18));
% signal_yD = signal_yD /3 / mean(abs(signal_yD)) * 0.25*(sqrt(2)+2*sqrt(10)+sqrt(18));

% Optimal parameters (Pfau et al.)
nsymbols=length(field); %data.numSymbols
nphasesP = nphasesPparam;
% nblocksP = 1;%nsymbols/nsymbolsblockP; %% Number of blocks 
nsymbolsblockP = floor(nsymbols/nblocksP);  %% Number of symbols/block 
signal_xD = signal_D(1:nsymbolsblockP*nblocksP);  % only use the nsymblocksblockP*nblocksP samples
% assert(nphasesPparam < 500);% assert(nsymbolsblockPparam < 500);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Phase noise estimation (Pfau)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Use optimal parameters
[PhiEstCont, CorrectOutput] = ff_cpe(signal_xD,QAMSymbols,nblocksP,nsymbolsblockP,nphasesP);

% Downsampling 2
% finalOutput = CorrectOutput(1:2:end);
finalOutput = signal_xD.*exp(-1i*PhiEstCont);   % calculate the correct output
%finalOutput = CorrectOutput;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% % Find optimal parameters
% % 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Optimal parameters (Pfau et al.)
% nsymbols=10000;
% nphasesP = 100;
% 
% nsymbolsblockvalues=[2,4,5,8,10,20,25,40,50,100,125,200,250]; %% divisors of the total number of symbols
% for k=1:length(nsymbolsblockvalues)
%     nsymbolsblockP=nsymbolsblockvalues(k);
%     nblocksP = nsymbols/nsymbolsblockP;
%     [PhiEstCont CorrectOutput] = ff_cpe(signal_xD(1:nsymbols),QAMSymbols,nblocksP,nsymbolsblockP,nphasesP);
%     EVM_Pfau(k) = evm(CorrectOutput(2000:8000), QAMSymbols);
% end
% [MinEVM MinIndexPfau]=min(EVM_Pfau)
% MinNsymbolsBlock=nsymbolsblockvalues(MinIndexPfau)
% 
% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% % EVM vs block length plot
% % 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% figure
% plot(nsymbolsblockvalues,EVM_Pfau,'b')
% xlabel('Symbols per block')
% ylabel('EVM')
% title('FF CPE algorithm (Pfau et al.)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Phase noise plots
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure
% plot(PhiEstCont,'r')
% xlabel('t (Tsymbol)')
% ylabel('Phase (rad)')
% title('CPE algorithm (Pfau)')
% legend('Actual','Estimated')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% EVM
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% EVM_Pfau = evm(CorrectOutput(2000:8000), QAMSymbols);
% 
% disp('                       ')
% disp('FF CPE algorithm (Pfau)')
% disp('                       ')
% disp(['EVM: ' num2str(EVM_Pfau)])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Constellation diagram
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure
% plot(signal_xD(1:nsymbols), 'r.')
% hold on
% plot(CorrectOutput, 'g.')
% plot(QAMSymbols, 'bs', 'MarkerFaceColor','b')
% axis equal
% xlabel('In-Phase', 'FontSize', 10)
% ylabel('Quadrature', 'FontSize', 10)
% title('16-QAM Constellations (Pfau)', 'FontSize', 10)
% legend('Received','Corrected','Ideal')
% hold off


%--------------------------------------------------------------------------
function [EstimatedPhaseNoise, CorrectedRxSignalSamples] = ff_cpe(RxSignalSamples,QAMSymbols,NumberOfBlocks,NumberOfSymbolsPerBlock,NumberOfTestPhases)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Phase noise estimation (Pfau)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Block segmentation of the received signal
RxSignalBlockData =  reshape(RxSignalSamples,NumberOfSymbolsPerBlock,NumberOfBlocks).';

%  Test phases
CurlyPhib = [0:NumberOfTestPhases-1]*pi/(2*NumberOfTestPhases);
TestExps = exp(1i*CurlyPhib);
EstimatedPhaseBlock = zeros(NumberOfBlocks,1);
%  Best tentative phase estimation
for m=1:NumberOfBlocks
    xTentative = TestExps'*RxSignalBlockData(m,:);
    
    xTentativeEstimate = complex(zeros(NumberOfTestPhases,NumberOfSymbolsPerBlock));
    DistanceMatrix = zeros(NumberOfTestPhases,NumberOfSymbolsPerBlock);
    s = zeros(NumberOfTestPhases,1); 
    
    for k=1:NumberOfTestPhases
        for l=1:NumberOfSymbolsPerBlock
            xTentativeEstimate(k,l)=decision(xTentative(k,l),QAMSymbols);
            DistanceMatrix(k,l) = abs(xTentative(k,l) - xTentativeEstimate(k,l)).^2;
        end
        s(k)=sum(DistanceMatrix(k,:));
    end
    [MinSum, MinSumIndex]=min(s);
    EstimatedPhaseBlock(m) = CurlyPhib(MinSumIndex);
end


% Phase unwrapping [Matlab]
% EstimatedPhaseBlockUnwrapped=0.25*unwrap(4*EstimatedPhaseBlock)-EstimatedPhaseBlock(1);
EstimatedPhaseBlockUnwrapped=0.25*unwrap(4*EstimatedPhaseBlock);

%figure
%plot(0:length(EstimatedPhaseBlockUnwrapped)-1,EstimatedPhaseBlockUnwrapped);
%title('phase field X');

% Continuous Phase 
EstimatedPhaseNoise = zeros((NumberOfBlocks-1)*NumberOfSymbolsPerBlock+NumberOfSymbolsPerBlock,1);
for k=1:NumberOfBlocks
    for l=1:NumberOfSymbolsPerBlock
        EstimatedPhaseNoise((k-1)*NumberOfSymbolsPerBlock+l)=EstimatedPhaseBlockUnwrapped(k)-2*(pi/2);
   end
end

%  Corrected QAM constellation pts
CorrectedRxSignalSamples = RxSignalSamples.*exp(-1i*EstimatedPhaseNoise);

%--------------------------------------------------------------------------
function [EstimatedSymbol] = decision(RxSignalSample,QAMSymbols)

% It calculates the the min.Euclidian distance of the received signal
% sample x from the symbols of the rectangular QAM grid, expressed in
% a complex array QAMSymbols and returns an the estimated symbol xest 
% of estimated symbols

EuclideanDistance = abs(RxSignalSample-QAMSymbols);
[MinDistance, MinIndex]=min(EuclideanDistance);
EstimatedSymbol = QAMSymbols(MinIndex);
 


