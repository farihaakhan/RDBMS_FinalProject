## Effects of Rebounds, Assists, and Field Goal Percentage on Winning Percentage of an NBA Team.
## By: Aracely Menjivar, Fariha Kahn, Rachel Brunner, Lamae Maharaj

The goal of our project was to test the effect of rebounds, assists, and field goal percentage of an NBA team on the team's winning percentage. 
We chose an NBA dataset from Kaggle that included NBA data from the 2004 - 2020 seasons. The dataset consisted of five tables which included details about each team, player, and game that was played during these years. 
After downloadind the data onto our computers, we began by creating tables to import the data into DBeaver. We used the varchar datatype for each column to ensure that all of the data would be imported and we would not encounter any domain integrity constraint violations. Below is the script we used to create the first table. 
		`create table games(`
		
`"GAME_DATE_EST" varchar`

`,"GAME_ID" varchar --key`

`,"GAME_STATUS_TEXT" varchar`

`,"HOME_TEAM_ID" varchar`

`,"VISITOR_TEAM_ID" varchar`

`,"SEASON" varchar`

`,"TEAM_ID_home" varchar --dupicate of 
HOME_TEAM_ID`

`,"PTS_home" varchar`

`,"FG_PCT_home" varchar`

`,"FT_PCT_home" varchar`

`,"FG3_PCT_home" varchar`

`,"AST_home" varchar`

`,"REB_home" varchar`

`,"TEAM_ID_away" varchar --ID of away team, duplicate of VISITOR_TEAM_ID`

`,"PTS_away" varchar`

`,"FG_PCT_away" varchar`

`,"FT_PCT_away" varchar`

`,"FG3_PCT_away" varchar`

`,"AST_away" varchar`

`,"REB_away" varchar`

`,"HOME_TEAM_WIN" varchar`
`);`

We used similar scripts to create the remaining four tables. We then used the copy command to import the data as shown below:

`copy postgres.public.ranking from 'C:\sampledb\NBA\ranking.csv' DELIMITER ',' CSV HEADER;`

`copy postgres.public.teams from 'C:\sampledb\NBA\teams.csv' DELIMITER ',' CSV HEADER;`

`copy postgres.public.players from 'C:\sampledb\NBA\players.csv' DELIMITER ',' CSV HEADER;`

`copy postgres.public.games_details from 'C:\sampledb\NBA\games_details.csv' DELIMITER ',' CSV HEADER;`

`copy postgres.public.games from 'C:\sampledb\NBA\games.csv' DELIMITER ',' CSV HEADER;`

The data was successfully loaded.
We then ran a few select statements to find the cardinality of each table. We checked to ensure that it was truly all of the data that had loaded. 

`select count (*) from postgres.public.games --25,796`

`select count (*) from postgres.public.games_details --645,953`

`select count(*) from postgres.public.players --7,228`

`select count (*) from postgres.public.ranking --201,792`

`select count (*) from postgres.public.teams --30`

This shows the total number of rows in each table. 
The next thing we did was create views from our original tables, where we used the `cast` function to cast each columns to its appropriate datatype. In the views, we only included the rows that were necessary for our analysis.
Below is the view we created for the games table. 
`create view postgres.public.games_v`

`as`

`select`

`cast("GAME_DATE_EST" as date) as "GAME_DATE_EST"`

`,cast("GAME_ID" as integer) as "GAME_ID" --Primary key`

`,cast("HOME_TEAM_ID" as integer) as "HOME_TEAM_ID" --can maybe map to team_id in games_details table"`

`,cast("VISITOR_TEAM_ID" as integer) as "VISITOR_TEAM_ID"`

`,cast("SEASON" as integer) as "SEASON"`

`,cast("PTS_home" as float) as "PTS_home"`

`,cast("FG_PCT_home" as float) as "FG_PCT_home"`

`,cast("AST_home" as float) as "AST_home"`

`,cast("REB_home" as float) as "REB_home"`

`,cast("PTS_away" as float) as "PTS_away"`

`,cast("FG_PCT_away" as float) as "FG_PCT_away"`

`,cast("AST_away" as float) as "AST_away"`

`,cast("REB_away" as float) as "REB_away"`

`,cast("HOME_TEAM_WIN" as boolean) as "HOME_TEAM_WIN"`

`from postgres.public.games`

After creating each view, we created a new table from the view using the script below:
`create table postgres.public.xf_games`

`as`

`select * from postgres.public.games_v;`

