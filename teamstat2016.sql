CREATE TABLE totalAST16 AS
with cte_totalAST15  as (
SELECT  "TEAM_ID", SUM("AST_HOME" + "AST_AWAY") as "total_AST", sum ("REBHOME"+"REBAWAY") as "total_REB", sum(("AVG_FGPCTHOME" + "AVG_FGPCTAWAY")/2) as "total_AVGPCT"
FROM postgres.public.almostcomstat
group by "TEAM_ID" 
)
SELECT *
from cte_totalAST16

create table almost2ComStat15 as (
SELECT *
FROM postgres.public.almostcomstat left JOIN
     postgres.public.totalAST16 ON postgres.public.almostcomstat."TEAM_ID" = postgres.public.totalAST15."TEAM2_ID"
);

ALTER TABLE postgres.public.totalAST16
RENAME COLUMN "TEAM_ID" TO "TEAM2_ID";
