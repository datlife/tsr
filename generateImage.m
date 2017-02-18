function [ image ] = generateImage(handles, coeff, frame)
[row, col,z] = size(coeff);
data = reshape(permute(coeff,[2 1 3]),[row*col,size(coeff,3)]);
image1 = 1:size(data);
for r = 1:row*col
     image1(r) = polyval(data(r,:),log(15*frame/900)); 
     image1(r) = exp(image1(r));
end
image = permute(reshape(permute(image1,[1 3 2]),col,row),[2 1]);

end

