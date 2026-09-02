# data-prep.R
# Shared data loading and cleaning for all analysis pages

library(igraph)
library(ggraph)
library(ggplot2)
library(dplyr)
library(kableExtra)

raw <- readRDS("data/rdf_triples_snapshot.rds")
cat("Raw triples:", nrow(raw), "\n")

# Cleaning entity names
alias_map <- c(
  "Jeffrey E." = "Jeffrey Epstein",
  "jeffrey E." = "Jeffrey Epstein",
  "JEE" = "Jeffrey Epstein",
  "Alan M. Dershowitz" = "Alan Dershowitz",
  "Brad Edwards" = "Bradley Edwards",
  "Bradley J. Edwards" = "Bradley Edwards",
  "Bradley James Edwards" = "Bradley Edwards",
  "Edwards" = "Bradley Edwards",
  "Mr. Edwards" = "Bradley Edwards",
  "Virginia Roberts" = "Virginia Giuffre",
  "Virginia Roberts Giuffre" = "Virginia Giuffre",
  "Virginia L. Giuffre" = "Virginia Giuffre",
  "President Clinton" = "Bill Clinton",
  "Donald J. Trump" = "Donald Trump",
  "President Trump" = "Donald Trump",
  "President Obama" = "Barack Obama",
  "Barak" = "Ehud Barak",
  "Ehud" = "Ehud Barak",
  "Stephen K. Bannon" = "Steve Bannon",
  "Lawrence M. Krauss" = "Lawrence Krauss",
  "Dr. Krauss" = "Lawrence Krauss",
  "Lawrence Summers" = "Larry Summers",
  "Alexander Acosta" = "Alex Acosta",
  "R. Alexander Acosta" = "Alex Acosta",
  "Joseph Recarey" = "Detective Recarey",
  "Joe Recarey" = "Detective Recarey",
  "Detective Joseph Recarey" = "Detective Recarey",
  "Larry Visoki" = "Larry Visoski",
  "Lawrance Visoski" = "Larry Visoski",
  "Paul Cassell" = "Paul G. Cassell",
  "Cassell" = "Paul G. Cassell",
  "Mr. Cassell" = "Paul G. Cassell",
  "Kenneth Starr" = "Ken Starr",
  "Kenneth W. Starr" = "Ken Starr",
  "Kathryn Ruemmler" = "Kathy Ruemmler",
  "Jean-Luc Brunel" = "Jean Luc Brunel",
  "Martin G. Weinberg" = "Martin Weinberg",
  "Landon Thomas" = "Landon Thomas Jr.",
  "Landon Thomas, Jr." = "Landon Thomas Jr.",
  "Mr. Scarola" = "Jack Scarola",
  "Federal Bureau of Investigation" = "FBI",
  "Department of Justice" = "Justice Department",
  "U.S. Department of Justice" = "Justice Department",
  "United States Government" = "U.S. Government",
  "United States government" = "U.S. Government",
  "court" = "Court"
)

raw$actor  <- trimws(raw$actor)
raw$target <- trimws(raw$target)

clean <- function(x, map) ifelse(x %in% names(map), map[x], x)
raw$actor  <- clean(raw$actor,  alias_map)
raw$target <- clean(raw$target, alias_map)
raw <- raw[raw$actor != raw$target, ]

cat("After alias cleaning:", nrow(raw), "| Unique actors:", n_distinct(raw$actor), "\n")