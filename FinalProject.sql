--create each of the tables with varchar values
create table games(
"GAME_DATE_EST" varchar 
,"GAME_ID" varchar --key
,"GAME_STATUS_TEXT" varchar
,"HOME_TEAM_ID" varchar
,"VISITOR_TEAM_ID" varchar
,"SEASON" varchar
,"TEAM_ID_home" varchar --dupicate of HOME_TEAM_ID 
,"PTS_home" varchar
,"FG_PCT_home" varchar
,"FT_PCT_home" varchar
,"FG3_PCT_home" varchar
,"AST_home" varchar
,"REB_home" varchar
,"TEAM_ID_away" varchar --ID of away team, duplicate of VISITOR_TEAM_ID
,"PTS_away" varchar
,"FG_PCT_away" varchar
,"FT_PCT_away" varchar
,"FG3_PCT_away" varchar
,"AST_away" varchar
,"REB_away" varchar
,"HOME_TEAM_WIN" varchar
);
--all columns in this table were labeled incorrectly in kaggle
 create table games_details(
 "GAME_ID" varchar --key
 ,"TEAM_ID" varchar --key
 ,"TEAM_ABBREVIATION" varchar
 ,"TEAM_CITY" varchar
 ,"PLAYER_ID" varchar --key
 ,"PLAYER_NAME" varchar
 ,"NICKNAME" varchar
 ,"START_POSITION" varchar
 ,"COMMENTS" varchar
 ,"MIN" varchar
 ,"FGM" varchar --field goals made
 ,"FGA" varchar --field goal attempted
 ,"FG_PCT" varchar --field goal percentage
 ,"FG3M" varchar --three pointers made
 ,"FG3A" varchar --three point attempted
 ,"FG3_PCT" varchar --three pointer percentage
 ,"FTM" varchar --free throws made
 ,"FTA" varchar --free throw attempted
 ,"FT_PCT" varchar --free throw percentage
 ,"OREB" varchar --offensive rebounds
 ,"DREB" varchar --defensive rebounds
 ,"REB" varchar --total rebounds
 ,"AST" varchar --assists
 ,"STL" varchar --steals
 ,"BLK" varchar --blocks
 ,"TO" varchar --turnovers
 ,"PF" varchar -- personal fouls
 ,"PTS" varchar--Pts
 ,"PLUS_MINUS" varchar); --plus-minus

 create table players(
 "PLAYER_NAME" varchar
 ,"TEAM_ID" varchar
 ,"PLAYER_ID" varchar
 ,"SEASON" varchar
 );

 create table ranking(
 "TEAM_ID" varchar
 ,"LEAGUE_ID" varchar
 ,"SEASON_ID" varchar
 ,"STANDINGSDATE" varchar
 ,"CONFERENCE" varchar
 ,"TEAM" varchar
 ,"G" varchar --number of games played on the season
 ,"W" varchar --# winning games
 ,"L" varchar -- # losing games
 ,"W_PCT" varchar
 ,"HOME_RECORD" varchar
 ,"ROAD_RECORD" varchar
 ,"RETURNTOPLAY" varchar
 );

 create table teams(
 "LEAGUE_ID" varchar
 ,"TEAM_ID" varchar
 ,"MIN_YEAR" varchar
 ,"MAX_YEAR" varchar
 ,"ABBREVIATION" varchar
 ,"NICKNAME" varchar
 ,"YEARFOUNDED" varchar
 ,"CITY" varchar
 ,"ARENA" varchar
 ,"ARENACAPACITY" varchar
 ,"OWNER" varchar
 ,"GENERALMANAGER" varchar
 ,"HEADCOACH" varchar
 ,"DLEAGUEAFFILIATION" varchar
 );

