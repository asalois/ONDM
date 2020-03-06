function [fieldX,fieldY,delay,dispersion] = create_uniqueField(sigx,sigy,samplesPerSymbol,...
    symbolRate,channelWavelength,normalizedFreq)

%CREAT_UNIQUEFIELD creates a combined electric field for optical signals.
%   It is modified from CREATE_FIELD(FTYPE,Eopt). 
%
%   THIS FUNCTION MUST BE CALLED IN EACH SIMULATION
%
%   Eopt is a matrix [Nfft,Nch] containing on columns the x polarization of
%   the electric fields to be multiplexed togehter. Nch is the overall 
%   number of channels, Nfft the number of FFT points. 
%   CREATE_FIELD creates new fields of the global variable GSTATE, 
%   GSTATE.FIELDX and its copy GSTATE.FIELDX_TX, respectively.
%   GSTATE.FIELDX is the electric field that will be propagated in the 
%   optical system. 
%   
%   FTYPE can be 'sepfields' (1) or 'unique' (2). With 'sepfields' GSTATE.FIELDX is
%   a copy of Eopt. 'sepfields' is useful for propagation in optical fibers
%   in absence of four wave mixing (FWM) and allows to obtain faster runs.
%   'unique' combines all channels into a unique channel and allows to
%   account for FWM in optical fibers. 'unique' allows therefore more
%   accurate results even if it is slow since requires larger value of
%   samplesPerBit (see RESET_ALL function) for accounting all channels. With 
%   option 'unique' CREATE_FIELD acts as an ideal multiplexer.
%
%   CREATE_FIELD(FTYPE,Eopt,SIGY) operates on the x (Eopt) and y (SIGY)
%   polarization creating GSTATE.FIELDX, and GSTATE.FIELDY (and their
%   copies, GSTATE.FIELDX_TX and GSTATE.FIELDY_TX, respectively). Eopt and
%   SIGY must have the same size [Nfft,Nch].
%
%   CREATE_FIELD(FTYPE,Eopt,SIGY,OPTIONS) accepts the optional parameter
%   OPTIONS, containing:
%   
%   OPTIONS.DELAY: can be the string 'rand' or a vector of double.
%                  In the first case a uniform distributed random delay
%                  between [0,1] is added to the channels before creating  
%                  the electric field. In the second case the vector is
%                  used as delay. The values are normalized to 
%                  1/symbRate, i.e. the symbol time.
%   OPTIONS.POWER: if set to 'average', the power defined in LASERSOURCE is
%                  not the peak power (default) but the average power.
%
%   Note: for hybrid symbol-rate systems, the delay is normalized to the
%   current (last defined) symbol time (1/symbRate) and not to 
%   the channel symbol time.
%
%   In absence of y polarization simply use:
%                  CREATE_FIELD(FTYPE,Eopt,[],OPTIONS)
%
%   CREATE_FIELD initializes the global variable GSTATE.DELAY to zero or to
%   the value imposed by OPTIONS.DELAY.
%   CREATE_FIELD initializes the global variable GSTATE.DISP to zero.
%
%   See also: RESET_ALL, LASERSOURCE, ELECTRICSOURCE
%
%   Author: Paolo Serena, 2009
%   University of Parma, Italy

%    This file is part of Optilux, the optical simulator toolbox.
%    Copyright (C) 2009  Paolo Serena, <serena@tlc.unipr.it>
%			 
%    Optilux is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 3 of the License, or
%    (at your option) any later version.
%
%    Optilux is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.

% Some functions need to be included for simulink.

% symbolRate   in  [1/s]; 
% channelWavelength in [nm]; 
% normalizedFreq is normaized frequency in symbol rate,i.e = freq/R 
%       with freq the frequency in [Hertz], R the symbol rate in [baud].

coder.extrinsic('exist');

ftype = 'unique';   % output will be  a combined field.
% lambda = 1550;                     % Wavelength  in [nm]
cLight = 299792458;    %  [m/s]

[Nfft,Nch] = size(sigx); % Nfft -number of FFT points,Nch - number of channels

% if exist('options','var')
%     checkfields(options,{'delay','power'});
% end
[nrx,ncx] = size(sigx);
if nargin >= 3
    if isempty(sigy)
        error('missing sigy. Set to empty if it does not exist');
    end
    npol = 2; % number of polarizations
    if isempty(sigy) 
        isy = false;        
        npol = 1;
    else
        isy = true;
    end
    if isempty(sigx) 
        error('empty x component');
    end    
    [nry,ncy] = size(sigy);
    if (nry ~= 0) && (ncx ~= ncy || nrx ~= nry)
        error('Eopt and sigy must have the same size');
    end
else
    npol = 1;
    isy = false;
    ncy = 0;
end
if (ncx ~= Nch) || (ncy ~= 0 && ncy ~= Nch)
    error('the number of columns of Eopt,sigy must be equal to the number of channels');
end

% Set the power to average if necessary 
% if exist('options','var') && any(strcmp(fieldnames(options),'power')) && strcmpi(options.power,'average')
%     if isy
%         avge = mean(abs(sigx).^2+abs(sigy).^2);    % <- 1xNch vector
%     else
%         avge = mean(abs(sigx).^2);    % <- 1xNch vector
%     end
%     sigx = sigx .* ( ones(Nfft,1) * ( sqrt(laserPower ./ avge )) );
%     if isy
%         sigy = sigy .* ( ones(Nfft,1) * ( sqrt(laserPower ./ avge )) );
%     end
%     laserPower = laserPower.*laserPower ./ avge;
% end

