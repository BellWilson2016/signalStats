%%
%	nanZscore.m
%
%	Z-score a matrix that might have NaN's in it.
%
%	args:
%		X: Data matrix. Each row is a data point. Columns are variables.
%
%%

function nanZ = nanZscore(X)

	nMean = nanmean(X);
	nStd = nanstd(X);

	nanZ = (X - ones(size(X,1),1)*nMean)./(ones(size(X,1),1)*nStd);
