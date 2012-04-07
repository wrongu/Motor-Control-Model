function Saccades = ExtractMovements(Data)

thresh = .5;
thresh2 = 10;
min_time = 2;

X = Data(:,1)';
Y = Data(:,2)';
Z = Data(:,3)';
T = 1:length(X);
dx=diff(X);
dy=diff(Y);
dz=diff(Z);

Saccades.X = X;
Saccades.Y = Y;
Saccades.Z = Z;
Saccades.T = T;

% sum absolute values of the changes to get vector magnitude of change (square of the distance)
mag=[sqrt(dx.^2 + dy.^2 + dz.^2) 0];

Saccades.mag = mag;

v1 = [dx 0; dy 0; dz 0];
v2 = [0 dx; 0 dy; 0 dz];

angles = acosd(sum(v1.*v2)./sqrt(sum(v1.^2).*sum(v2.^2)));

Saccades.angles = angles;

cumdx = cumsum(dx);
cumdy = cumsum(dy);

anglemag=[sqrt(cumdx.^2 + cumdy.^2)./(1:length(cumdx)) 0];

%%

above=zeros(size(mag));
above(mag >= thresh)=1;

above2 = zeros(size(angles));
above2(angles <= thresh2)=1;
above.*above2;

plot(T,X)
plot(T,thresh*(above.*above2)*2+1000,'k')

figure
plot(T,mag)
hold on
plot(T,thresh*(above.*above2),'r')

figure
plot(T,angles)
hold on
plot(T,thresh2*(above.*above2),'r')

% forward cross-correlate to locate sustained above-threshold values.
fsustained=[];
ffilter=zeros(size(above));
ffilter(1:min_time)=1;
for j=1:length(above)-min_time,
    if sum(ffilter.*above.*above2) == min_time
        fsustained = [fsustained j];  % add to list of sustained values
    end;
    ffilter=[0 ffilter(1:(end-1))];  % slide filter
end;

centerindex = 0;
count = 1;

fsustained

if ~isempty(fsustained),
    
    t0 = fsustained(1);
    search_start=find(fsustained <=t0, 1, 'last' ); % locate that index in fsustained
 
    
    while length(fsustained)~= 0,
        
        onset=fsustained(1);   % index to onset
        for i=search_start:-1:2
            % is previous element the previous sample?
            if fsustained(i) ~= (fsustained(i-1)+1),
                onset=fsustained(i);   % index to onset
                break;
            end;
        end;
        
        saccadestart = T(onset);
        Saccades.starttime(count) = saccadestart;
        Saccades.startpoint(:,count) = [X(onset); Y(onset); Z(onset)];
        
        %%
        
        % work forward in time to find first element to fail criteria
        offset=fsustained(end)+min_time-1;
        for i=search_start:(length(fsustained)-1)
            if fsustained(i) ~= (fsustained(i+1)-1)
                offset=fsustained(i)+min_time-1;  % index to offset
                break;
            end;
        end;
        
        saccadestop = T(offset);
        Saccades.stoptime(count) = saccadestop;
        Saccades.stoppoint(:,count) = [X(offset); Y(offset); Z(offset);];
        
        Saccades.duration(count) = Saccades.stoptime(count) - Saccades.starttime(count);
        
        movementangle = (atan2(Y(offset)-Y(onset), X(offset)-X(onset))*(180/pi));
        Saccades.movementangle(count) = movementangle;
        Saccades.binangle = movementangle(1);
       
        analog_rate_of_change = sqrt( (Y(offset)-Y(onset)).^2 + (X(offset)-X(onset)).^2 );
        Saccades.distance(count) = analog_rate_of_change;
        Saccades.velocity(count) = analog_rate_of_change ./ Saccades.duration(count);
        
        fsustained = fsustained(i+1:end);
        
        count = count + 1;
        
    end
    
else
    
    Saccades.starttime(count) = 1;
end


end