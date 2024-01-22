create view "NBA".public.games_details_v
 as
 select
 cast("TEAM_ID" as integer) as "TEAM_ID"
 ,cast("PLAYER_ID" as integer) as "PLAYER_ID"
 ,"PLAYER_NAME"
 ,cast("PTS" as float) as "PTS"
,cast("GAME_ID" as integer) as "GAMES_ID"

 from "NBA".public.games_details
 
 create table "NBA".public.xf_games_details
 as
 select * from "NBA".public.games_details_v;
 
CREATE TABLE player_details_2 AS
with cte_players as (
select "TEAM_ID" as "TID", "PLAYER_ID" as "PID", "SEASON" 
from "NBA".public.players_v
group by "TID", "PID", "SEASON" 
order by "TID"
),
cte_games_details as ( 
select "TEAM_ID", "PLAYER_ID", "PLAYER_NAME", "PTS", "GAMES_ID"
from "NBA".public.games_details_v
group by "PLAYER_ID", "TEAM_ID" , "PLAYER_NAME", "GAMES_ID", "PTS"
order by "PLAYER_ID" 
)
SELECT *
FROM cte_players inner JOIN
     cte_games_details ON cte_players."PID" = cte_games_details."PLAYER_ID";

    

 select avg("PTS") as "avg_player_pts", "PLAYER_NAME", "TID"
 from "NBA".public.player_details_2 
 where "SEASON" = 2019
 and "PTS"  is not null
 group by "PLAYER_ID", "PLAYER_NAME", "TID" 
 order by avg_player_pts desc
limit 5;
