%let path=/srv/nfs/kubedata/compute-landingzone/home/sbxpav/belgmap; 
/*%let shapeversion=AdminVector_2015_WGS84_shp;*/
%let shapeversion=AdminVector_2025_WGS84_shp; 
/*Using X command to unzip shapefiles*/
x "mkdir -p &path/&shapeversion"; 
x "unzip &path/&shapeversion..zip -d &path/&shapeversion";

