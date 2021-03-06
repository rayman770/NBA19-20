library(SportsAnalytics)

#1) Loading the season data and extracting some meaningful statistics 
#(field goals made, three points made, free throws made, total rebounds, total points)
nba1920 <- fetch_NBAPlayerStatistics("19-20")

player_stat <- nba1920[, c("Name", "Team", "FieldGoalsMade", "ThreesMade", "FreeThrowsMade", "TotalRebounds",
                           "TotalPoints")]

#2) Subsetting the data to include only players for LAL, the champion of 19-20 season. 
#Finding the players who are “best” for some meaningful stats.

LAL_subset <- subset(nba1920, Team == 'LAL')
sub <- matrix(c(LAL_subset[which.max(LAL_subset$FieldGoalsMade), c("Name", "FieldGoalsMade")],
                LAL_subset[which.max(LAL_subset$ThreesMade), c("Name", "ThreesMade")],
                LAL_subset[which.max(LAL_subset$FreeThrowsMade), c("Name", "FreeThrowsMade")],
                LAL_subset[which.max(LAL_subset$TotalRebounds), c("Name", "TotalRebounds")],
                LAL_subset[which.max(LAL_subset$TotalPoints), c("Name", "TotalPoints")]), ncol = 2, byrow = TRUE)
colnames(sub) <- c("Player", "Statistics")
rownames(sub) <- c("Field Goals Made", "Three Points Made", "Free Throws Made", "Total Rebounds",
                   "Total Points")
sub

#3) Showing 5 teams for the season that have the most wins in descending order.
library(rvest)
reg_season1920 <- read_html("https://en.wikipedia.org/wiki/2019%E2%80%9320_NBA_season")
reg_season_data <- reg_season1920 %>% html_nodes("table.wikitable")

#By Division
East_ATL_Div <- (reg_season_data[2] %>% html_table)[[1]]  # Eastern Conference - Atlantic Division
East_CEN_Div <- (reg_season_data[3] %>% html_table)[[1]]  # Eastern Conference - Central Division
East_SOU_Div <- (reg_season_data[4] %>% html_table)[[1]]  # Eastern Conference - Southeast Division

West_NOR_Div <- (reg_season_data[5] %>% html_table)[[1]]  # Western Conference - Northwest Division
West_PAC_Div <- (reg_season_data[6] %>% html_table)[[1]]  # Western Conference - Pacific Division
West_SOU_Div <- (reg_season_data[7] %>% html_table)[[1]]  # Western Conference - Southhwest Division

#Getting rid of unnecessary indications on the Team names
East_ATL_Div$`Atlantic Division` <- gsub("y – ", "", East_ATL_Div$`Atlantic Division`)
East_ATL_Div$`Atlantic Division` <- gsub("x – ", "", East_ATL_Div$`Atlantic Division`)

East_CEN_Div$`Central Division` <- gsub("z – ", "", East_CEN_Div$`Central Division`)
East_CEN_Div$`Central Division` <- gsub("x – ", "", East_CEN_Div$`Central Division`)

East_SOU_Div$`Southeast Division` <- gsub("y – ", "", East_SOU_Div$`Southeast Division`)
East_SOU_Div$`Southeast Division` <- gsub("x – ", "", East_SOU_Div$`Southeast Division`)

West_NOR_Div$`Northwest Division` <- gsub("y – ", "", West_NOR_Div$`Northwest Division`)
West_NOR_Div$`Northwest Division` <- gsub("x – ", "", West_NOR_Div$`Northwest Division`)

West_PAC_Div$`Pacific Division` <- gsub("c – ", "", West_PAC_Div$`Pacific Division`)
West_PAC_Div$`Pacific Division` <- gsub("x – ", "", West_PAC_Div$`Pacific Division`)

West_SOU_Div$`Southwest Division` <- gsub("y – ", "", West_SOU_Div$`Southwest Division`)
West_SOU_Div$`Southwest Division` <- gsub("x – ", "", West_SOU_Div$`Southwest Division`)

East_ATL_Div
East_CEN_Div
East_SOU_Div

West_NOR_Div
West_PAC_Div
West_SOU_Div

#By Conference with top 5 teams
EastConf <- (reg_season_data[8] %>% html_table)[[1]][1:6,]  #6 rows needed due to the header name (conference)
WestConf <- (reg_season_data[9] %>% html_table)[[1]][1:6,]

