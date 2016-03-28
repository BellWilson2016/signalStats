%%
%	totalVariance.m
%
%	Calculates the total variance in a data matrix via the scaled frobenius norm.
%	Also includes test code...
%
%	args: 
%		X: Data matrix. Data points in rows, variables in columns.
%		arg2: Triggers a test routine.
%
%%
function totVar = totalVariance(X, varargin)

	if nargin > 1
		disp('Running test routine...');
		testTotalVariance();
		totalVar = 0;
		return;
	end

	totVar = (norm(X,'fro')^2)/(size(X,1)-1);

function testTotalVariance()

	X = randi(10,20,5);

	cX = X - ones(size(X,1),1)*mean(X,1);
	[coeff,score,latent,tsq,explained] = pca(cX);
	
	disp('Sum latent:');
	sum(latent)

	[Vs,Ds] = eig(cov(cX));
	disp('Sum cov. eigenvals:');
	sum(diag(Ds))

	[U,S,V] = svd(cX);
	diagS = (diag(S).^2)./(size(cX,1)-1);
	disp('Sum scaled principal values:');
	sum(diagS)
	
	% Scaled frobenius norm
	disp('Sum scaled frobenius norm:');
	totalVariance(cX)
