%%
%	rDist.m
%
%	Calculates the distribution of the Pearson correlations of 
%	vectors of length n drawn from uncorrelated populations.
%
%%
function stdF = rDist(n)

	% Define the density distribution under p=0
	f = @(r) ((1-r.^2).^((n-4)/2))./beta(1/2,(n-2)/2);
	r = -1:.001:1;

	% Calculate out the distribution
	fr = f(r);
	fr = fr./(sum(fr));

	% if false;
	%	plot(r,fr);
	% end

	% Calculate the std. dev of the distribution
	muF = 0; % By construction
	stdF = sqrt(sum((r - muF).^2.*fr));