--COPY COMMAND to import data
  copy  postgres.public.ranking from 'C:\sampledb\NBA\ranking.csv' DELIMITER ',' CSV HEADER;
  copy  postgres.public.teams from 'C:\sampledb\NBA\teams.csv' DELIMITER ',' CSV HEADER;
  copy  postgres.public.players from 'C:\sampledb\NBA\players.csv' DELIMITER ',' CSV HEADER;
  copy  postgres.public.games_details from 'C:\sampledb\NBA\games_details.csv' DELIMITER ',' CSV HEADER;
  copy  postgres.public.games from 'C:\sampledb\NBA\games.csv' DELIMITER ',' CSV HEADER;
 
 
--count the total number of rows and entries in each column, just to make sure we have all of the data imported
 select count (*) from postgres.public.games --25,796
 select count (*) from postgres.public.games_details --645,953
 select count(*) from postgres.public.players --7,228
 select count (*) from postgres.public.ranking --201,792
 select count (*) from postgres.public.teams --30


--counts entries in each column
 with cte_games as (
  select "GAME_DATE_EST", "GAME_ID", "GAME_STATUS_TEXT", "HOME_TEAM_ID", "VISITOR_TEAM_ID", "SEASON", 
  "TEAM_ID_home", "PTS_home", "FG_PCT_home", "FT_PCT_home", "FG3_PCT_home", "AST_home", "REB_home", 
  "TEAM_ID_away", "PTS_away", "FG_PCT_away", "FT_PCT_away", "FG3_PCT_away", "AST_away", "REB_away", "HOME_TEAM_WIN", "home_team_wins"                                              
  from "games"
  ) select count("GAME_DATE_EST") as cnt_GAME_DATE_EST,
  count("GAME_ID") as cnt_GAME_ID,
  count("GAME_STATUS_TEXT") as cnt_GAME_STATUS_TEXT,
  count("HOME_TEAM_ID") as cnt_HOME_TEAM_ID,
  count("VISITOR_TEAM_ID") as cnt_VISITOR_TEAM_ID,
  count("SEASON") as SEASON,
  count("TEAM_ID_home") as cnt_TEAM_ID_home,
  count("PTS_home") as cnt_PTS_home,
  count("FG_PCT_home") as cnt_FG_PCT_home,
  count("FT_PCT_home") as cnt_FT_PCT_home,
  count("FG3_PCT_home") as cnt_FG3_PCT_home,
  count("AST_home") as cnt_AST_home,
  count("REB_home") as cnt_REB_home,
  count("TEAM_ID_away") as cnt_TEAM_ID_away,
  count("PTS_away") as cnt_PTS_away,
  count("FG_PCT_away") as cnt_FG_PCT_away,
  count("FT_PCT_away") as cnt_FT_PCT_away,
  count("FG3_PCT_away") as cnt_FG3_PCT_away,
  count("AST_away") as cnt_AST_away,
  count("REB_away") as cnt_REB_away,
  count("HOME_TEAM_WIN") as cnt_HOME_TEAM_WIN,
  count("home_team_wins") as cnt_home_team_wins
  from cte_games


--create views for each of the tables with appropriate data types, then recreate tables from the views. In each view, we only included the columns we 
--want to use for our analysis

  create view postgres.public.games_v
  as
  select
  cast("GAME_DATE_EST" as date) as "GAME_DATE_EST"
  ,cast("GAME_ID" as integer) as "GAME_ID" --Primary key
  ,cast("HOME_TEAM_ID" as integer) as "HOME_TEAM_ID" --can maybe map to team_id in games_details table"
  ,cast("VISITOR_TEAM_ID" as integer) as "VISITOR_TEAM_ID"
  ,cast("SEASON" as integer) as "SEASON"
  ,cast("PTS_home" as float) as "PTS_home"
  ,cast("FG_PCT_home" as float) as "FG_PCT_home"
  ,cast("AST_home" as float) as "AST_home"
  ,cast("REB_home" as float) as "REB_home"
  ,cast("PTS_away" as float) as "PTS_away"
  ,cast("FG_PCT_away" as float) as "FG_PCT_away"
  ,cast("AST_away" as float) as "AST_away"
  ,cast("REB_away" as float) as "REB_away"
  ,cast("HOME_TEAM_WIN" as boolean) as "HOME_TEAM_WIN"
  from postgres.public.games
 
 create table postgres.public.xf_games
 as
 select * from postgres.public.games_v;

 create view postgres.public.games_details_v
 as
 select
 cast("TEAM_ID" as integer) as "TEAM_ID"
 ,cast("PLAYER_ID" as integer) as "PLAYER_ID"
 ,"PLAYER_NAME"
 ,cast("FG_PCT" as float) as "FG_PCT"
 from postgres.public.games_details
 
 create table postgres.public.xf_games_details
 as
 select * from postgres.public.games_details_v;


 create view postgres.public.players_v
 as
 select
 "PLAYER_NAME" 
 ,cast("TEAM_ID" as integer) as "TEAM_ID" --foreign key
 ,cast("PLAYER_ID" as integer) as"PLAYER_ID"
 ,cast("SEASON" as integer) as "SEASON"
 from postgres.public.players

 create table postgres.public.xf_players
 as
 select * from postgres.public.players_v;
 
