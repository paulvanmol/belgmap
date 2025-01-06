%let path=/workshop/belgmap;
%let path=/srv/nfs/kubedata/compute-landingzone/home/sbxpav/belgmap; 

%let shapeversion=AdminVector_2025_WGS84_shp; 
%let version=%scan(&shapeversion,2,_);
%put &version;
%let maplib=mapscstm;
%let cashost=&_cashost_; 
%let casport=5570; 


/*Create a Global Caslib MAPSCSTM if you wish to store MAP datasets in a seperate caslib*/
/*cas mysession; */
/*caslib mapscstm clear; */
/*caslib mapscstm datasource=(srctype="path") path="&path/sasdata" 
sessref=mySession subdirs ;*/
/*caslib mapscstm datasource=(srctype="path") path="/srv/nfs/kubedata/cas-landingzone/sbxpav/belgmap/sasdata" 
sessref=mySession subdirs global;
libname mapscstm cas;*/
/*cas mysession terminate*/


cas mysession; 

proc casutil ; 
droptable casdata="beStatisticSector&version" incaslib='mapscstm' quiet;
droptable casdata="beStatisticSector&version" incaslib='casuser' quiet;
quit; 

cas mysession terminate ; 
 
%shpcntnt(shapefilepath=&path/&shapeversion/statisticalsector_4326.shp)

%shpimprt(shapefilepath=&path/&shapeversion/statisticalsector_4326.shp,
			ID=NISCODE,
			outtable=beStatisticSector&version,
			cashost=&cashost,
			casport=5570,
			caslib='casuser',
			reduce=1)
/*****************************************************************************/
/*  Create a default CAS session and create SAS librefs for existing caslibs */
/*  so that they are visible in the SAS Studio Libraries tree.               */
/*****************************************************************************/

cas mysession; 
caslib _all_ assign;


data mapscstm.beStatisticSector&version (promote=yes replace=yes);
length niscode $ 9; 
set casuser.beStatisticSector&version;
IDNAME=NISCODE;
 
drop 
	  modifdate tgid  ; 
run; 
/*
   Input filename: /srv/nfs/kubedata/compute-landingzone/home/sbxpav/belgmap/AdminVector_2025_WGS84_shp/statisticalsector_4326.shp
   List of Fields and Attributes
   # Field        Type Width Decimals
   1 tgid         CHAR    38     0
   2 modifdate    NUM      8     0
   3 niscode      CHAR   254     0
Number of Fields:      3
Number of Records:     20460
*/
cas mysession terminate;
cas mysession; 

proc casutil ; 
droptable casdata="bemunicipalsection&version" incaslib='mapscstm' quiet;
droptable casdata="bemunicipalsection&version" incaslib='casuser' quiet;
quit; 

cas mysession terminate ; 
 
%shpcntnt(shapefilepath=&path/&shapeversion/municipalsection_4326.shp)

%shpimprt(shapefilepath=&path/&shapeversion/municipalsection_4326.shp,
			ID=PSEUDONIS,
			outtable=bemunicipalsection&version,
			cashost=&cashost,
			casport=5570,
			caslib='casuser',
			reduce=1)
/*****************************************************************************/
/*  Create a default CAS session and create SAS librefs for existing caslibs */
/*  so that they are visible in the SAS Studio Libraries tree.               */
/*****************************************************************************/

cas mysession; 
caslib _all_ assign;

data mapscstm.bemunicipalsection&version (promote=yes replace=yes);
length niscode $ 9; 
set casuser.bemunicipalsection&version (rename=(pseudonis=niscode));
IDNAME=NISCODE;
drop
	  modifdate  legal tgid ; 