We did a similar thing for the remaining tables.
After creating our new tables, we tried to establish primary and foreign key relationships.
It was clear that the "TEAM_ID" column was a map between the tables, but we needed to figure out which table should be the parent and which should be the child. To do this, we counted the distinct entries for this column in each table and it compared that count with the total row count for the table. When we tried to implement a primary key, we ran into an error saying that our primary key had a duplicate value. We selected the rows with the identical value and realized that it belonged to the 2020 season which we had chosen not to analyze. Therefore, we were able to delete the row from our new table that we created from the view.
After successfully implementing these relationships we were finally able to begin creating the tables we wanted.
We chose a subset of five seasons of data to analyze. We chose seasons 2015-2019. 
We decided to create an individual table for each season, where each table had the team name, total team statistics of interest for that team, and winning percentage of that team for that season.
We began with the 2015 season. 
In the original data set, the "games" table included details for every game played in every season. The table had columns for the home team and visiting team for every game, and the statistics for each game were separated by home and visiting teams. We wanted a total count of assists, rebounds, and a total average field goal percentage per team, including both home and away games. 
In order to get this, we created two separate cte's, one with home team statistics and one with away team statistics. In each one, we grouped the results by Team ID so each team would appear in one and only one row. We then joined the cte's on the TEAM ID column to create one big cte with all results for that team. Below is the script for the 2015 season:

`CREATE TABLE teamstats AS`

`with cte_hometeamstats as (`

`select "HOME_TEAM_ID" as "TEAM_ID",sum ("AST_home") as "AST_HOME" , sum ("REB_home") as "REBHOME", avg ("FG_PCT_home") as "AVG_FGPCTHOME"`

`from postgres.public.xf_games xg`

`where "SEASON" = 2015`

`group by "HOME_TEAM_ID"`

`order by "HOME_TEAM_ID"`

`),`

`cte_visitorteamstats as (`

`select "VISITOR_TEAM_ID" as "VTEAM_ID", sum ("AST_away") as "AST_AWAY" , sum ("REB_away") as "REBAWAY", avg ("FG_PCT_away") as "AVG_FGPCTAWAY"`

`from postgres.public.xf_games xg`

`where "SEASON" = 2015`

`group by "VISITOR_TEAM_ID"`

`order by "VISITOR_TEAM_ID"`

`)`

`SELECT *`

`FROM cte_hometeamstats inner JOIN`

`cte_visitorteamstats ON` `cte_hometeamstats."TEAM_ID" = ``cte_visitorteamstats."VTEAM_ID";`

`;`

The type of join we used did not matter, as every join returned the same result. This told us that every team ID was mentioned exactly once in both of the cte's we were joining. We used the aggregate functions `sum`  as we wanted to total number of assists per team, total number of rebounds per team, and total average field goal percentage per team for that season. We created a table with this join. This new table had a double column for TEAM_ID, so we dropped one of them. 

We then did a similar thing to the "ranking" table which contained the winning percentage for each team. 
`create table winningPStats as`

`with cte_teamrankingstats as (`

`select "TEAM_ID","SEASON_ID","W_PCT"`

`from postgres.public.xf_ranking xr`

`)`

`select "TEAM_ID", avg ("W_PCT") as "AVG_WPCT"`

`from postgres.public.xf_ranking xr`

`where "SEASON_ID" = 22015`

`group by "TEAM_ID"`

`order by "TEAM_ID"`

We selected the 2015 season, and took the average of each team's winning percentage for that season. 
We then did one final join, joining the table with winning percentages and the table with the team statistics. This was done with the script below:
`create table almostComStat as (`

`select * from postgres.public.teamstats t left join`

`postgres.public.winningpstats w on t."TEAM_ID" = w."TEAM2_ID"`

`);`
Again, the type of join we used did not matter, as each team_id was referenced exactly once in each table. This join created a table with each team_id, the team's winning percentage, and the desired statistics for that team. 

In the table we created thus far, each team had a total number of assists for their home games, and a separate total number of assists for their away games. The same applied to rebounds and field goal percentage. As previously mentioned, we did not care about the difference between home and away games, we just wanted a total per team per season. Therefore, we used our latest table to create another cte in which we used the `sum` function to add the total_ast_home and total_ast_away columns and create a new column called total_ast. We did a similar thing for the rebound and field goal percentage columns as shown below:
`CREATE TABLE totalAST15 AS`

`with cte_totalAST15 as (`

`SELECT "TEAM_ID", SUM("AST_HOME" + "AST_AWAY") as "total_AST", sum ("REBHOME"+"REBAWAY") as "total_REB", sum(("AVG_FGPCTHOME" + "AVG_FGPCTAWAY")/2) as "total_AVGPCT"`

`FROM postgres.public.almostcomstat`

`group by "TEAM_ID"`

`)`

`SELECT *`

`from cte_totalAST15`

We then joined this cte with our previous table using the team_id column, so the total statistics for each team would be appended to the rows with their winning percentages. 