create view postgres.public.ranking_v 
as
select
cast("TEAM_ID" as integer) as "TEAM_ID"
,cast("SEASON_ID" as integer) as "SEASON_ID"
,cast("W_PCT" as decimal) as "W_PCT"
from postgres.public.ranking

create table postgres.public.xf_ranking
as
select * from postgres.public.ranking_v;

create view postgres.public.teams_v
as
select
,cast("TEAM_ID" as integer) as "TEAM_ID" --primary Key
,"ABBREVIATION"
,"NICKNAME"
from postgres.public.teams

create table postgres.public.xf_teams
as
select * from postgres.public.teams_v;



--below are the counts for each original table, as well as some counts of unique values for certain columns
 select count(*) from postgres.public.games --25,796
 select count(*) from postgres.public.players --7,228
 select count(*) from postgres.public.games_details --645,953
 select count(*) from postgres.public.ranking --201,822
 select count(*) from postgres.public.teams --30
 
 --it is clear that the "TEAM_ID" column can be used as the link between the tables. We just need to check if it is unique and establish PK and FK relationships.

 select count(distinct "TEAM_ID") from postgres.public.games_details --30 --does not qualify as PK as total row# =/ 30
 select count(distinct "HOME_TEAM_ID") from postgres.public.games --30 --does not qualify as PK as total row# =/ 30
 select count(distinct "VISITOR_TEAM_ID") from postgres.public.games --30 --does not qualify as PK as total row# =/ 30
 select count(distinct "TEAM_ID") from  postgres.public.xf_teams --30 - Primary Key



--Primary Key
 ALTER TABLE postgres.public.xf_teams ADD PRIMARY KEY ("TEAM_ID");
 ALTER TABLE postgres.public.xf_games ADD PRIMARY KEY ("GAME_ID"); --Dataset has duplicated row

 select * from postgres.public.xf_games
 where "GAME_ID" = 22000038;

--Deleted one of the duplicated rows
 DELETE FROM postgres.public.xf_games 
 WHERE "GAME_ID" IN 
 (SELECT "GAME_ID"
 FROM (SELECT "GAME_ID",
       ROW_NUMBER() OVER (partition BY 22000038 ORDER BY "GAME_ID") AS RowNumber
      FROM postgres.public.xf_games ) AS T
 WHERE T.RowNumber > 1);


--FOREIGN KEY relationship
ALTER TABLE postgres.public.xf_players
ADD FOREIGN KEY ("TEAM_ID") REFERENCES postgres.public.xf_teams("TEAM_ID")

ALTER TABLE postgres.public.xf_games_details
ADD FOREIGN KEY ("GAME_ID") REFERENCES postgres.public.xf_games("GAME_ID"),
ADD FOREIGN KEY ("TEAM_ID") REFERENCES postgres.public.xf_teams("TEAM_ID"),
ADD FOREIGN KEY ("PLAYER_ID") REFERENCES postgres.public.xf_players("PLAYER_ID"); --need to fix players table first 
 

