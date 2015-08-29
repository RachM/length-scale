function F = fast_h_function(h,data)

lambda=data.constant2*h^(5/7);
[D4]=FastUnivariateDensityDerivative(data.N,data.N,data.X,data.X,lambda,4,data.epsil);
phi4=sum(D4)/(data.N-1);
F=h-data.constant1*phi4^(-1/5);