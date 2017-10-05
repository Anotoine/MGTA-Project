warning('off','all'); clearvars; tic;

fileID = fopen('Arrivals_NoHeader.txt','r');
FileArrivals = textscan(fileID,'%s%d%s %s ;%{h:mm a}D%*[^\n]','Delimiter',{';','(',')'});
fclose(fileID);

fileID = fopen('Departures_NoHeader.txt','r');
FileDepartures = textscan(fileID,'%s%d%s %s ;%{h:mm a}D%*[^\n]','Delimiter',{';','(',')'});
fclose(fileID);

fileID = fopen('airports.dat','r');
Airports = textscan(fileID,'%d%s%s%s%s%s%f%f%f%s%s%s%*[^\n]','Delimiter',{',"','","','",',','});
fclose(fileID);

DataA = table(int16(1),"","","","",double(0),double(0),int16(0),"PHX","PHOENIX",double(33.43429946899414),double(-112.01200103759766),int16(1135),[0 0],datetime(0,0,0),false,int16(0),double(0),...
    'VariableNames',{'Number','Airline','FlightID','IATA_O','City_O','Lat_O','Lon_O','Alt_O','IATA_D','City_D','Lat_D','Lon_D','Alt_D','ETA','ETD','Int','CPAX','Distance'});

DataA.Properties.VariableUnits{'Distance'} = 'Nautical Miles';
DataA.Properties.VariableUnits{'Lat_O'} = 'Degrees (Decimal)';
DataA.Properties.VariableUnits{'Lon_O'} = 'Degrees (Decimal)';
DataA.Properties.VariableUnits{'Lat_D'} = 'Degrees (Decimal)';
DataA.Properties.VariableUnits{'Lon_D'} = 'Degrees (Decimal)';
DataA.Properties.VariableUnits{'Alt_O'} = 'Feet';
DataA.Properties.VariableUnits{'Alt_D'} = 'Feet';

DataD = table(int16(1),"","","PHX","PHOENIX",double(33.43429946899414),double(-112.01200103759766),int16(1135),"","",double(0),double(0),int16(0),datetime(0,0,0),datetime(0,0,0),false,int16(0),double(0),...
    'VariableNames',{'Number','Airline','FlightID','IATA_O','City_O','Lat_O','Lon_O','Alt_O','IATA_D','City_D','Lat_D','Lon_D','Alt_D','ETA','ETD','Int','CPAX','Distance'});

DataD.Properties.VariableUnits{'Distance'} = 'Nautical Miles';
DataD.Properties.VariableUnits{'Lat_O'} = 'Degrees (Decimal)';
DataD.Properties.VariableUnits{'Lon_O'} = 'Degrees (Decimal)';
DataD.Properties.VariableUnits{'Lat_D'} = 'Degrees (Decimal)';
DataD.Properties.VariableUnits{'Lon_D'} = 'Degrees (Decimal)';
DataD.Properties.VariableUnits{'Alt_O'} = 'Feet';
DataD.Properties.VariableUnits{'Alt_D'} = 'Feet';

%etime

NationalLogical = (strcmp(Airports{1,4}, 'United States') | strcmp(Airports{1,4}, 'Canada'));
NationalIATAName = cell(sum(NationalLogical),1);
NationalIATALat = zeros(sum(NationalLogical),1);
NationalIATALon = zeros(sum(NationalLogical),1);
NationalIATAAlt = zeros(sum(NationalLogical),1);

count = 1;
for i = 1:1:length(NationalLogical)
    if NationalLogical(i) == true
        NationalIATAName(count) = Airports{1,5}(i);
        NationalIATALat(count) = Airports{1,7}(i);
        NationalIATALon(count) = Airports{1,8}(i);
        NationalIATAAlt(count) = Airports{1,9}(i);
        count = count + 1;
    end
end

