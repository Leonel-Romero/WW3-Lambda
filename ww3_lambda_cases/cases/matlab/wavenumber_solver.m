function k=wavenumber_solver(w,h);
%function k=wavenumber_solver(w,h);
% Calculates the wavenumber with Newton's iterative method
% In:
% w is the radial frequency (rad/s)
% h is the water depth (m)
%
% Out:
% k is the wavenumber (rad/m)
%
% L. Romero 2012
%
g=9.81;
%1st guess, deep water
ko=w.^2/g;
k=ko;
for n=1:5   
    k=k+(w.^2-g*k.*tanh(k.*h))./(g.*tanh(k.*h)+g*k.*h.*(1-tanh(k.*h).^2));
end
