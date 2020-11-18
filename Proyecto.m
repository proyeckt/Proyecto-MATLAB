appdesigner;

%Prueba
%%row=data1(1,:)
%%lat=row.LATITUDMUNICIPIO
%%long=row.LONGITUDMUNICIPIO
%%geoplot(lat, long, 'g-*')
    
%Propiedades
%geolimits([45 62],[-149 -123])
%geoscatter(data1.LONGITUDMUNICIPIO, data1.LATITUDMUNICIPIO, '*')

%weights = data1.TOTALGENERAL;
%geodensityplot(data1.LONGITUDMUNICIPIO,data1.LATITUDMUNICIPIO,weights)

%tsunamis = readtable('tsunamis.xlsx');


%Leer Datos
dataELN=readtable('Datos ELN.xlsx');
dataFARC=readtable('Datos Disidencias FARC.xlsx');
dataPNIS=readtable('Datos PNIS.xlsx');%,'PreserveVariableNames',true
dataCultivos=readtable('Datos Cultivos Coca 2019.xlsx');
dataDefensores=readtable('Datos Defensores DDHH Asesinados 2019 - SIADDHH.xlsx');
dataMineria=readtable('Datos Minería Ilegal Oro.xlsx');
dataPDET=readtable('Datos PDET.xlsx');


%DATOS DESCRIPTIVOS

%ELN
figELN=figure;
geoscatter(dataELN.LATITUDMUNICIPIO,dataELN.LONGITUDMUNICIPIO,'*');

%PDET
figPDET=figure;
geoscatter(dataPNIS.LATITUDMUNICIPIO,dataPNIS.LONGITUDMUNICIPIO,'*');

%Minería Ilegal Oro
figMineria=figure;
geoscatter(dataMineria.LATITUDMUNICIPIO,dataMineria.LONGITUDMUNICIPIO,'*');


%DATOS NUMERICOS

%PNIS
figPNIS=figure;
dataPNIS.NOMBREDEPARTAMENTO=categorical(dataPNIS.NOMBREDEPARTAMENTO);
geobubble(dataPNIS,'LATITUDMUNICIPIO','LONGITUDMUNICIPIO','SizeVariable','TOTALGENERAL','ColorVariable','NOMBREDEPARTAMENTO');

%HOMICIDIOS 2017
figHomicidios2017=figure;
dataFARC.NOMBREDEPARTAMENTO=categorical(dataFARC.NOMBREDEPARTAMENTO);
geobubble(dataFARC,'LATITUDMUNICIPIO','LONGITUDMUNICIPIO','SizeVariable','x_HOMICIDIOS2017','ColorVariable','NOMBREDEPARTAMENTO');

%HOMICIDIOS 2018
figHomicidios2018=figure;
dataFARC.NOMBREDEPARTAMENTO=categorical(dataFARC.NOMBREDEPARTAMENTO);
geobubble(dataFARC,'LATITUDMUNICIPIO','LONGITUDMUNICIPIO','SizeVariable','x_HOMICIDIOS2018','ColorVariable','NOMBREDEPARTAMENTO');

%CULTIVO COCA
figCultivos=figure;
dataCultivos.NOMBREDEPARTAMENTO=categorical(dataCultivos.NOMBREDEPARTAMENTO);
geobubble(dataCultivos,'LATITUDMUNICIPIO','LONGITUDMUNICIPIO','SizeVariable','HECT_REASDECOCA','ColorVariable','NOMBREDEPARTAMENTO');


%for i=1:height(data1)
%    row=data1(i,:);
%    lat=row.LATITUDMUNICIPIO;
%    long=row.LONGITUDDEPARTAMENTO;
%    geoscatter(data1.LONGITUDMUNICIPIO, data1.LATITUDMUNICIPIO, '*')
%end

%data1.Properties.VariableNames
%data1.Properties.VariableNames = {'CodDepartamento','NombreDepartamento','CodMunicipio','NombreMunicipio'}


%Links
%%https://la.mathworks.com/help/matlab/ref/appdesigner.html
%%https://es.mathworks.com/help/matlab/matlab_prog/access-data-in-a-table.html
%%https://la.mathworks.com/help/matlab/creating_plots/plot-in-geographic-coordinates.html
%%https://la.mathworks.com/help/matlab/ref/geobubble.html
%%https://la.mathworks.com/help/matlab/ref/matlab.graphics.chart.geographicbubblechart-properties.html
%%https://la.mathworks.com/help/matlab/ref/geoaxes.html