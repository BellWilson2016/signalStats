%%
%	bonferroniHolm.m
%
%	Implements the Bonferroni-Holm procedure for adjusting P-values for multiple comparisons.
%	See Holm, 1979.%
%
%%
function pAdj = bonferroniHolm(pValues)

	% Make an ordered list of P-values
    pValues = pValues(:);
    [sortedP, IX] = sort(pValues,'ascend');

	% For each P-value in the list
    m = length(pValues);
    for i = 1:m
			% Scale that P and lower P's according to their order.
	        scaleP = (m + 1 - [1:i]).*sortedP(1:i)';
			% A P-value can't be lower than the max of the P's before it.
	        corrP = max(scaleP);
			% A P-value can't be P > 1
			pAdj(i) = min([corrP, 1]);
	end

    % Undo the sorting to output P-values in the correct order.
	order = 1:m;
	[unsort, unIX] = sort(order(IX));
	pAdj = pAdj(unIX);
	pAdj = pAdj(:);
