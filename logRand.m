%%
%	logRand.m
%
%	Log distributed random numbers.
%
%%
function out = logRand(bottom, top, base)

	lb = log(bottom)/log(base);
	lt = log(top)/log(base);

	randExp = rand()*(lt - lb) + lb;
	out = base^randExp;

