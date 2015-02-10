function nanZ = nanZscore(X)

	nMean = nanmean(X);
	nStd = nanstd(X);

	nanZ = (X - ones(size(X,1),1)*nMean)./(ones(size(X,1),1)*nStd);
