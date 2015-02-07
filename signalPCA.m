function [coeffs,scores,latent,mu,expVar] = signalPCA( X, classIX, nPC)

	% Always center the data
	mu = mean(X,1);
	cX = X - ones(size(X,1),1)*mu;

	debugPlot = false;

	%% 
	%	Two methods are presented, both should give equivalent values. The c
	%	covariance method seems to be faster, but the SVD method should 
	%   perform better at very high dimensionalities (> 10000) because the
	%   covariance matrix doesn't have to be calculated.
	%%
	covMethod = true;
	
	if (covMethod)
		% Calculate the signal covariance matrix and diagonalize it
		sigMatrix = signalDataMatrix(cX, classIX);
		disp('Calculating signal covariance matrix...');
		sigCov = cov(sigMatrix);
		disp('Finding eigenvectors...');
		[Vs,Ds] = eigs(sigCov,nPC);
		nRet = size(diag(Ds),1);
		if (nRet < nPC)
			disp(['***** Warning! eigs() only returned ',num2str(nRet),...
					'/',num2str(nPC),' PCs *****']);
			nPC = nRet;
		end

		% Sort eigenvalues and eigenvectors
		[eigVals,eigIX] = sort(diag(Ds),'descend');
		coeffs = Vs(:,eigIX);
		expVar = totalVariance(sigMatrix);
		latent = eigVals(1:nPC)./expVar;

		% Calculate scores
		scores = cX*coeffs;
	else
		% Calculate the signal data matrix
		sigMatrix = signalDataMatrix(cX, classIX);
		
		% SVD it, make sure we get enough values
		options.tol = 10^-10; options.maxit = 300; options.disp = 0;
		disp('Finding SVD of signal data...');
		[U,S,V] = svds(sigMatrix,nPC,'L',options);
		nRet = size(S,1);
		if (nRet < nPC)
			disp(['***** Warning! svds() only returned ',num2str(nRet),...
					'/',num2str(nPC),' PCs *****']);
			nPC = nRet;
		end

		% Scale and sort the eigenvalues
		[eigVals,eigIX] = sort((diag(S).^2)./(size(cX,1)-1),'descend'); 
		coeffs = V(:,eigIX);
		expVar = totalVariance(sigMatrix);
		latent = eigVals(1:nPC)./expVar;

		% Calculate the scores
		scores = cX*coeffs;
	end

	if debugPlot
		figure();

		[sigCorr,noiseCorr] = signalCorrelation(cX,classIX);
		[B,IX] = sort(diag(sigCorr),'descend');

		subplot(2,3,1);
		image(sigCorr(IX,IX),'CDataMapping','scaled'); colorbar;
		title('sigCorr of centered data');

		subplot(2,3,2);
		plot(cumsum(latent)./sum(latent),'bo-');
		title('Fraction of explainable variance');

		subplot(2,3,4);
		image(cov(scores),'CDataMapping','scaled'); colorbar;
		title('Cov of scores');

		subplot(2,3,5);
		[sigCov,noiseCov] = signalCovariance(scores,classIX);
		image(sigCov,'CDataMapping','scaled'); colorbar;
		title('signalCov of scores');

		subplot(2,3,6);
		[sigCorr,noiseCorr] = signalCorrelation(scores,classIX);
		image(sigCorr,'CDataMapping','scaled'); colorbar;
		title('Sig Corr of scores');
	end


