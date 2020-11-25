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

format bank;
data=xlsread('data_municipios_som_norm2');
tam=size(data)
rows=tam(1)
cols=tam(2)

data_train=data(:,2:cols);
cods=data(:,1)

%Kmeans
k=4;
[idx,C] = kmeans(data_train,k);
%PCA
[standard_data, mu, sigma] = zscore(data_train);     % standardize data so that the mean is 0 and the variance is 1 for each variable
[coeff, score, ~]  = pca(standard_data);     % perform PCA
new_C = (C-mu)./sigma*coeff;     % apply the PCA transformation to the centroid data

%Validation
for(i=1:length(score))
    sumData(i,1)=sum(score(i,:));
end
sumData

suma1=0;
suma2=0;
suma3=0;
suma4=0;
n1=0;
n2=0;
n3=0;
n4=0;
for i=1:length(idx)
    if idx(i,1)==1
        suma1=suma1+sumData(i);
        n1=n1+1;
    elseif idx(i,1)==2
        suma2=suma2+sumData(i);
        n2=n2+1;
    elseif idx(i,1)==3
        suma3=suma3+sumData(i);
        n3=n3+1;
    elseif idx(i,1)==4
        suma4=suma4+sumData(i);
        n4=n4+1;
    end
end

sumClusters(1,1)=suma1;
sumClusters(2,1)=suma2;
sumClusters(3,1)=suma3;
sumClusters(4,1)=suma4;


n1
n2
n3
n4
sumClusters

sumClustersOrdered=sort(sumClusters);
cat=categorical(sumClusters,sumClustersOrdered,{'Bajo','Medio','Alto','Muy Alto'});
catSorted=sort(cat);
cat

%Plotting
gscatter(score(:,1), score(:,2),idx,'bryg','....',[15 15])     % plot 2 principal components of the cluster data (three clusters are shown in different colors)
hold on
plot(new_C(:, 1), new_C(:, 2),'kx','MarkerSize',8)     % plot 2 principal components of the centroid data
%plot(C(:,1),C(:,2),'kx') 
%legend('Cluster 1','Cluster 2','Centroids','Location','NW')
title 'Cluster Assignments and Centroids';
legend(char(cat(1)),char(cat(2)),char(cat(3)),char(cat(4)),'Cluster Centroid');
%legend(char(catSorted(1)),char(catSorted(2)),char(catSorted(3)),char(catSorted(4)),'Cluster Centroid');


%silhouette(data_train, idx);

figBar=figure;
bar(cat,[n1 n2 n3 n4])
title('Riesgo vs Municipio')
xlabel('Niveles de Riesgo')
ylabel('Número de Municipios')

%Create Excel
res=[cods,idx]
table=array2table(res,'VariableNames',{'cod_municipio','nivel_riesgo'});

filename='output_kmeans_norm2.xlsx';
writetable(table,filename)

%DETECT THE BEST K
n=5;
klist=2:n;%the number of clusters you want to try
myfunc = @(X,K)(kmeans(X, K));
eva = evalclusters(data_train,myfunc,'CalinskiHarabasz','klist',klist)
classes=kmeans(data_train,eva.OptimalK);

%Links
%%https://la.mathworks.com/help/matlab/ref/appdesigner.html
%%https://es.mathworks.com/help/matlab/matlab_prog/access-data-in-a-table.html
%%https://la.mathworks.com/help/matlab/creating_plots/plot-in-geographic-coordinates.html
%%https://la.mathworks.com/help/matlab/ref/geobubble.html
%%https://la.mathworks.com/help/matlab/ref/matlab.graphics.chart.geographicbubblechart-properties.html
%%https://la.mathworks.com/help/matlab/ref/geoaxes.html