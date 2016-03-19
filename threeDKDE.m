function out = threeDKDE(x1,x2,x3,sig1,sig2,sig3,bins1,bins2,bins3)

	coverageFactor = 5;
	res1 = bins1(2)-bins1(1);
	res2 = bins2(2)-bins2(1);
	res3 = bins3(2)-bins3(1);

	nPoints = length(x1);
	quant1 = dsearchn(bins1(:),x1(:));
	quant2 = dsearchn(bins2(:),x2(:));
	quant3 = dsearchn(bins3(:),x3(:));

	% Make a raster
	raster = zeros(length(bins1),length(bins2),length(bins3));
	for ptN = 1:nPoints
		raster(quant1(ptN),quant2(ptN),quant3(ptN)) = ...
					raster(quant1(ptN),quant2(ptN),quant3(ptN)) + 1;

	end


	% Make a unitary gaussian
	gaussian = zeros(length(bins1),length(bins2),length(bins3));
	gbins1 = bins1 - mean(bins1);
	gbins2 = bins2 - mean(bins2);
	gbins3 = bins3 - mean(bins3);
	for bin3N = 1:length(bins3)
		mat1 = 1./(sig1*sqrt(2*pi)).*exp(-gbins1(:).^2./(2*sig1.^2))*...
								ones(1,length(gbins2));
		mat2 = ones(length(gbins1),1)*(1./(sig2*sqrt(2*pi)).*...
						exp(-(gbins2(:)').^2./(2*sig2.^2)));
		mat3 = 1./(sig3*sqrt(2*pi)).*exp(-gbins3(bin3N).^2./(2*sig3.^2));

		gaussian(:,:,bin3N) = mat1.*mat2.*mat3;
	end

	disp('Convolving...'); 
	out = convn(raster, gaussian, 'same');
	disp('...done.');

%	sum(gaussian(:))
%
%	for n = 1:8
%		subplot(4,2,n);
%		image(out(:,:,n),'CDataMapping','scaled'); colorbar;
%	end

