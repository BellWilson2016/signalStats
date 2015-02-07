%%
%	signalCorrelation.m
%
%	Also includes:
%
%		shuffleSignalCorrelation() - Calculates (equivalent) statistic
%									 using shuffling within class groups.
%
%		testSignalCorrelation()	   - Shows convergence of two methods.
%
%%
function [sigCorr, noiseCorr] = signalCorrelation( X, classIX, varargin)

	% If a nShuffles is provided, run shuffleSignalCorrelation
	if (nargin > 2)
		if isnumeric(varargin{1})
			[sigCorr, noiseCorr] = shuffleSignalCorrelation( X, classIX, varargin{1});
			return;
		else
			testSignalCorrelation(X,classIX);
			[sigCorr,noiseCorr] = signalCorrelation( X, classIX);
			return;
		end
	end

	% Protect against NaN
	ix = find(isnan(X));
	X(ix) = 0;

	% Score matrix for unit variance
	zX = zscore(X,0,1);
	sigMatrix = signalDataMatrix( zX, classIX);

	% Remember, zX got z-scored so the total variance is unitary...
	totalCorr  = cov(zX);
	sigCorr = cov(sigMatrix);
    noiseCorr = totalCorr - sigCorr;

            
%%
%		shuffleSignalCorrelation() - Uses shuffle method to calculate same stat.
%
%%
function [sigCorr, noiseCorr] = shuffleSignalCorrelation( X, classIX, nSplits)

	% Protect against NaN
	ix = find(isnan(X));
	X(ix) = 0;

	% Seed with a predictable seed so that sig. correlation is crystalized
	rng(314159);

    nDim = size(X, 2);
    corrMatrices = zeros(nDim,nDim,nSplits);
    shuffMatrix = zeros(size(X,1),size(X,2),nSplits);
    uniqueClasses = unique(classIX);
    
    totalCorr = corr(X);
    
    % Make shuffles matrices
    for classNn = 1:length(uniqueClasses)
        ix = find(classIX == uniqueClasses(classNn));
        for splitN = 1:nSplits
            for dimN = 1:nDim
                newOrder = ix(randperm(length(ix)));
                shuffMatrix(newOrder, dimN, splitN) = X(ix,dimN);
            end
        end
    end
    
    % Calculate the correlation matrix of each shuffled matrix
    for splitN = 1:nSplits
        corrMatrices(:,:,splitN) = corr(X, squeeze(shuffMatrix(:,:,splitN)));
    end
    
    % Average the shuffled correlation matrices
    sigCorr = mean(corrMatrices,3);
	ix = isnan(sigCorr); sigCorr(ix) = 0;
	
    noiseCorr = totalCorr - sigCorr;
	ix = isnan(noiseCorr); noiseCorr(ix) = 0;

	% Re-seed the rng 
	rng('shuffle');
            
            
            
        
%%
%
%  Test function for showing convergence of metrics on test data.
%
%%
function testSignalCorrelation(X,classIX)

	tic
	[s1,n1] = shuffleSignalCorrelation(X,classIX,128);
	toc

	[B,IX] = sort(diag(s1),'descend');

	tic
	[s2,n2] = signalCorrelation(X,classIX);
	toc

	figure();
	subplot(2,2,1);
	image(s1(IX,IX),'CDataMapping','scaled');
	colorbar;

	subplot(2,2,2);
	image(s2(IX,IX),'CDataMapping','scaled');
	colorbar;

	subplot(2,2,3);
	image(n1(IX,IX),'CDataMapping','scaled');
	colorbar;

	subplot(2,2,4);
	image(n2(IX,IX),'CDataMapping','scaled');
	colorbar;

	pause(3);

	figure();
	shuffList = 2.^[1:12];
	for n = 1:length(shuffList)
		tic();
		[s1,n1] = shuffleSignalCorrelation(X,classIX,shuffList(n));
		computeTime(n) = toc();
		corrErr(n) = norm(s2 - s1);
		plot(log(computeTime),log(corrErr),'bo-'); 
		xlabel('Log compute time'); ylabel('Log error');
		pause(1);
	end