run; 
/*
   Input filename: /srv/nfs/kubedata/compute-landingzone/home/sbxpav/belgmap/AdminVector_2025_WGS84_shp/municipalsection_4326.shp
   List of Fields and Attributes
   # Field        Type Width Decimals
   1 tgid         CHAR    38     0
   2 pseudonis    CHAR    80     0
   3 zipcode      CHAR    80     0
   4 niscode_mu   CHAR   254     0
   5 modifdate    NUM      8     0
   6 legal        NUM      9     0
   7 nameger      CHAR    80     0
   8 namefre      CHAR    80     0
   9 namedut      CHAR    80     0
Number of Fields:      9
Number of Records:     2664
*/
cas mysession terminate;



/*****************************************************************************/
/*  Start a session named mySession using the existing CAS server connection */
/*  while allowing override of caslib, timeout (in seconds), and locale     */
/*  defaults.                                                                */
/*****************************************************************************/

cas mySession sessopts=(caslib=casuser timeout=1800 locale="en_US");

/*****************************************************************************/
/*  Create a CAS library (myCaslib) for the specified path ("/filePath/")    */ 
/*  and session (mySession).  If "sessref=" is omitted, the caslib is        */ 
/*  created and activated for the current session.  Setting subdirs extends  */
/*  the scope of myCaslib to subdirectories of "/filePath".                  */
/*****************************************************************************/

*caslib mapscstm datasource=(srctype="path") path="&path/sasdata" sessref=mySession subdirs;

proc casutil ; 
droptable casdata="bemunicipality&version" incaslib='mapscstm' quiet;
droptable casdata="bemunicipality&version" incaslib='casuser' quiet;
quit; 

cas mysession terminate ; 
 
%shpcntnt(shapefilepath=&path/&shapeversion/municipality_4326.shp)
/*   Input filename: /srv/nfs/kubedata/compute-landingzone/home/sbxpav/belgmap/AdminVector_2025_WGS84_shp/municipality_4326.shp
   List of Fields and Attributes
   # Field        Type Width Decimals
   1 tgid         CHAR    38     0
   2 modifdate    NUM      8     0
   3 arrondisse   NUM      1     0
   4 provinceca   NUM      1     0
   5 regioncapi   NUM      1     0
   6 countrycap   NUM      1     0
   7 niscode      CHAR   254     0
   8 city         NUM      9     0
   9 languagest   NUM      9     0
  10 nameger      CHAR    80     0
  11 namefre      CHAR    80     0
  12 namedut      CHAR    80     0
Number of Fields:      12
Number of Records:     565
*/

%shpimprt(shapefilepath=&path/&shapeversion/municipality_4326.shp,
			ID=NISCODE,
			outtable=bemunicipality&version,
			cashost=&cashost,
			casport=5570,
			caslib='casuser',
			reduce=1)

cas mysession; 
caslib _all_ assign;

data mapscstm.bemunicipality&version (promote=yes replace=yes) ;
length niscode $ 9 ; 
set casuser.bemunicipality&version;
if languagest=1 then IDNAME=NAMEDUT; 
else if languagest=2 then IDNAME=NAMEFRE;
else if languagest=4 then IDNAME=catx('/',NAMEFRE,NAMEDUT);
else if languagest=5 then IDNAME=catx('/',NAMEFRE,NAMEDUT);
else if languagest=6 then IDNAME=catx('/',NAMEFRE,NAMEDUT);
else if languagest=7 then IDNAME=catx('/',NAMEFRE,NAMEGER);
else if languagest=8 then IDNAME=catx('/',NAMEFRE,NAMEGER);
drop nameger namedut namefre tgid
	regioncapi provinceca languagest 
	modifdate arrondisse countrycap city ; 
run; 

cas mysession terminate;


cas mysession; 

proc casutil ; 
droptable casdata="bedistrict&version" incaslib='mapscstm' quiet;
droptable casdata="bedistrict&version" incaslib='casuser' quiet;
quit; 

cas mysession terminate ; 
 
%shpcntnt(shapefilepath=&path/&shapeversion/arrondissement_4326.shp)

%shpimprt(shapefilepath=&path/&shapeversion/arrondissement_4326.shp,
			ID=NISCODE,
			outtable=bedistrict&version,
			cashost=&cashost,
			casport=5570,
			caslib='casuser',
			reduce=1)
