%%Divya Gunasekaran
%%October 15, 2010

%Function to check whether to continue with posture registration. We expect
%the rate of posture registration to be above a certain threshold sigma. If
%not, we consider the cell saturated with postures, and return an integer
%continueReg = 0, which will tell the posture generation process to halt.

%Inputs:
%cycle = number of cycles over which number of registered postures is
%averaged
%numNewPostures = number of registered postures
%sigma = threshold for growth of new postures


function [continueReg, newRate] = checkRegRate(numNewPostures, cycle, sigma)
    continueReg=1;
    newRate = numNewPostures / cycle;

    if newRate < sigma,
        continueReg=0;
    end
end