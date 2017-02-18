function [coeff,coeff_1D,coeff_2D ] = processData(data )
%   Detailed explanation goes here
[row, col,z] = size(data);

%Covert data to a new matrix Nx900 .It impressively increases the speed
coeffi     = zeros(row*col,7);
coeffi_1D  = zeros(row*col,6);
coeffi_2D  = zeros(row*col,5);

RData = reshape(permute(data,[2 1 3]),[row*col,900]);

disp('Data processing...');
parpool(4);
parfor r = 1:row*col
    coeffi(r,:) = processOnePixel(RData(r,:));
  	coeffi_1D(r,:) = polyder(coeffi(r,:));
    coeffi_2D(r,:) = polyder(coeffi_1D(r,:));
end
%Convert back to original matrix data
coeff = permute(reshape(permute(coeffi,[1 3 2]),col,row,7),[2 1 3]);
coeff_1D = permute(reshape(permute(coeffi_1D,[1 3 2]),col,row,6),[2 1 3]);
coeff_2D = permute(reshape(permute(coeffi_2D,[1 3 2]),col,row,5),[2 1 3]);

disp('Processing completed...');

poolobj = gcp('nocreate');
delete(poolobj);
end