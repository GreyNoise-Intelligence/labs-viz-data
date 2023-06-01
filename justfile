kev:
  curl -s -o docs/kev.json https://www.cisa.gov/sites/default/files/feeds/known_exploited_vulnerabilities.json

tags:
  curl -s -o docs/tags.json https://viz.greynoise.io/api/enterprise/v2/meta/metadata

kev-tags:
  Rscript kev-tags-30d.R