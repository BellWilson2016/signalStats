%%
%	signalReliability.m
%
%%
function sigReliability = signalReliability( X, classIX)

	% Remove NaN's
	X(find(isnan(X))) = 0;
	zX = zscore(X,0,1);

	sigMatrix = signalDataMatrix( zX, classIX);
	
	sigReliability = zeros(size(sigMatrix,2),1);
	
	for scoreN = 1:size(sigMatrix,2)
		sigReliability(scoreN) = cov(sigMatrix(:,scoreN));
	end

