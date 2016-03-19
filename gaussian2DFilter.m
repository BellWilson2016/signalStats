%%
%	Convolves a 2D signal with a unitary gaussian kernel.
%
function out = gaussian2DFilter(signal, sigmaX, sigmaY, sampleRate)

	coverageFactor = 3;	% How many sigma out to take the tails?
	tVecX = [-coverageFactor*sigmaX:(1/sampleRate):coverageFactor*sigmaX];
	tVecY = [-coverageFactor*sigmaY:(1/sampleRate):coverageFactor*sigmaY];
	kernelX = 1/(sigmaX*sqrt(2*pi))*exp(-tVecX.^2/(2*sigmaX^2))*(1/sampleRate);
	kernelY = 1/(sigmaY*sqrt(2*pi))*exp(-tVecY.^2/(2*sigmaY^2))*(1/sampleRate);

	kernel = kernelX'*kernelY;
	sum(kernel(:))

	% Diagnostics to make sure you made the kernel correctly...
	% plot(tVec, kernel)
	% sum(kernel)*1/sampleRate

	% Pad the signal with the first and last value instead of zeros
	% first = signal(1);
	% last  = signal(end);
	% nPads = length(kernel);
	% paddedSignal = [ones(1,nPads)*first,signal(:)',ones(1,nPads)*last];

	% Convolve! (Return the 'same' length as signal.)
	% paddedOut = conv(paddedSignal, kernel, 'same');
	% out = paddedOut((nPads+1):(end-nPads));

	out = conv2(signal, kernel, 'same');
