%%
%	signalCovariance.m
%
%%
function [sigCov, noiseCov] = signalCovariance( X, classIX)

	sigMatrix = signalDataMatrix( X, classIX);

	totalCov  = cov(X);
	sigCov = cov(sigMatrix);
    noiseCov = totalCov - sigCov;

