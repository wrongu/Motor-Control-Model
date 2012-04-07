%Divya Gunasekaran
%May 11, 2011

%Principle Component Analysis
%Get sample covariance matrix

%Assuming each row in timeSeriesData is an observed joint trajectory with p
%time intervals for the given angle 

%Output S is a pxp matrix

function S = GetCovariance(mean,timeSeriesData)

%N is number of measured joint trajectories (number of movements)
%p is number of uniform time intervals 
[N,p] = size(timeSeriesData);

S = zeros(p,p);
for i=1:N
    S = S + ((timeSeriesData(i,:)- mean)')*(timeSeriesData(i,:)- mean);
end

S = (1/N)*S;
