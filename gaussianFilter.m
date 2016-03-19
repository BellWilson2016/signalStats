%%
%	Convolves a 1D signal with a unitary gaussian kernel.
%
function out = gaussianFilter(signal, sigma, sampleRate)

	coverageFactor = 5;	% How many sigma out to take the tails?
	tVec = [-coverageFactor*sigma:(1/sampleRate):coverageFactor*sigma];
	kernel = 1/(sigma*sqrt(2*pi))*exp(-tVec.^2/(2*sigma^2))*(1/sampleRate);

	% Diagnostics to make sure you made the kernel correctly...
	% plot(tVec, kernel)
	% sum(kernel)*1/sampleRate

	% Pad the signal with the first and last value instead of zeros
	first = signal(1);
	last  = signal(end);
	nPads = length(kernel);
	paddedSignal = [ones(1,nPads)*first,signal(:)',ones(1,nPads)*last];

	% Convolve! (Return the 'same' length as signal.)
	paddedOut = conv(paddedSignal, kernel, 'same');
	out = paddedOut((nPads+1):(end-nPads));
