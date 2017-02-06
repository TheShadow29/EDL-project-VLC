%coded by Xiao Long (University of Cambridge) and LC Png (Nanyang Technological University)
function f = Ndistribution(x, mu, s)

% x = data array
% mu = mean
% s = standard deviation

f = (1./(s*sqrt(2*pi))) .* exp(((x-mu).^2)./(2*(s.^2)));  