% Now set the delay
% if exist('options','var') && any(strcmp(fieldnames(options),'delay'))
%     isd = true;
%     if strcmp(options.delay,'rand')
%         tau1 = rand(npol,numberChannels);
%         tau = round(tau1*samplesPerSymbol);
%     elseif isnumeric(options.delay)
%         [nrd,ncd] = size(options.delay);
%         if nrd ~= npol || ncd ~= numberChannels
%             error('the delay must be of size [number of polarizations,number of channels]');
%         end
%         tau = round(options.delay*samplesPerSymbol);
%     end
% 	for kch=1:numberChannels
%         sigx(:,kch) = fastshift(sigx(:,kch),tau(1,kch));
%         if isy
%             sigy(:,kch) = fastshift(sigy(:,kch),tau(2,kch));
%         end
% 	end	
%     delay = tau;
% else
    delay = zeros(npol,Nch);
    isd = false;
% end

% Now set the cumulated dispersion
dispersion = zeros(npol, Nch);

% Now create the electric fields

if strcmpi(ftype,'unique')      % UNIQUE FIELD
    
    lamt = channelWavelength; % This has to be the wavelength for each of the channels for one channel is lambda yes.
    maxl = max(lamt);
    minl = min(lamt);
    fnyqmin = (cLight/minl-cLight/maxl)/(symbolRate*1e-9);
    if (samplesPerSymbol < fnyqmin) && fnyqmin ~= 0
%         reply = input('The number of samples per symbol is too small to avoid aliasing. Do you want to continue? Y/N [N]: ', 's');
%         if isempty(reply)
%             reply = 'N';
%         end
%         if ~strcmpi(reply,'Y')
        error('number of samples per symbol is too small. You are generating aliasing (line 179 create_field function)');
%         end
    end

    lamc = 2*maxl*minl/(maxl+minl); %central wavelength: 1/lamc = 0.5(1/maxl+1/minl)
%     lamc = (maxl+minl)/2;
    deltafn = cLight*(1/lamc-1./lamt);   % absolute frequency spacing [GHz]
    minfreq = normalizedFreq(2)-normalizedFreq(1);    % minfreq= GSTATE.FN(2)-GSTATE.FN(1)
    ndfn = round(deltafn./(symbolRate*1e-9)/minfreq);  % spacing in points
%     assert(Nfft<20);
    fieldX = complex(zeros(Nfft,1));
    zfieldx = fft(sigx);
    if isy, fieldY = complex(zeros(Nfft,1));end
    for kch=1:Nch    % create the unique field combining the channels       
%         fieldX = fieldX + fastshift(zfieldx(:,kch),-ndfn(kch));
        fieldX = fieldX + fastshift(zfieldx(:,kch),-ndfn(kch));
        if isy
            zfieldy = fft(sigy(:,kch));
            fieldY = fieldY + fastshift(zfieldy,-ndfn(kch));
        end
    end
    fieldX = ifft(fieldX);
   %     fieldXTx = fieldX;
    if isy
        fieldY = ifft(fieldY);
%         fieldYTx = fieldY;
    end
else
    error('ftype must be ''sepfields'' or ''unique''');
end
% fieldX = zeros(16*5512,1);
% fieldY = zeros(16*5512,1);
% delay = zeros(2,9);
% dispersion = zeros(2,9);

function y=fastshift(x,n)

%FASTSHIFT Fast but simplified circular shift.
%   Y=FASTSHIFT(X,N) shifts the vector or matrix X circularly.
%   If X is a vector then Y=FASTSHIFT(X,N) is equivalent to
%   Y=CIRCSHIFT(X,N). 
%
%   E.g. N=2. 
%
%   X   0 1  2 3 4 5 6 7 8 9 10
%   Y   9 10 0 1 2 3 4 5 6 7  8 
%
%   If X is a matrix of then FASTSHIFT acts on the first dimension
%   (rows) and Y=FASTSHIFT(X,N) is equivalent to Y=CIRCSHIFT(X,[N 0]).
%
%   E.g. N=2. 
%   X = [     1     2     3
%             4     5     6
%             7     8     9 ]
%   Y = [     4     5     6
%             7     8     9
%             1     2     3 ]
%
%   See also CIRCSHIFT, NMOD
%
%   Author: Massimiliano Salsi, 2009
%   University of Parma, Italy

%    This file is part of Optilux, the optical simulator toolbox.
%    Copyright (C) 2009  Paolo Serena, <serena@tlc.unipr.it>
%			 
%    Optilux is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 3 of the License, or
%    (at your option) any later version.
%
%    Optilux is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.

if length(n) > 1,error('the shift must be a single element');end
if size(x,1) == 1
    x=x(:);
    spy=true;
else
    spy=false;
end
if n<0
    n=-n;
    y = [x( nmod(n+1,end) :end,:);x(1:mod(n,end),:)];
elseif n>0
    y = [x( nmod( end-n+1,end):end ,:);x( 1:mod(end-n,end),:)];
else
    y=x;
end
if spy
    y=y.';
end


function y=nmod(A,N)

%NMOD N-modulus of an integer.
%   Y=NMOD(A,N) reduces the integer A into 1->N, mod N.
%
%   E.g. N=8. 
%
%   A   ... -2 -1 0 1 2 3 4 5 6 7 8 9 10 ...
%   Y   ...  6  7 8 1 2 3 4 5 6 7 8 1 2  ...
%
%   Author: Paolo Serena, 2009
%   University of Parma, Italy

%    This file is part of Optilux, the optical simulator toolbox.
%    Copyright (C) 2009  Paolo Serena, <serena@tlc.unipr.it>
%			 
%    Optilux is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 3 of the License, or
%    (at your option) any later version.
%
%    Optilux is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.


y = mod(A-1-N,N)+1;

