function G = gaussian(sigma)

L = ceil(3*sigma);

if sigma == 0
    G = 0;
else
    G = 1/(sigma*sqrt(2*pi)) * exp(-(-L:L).^2/(2*sigma^2));
    %(normalization)
    G = G / sum(G);
end

end