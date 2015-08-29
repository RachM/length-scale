function [h]=fast_univariate_bandwidth_estimate_STEPI(N,X,epsil)

%     AMISE optimal bandwidth estimation for univariate kernel
%     density estimation. [FAST METHOD]
%     [Shether Jones Solve-the-equation plug-in method.]
%     --------------------------------------------------------------------------
%     INPUTS
%     --------------------------------------------------------------------------
%     N                 --> number of source points.
%     X                 --> 1 x N matrix of N source points.
%     epsil           --> accuracy parametr for fast density derivative
%                              estimation [1e-3 to 1e-6]
%     --------------------------------------------------------------------------
%     OUTPUTS
%     --------------------------------------------------------------------------
%     h                 --> the optimal bandiwdth estimated using the
%                              Shether Jones Solve-the-equation plug-in
%                              method.
%     --------------------------------------------------------------------------
%     Implementation based on:
%
%     V. C. Raykar and R. Duraiswami 'Very fast optimal bandwidth 
%     selection for univariate kernel density estimation'
%     Technical Report CS-TR-4774, Dept. of Computer 
%     Science, University of Maryland, College Park.
%
%    S.J. Sheather and M.C. Jones. 'A reliable data-based
%    bandwidth selection method for kernel density estimation'
%    J. Royal Statist. Soc. B, 53:683-690, 1991
%    ---------------------------------------------------------------------------


% Scale the data to lie in the unit interval

shift=min(X); X_shifted=X-shift;
scale=1/(max(X_shifted)); X_shifted_scaled=X_shifted*scale;

% Compute an estimate of the standard deriviation of the data

sigma=std(X_shifted_scaled);

% Estimate the density functionals ${\Phi}_6$ and ${\Phi}_8$ using the normal scale rule.

phi6=(-15/(16*sqrt(pi)))*(sigma^(-7));
phi8=(105/(32*sqrt(pi)))*(sigma^(-9));

% Estimate the density functionals ${\Phi}_4$ and ${\Phi}_6$ using the kernel density
% estimators with the optimal bandwidth based on the asymptotic MSE.

g1=(-6/(sqrt(2*pi)*phi6*N))^(1/7);
g2=(30/(sqrt(2*pi)*phi8*N))^(1/9);

[D4]=FastUnivariateDensityDerivative(N,N,X_shifted_scaled,X_shifted_scaled,g1,4,epsil);
phi4=sum(D4)/(N-1);

[D6]=FastUnivariateDensityDerivative(N,N,X_shifted_scaled,X_shifted_scaled,g2,6,epsil);
phi6=sum(D6)/(N-1);

% The bandwidth is the solution to the following  equation.

constant1=(1/(2*sqrt(pi)*N))^(1/5);
constant2=(-6*sqrt(2)*phi4/phi6)^(1/7);

h_initial=constant1*phi4^(-1/5);

options = optimset('Display','off','TolFun',1e-14,'TolX',1e-14,'LargeScale','on');
data.N=N;
data.X=X_shifted_scaled;
data.constant1=constant1;
data.constant2=constant2;
data.epsil=epsil;

[h,resnorm,residual,exitflag,output] = lsqnonlin('fast_h_function',h_initial,[0],[],options,data) ;

h=h/scale;

if exitflag>0    disp('The function converged to a solution.'); end
if exitflag==0  disp('The maximum number of function evaluations or iterations was exceeded.'); end
if exitflag<0    disp('The function did not converge to a solution.'); end

