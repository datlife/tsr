function [plFit, Error, mu] = processOnePixel( data )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%  data : a vector length TIME
%==========CONSTANTS AND VARIABLES======
%Get a finer grid
grid_detail = 0.02; 
%Initial flash-frame for flashpoint cal
flash_frame = 10;
%=======================================
%Create time vector based on data
Time  = 1:size(data,2);
%Pre-flash calculation
deltaT           = data   -  mean(data(1:8)); 
%Adjust the timeline
Time             = Time -  Time(flash_frame);
%Get natural log of vectors Time and Temp
lnTemp_original   = log(abs(deltaT(flash_frame+1:end)));
lnTime_original   = log((Time  (flash_frame+1:end)));

%Recreate the data for the
%entire duration for 200 equally spaced intervals in log(t).
lnTime = lnTime_original(2):grid_detail:lnTime_original(end);
lnTemp = interp1(lnTime_original,lnTemp_original,lnTime,'spline');

%Adjust the timeline
%lnTime           = lnTime - lnTime(flash_frame);
 
%Calculate co-efficients for lnTime vs lnTemp
[plFit, Error, mu] = polyfit(lnTime(flash_frame+1:end),lnTemp(flash_frame+1:end),6);

% %UNIT TEST - PLOT RESULT
% 
% figure(1);
% %Orginal Data
% hold on;
% plot(lnTime,lnTemp)
% title('Orginal Data'); xlabel('ln(Time)'); ylabel('ln(Temp)');grid on;
% hold off;
% 
% [y] = polyval(plFit,lnTime,Error,mu);
% figure(2);
% hold on;
% plot( lnTime(flash_frame:end),y(flash_frame:end));
% title('\DeltaTemp and Fitted Curves');
% xlabel('ln(Time)'); ylabel('ln(\DeltaTemp)');grid on;
% hold off;

% 
% %(B)1st-derivative
% %Center the time
% Center_Time = (lnTime - mean(lnTime))/std(lnTime);
% %Center_Time = lnTime;
% %(B)Find 1st- derivative
% Fit1D  = polyder(plFit);
% lnTemp1D = polyval(Fit1D,Center_Time);
% %1st-Derivative Data
% figure(3);
% hold on;
% plot( lnTime,lnTemp1D);
% title('1st-Derivative Data');
% xlabel('ln(Time)'); ylabel('ln(\DeltaTemp)');
% grid on;
% hold off;
% 
% 
% %(C)2nd-derivative
% Fit2D  = polyder(Fit1D);
% lnTemp2D = polyval(Fit2D,Center_Time);
% figure(4);
% hold on;
% plot( lnTime,lnTemp2D);
% title('2nd-Derivative Data');
% xlabel('ln(Time)'); ylabel('ln(\DeltaTemp)');
% grid on;
% hold off;
end