colnames(EastConf) <- EastConf[1,]  #Make the appropriate column names for the table
EastConf <- EastConf[-1,]
rownames(EastConf) <- NULL

colnames(WestConf) <- WestConf[1,]
WestConf <- WestConf[-1,]
rownames(WestConf) <- NULL

EastConf$Team <- gsub("z – ", "", EastConf$Team)
EastConf$Team <- gsub("y – ", "", EastConf$Team)
EastConf$Team <- gsub("x – ", "", EastConf$Team)
EastConf$Team <- gsub("\\*", "", EastConf$Team)
EastConf$Team <- gsub("\\s", "", EastConf$Team)
EastConf$Team <- gsub("([a-z])([A-Z])", "\\1 \\2", EastConf$Team)

WestConf$Team <- gsub("c – ", "", WestConf$Team)
WestConf$Team <- gsub("x – ", "", WestConf$Team)
WestConf$Team <- gsub("y – ", "", WestConf$Team)
WestConf$Team <- gsub("\\*", "", WestConf$Team)
WestConf$Team <- gsub("\\s", "", WestConf$Team)
WestConf$Team <- gsub("([a-z])([A-Z])", "\\1 \\2", WestConf$Team)

EastConf
WestConf

#4) Creating data visualizations with NBA 19-29
library(ggplot2)
library(tidyr)

#i) Comparison between Eastern and Western in terms of five statistics that are previously selected
EastStat <- subset(player_stat, player_stat$Team == "MIL" | player_stat$Team == "TOR" | 
                     player_stat$Team == "BOS" | player_stat$Team == "IND" | player_stat$Team == "MIA" |
                     player_stat$Team == "PHI" | player_stat$Team == "BRO" | player_stat$Team == "ORL" |
                     player_stat$Team == "WAS" | player_stat$Team == "CHA" | player_stat$Team == "CHI" |
                     player_stat$Team == "NYK" | player_stat$Team == "DET" | player_stat$Team == "ATL" |
                     player_stat$Team == "CLE")
WestStat <- subset(player_stat, player_stat$Team == "LAL" | player_stat$Team == "LAC" | 
                     player_stat$Team == "DEN" | player_stat$Team == "HOU" | player_stat$Team == "OKL" |
                     player_stat$Team == "UTA" | player_stat$Team == "DAL" | player_stat$Team == "POR" |
                     player_stat$Team == "MEM" | player_stat$Team == "PHO" | player_stat$Team == "SAN" |
                     player_stat$Team == "SAC" | player_stat$Team == "NOR" | player_stat$Team == "MIN" |
                     player_stat$Team == "GSW")

EastStat$Conf <- "Eastern"
WestStat$Conf <- "Western"

AllConf <- rbind(EastStat, WestStat)

FGM_by_Conf <- setNames(aggregate(x = AllConf$FieldGoalsMade, by = list(AllConf$Conf), FUN = sum), 
                        c("Conference", "Field Goals Made"))
THR_by_Conf <- setNames(aggregate(x = AllConf$ThreesMade, by = list(AllConf$Conf), FUN = sum),
                        c("Conference", "Three Points Made"))
FTM_by_Conf <- setNames(aggregate(x = AllConf$FreeThrowsMade, by = list(AllConf$Conf), FUN = sum),
                        c("Conference", "Free Throws Made"))
TRB_by_Conf <- setNames(aggregate(x = AllConf$TotalRebounds, by = list(AllConf$Conf), FUN = sum),
                        c("Conference", "Total Rebounds"))
TP_by_Conf <- setNames(aggregate(x = AllConf$TotalPoints, by = list(AllConf$Conf), FUN = sum),
                       c("Conference", "Total Points"))

AllMerged <- merge(merge(merge(merge(FGM_by_Conf, THR_by_Conf), FTM_by_Conf), TRB_by_Conf), TP_by_Conf)

AllMergedGathered <- gather(AllMerged, Stats, Records, -Conference)
ggplot(AllMergedGathered, aes(x = Stats, y = Records, fill = factor(Conference))) + 
  geom_bar(stat = 'identity', position = 'dodge') + theme_minimal() + 
  scale_fill_discrete(name = "Conference") + 
  scale_fill_manual("Conference", values = c("Eastern" = "green", "Western" = "red")) + 
  theme(axis.text.x = element_text(face = "bold")) + theme(axis.text.y = element_text(face = "bold")) +
  ggtitle("Five Stats Comparison by Conference") + xlab('') + ylab('') +
  coord_flip()