/*****************************************************************************/
/*  Create a default CAS session and create SAS librefs for existing caslibs */
/*  so that they are visible in the SAS Studio Libraries tree.               */
/*****************************************************************************/

cas mysession; 
caslib _all_ assign;

data mapscstm.bedistrict&version (promote=yes replace=yes);
length niscode $ 9; 
set casuser.bedistrict&version;
IF substr(left(niscode),1,1) in ('7','4','3','1') THEN DO;
  	IF namedut ne ' ' THEN IDNAME=namedut; 
  END; 
  ELSE IF substr(left(niscode),1,1) in ('9','8','6','5') THEN DO; 
  	IF namefre ne ' ' THEN IDNAME=namefre;
  	ELSE IF nameger ne ' ' THEN IDNAME=nameger;
  END;
  ELSE IF substr(left(niscode),1,1) = '2' THEN DO;
    code = substr(left(niscode),1,2);
  	IF code in ('24', '23') THEN IDNAME = namedut;
	ELSE IF code = '25' THEN IDNAME = namefre;
	ELSE IF code = '21' THEN IDNAME = catx('/',namefre,namedut);
  END;
drop nameger namedut namefre
	  modifdate  code tgid; 
run; 

cas mysession terminate;
/*     Input filename: /srv/nfs/kubedata/compute-landingzone/home/sbxpav/belgmap/AdminVector_2025_WGS84_shp/arrondissement_4326.shp
   List of Fields and Attributes
   # Field        Type Width Decimals
   1 tgid         CHAR    38     0
   2 modifdate    NUM      8     0
   3 niscode      CHAR   254     0
   4 nameger      CHAR    80     0
   5 namefre      CHAR    80     0
   6 namedut      CHAR    80     0
Number of Fields:      6
Number of Records:     43
*/

cas mysession; 
caslib _all_ assign;
proc casutil ; 
droptable casdata="beprovince&version" incaslib='mapscstm' quiet;
droptable casdata="beprovince&version" incaslib='casuser' quiet;
quit; 

cas mysession terminate ; 
 
%shpcntnt(shapefilepath=&path/&shapeversion/province_4326.shp)

%shpimprt(shapefilepath=&path/&shapeversion/province_4326.shp,
			ID=NISCODE,
			outtable=beprovince&version,
			cashost=&cashost,
			casport=5570,
			caslib='casuser',
			reduce=1)

cas mysession; 
caslib _all_ assign;

data mapscstm.beprovince&version (replace=yes promote=yes) ;
length niscode $ 9; 
set casuser.beprovince&version;
IF substr(left(niscode),1,1) in ('7','4','3','1') THEN DO;
  	IF namedut ne ' ' THEN IDNAME=namedut; 
  END; 
  ELSE IF substr(left(niscode),1,1) in ('9','8','6','5') THEN DO; 
  	IF namefre ne ' ' THEN IDNAME=namefre;
  	ELSE IF nameger ne ' ' THEN IDNAME=nameger;
  END;
  ELSE IF substr(left(niscode),1,1) = '2' THEN DO;
    IF substr(left(niscode),1,2) in ('24', '23') THEN IDNAME = namedut;
	ELSE IF substr(left(niscode),1,2) = '25' THEN IDNAME = namefre;
	ELSE IF substr(left(niscode),1,2) = '21' THEN IDNAME = catx('/',namefre,namedut);
  END;
drop nameger namedut namefre
	modifdate Fictitious tgid ; 
run; 
/*   Input filename: /srv/nfs/kubedata/compute-landingzone/home/sbxpav/belgmap/AdminVector_2025_WGS84_shp/province_4326.shp
   List of Fields and Attributes
   # Field        Type Width Decimals
   1 tgid         CHAR    38     0
   2 modifdate    NUM      8     0
   3 niscode      CHAR   254     0
   4 fictitious   NUM      9     0
   5 nameger      CHAR    80     0
   6 namefre      CHAR    80     0
   7 namedut      CHAR    80     0
Number of Fields:      7
Number of Records:     11
*/
cas mysession terminate;