--our question is which of AST, REB, and FG_PCT have greatest affect on winning pct of a team.
--we chose a subset of 5 seasons for our dataset and create one table for each season
--each table consists of a column for the team_id, the sum of assists for that season, sum of rebounds per season, and avg fg_pct for that season.
--below we have done this for the 2015 season. We began by pulling info from the games table.
select "HOME_TEAM_ID",sum ("AST_home") as "ASTHOME" , sum ("REB_home") as "REBHOME", avg ("FG_PCT_home") as "AVG_FGPCTHOME"
from postgres.public.xf_games xg 
where "SEASON" = 2015
group by "HOME_TEAM_ID"
order by "HOME_TEAM_ID";

--the games table team_id's were split into home team and visiting team.
--so we created one cte with all necessary home_team stats grouped by home_team id and another cte with all visitor_team stats grouped by visitor team ID. all from the 2015 season.
--we used the cast statement to cast both "Home_team id" and visitor_team ID as team_ID, and then used that common column to join the two CTE's into one
--this join provided us with all of the stats for a given team whether the team was the home team or the visitor team
--i.e. we had the rows indexed by team id, and each row contained the sum of reb_home for that team and sum of reb_away for that team and same for ast and fg_pct.


with cte_hometeamstats as (
select "HOME_TEAM_ID" as "TEAM_ID",sum ("AST_home") as "AST_HOME" , sum ("REB_home") as "REBHOME", avg ("FG_PCT_home") as "AVG_FGPCTHOME"
from postgres.public.xf_games xg 
where "SEASON" = 2015
group by "HOME_TEAM_ID"
order by "HOME_TEAM_ID"
),
cte_visitorteamstats as ( 
select "VISITOR_TEAM_ID" as "VTEAM_ID", sum ("AST_away") as "AST_AWAY" , sum ("REB_away") as "REBAWAY", avg ("FG_PCT_away") as "AVG_FGPCTAWAY"
from postgres.public.xf_games xg 
where "SEASON" = 2015
group by "VISITOR_TEAM_ID"
order by "VISITOR_TEAM_ID"
)
SELECT *
FROM cte_hometeamstats inner JOIN
     cte_visitorteamstats ON cte_hometeamstats."TEAM_ID" = cte_visitorteamstats."VTEAM_ID";
;

--after joining the two cte's we created a table from the cte called teamstats
CREATE TABLE teamstats AS
with cte_hometeamstats as (
select "HOME_TEAM_ID" as "TEAM_ID",sum ("AST_home") as "AST_HOME" , sum ("REB_home") as "REBHOME", avg ("FG_PCT_home") as "AVG_FGPCTHOME"
from postgres.public.xf_games xg 
where "SEASON" = 2015
group by "HOME_TEAM_ID"
order by "HOME_TEAM_ID"
),
cte_visitorteamstats as ( 
select "VISITOR_TEAM_ID" as "VTEAM_ID", sum ("AST_away") as "AST_AWAY" , sum ("REB_away") as "REBAWAY", avg ("FG_PCT_away") as "AVG_FGPCTAWAY"
from postgres.public.xf_games xg 
where "SEASON" = 2015
group by "VISITOR_TEAM_ID"
order by "VISITOR_TEAM_ID"
)
SELECT *
FROM cte_hometeamstats inner JOIN
     cte_visitorteamstats ON cte_hometeamstats."TEAM_ID" = cte_visitorteamstats."VTEAM_ID";
;

--after the join, our table have two identical team id columns, so we dropped one of them
alter table postgres.public.teamstats
drop column  "VTEAM_ID";

--then, we did a similar thing for the ranking table. we wanted the average winning percentage for each team for the 2015 season
--so we created a cte with the team_id and avg_winning pct for that season
create table winningPStats as 
with cte_teamrankingstats as (
select "TEAM_ID","SEASON_ID","W_PCT"
from postgres.public.xf_ranking xr
)
select "TEAM_ID", avg ("W_PCT") as "AVG_WPCT"
from postgres.public.xf_ranking xr
where "SEASON_ID" = 22015
group by "TEAM_ID"
order by "TEAM_ID"