#ii) Fouls by position of top 5 Western teams
west_top5 <- subset(nba1920, nba1920$Team == "LAL" | nba1920$Team == "LAC" | nba1920$Team == "DEN" |
                      nba1920$Team == "HOU" | nba1920$Team == "OKL")

foul_by_pos <- west_top5[, c("Team", "Position", "PersonalFouls")]
ggplot(foul_by_pos, aes(x = Position, y = PersonalFouls, fill = Team)) + 
  geom_bar(stat = 'identity', position = 'dodge') + 
  ggtitle("Personal Fouls by Position of Top 5 Western Teams") + 
  scale_fill_manual("Team", values = c("DEN" = "navy blue", "HOU" = "red", "LAC" = "black", 
                                       "LAL" = "yellow", "OKL" = "orange")) +
  ylab("Number of Fouls") + theme_bw() + theme(plot.title = element_text(face = "bold"))

#iii) Number of Views on NBA Final 
final_views <- read_html("https://en.wikipedia.org/wiki/NBA_Finals_television_ratings")
final_views_data <- final_views %>% html_nodes("table.wikitable")

views_by_year <- (final_views_data[2] %>% html_table(fill = TRUE))[[1]]
views_by_year <- views_by_year[, 1:ncol(views_by_year) - 1]

views_by_year$Year <- gsub('\\[a]', '', views_by_year$Year)

views_by_year$Avg <- gsub("[a-z]", "", views_by_year$Avg)
views_by_year$Avg <- gsub("[A-Z]", "", views_by_year$Avg)
views_by_year$Avg <- gsub(".*\\((.*)\\).*", "\\1", views_by_year$Avg)

views_by_year$Avg <- as.numeric(views_by_year$Avg)
views_by_year$Year <- as.numeric(views_by_year$Year)

views_by_year <- views_by_year[1:35, ] #Before 1986, there's no data of number of views, so truncated
views_by_year$NumGame <- ifelse(views_by_year$`Game 5` == "No Game" & !is.na(views_by_year$`Game 5`), 
                                "Sweep", views_by_year$`Game 5`)
views_by_year$NumGame <- ifelse(views_by_year$`Game 5` != "No Game" & views_by_year$`Game 6` == "No Game" & 
                                  !is.na(views_by_year$`Game 6`), "5 Games", views_by_year$NumGame)
views_by_year$NumGame <- ifelse(views_by_year$`Game 5` != "No Game" & views_by_year$`Game 6` != "No Game" & 
                                  views_by_year$`Game 7` == "No Game" & !is.na(views_by_year$`Game 7`), 
                                "6 Games", views_by_year$NumGame)
views_by_year$NumGame <- ifelse(views_by_year$`Game 5` != "No Game" & views_by_year$`Game 6` != "No Game" & 
                                  views_by_year$`Game 7` != "No Game" & !is.na(views_by_year$`Game 7`), 
                                "7 Games", views_by_year$NumGame)

library(gridExtra)
a <- ggplot(views_by_year, aes(x = Year, y = Avg)) + geom_line(linetype = 'dashed') + geom_point() + 
  ggtitle("Number of Views on NBA Finals since 1986") + ylab("Average Views in Million") + theme_bw() +
  theme(plot.title = element_text(face = "bold"))

b <-ggplot(views_by_year, aes(x = Year, y = Avg, group = NumGame, colour = NumGame)) + geom_line(size = 1) + 
  ggtitle("Number of Views on NBA Finals since 1986 by Games") + ylab("Average Views in Million") +
  theme_bw() + theme(plot.title = element_text(face = "bold"))

grid.arrange(a, b, nrow = 2)


#iv) Five NBA Star Players Stat Comparison
star_players <- subset(nba1920, nba1920$Name == "Lebron James" | nba1920$Name == "G Antetokounmpo" |
                         nba1920$Name == "Anthony Davis" | nba1920$Name == "James Harden" | 
                         nba1920$Name == "Kawhi Leonard") 

