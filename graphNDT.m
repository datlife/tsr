
function [] = graphNDT(sound,defect)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%Process sound and defect data

%SAMPLE:
%defect data : 276 61
%sound data  : 86 231

DeltaTdat = [sound, defect];
DeltaTdat = transpose(DeltaTdat);
grid_detail = 0.02;
Time  = 1:size(sound,1);

for n = 1:2
data        = DeltaTdat(n,:); 
flash_frame = 10;
%FIND THE FLASHING POINT by calculating slope
clear slope;
%Pre-flash calculation
Pre_Flash_Data   = mean(data(1:8));    
deltaT           = data   - Pre_Flash_Data;
 
%Adjust the timeline
adjust_time      = Time(flash_frame);
Time             = Time - adjust_time;
 
%Get natural log of vectors Time and Temp
lnTemp_original = log(abs(deltaT(flash_frame+1:end)));
lnTime_original   = log((Time  (flash_frame+1:end)));
 
%Recreate the data for the
%entire duration for 200 equally spaced intervals in log(t).
lnTime = lnTime_original(2):grid_detail:lnTime_original(end);
lnTemp = interp1(lnTime_original,lnTemp_original,lnTime,'spline');

%Start with 1st degree
degree = 1; 
old_rsq = 0;
%(A)Find curve-fit
while 1
    %Calculate co-efficients for lnTime vs lnTemp
    [plFit, Error, mu] = polyfit(lnTime(flash_frame:end),...
                                 lnTemp(flash_frame:end),...
                                 degree);
    %Evaluate error
    [y, delta] = polyval(plFit,lnTime,...
                         Error,mu);
    %Calculate percentage of error(PoE) comparing to actual values
        total_error = sqrt(sum(delta.^2));
        total_value = sum((y - mean(y)).^2);
        Rsq = 1 - total_error/total_value;   %PoE value
    %Break loop if PoE < 0.001   
    if (Rsq == 1) || (degree == 6) %|| %(Rsq - old_rsq) < 0.0001 
        break;
    else
        degree = degree + 1; 
        old_rsq = Rsq;
    end
end


%(B)1st-derivative
%Center the time
Center_Time = (lnTime - mean(lnTime))/std(lnTime);
%Center_Time = lnTime;
%(B)Find 1st- derivative
Fit1D  = polyder(plFit);
lnTemp1D = polyval(Fit1D,Center_Time);

%(C)2nd-derivative
Fit2D  = polyder(Fit1D);
lnTemp2D = polyval(Fit2D,Center_Time);

%DISPLAY RESULT
%Plot result
figure(1);
%Orginal Data
hold on;
if(n == 2)  plot(lnTime,lnTemp,'color','r','linewidth', 1);  
else        plot(lnTime,lnTemp,'color','b','linewidth', 1);       
end
    title('Orginal Data'); xlabel('ln(Time)'); ylabel('ln(Temp)');
    grid on;
hold off;
%CurvedFit Data
figure(2);
hold on;
if(n == 2) plot( lnTime(flash_frame:end),y(flash_frame:end),...
                 '--','linewidth', 1,'color','r');
else       plot( lnTime(flash_frame:end),y(flash_frame:end),...
                 '.','linewidth', 1,'color','b');
end
    title('\DeltaTemp and Fitted Curves');
    xlabel('ln(Time)'); ylabel('ln(\DeltaTemp)');
    grid on;
 hold off;
%1st-Derivative Data
figure(3);
hold on;
if(n == 2) plot( lnTime,lnTemp1D,...
                 '--','linewidth', 1,'color','r');
else       plot(lnTime,lnTemp1D,...
                 '.','linewidth', 1,'color','b');
end
    title('1st-Derivative Data');
    xlabel('ln(Time)'); ylabel('ln(\DeltaTemp)');
    grid on;
 hold off;
 
 
 %2nd-Derivative Data
figure(4);
hold on;
if(n == 2) plot( lnTime,lnTemp2D,...
                 '--','linewidth', 1,'color','r');
else       plot(lnTime,lnTemp2D,...
                 '.','linewidth', 1,'color','b');
end
    title('2nd-Derivative Data');
    xlabel('ln(Time)'); ylabel('ln(\DeltaTemp)');
    grid on;
 hold off;
 
 


end

