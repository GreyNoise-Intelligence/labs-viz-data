# nolint start
library(dplyr)
library(tidyr)

kev <- jsonlite::fromJSON("docs/kev.json")$vulnerabilities

tags <- jsonlite::fromJSON("docs/tags.json")$metadata

tags <- dplyr::rename(tags, c("cveID" = "cves"))
tags <- tidyr::unnest(tags, cveID)

kev_tags <- tags[tags$cveID %in% kev$cveID, ]
kev_tags$activity_url <- sprintf("https://viz.greynoise.io/api/v3/tags/%s/activity?days=30&granularity=24h", kev_tags$id)

kev_tags |> 
	dplyr::mutate(
		activity = lapply(activity_url, function(.url) jsonlite::fromJSON(.url)),
		series = lapply(activity, function(.x) { .x$activity[[1]] })
	) |> 
	dplyr::select(name, id, slug, series) |> 
	tidyr::unnest(series) |> 
	dplyr::mutate(
		start = as.Date(start)
	) |> 
	dplyr::select(
		id, slug, name, start, activeIps
	) -> kev_tags

writeLines(jsonlite::toJSON(kev_tags), "docs/kev-tags-30d.json")
# nolint end