cas mysession; 
caslib _all_ assign;
proc casutil ; 
droptable casdata="beregion&version" incaslib='mapscstm' quiet;
droptable casdata="beregion&version" incaslib='casuser' quiet;
quit; 

cas mysession terminate ; 
 
%shpcntnt(shapefilepath=&path/&shapeversion/region_4326.shp)

%shpimprt(shapefilepath=&path/&shapeversion/region_4326.shp,
			ID=NISCODE,
			outtable=beregion&version,
			cashost=&cashost,
			casport=5570,
			caslib='casuser',
			reduce=1)

cas mysession; 
caslib _all_ assign;

data mapscstm.beregion&version (replace=yes promote=yes) ;
length niscode $ 9 ; 
set casuser.beregion&version;
IF substr(left(niscode),1,2) in ('02') THEN DO;
  	IF namedut ne ' ' THEN IDNAME=namedut; 
  END; 
  ELSE IF substr(left(niscode),1,3) in ('03') THEN DO; 
  	IF namefre ne ' ' THEN IDNAME=namefre;
  END;
  ELSE IF substr(left(niscode),1,2) = '01' THEN DO;
     NISCODE='04000';
     IDNAME = catx('/',namefre,namedut);
  END;
drop nameger namedut namefre
	modifdate tgid ; 
run; 
/*   Input filename: /srv/nfs/kubedata/compute-landingzone/home/sbxpav/belgmap/AdminVector_2025_WGS84_shp/region_4326.shp
   List of Fields and Attributes
   # Field        Type Width Decimals
   1 tgid         CHAR    38     0
   2 modifdate    NUM      8     0
   3 niscode      CHAR   254     0
   4 nameger      CHAR    80     0
   5 namefre      CHAR    80     0
   6 namedut      CHAR    80     0
Number of Fields:      6
Number of Records:     3
*/
cas mysession terminate;

/* Creates a permanent copy of an in-memory table ("sourceTableName") from "sourceCaslib". */
/* The in-memory table is saved to the data source that is associated with the target      */
/* caslib ("targetCaslib") using the specified name ("targetTableName").                   */
/*                                                                                         */
/* To find out the caslib associated with an CAS engine libref, right click on the libref  */
/* from "Libraries" and select "Properties". Then look for the entry named "Server Session */
/* CASLIB".                                                                                */
cas mysession; 

proc casutil;
 save casdata="bestatisticsector&version" incaslib="MAPSCSTM" outcaslib="MAPSCSTM" replace;
 save casdata="bemunicipalsection&version" incaslib="MAPSCSTM" outcaslib="MAPSCSTM" replace;
 save casdata="bemunicipality&version" incaslib="MAPSCSTM" outcaslib="MAPSCSTM" replace;
 save casdata="bedistrict&version" incaslib="MAPSCSTM" outcaslib="MAPSCSTM" replace;
 save casdata="beprovince&version" incaslib="MAPSCSTM" outcaslib="MAPSCSTM" replace;
 save casdata="beregion&version" incaslib="MAPSCSTM" outcaslib="MAPSCSTM" replace;
quit;
/*
proc casutil;
 save casdata="bestatisticsector&version" incaslib="MAPSCSTM" outcaslib="PUBLIC" replace;
 save casdata="bemunicipalsection&version" incaslib="MAPSCSTM" outcaslib="PUBLIC" replace;
 save casdata="bemunicipality&version" incaslib="MAPSCSTM" outcaslib="PUBLIC" replace;
 save casdata="bedistrict&version" incaslib="MAPSCSTM" outcaslib="PUBLIC" replace;
 save casdata="beprovince&version" incaslib="MAPSCSTM" outcaslib="PUBLIC" replace;
 save casdata="beregion&version" incaslib="MAPSCSTM" outcaslib="PUBLIC" replace;
quit;*/
cas mysession terminate;