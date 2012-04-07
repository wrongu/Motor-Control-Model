%Divya Gunasekaran
%May 11, 2011

%Principle Component Analysis
%Get mean of time series data vector

function mean = GetSampleMean(timeSeriesData)

%N is number of measured joint trajectories (number of movements)
%p is number of uniform time intervals 
[N,p] = size(timeSeriesData);

sum = zeros(1,p);
for i=1:N
    sum = sum + timeSeriesData(i,:);
end

mean = (1/N).*sum;