`create table almost2ComStat15 as (`

`SELECT *`

`FROM postgres.public.almostcomstat left JOIN`

`postgres.public.totalAST15 ON postgres.public.almostcomstat."TEAM_ID" = postgres.public.totalAST15."TEAM2_ID"`

`);`

After doing this, we dropped all of the columns that we no longer needed, including ast_home, ast_away, reb_home, reb_away, fgpct_home and fgpct_away. We also dropped the duplicate team_id column. 

As a final step, we joined our latest table with the "teams" table that contained each team's official name. 
`create table teamstat2019 as (`

`SELECT *`

`FROM xf_teams inner JOIN`

`almost2comstat19 ON xf_teams."TEAM2_ID" = almost2comstat19."TEAM_ID"`

`);`

After dropping the repeated columns again, we had the final table we desired.

We then used the following code to export our new tables as csv files so we could upload them into tableau and create our data visualizations. 
`COPY postgres.public.teamstat2015("ABBREVIATION", "NICKNAME", "TEAM_ID", "AVG_WPCT", "total_AST", "total_REB", "total_AVGPCT")`

`TO 'C:\sampledb\NBA\teamstat2015.csv' DELIMITER ',' CSV HEADER;`

`COPY postgres.public.teamstat2016("ABBREVIATION", "NICKNAME", "TEAM_ID", "AVG_WPCT", "total_AST", "total_REB", "total_AVGPCT")`

`TO 'C:\sampledb\NBA\teamstat2016.csv' DELIMITER ',' CSV HEADER;`

`COPY postgres.public.teamstat2017("ABBREVIATION", "NICKNAME", "TEAM_ID", "AVG_WPCT", "total_AST", "total_REB", "total_AVGPCT")`

`TO 'C:\sampledb\NBA\teamstat2017.csv' DELIMITER ',' CSV HEADER;`

`COPY postgres.public.teamstat2018("ABBREVIATION", "NICKNAME", "TEAM_ID", "AVG_WPCT", "total_AST", "total_REB", "total_AVGPCT")`

`TO 'C:\sampledb\NBA\teamstat2018.csv' DELIMITER ',' CSV HEADER;`

`COPY postgres.public.teamstat2019("ABBREVIATION", "NICKNAME", "TEAM_ID", "AVG_WPCT", "total_AST", "total_REB", "total_AVGPCT")`

`TO 'C:\sampledb\NBA\teamstat2019.csv' DELIMITER ',' CSV HEADER;`

After completing this part of our analysis, we wanted to see whether or not there was a relationship between the top players and the top teams. Do the teams with the highest winning percentages actually have the top players?
In order to answer this question, we used the games_details and players tables. We created a cte for each of these tables, and then joined the cte's using an inner join as shown below:
`CREATE TABLE player_details_2 AS`

`with cte_players as (`

`select "TEAM_ID" as "TID", "PLAYER_ID" as "PID", "SEASON"`

`from "NBA".public.players_v`

`group by "TID", "PID", "SEASON"`

`order by "TID"`

`),`

`cte_games_details as (`

`select "TEAM_ID", "PLAYER_ID", "PLAYER_NAME", "PTS", "GAMES_ID"`

`from "NBA".public.games_details_v`

`group by "PLAYER_ID", "TEAM_ID" , "PLAYER_NAME", "GAMES_ID", "PTS"`

`order by "PLAYER_ID"`

`)`

`SELECT *`

`FROM cte_players inner JOIN`

`cte_games_details ON cte_players."PID" = cte_games_details."PLAYER_ID";`

We defined the "top" players as the players with the highest average points scored per game. 
After creating this table, we just ran a select statement to select the average number of points per player for each season. The script is shown below:
`select avg("PTS") as "avg_player_pts",` `"PLAYER_NAME", "TID"`

`from "NBA".public.player_details_2`

`where "SEASON" = 2019`

`and "PTS" is not null`

`group by "PLAYER_ID", "PLAYER_NAME", "TID"`

`order by avg_player_pts desc`

`limit 5;`

We limited the query to return only five results, as we wanted to look at the top five players in the league per season. 
The results for the 2019 season were as follows:
|  Player |Average Points  | Team|
|--|--|--|
| Kevin Durant |26.96|Brooklyn Nets|
|LeBron James | 26.84|Los Angeles Lakers|
|Luka Doncic|26.05|Mavericks|
|Zion Williamson|25.68|Pelicans|
|Joel Embiid|24.97|Philadelphia 76'ers|

Interestingly, out of these teams, only the Lakers appeared as one of the top five teams with highest winning percentage in 2019. This seems to show that having the best player is not necessarily the key to winning the game. 





