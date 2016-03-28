%%
%	signalReliability.m
%
%	Calculate the ratio of the between group variance to the total variance.
%
%	args:
%		X: Data matrix. Data points in rows. Columns are variables.
%		classIX: Vector of numbers signifying group membership for each data point.
%
%%
function sigReliability = signalReliability( X, classIX)

	% Remove NaN's
	X(find(isnan(X))) = 0;

	% Z-score the data matrix. Now all columns will have unit variance.
	zX = zscore(X,0,1);

	% Replace each entry with the average of the entries of the same group.
	sigMatrix = signalDataMatrix( zX, classIX);
	
	sigReliability = zeros(size(sigMatrix,2),1);

	% For each variable, the reliability is the ratio of the between group
	% variance to the total variance. We've already scaled so total variance
	% is 1. So get the between group variance...
	for scoreN = 1:size(sigMatrix,2)
		sigReliability(scoreN) = cov(sigMatrix(:,scoreN));
	end

