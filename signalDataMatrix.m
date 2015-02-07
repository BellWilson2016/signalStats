%%
%	signalDataMatrix.m
%
%%
function sigMatrix = signalDataMatrix( X, classIX)

	% Protect against NaN
	ix = find(isnan(X));
	X(ix) = 0;

	nPoints = size(X,1);
    nDim = size(X, 2);
    uniqueClasses = unique(classIX);

	% Generate a matrix with each data point's value replaced by the class mean
	classMeanX = zeros(nPoints,nDim);
	currPt = 1;
	for classNn = 1:length(uniqueClasses)
		classN = uniqueClasses(classNn);
		ix = find(classIX == classN);
		nInClass = length(ix);
		classMean = mean(X(ix,:),1);
		classMeanX(currPt:(currPt+nInClass-1),:) = ones(nInClass,1)*classMean;
		currPt = currPt + nInClass;
	end

	sigMatrix = classMeanX;
