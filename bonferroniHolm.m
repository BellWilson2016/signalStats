function pAdj = bonferroniHolm(pValues)

    pValues = pValues(:);

    [sortedP, IX] = sort(pValues,'ascend');
    m = length(pValues);
    for i = 1:m
	        pAdj(i) = min([max((m + 1 - [1:i]).*sortedP(1:i)'),1]);
	end

    % Undo the sorting
	order = 1:m;
	order = order(IX);

	[unsort, unIX] = sort(order);
	pAdj = pAdj(unIX);
	pAdj = pAdj(:);