TMP <- setNames(aggregate(x = star_players$TotalMinutesPlayed, by = list(star_players$Name), FUN = sum),
                c("Name", "Total Minutes Played"))
TP <- setNames(aggregate(x = star_players$TotalPoints, by = list(star_players$Name), FUN = sum),
               c("Name", "Total Points"))
TR <- setNames(aggregate(x = star_players$TotalRebounds, by = list(star_players$Name), FUN = sum),
               c("Name", "Total Rebound"))
FGM <- setNames(aggregate(x = star_players$FieldGoalsMade, by = list(star_players$Name), FUN = sum),
                c("Name", "Field Goals Made"))

AllMerged2 <- merge(merge(merge(TMP, TP), TR), FGM)

AllMerged2_gathered <- gather(AllMerged2, Stats, Records, -Name)

ggplot(AllMerged2_gathered, aes(x = Stats, y = Records, group = Name, colour = Name)) + 
  geom_line(size = 1) + geom_point(color = 'black') + theme_bw() + 
  ggtitle("Five NBA Star Players Stat Comparison") + scale_fill_discrete(name = "Players") +
  theme(axis.text.x = element_text(angle = 45, face = "bold")) + xlab(NULL) + ylab(NULL) + 
  theme(plot.title = element_text(face = "bold"))

#v)LAL 2020 starting lineup players stat comparison
library(fmsb)

LAL_lineups <- nba1920[nba1920$Name == "Alex Caruso" | nba1920$Name == "Anthony Davis" | nba1920$Name == "Danny Green" | 
                         nba1920$Name == "K Caldwell-pope" | nba1920$Name == "Lebron James", 
                       c("TotalMinutesPlayed", "FieldGoalsMade", "FieldGoalsAttempted", "ThreesMade", "ThreesAttempted", "FreeThrowsMade", 
                         "FreeThrowsAttempted", "TotalRebounds", "Assists", "Steals", "Turnovers", "Blocks", "PersonalFouls")]
LAL_lineups$`Field Goal%` <- LAL_lineups$FieldGoalsMade / LAL_lineups$FieldGoalsAttempted * 100
LAL_lineups$`3P%` <- LAL_lineups$ThreesMade / LAL_lineups$ThreesAttempted * 100
LAL_lineups$`Free Thr%` <- LAL_lineups$FreeThrowsMade / LAL_lineups$FreeThrowsAttempted * 100
LAL_lineups <- LAL_lineups[c("TotalMinutesPlayed", "Field Goal%", "3P%", "Free Thr%",
                             "TotalRebounds", "Assists", "Steals", "Turnovers", "Blocks", "PersonalFouls")]
rownames(LAL_lineups) <- c("K Caldwell-pope", "Alex Caruso", "Anthony Davis", "Danny Green", "Lebron James")
colnames(LAL_lineups) <- c("PlayMinutes", "Field Goal%", "3P%", "Free Thr%", "Rebounds", "Assists", "Steals", "Turnovers", "Blocks",
                           "Fouls")
LAL_lineups <- rbind(c(2500, 100, 100, 100, 550, 700, 100, 280, 150, 170), c(1000, 0, 0, 0, 100, 80, 50, 50, 10, 80), LAL_lineups)

par(mfrow = c(2,3))
radarchart(LAL_lineups[1:3, ], title = "K Caldwell-pope (SG)", axistype = 2, pcol=rgb(0.2,0.5,0.5,0.9), pfcol=rgb(0.2,0.5,0.5,0.5), 
           plwd=4, cglcol="grey", cglty=1, axislabcol="purple")
radarchart(LAL_lineups[c(1,2,4),], title = "Alex Caruso (PG)", axistype = 2, pcol=rgb(0.8,0.2,0.5,0.9), pfcol=rgb(0.8,0.2,0.5,0.5), 
           plwd=4, cglcol="grey", cglty=1, axislabcol="purple")
radarchart(LAL_lineups[c(1,2,5),], title = "Anthony Davis (PF)", axistype = 2, pcol=rgb(0.7,0.5,0.1,0.9), pfcol=rgb(0.7,0.5,0.1,0.5), 
           plwd=4, cglcol="grey", cglty=1, axislabcol="purple")
radarchart(LAL_lineups[c(1,2,6),], title = "Danny Green (SF)", axistype = 2, pcol=rgb(0.2,0.8,0.4,0.9), pfcol=rgb(0.2,0.8,0.4,0.5), 
           plwd=4, cglcol="grey", cglty=1, axislabcol="purple")
