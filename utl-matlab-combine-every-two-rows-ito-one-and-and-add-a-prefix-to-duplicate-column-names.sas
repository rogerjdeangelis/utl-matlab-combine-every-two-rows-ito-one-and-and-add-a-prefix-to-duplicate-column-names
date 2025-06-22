%let pgm=utl-matlab-combine-every-two-rows-ito-one-and-and-add-a-prefix-to-duplicate-column-names;

%stop_submission;

matlab combine every two rows ito one and and add a prefix to duplicate column name

github
https://tinyurl.com/59n8athe
https://github.com/rogerjdeangelis/utl-matlab-combine-every-two-rows-ito-one-and-and-add-a-prefix-to-duplicate-column-names

stackoverflow matlab
https://tinyurl.com/982vjmyc
https://stackoverflow.com/questions/79396087/trying-to-reshape-rearrange-table-variables-in-matlab

        SOLUTION ( suspect Art's transpose macro can do this with a one liner)

              1 sas transpose macro (one liner)
              2 sas sql
              3 sas sql arrays
              4 matab sql
                also works in r, python and excel
                see https://tinyurl.com/4e6yaap8
                most of run time is loading the packageg
              5 see stackoverflow for base octave solution

PROBLEM: sql self join on have where PFX='F!' for left table and pfx='F2' for righ table

          INPUT                      OUTPUT

     ID  PFX  A  B  C     ID F1_A F2_A F1_B F2_B F1_C F2_C

     12  F1   1  3  5     12   1    2    3    4    5    6
     12  F2   2  4  6


/**************************************************************************************************************************/
/*          INPUT                 |        PROCESS                             |       OUTPUT                             */
/*          =====                 |        =======                             |       ======                             */
/* SAS SD!.HAVE                   | 1 SAS TRANSPOSE MACRO (one liner)          | WORK.WANT                                */
/* ============                   | =================================          |                                          */
/*                                |                                            |                                          */
/* ID  PFX  A  B  C               | %utl_transpose(                            |     F1  F1  F1  F2  F2  F2               */
/*                                |       data=sd1.have                        | ID   A   B   C   A   B   C               */
/* 12  F1   1  3  5               |      ,out=want                             |                                          */
/* 12  F2   2  4  6               |      ,by=id                                | 12   1   3   5   2   4   6               */
/*                                |      ,id=pfx                               | 13   3   5   7   4   6   8               */
/*                                |      ,var_first=NO                         |                                          */
/* SQLITE TABLE MATLAB INPUT      |      ,delimiter=_                          |                                          */
/* =========================      |      ,var=a b c                            |                                          */
/*                                |      );                                    |                                          */
/* pragma_table_info('have')      |                                            |                                          */
/* contents                       |--------------------------------------------|------------------------------------------*/
/*              not               | 2 SAS SQL                                  |                                          */
/* id name type null dflt pk      | =========                                  | WORK.WANT (SAME OUTPUT DIFFERENT ORDER)  */
/*                                |                                            |                                          */
/*  0   ID REAL    0  NA  0       | proc sql;                                  |      F1  F2   F1  F2   F1  F2            */
/*  1  PFX TEXT    0  NA  0       |   create                                   | ID    A   A    B   B    C   C            */
/*  2    A REAL    0  NA  0       |      table want as                         |                                          */
/*  3    B REAL    0  NA  0       |   select                                   | 12    1   2    3   4    5   6            */
/*  4    C REAL    0  NA  0       |     f1.id                                  | 13    3   4    5   6    7   8            */
/*                                |     ,f1.a  as f1_a                         |                                          */
/* SQLITE TABLE                   |     ,f2.a  as f2_a                         |                                          */
/*                                |     ,f1.b  as f1_b                         |                                          */
/* ID PFX  A B C                  |     ,f2.b  as f2_b                         |                                          */
/*                                |     ,f1.c  as f1_c                         |                                          */
/* 12 F1   1 3 5                  |     ,f2.c  as f2_c                         |                                          */
/* 12 F2   2 4 6                  |   from                                     |                                          */
/* 13 F1   3 5 7                  |     sd1.have as f1, sd1.have as f2         |                                          */
/* 13 F2   4 6 8                  |   where                                    |                                          */
/*                                |     f1.pfx = 'F1' and                      |                                          */
/*                                |     f2.pfx = 'F2' and                      |                                          */
/*                                |     f1.id  = f2.id                         |                                          */
/* options                        | ;quit;                                     |                                          */
/*  validvarname=upcase;          |                                            |                                          */
/* libname sd1 "d:/sd1";          |--------------------------------------------|------------------------------------------*/
/* data sd1.have;                 | 3 SAS SQL ARRAYS                           | WORK.WANT                                */
/* input id pfx$ a b c;           | ================                           |                                          */
/* cards4;                        |                                            |      F1  F2   F1  F2   F1  F2            */
/* 12 F1 1 3 5                    | %array(_ltr,values=a b c);                 | ID    A   A    B   B    C   C            */
/* 12 F2 2 4 6                    |                                            |                                          */
/* 13 F1 3 5 7                    | proc sql;                                  | 12    1   2    3   4    5   6            */
/* 13 F2 4 6 8                    |   create                                   | 13    3   4    5   6    7   8            */
/* ;;;;                           |      table want as                         |                                          */
/* run;quit;                      |   select                                   |                                          */
/*                                |     f1.id                                  |                                          */
/*                                |     %do_over(_ltr,phrase=%str(             |                                          */
/*                                |     ,f1.?  as f1_?                         |                                          */
/* %utlfkil(d:/sqlite/have.db);   |     ,f2.?  as f2_?))                       |                                          */
/*                                |   from                                     |                                          */
/* %utl_rbeginx;                  |     sd1.have as f1, sd1.have as f2         |                                          */
/* parmcards4;                    |   where                                    |                                          */
/* library(haven)                 |     f1.pfx = 'F1' and                      |                                          */
/* library(DBI)                   |     f2.pfx = 'F2' and                      |                                          */
/* library(RSQLite)               |     f1.id  = f2.id                         |                                          */
/* have<-read_sas(                | ;quit;                                     |                                          */
/*  "d:/sd1/have.sas7bdat")       |                                            |                                          */
/* have                           |                                            |                                          */
/* con <- dbConnect(              |--------------------------------------------|------------------------------------------*/
/*     RSQLite::SQLite()          | 4 MATAB SQL                                | SQLITE WANT TABLE                        */
/*    ,"d:/sqlite/have.db")       | ===========                                |                  not                     */
/* dbWriteTable(                  |                                            | cid  name  type  null dflt pk            */
/*     con                        | %utl_mbegin;                               | ___  ____  ____  ____ ___  __            */
/*   ,"have"                      | parmcards4;                                |                                          */
/*   ,have)                       | pkg load database                          | 0    ID    REAL   0        0             */
/* dbListTables(con)              | pkg load sqlite                            | 1    f1_a  REAL   0        0             */
/* dbGetQuery(                    | pkg load io                                | 2    f2_a  REAL   0        0             */
/*    con                         | pkg load tablicious                        | 3    f1_b  REAL   0        0             */
/*  ,"SELECT                      | db = sqlite("d:/sqlite/have.db");          | 4    f2_b  REAL   0        0             */
/*      *                         | execute(db,'drop table if exists want')    | 5    f1_c  REAL   0        0             */
/*    FROM                        | execute(db                        ...      | 6    f2_c  REAL   0        0             */
/*      have")                    |  ,["  create                    " ...      |                                          */
/* dbGetQuery(con                 |    "     table want as          " ...      | SAS SD1.WANT                             */
/*  ,"SELECT                      |    "  select                    " ...      |                                          */
/*     *                          |    "    f1.id                   " ...      |      F1  F2   F1  F2   F1  F2            */
/*   FROM                         |    "    ,f1.a  as f1_a          " ...      | ID    A   A    B   B    C   C            */
/*    pragma_table_info('have')") |    "    ,f2.a  as f2_a          " ...      |                                          */
/* dbDisconnect(con)              |    "    ,f1.b  as f1_b          " ...      | 12    1   2    3   4    5   6            */
/* ;;;;                           |    "    ,f2.b  as f2_b          " ...      | 13    3   4    5   6    7   8            */
/* %utl_rendx;                    |    "    ,f1.c  as f1_c          " ...      |                                          */
/*                                |    "    ,f2.c  as f2_c          " ...      |                                          */
/* proc report nowd data=want;    |    "  from                      " ...      |                                          */
/* run;quit;                      |    "     have as f1, have as f2 " ...      |                                          */
/*                                |    "  on                        " ...      |                                          */
/*                                |    "    f1.pfx = 'F1' and       " ...      |                                          */
/*                                |    "    f2.pfx = 'F2' and       " ...      |                                          */
/*                                |    "    f1.id  = f2.id          " ...      |                                          */
/*                                |  ]);                                       |                                          */
/*                                | % check sqlite result                      |                                          */
/*                                | dic=fetch(db,"PRAGMA table_info('want');") |                                          */
/*                                | chk=fetch(db,"select * from want")         |                                          */
/*                                | close(db)                                  |                                          */
/*                                | ;;;;                                       |                                          */
/*                                | %utl_mend;                                 |                                          */
/*                                |                                            |                                          */
/*                                |                                            |                                          */
/*                                | BACK TO SAS                                |                                          */
/*                                |                                            |                                          */
/*                                | %utl_rbeginx;                              |                                          */
/*                                | parmcards4;                                |                                          */
/*                                | library(haven)                             |                                          */
/*                                | library(DBI)                               |                                          */
/*                                | library(RSQLite)                           |                                          */
/*                                | library(sqldf)                             |                                          */
/*                                |                                            |                                          */
/*                                | source("c:/oto/fn_tosas9x.R")              |                                          */
/*                                | con <- dbConnect(                          |                                          */
/*                                |     RSQLite::SQLite()                      |                                          */
/*                                |    ,"d:/sqlite/have.db")                   |                                          */
/*                                | dbListTables(con)                          |                                          */
/*                                | df <- dbReadTable(con, "want")             |                                          */
/*                                | df                                         |                                          */
/*                                | fn_tosas9x(                                |                                          */
/*                                |       inp    = df                          |                                          */
/*                                |      ,outlib ="d:/sd1/"                    |                                          */
/*                                |      ,outdsn ="want"                       |                                          */
/*                                |      )                                     |                                          */
/*                                | ;;;;                                       |                                          */
/*                                | %utl_rendx;                                |                                          */
/*                                |                                            |                                          */
/*                                | libname sd1 "d:/sd1";                      |                                          */
/*                                | proc print data=sd1.want;                  |                                          */
/*                                | run;quit;                                  |                                          */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

options
 validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
input id pfx$ a b c;
cards4;
12 F1 1 3 5
12 F2 2 4 6
13 F1 3 5 7
13 F2 4 6 8
;;;;
run;quit;


%utlfkil(d:/sqlite/have.db);

%utl_rbeginx;
parmcards4;
library(haven)
library(DBI)
library(RSQLite)
have<-read_sas(
 "d:/sd1/have.sas7bdat")
have
con <- dbConnect(
    RSQLite::SQLite()
   ,"d:/sqlite/have.db")
dbWriteTable(
    con
  ,"have"
  ,have)
dbListTables(con)
dbGetQuery(
   con
 ,"SELECT
     *
   FROM
     have")
dbGetQuery(con
 ,"SELECT
    *
  FROM
   pragma_table_info('have')")
dbDisconnect(con)
;;;;
%utl_rendx;

proc report nowd data=want;
run;quit;


/**************************************************************************************************************************/
/* SAS SD!.HAVE                                                                                                           */
/* ============                                                                                                           */
/*                                                                                                                        */
/* ID  PFX  A  B  C                                                                                                       */
/*                                                                                                                        */
/* 12  F1   1  3  5                                                                                                       */
/* 12  F2   2  4  6                                                                                                       */
/*                                                                                                                        */
/*                                                                                                                        */
/* FOR MATLAB                                                                                                             */
/* SQLITE TABLE MATLAB INPUT                                                                                              */
/* =========================                                                                                              */
/*                                                                                                                        */
/* pragma_table_info('have')                                                                                              */
/* contents                                                                                                               */
/*              not                                                                                                       */
/* id name type null dflt pk                                                                                              */
/*                                                                                                                        */
/*  0   ID REAL    0  NA  0                                                                                               */
/*  1  PFX TEXT    0  NA  0                                                                                               */
/*  2    A REAL    0  NA  0                                                                                               */
/*  3    B REAL    0  NA  0                                                                                               */
/*  4    C REAL    0  NA  0                                                                                               */
/*                                                                                                                        */
/* SQLITE TABLE                                                                                                           */
/*                                                                                                                        */
/* ID PFX  A B C                                                                                                          */
/*                                                                                                                        */
/* 12 F1   1 3 5                                                                                                          */
/* 12 F2   2 4 6                                                                                                          */
/* 13 F1   3 5 7                                                                                                          */
/* 13 F2   4 6 8                                                                                                          */
/**************************************************************************************************************************/

/*                   _
/ |  ___  __ _ ___  | |_ _ __ __ _ _ __  ___ _ __   ___  ___  ___  _ __ ___   __ _  ___ _ __ ___
| | / __|/ _` / __| | __| `__/ _` | `_ \/ __| `_ \ / _ \/ __|/ _ \| `_ ` _ \ / _` |/ __| `__/ _ \
| | \__ \ (_| \__ \ | |_| | | (_| | | | \__ \ |_) | (_) \__ \  __/| | | | | | (_| | (__| | | (_) |
|_| |___/\__,_|___/  \__|_|  \__,_|_| |_|___/ .__/ \___/|___/\___||_| |_| |_|\__,_|\___|_|  \___/

*/

%utl_transpose(
      data=sd1.have
     ,out=want
     ,by=id
     ,id=pfx
     ,var_first=NO
     ,delimiter=_
     ,var=a b c
     );

/**************************************************************************************************************************/
/* WORK.WANT total obs=2                                                                                                  */
/*                                                                                                                        */
/* ID    F1_A    F1_B    F1_C    F2_A    F2_B    F2_C                                                                     */
/*                                                                                                                        */
/* 12      1       3       5       2       4       6                                                                      */
/* 13      3       5       7       4       6       8                                                                      */
/**************************************************************************************************************************/

/*___                              _
|___ \   ___  __ _ ___   ___  __ _| |
  __) | / __|/ _` / __| / __|/ _` | |
 / __/  \__ \ (_| \__ \ \__ \ (_| | |
|_____| |___/\__,_|___/ |___/\__, |_|
                                |_|
*/

proc sql;
  create
     table want as
  select
    f1.id
    ,f1.a  as f1_a
    ,f2.a  as f2_a
    ,f1.b  as f1_b
    ,f2.b  as f2_b
    ,f1.c  as f1_c
    ,f2.c  as f2_c
  from
    sd1.have as f1, sd1.have as f2
  where
    f1.pfx = 'F1' and
    f2.pfx = 'F2' and
    f1.id  = f2.id
;quit;

/**************************************************************************************************************************/
/* WORK.WANT total obs=2                                                                                                  */
/*                                                                                                                        */
/*  ID    F1_A    F2_A    F1_B    F2_B    F1_C    F2_C                                                                    */
/*                                                                                                                        */
/*  12      1       2       3       4       5       6                                                                     */
/*  13      3       4       5       6       7       8                                                                     */
/**************************************************************************************************************************/

/*____                             _
|___ /   ___  __ _ ___   ___  __ _| |   __ _ _ __ _ __ __ _ _   _ ___
  |_ \  / __|/ _` / __| / __|/ _` | |  / _` | `__| `__/ _` | | | / __|
 ___) | \__ \ (_| \__ \ \__ \ (_| | | | (_| | |  | | | (_| | |_| \__ \
|____/  |___/\__,_|___/ |___/\__, |_|  \__,_|_|  |_|  \__,_|\__, |___/
                                |_|                         |___/
If you have more columns. for instance a-z you can use sql arrays
*/

/*--- this is in my autoexec so you don not need this assignment ----*/

%let letters=A B C D E F G H I J K L M N O P Q R S T U V W X Y Z;

%array(_ltr,values=&letters);

%put &=_ltrn;  /*--- _LTRN=26  array size                        ----*/

%put &=_ltr1;  /*--- _LTR1  = A                                  ----*/
%put &=_ltr26; /*--- _LTR26 = Z                                  ----*/

/*--- I am going to set _ltrn=3 because we only have 3columns    ----*/
%let _ltrn=3;

proc sql;
  create
     table want as
  select
    f1.id
    %do_over(_ltr,phrase=%str(
    ,f1.?  as f1_?
    ,f2.?  as f2_?))
  from
    sd1.have as f1, sd1.have as f2
  where
    f1.pfx = 'F1' and
    f2.pfx = 'F2' and
    f1.id  = f2.id
;quit;

/*--- if you want he generated code turn on mprint or do this    ----*/

data _null_;
   put "%do_over(_ltr,phrase=%str(
          ,f1.?  as f1_?
          ,f2.?  as f2_?))";
run;quit;

,f1.A as f1_A ,f2.A as f2_A ,f1.B as f1_B ,f2.B as f2_B ,f1.C as f1_C ,f2.C as f2_C

/**************************************************************************************************************************/
/* WORK.WANT total obs=2                                                                                                  */
/*                                                                                                                        */
/*  ID    F1_A    F2_A    F1_B    F2_B    F1_C    F2_C                                                                    */
/*                                                                                                                        */
/*  12      1       2       3       4       5       6                                                                     */
/*  13      3       4       5       6       7       8                                                                     */
/*                                                                                                                        */
/* IF you want rge code                                                                                                   */
/*                                                                                                                        */
/* data _null_;                                                                                                           */
/*    put "%do_over(_ltr,phrase=%str(                                                                                     */
/*           ,f1.?  as f1_?                                                                                               */
/*           ,f2.?  as f2_?))";                                                                                           */
/* run;quit;                                                                                                              */
/*                                                                                                                        */
/* ,f1.A as f1_A ,f2.A as f2_A ,f1.B as f1_B ,f2.B as f2_B ,f1.C as f1_C ,f2.C as f2_C                                    */
/**************************************************************************************************************************/

/*  _                     _   _       _                 _
| || |    _ __ ___   __ _| |_| | __ _| |__    ___  __ _| |
| || |_  | `_ ` _ \ / _` | __| |/ _` | `_ \  / __|/ _` | |
|__   _| | | | | | | (_| | |_| | (_| | |_) | \__ \ (_| | |
   |_|   |_| |_| |_|\__,_|\__|_|\__,_|_.__/  |___/\__, |_|
                                                     |_|
*/

%utl_mbegin;
parmcards4;
pkg load database
pkg load sqlite
pkg load io
pkg load tablicious
db = sqlite("d:/sqlite/have.db");
execute(db,'drop table if exists want')
execute(db                        ...
 ,["  create                    " ...
   "     table want as          " ...
   "  select                    " ...
   "    f1.id                   " ...
   "    ,f1.a  as f1_a          " ...
   "    ,f2.a  as f2_a          " ...
   "    ,f1.b  as f1_b          " ...
   "    ,f2.b  as f2_b          " ...
   "    ,f1.c  as f1_c          " ...
   "    ,f2.c  as f2_c          " ...
   "  from                      " ...
   "     have as f1, have as f2 " ...
   "  on                        " ...
   "    f1.pfx = 'F1' and       " ...
   "    f2.pfx = 'F2' and       " ...
   "    f1.id  = f2.id          " ...
 ]);
% check sqlite result
dic=fetch(db,"PRAGMA table_info('want');")
chk=fetch(db,"select * from want")
close(db)
;;;;
%utl_mend;


BACK TO SAS

%utl_rbeginx;
parmcards4;
library(haven)
library(DBI)
library(RSQLite)
library(sqldf)

source("c:/oto/fn_tosas9x.R")
con <- dbConnect(
    RSQLite::SQLite()
   ,"d:/sqlite/have.db")
dbListTables(con)
df <- dbReadTable(con, "want")
df
fn_tosas9x(
      inp    = df
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

libname sd1 "d:/sd1";
proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*  SQLITE WANT TABLE                                                                                                     */
/*                   not                                                                                                  */
/*  cid  name  type  null dflt pk                                                                                         */
/*  ___  ____  ____  ____ ___  __                                                                                         */
/*                                                                                                                        */
/*  0    ID    REAL   0        0                                                                                          */
/*  1    f1_a  REAL   0        0                                                                                          */
/*  2    f2_a  REAL   0        0                                                                                          */
/*  3    f1_b  REAL   0        0                                                                                          */
/*  4    f2_b  REAL   0        0                                                                                          */
/*  5    f1_c  REAL   0        0                                                                                          */
/*  6    f2_c  REAL   0        0                                                                                          */
/*                                                                                                                        */
/*  SAS SD1.WANT                                                                                                          */
/*                                                                                                                        */
/*       F1  F2   F1  F2   F1  F2                                                                                         */
/*  ID    A   A    B   B    C   C                                                                                         */
/*                                                                                                                        */
/*  12    1   2    3   4    5   6                                                                                         */
/*  13    3   4    5   6    7   8                                                                                         */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/

