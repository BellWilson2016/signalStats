%%
%	nancorr.m
%
%	Correlation matrix protected against NaNs.
%
%%
function nanC = nancorr(X,Y)

	zX = nanZscore(X);
	zY = nanZscore(Y);

	nanC = zeros(size(zX,2),size(zY,2));
	for n1 = 1:size(zX,2)
		for n2 = 1:size(zY,2)
			cEntry = (nancov([zX(:,n1),zY(:,n2)]));
			nanC(n1,n2) = cEntry(1,2);
		end
	end


		

