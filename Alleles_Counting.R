library(tidyverse)
library(listviewer)

# Data upload -------------------------------------------------------------

d <- readRDS(file = 'snpdata.rds')


# Counting the number of alleles ------------------------------------------

# OBS.1: The first column is not necessary
# OBS.2: The procedure creates a list
d[,-1] |> map(plyr::count) -> l 


# Renaming the list properly ----------------------------------------------

l |> names() |>
  str_remove_all('.Top Alleles') |>
  str_replace_all('-', '_') -> names_vars

names(l) <- names_vars


# Viewing the allele count as a list --------------------------------------

map(l, ~ rename(.x, Alleles = x, Freq = freq)) -> l

jsonedit(l)


# Creating and saving the dataframe df1 -----------------------------------

l |>
  bind_rows(.id = 'Code') -> df1

openxlsx::write.xlsx(df1, 'df1_alleles.xlsx')


# Modifying the view of df1 and saving as df2 -----------------------------

df1 |>
  pivot_wider(names_from = Code, 
              values_from = Freq,
              values_fill = 0) -> df2


openxlsx::write.xlsx(df2, 'df2_alleles.xlsx')


# Just a test code ---------------------------------------------------------

map2(l, names_vars, ~ rename_at(.x, vars(freq), \(y) .y)) -> df_list
