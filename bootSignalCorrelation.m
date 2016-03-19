function pVals = bootSignalCorrelation(X, classIX, nBoots)

	% Replace NaNs
	ix = find(isnan(X));
	X(ix) = 0;

	% Score matrix for unit variance
	zX = zscore(X,0,1);

	% Add random noise...
	% zX = zX + 3*randn(size(zX,1),size(zX,2));

	sigMatrix = signalDataMatrix( zX, classIX);
	sigCorr = cov(sigMatrix);

	nSamples = size(zX,1);
	nScores = size(zX,2);
	bootCorrs = zeros( nScores, nScores, nBoots);
	pVals = zeros( nScores, nScores);

	for bootN = 1:nBoots
		% Bootstrap by permuting class labels
%		randSeq = randperm(length(classIX));
%		randClass = classIX(randSeq);
%		bootSigMatrix = signalDataMatrix( zX, randClass);

		% Bootstrap by drawing samples with replacement
		bootX = X(randi(nSamples,nSamples,1),:);
		bootZX = zscore(bootX,0,1);
		bootSigMatrix = signalDataMatrix( bootZX, classIX);

		bootSigCorr = cov(bootSigMatrix);
		bootCorrs(:,:,bootN) = bootSigCorr;
	end

	for v1 = 1:nScores
		for v2 = 1:nScores

			testScore = sigCorr(v1,v2);
			bootScores = bootCorrs(v1,v2,:);

			pVals(v1,v2) = (sum(abs(bootScores) >= abs(testScore))+1)/(nBoots + 1);
		end
	end

	% image(log10(pVals),'CDataMapping','scaled');