--we then created a new table, joining our teamstats table with the winningpstats table
create table almostComStat as (
select * from postgres.public.teamstats t left join 
postgres.public.winningpstats w  on t."TEAM_ID" = w."TEAM2_ID"
); 

--again, this resulted in two team id columns so we dropped one
 ALTER TABLE postgres.public.winningpstats
 RENAME COLUMN "TEAM_ID" TO "TEAM2_ID";

 alter table postgres.public.almostComStat
 drop column  "TEAM2_ID";


--Added up total AST and REB. Also the average of AGP. Then we joined the cte with the teamstat table for each seasons.
--Dropped the extra columns
CREATE TABLE totalAST15 AS
with cte_totalAST15  as (
SELECT  "TEAM_ID", SUM("AST_HOME" + "AST_AWAY") as "total_AST", sum ("REBHOME"+"REBAWAY") as "total_REB", sum(("AVG_FGPCTHOME" + "AVG_FGPCTAWAY")/2) as "total_AVGPCT"
FROM postgres.public.almostcomstat
group by "TEAM_ID" 
)
SELECT *
from cte_totalAST15

create table almost2ComStat15 as (
SELECT *
FROM postgres.public.almostcomstat left JOIN
     postgres.public.totalAST15 ON postgres.public.almostcomstat."TEAM_ID" = postgres.public.totalAST15."TEAM2_ID"
);

ALTER TABLE postgres.public.totalAST15
RENAME COLUMN "TEAM_ID" TO "TEAM2_ID";


--Final Team Stats table with individual team names
--Joined previous tables with Team table
create table teamstat2019 as (
SELECT *
FROM xf_teams inner JOIN
     almost2comstat19 ON xf_teams."TEAM2_ID" = almost2comstat19."TEAM_ID"
     );
     
ALTER TABLE postgres.public.xf_teams
RENAME COLUMN "TEAM_ID" TO "TEAM2_ID";

alter table postgres.public.teamstat2019
drop column  "TEAM2_ID";


--Copy to command to export the table as CSV file
COPY postgres.public.teamstat2015("ABBREVIATION", "NICKNAME", "TEAM_ID", "AVG_WPCT", "total_AST", "total_REB", "total_AVGPCT") 
TO 'C:\sampledb\NBA\teamstat2015.csv' DELIMITER ',' CSV HEADER;
COPY postgres.public.teamstat2016("ABBREVIATION", "NICKNAME", "TEAM_ID", "AVG_WPCT", "total_AST", "total_REB", "total_AVGPCT") 
TO 'C:\sampledb\NBA\teamstat2016.csv' DELIMITER ',' CSV HEADER;
COPY postgres.public.teamstat2017("ABBREVIATION", "NICKNAME", "TEAM_ID", "AVG_WPCT", "total_AST", "total_REB", "total_AVGPCT") 
TO 'C:\sampledb\NBA\teamstat2017.csv' DELIMITER ',' CSV HEADER;
COPY postgres.public.teamstat2018("ABBREVIATION", "NICKNAME", "TEAM_ID", "AVG_WPCT", "total_AST", "total_REB", "total_AVGPCT") 
TO 'C:\sampledb\NBA\teamstat2018.csv' DELIMITER ',' CSV HEADER;
COPY postgres.public.teamstat2019("ABBREVIATION", "NICKNAME", "TEAM_ID", "AVG_WPCT", "total_AST", "total_REB", "total_AVGPCT") 
TO 'C:\sampledb\NBA\teamstat2019.csv' DELIMITER ',' CSV HEADER;

--we now have one table with a column for team id, one for sum of reb per team, sum of ast per team, ave fg pct per team, avg w pct per team
--the next thing we need is just to join this with the teams table, so we can line up the team name with their stats



