radarchart(LAL_lineups[c(1,2,7),], title = "Lebron James (PG)", axistype = 2, pcol=rgb(0.9,0.4,0.3,0.9), pfcol=rgb(0.9,0.4,0.3,0.5),
           plwd=4, cglcol="grey", cglty=1, axislabcol="purple")
par(mfrow = c(1,1))

#vi) Offensive Rebounds vs Defensive Rebounds for Turnovers
nba1920$DefensiveRebounds <- nba1920$TotalRebounds - nba1920$OffensiveRebounds  

x <- ggplot(nba1920, aes(x = OffensiveRebounds, y = Turnovers)) + geom_point(color = "dark blue") + 
  theme_bw() + ggtitle("Offensive Rebounds & Turnovers") + xlab("Offensive Rebounds") + 
  theme(plot.title = element_text(face = "bold"))

y <- ggplot(nba1920, aes(x = DefensiveRebounds, y = Turnovers)) + geom_point(color = "orange") + 
  theme_bw() + ggtitle("Defensive Rebounds & Turnovers") + xlab("Defensive Rebounds") + 
  theme(plot.title = element_text(face = "bold"))

grid.arrange(x,y, nrow = 2)

#5) Displaying the home locations of the last 10 champions of the league with GoogleVis
library(googleVis)
library(dplyr)
library(tmap)
library(tmaptools)

NBA_Champs <- read_html("https://en.wikipedia.org/wiki/List_of_NBA_champions")
NBA_Champs_data <- NBA_Champs %>% html_nodes("table.wikitable")

Champs <- (NBA_Champs_data[2] %>% html_table())[[1]]
Champs <- tail(Champs, 10) %>% select(Year,`Western champion`,Result,`Eastern champion`)

Champs$`Eastern champion` <- gsub("\\s.*", "", Champs$`Eastern champion`)
Champs$`Western champion` <- gsub("^(\\S*\\s+\\S+).*", "\\1", Champs$`Western champion`)
Champs$`Western champion` <- gsub("Golden State", "San Francisco", Champs$`Western champion`)
Champs$`Western champion` <- gsub("Mavericks", "", Champs$`Western champion`)

Champs$WestWins <- as.numeric(substr(Champs$Result,1,1))
Champs$EastWins <- as.numeric(substr(Champs$Result,3,3))
Champs$Winner <- ifelse(Champs$WestWins > Champs$EastWins, Champs$`Western champion`, Champs$`Eastern champion`)

latlong <- geocode_OSM(unique(Champs$Winner))
latlong <- as_tibble(latlong) %>% rename(Winner = query)

newChamps <- Champs %>% inner_join(latlong)
newChamps$LatLong <- paste(as.character(newChamps$lat), as.character(newChamps$lon), sep = ":")
newChamps$state <- c("Texas", "Florida", "Florida", "Texas", "California", "Ohio", rep("California", 2),
                     "Ontario", "California")

stateChart <- gvisGeoChart(newChamps, "state",
                           options = list(region = "US", resolution = 'provinces'))
cityChart <- gvisGeoChart(newChamps, "LatLong",
                          options = list(region = "US", resolution = 'provinces'))

plot(stateChart)
plot(cityChart)

#6) Simple Linear Regression for Total Points by Field Goals Attempted
cor(nba1920$FieldGoalsAttempted, nba1920$TotalPoints)  #Field Goals Attempted has a high correlation coefficient with total points

m <- lm(TotalPoints~FieldGoalsAttempted, data = nba1920)
summary(m)    #The equation of the model is y = -14.131 + 1.3x, meaning that each field goal attempt increases 1.3 total points

ggplot(nba1920,aes(x = FieldGoalsAttempted, y = TotalPoints)) + geom_point(color = 'dark blue') +
  geom_smooth(method = "lm", color = 'orange') + theme_bw() + 
  ggtitle("Field Goals Attempted and Total Points") + xlab("Field Goals Attempted") +
  ylab("Total Points") + theme(plot.title = element_text(face = "bold"))

library(ggiraph)
library(ggiraphExtra)
library(plyr)
ggPredict(m, se = TRUE, interactive = TRUE) #It is the interactive plot for this simple linear regression.

