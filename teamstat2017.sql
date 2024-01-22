CREATE TABLE totalAST17 AS
with cte_totalAST17 as (
SELECT  "TEAM_ID", SUM("AST_HOME" + "AST_AWAY") as "total_AST", sum ("REBHOME"+"REBAWAY") as "total_REB", sum(("AVG_FGPCTHOME" + "AVG_FGPCTAWAY")/2) as "total_AVGPCT"
FROM postgres.public.almostcomstat
group by "TEAM_ID" 
)
SELECT *
from cte_totalAST17

create table almost2ComStat17 as (
SELECT *
FROM postgres.public.almostcomstat left JOIN
     postgres.public.totalAST17 ON postgres.public.almostcomstat."TEAM_ID" = postgres.public.totalAST15."TEAM2_ID"
);

ALTER TABLE postgres.public.totalAST17
RENAME COLUMN "TEAM_ID" TO "TEAM2_ID";