%--->Arrivals
for i = 1:1:length(FileArrivals{1,1})
    DataA.Number(i,1) = i;
    DataA.Airline(i) = FileArrivals{1,1}{i,1};
    DataA.FlightID(i) = FileArrivals{1,2}(i);
    ETA = string(FileArrivals{1,5}(i));
    ETA = strsplit(ETA,' ');
    ETA = strsplit(ETA(1),':');
    DataA.ETA(i,1) = ETA(1);
    DataA.ETA(i,2) = ETA(2);
    DataA.City_O(i) = FileArrivals{1,3}{i,1};
    DataA.IATA_O(i) = FileArrivals{1,4}{i,1};
    DataA.IATA_D(i) = "PHX";
    DataA.City_D(i) = "PHOENIX";
    DataA.Lat_D(i) = double(33.43429946899414);
    DataA.Lon_D(i) = double(-112.01200103759766);
    DataA.Alt_D(i) = int16(1135);
    
    if(strcmp('American Airlines',DataA.Airline(i))||strcmp('Delta Air Lines',DataA.Airline(i))||strcmp('United Airlines',DataA.Airline(i))||strcmp('Air Canada',DataA.Airline(i))||strcmp('British Airways',DataA.Airline(i)))
        DataA.CPAX(i) = randi([0 40],'int8');
    else
        DataA.CPAX(i) = randi([0 15],'int8');
    end
    
    for j = 1:1:length(NationalIATAName)
        if strcmp(DataA.IATA_O(i),NationalIATAName(j))
            DataA.Int(i) = false;
            DataA.Lat_O(i) = NationalIATALat(j);
            DataA.Lon_O(i) = NationalIATALon(j);
            DataA.Alt_O(i) = NationalIATAAlt(j);
            break;
        else
            DataA.Int(i) = true;
        end
    end
end
% DataA.ETA = FileArrivals{1,5};


for i=1:DataA.Number(end)
    if DataA.Int(i) == true
        for j = 1:1:length(Airports{1,5})
            if strcmp(DataA.IATA_O(i),Airports{1,5}(j))
                DataA.Lat_O(i) = Airports{1,7}(j);
                DataA.Lon_O(i) = Airports{1,8}(j);
                DataA.Alt_O(i) = Airports{1,9}(j);
            end
        end
    end
end

DataA.Distance(:) = deg2nm(distance(DataA.Lat_O(:),DataA.Lon_O(:),DataA.Lat_D(:), DataA.Lon_D(:)));

datetime.setDefaultFormats('default','HH:mm:ss')
Format = 'HH:mm:ss'; DataA.ETD(:) = datetime(2017,9,18,0,0,((hour(DataA.ETA(:))*60+minute(DataA.ETA(:))) - 60*DataA.Distance(:)/400)*60);
% DataA.ETD(:) = datetime(DataA.ETD(:),'InputFormat','HH:mm:ss');


%--->Departures
for i = 1:1:length(FileDepartures{1,1})
    DataD.Number(i,1) = i;
    DataD.Airline(i) = FileDepartures{1,1}{i,1};
    DataD.FlightID(i) = FileDepartures{1,2}(i);
    DataD.IATA_O(i) = "PHX";
    DataD.City_O(i) = "PHOENIX";
    DataD.Lat_O(i) = double(33.43429946899414);
    DataD.Lon_O(i) = double(-112.01200103759766);
    DataD.Alt_O(i) = int16(1135);
    DataD.City_D(i) = FileDepartures{1,3}{i,1};
    DataD.IATA_D(i) = FileDepartures{1,4}{i,1};

    if(strcmp('American Airlines',DataD.Airline(i))||strcmp('Delta Air Lines',DataD.Airline(i))||strcmp('United Airlines',DataD.Airline(i))||strcmp('Air Canada',DataD.Airline(i))||strcmp('British Airways',DataD.Airline(i)))
        DataD.CPAX(i) = randi([0 40],'int8');
    else
        DataD.CPAX(i) = randi([0 15],'int8');
    end
    
    for j = 1:1:length(NationalIATAName)
        if strcmp(DataD.IATA_D(i),NationalIATAName(j))
            DataD.Int(i) = false;
            DataD.Lat_D(i) = NationalIATALat(j);
            DataD.Lon_D(i) = NationalIATALon(j);
            DataD.Alt_D(i) = NationalIATAAlt(j);
            break;
        else
            DataD.Int(i) = true;
        end
    end
end
DataD.ETA = FileDepartures{1,5};

for i=1:DataD.Number(end)
    if DataD.Int(i) == true
        for j = 1:1:length(Airports{1,5})
            if strcmp(DataD.IATA_D(i),Airports{1,5}(j))
                DataD.Lat_D(i) = Airports{1,7}(j);
                DataD.Lon_D(i) = Airports{1,8}(j);
                DataD.Alt_D(i) = Airports{1,9}(j);
            end
        end
    end
end

DataD.Distance(:) = deg2nm(distance(DataD.Lat_D(:),DataD.Lon_D(:),DataD.Lat_O(:), DataD.Lon_O(:)));

toc; disp('Done!')
