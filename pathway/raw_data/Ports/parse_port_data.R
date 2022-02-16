library(dplyr)

download.file(
  sprintf("https://www.bitre.gov.au/sites/default/files/documents/water_0%s_timeSeries.zip", 65),
  f <- tempfile())
ff <- unzip(f, exdir=tempdir())

locs <- data.frame(
  port=c('Adelaide', 'Brisbane', 'Fremantle', 'Melbourne', 'Sydney'),
  PortCode=c('AUADL', 'AUBNE', 'AUFRE', 'AUMEL', 'AUSYD'),
  Longitude=c(138.5079505, 153.17156, 115.74806, 144.91585, 151.190688),
  Latitude=c(-34.79916667, -27.37148, -32.0472, -37.817451, -33.86068))


fields <- c("port", "year", "ships_stev", "cont_stev", "teu_stev", "pct_40ft", 
            "ships_term", "cont_term", "all_mt_port", "teu_total_port", 
            "teu_full_im", "teu_empty_im", "teu_full_ex", "teu_empty_ex")

d <- readr::read_csv(grep('t1qtr\\.csv', ff, value=TRUE)) %>% 
  dplyr::mutate(year = substr(quarter, 1, 4)) %>% 
  dplyr::filter(year != max(year)) # drop latest year (assume incomplete)

z <- d %>% 
  dplyr::select(fields) %>% 
  dplyr::group_by(year, port) %>% 
  tidyr::pivot_longer(-c(port, year), names_to='variable') %>% 
  dplyr::group_by(year, port, variable) %>% 
  dplyr::summarise(value_sum=sum(value, na.rm=TRUE),
                   value_mean=mean(value, na.rm=TRUE)) %>% 
  dplyr::mutate(value=ifelse(variable=='pct_40ft', value_mean, value_sum)) %>% 
  dplyr::select(-value_sum, -value_mean) %>% 
  dplyr::filter(port != 'Five ports', variable=='teu_full_im') %>% 
  tidyr::pivot_wider(names_from='variable', values_from='value') %>% 
  dplyr::ungroup() %>% 
  dplyr::filter(year==max(year)) %>% 
  dplyr::left_join(locs) %>% 
  dplyr::arrange(desc(teu_full_im)) %>% 
  dplyr::select(Name=port, PortCode, Longitude, Latitude, Count=teu_full_im)

write.csv(z, '../../project-170607/projects/case_studies/risk_layers/pathway/raw_data/Ports/ports.csv',
          row.names=FALSE)

