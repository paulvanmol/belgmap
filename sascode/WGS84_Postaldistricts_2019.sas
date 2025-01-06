
/*%let path=/workshop/belgmap;*/
%let path=/srv/nfs/kubedata/compute-landingzone/home/sbxpav/belgmap; 

/*%let shapeversion=AdminVector_2015_WGS84_shp;*/
%let shapeversion=postaldistricts;
%let cashost=&_cashost_; 
%let casport=5570; 
%let maplib=public;

cas mysession; 
/*****************************************************************************/
/*  Create a CAS library (myCaslib) for the specified path ("/filePath/")    */ 
/*  and session (mySession).  If "sessref=" is omitted, the caslib is        */ 
/*  created and activated for the current session.  Setting subdirs extends  */
/*  the scope of myCaslib to subdirectories of "/filePath".                  */
/*****************************************************************************/
/*caslib mapscstm clear; 
caslib mapscstm datasource=(srctype="path") path="&path/sasdata" 
sessref=mySession subdirs ;
libname mapscstm cas;*/




proc casutil ; 
droptable casdata="postaldistricts" incaslib="&maplib" quiet;
droptable casdata="postaldistricts" incaslib='casuser' quiet;
quit; 

cas mysession terminate ; 
 
%shpcntnt(shapefilepath=&path/&shapeversion/postaldistricts.shp)


%shpimprt(shapefilepath=&path/&shapeversion/postaldistricts.shp,
			ID=nouveau_PO,
			outtable=postaldistricts,
			cashost=&cashost,
			casport=&casport,
			caslib='casuser',
			reduce=1)
/*****************************************************************************/
/*  Create a default CAS session and create SAS librefs for existing caslibs */
/*  so that they are visible in the SAS Studio Libraries tree.               */
/*****************************************************************************/

cas mysession; 
caslib _all_ assign;

data &maplib..postaldistricts (promote=yes replace=yes);
length postalcode $ 10; 
set casuser.postaldistricts;
postalcode=nouveau_PO; 
 
drop 
	 nouveau_PO  shape_Area shape_leng join_count ; 
run; 

cas mysession terminate;
/* Creates a permanent copy of an in-memory table ("sourceTableName") from "sourceCaslib". */
/* The in-memory table is saved to the data source that is associated with the target      */
/* caslib ("targetCaslib") using the specified name ("targetTableName").                   */
/*                                                                                         */
/* To find out the caslib associated with an CAS engine libref, right click on the libref  */
/* from "Libraries" and select "Properties". Then look for the entry named "Server Session */
/* CASLIB".                                                                                */
cas mysession; 
caslib _all_ assign;
libname sasdata "&path/sasdata"; 
proc casutil;
 save casdata="postaldistricts" incaslib="&maplib" outcaslib="&maplib" replace;
quit;

proc copy inlib=&maplib outlib=sasdata; 
select postaldistricts; 
run; 

cas mysession terminate;