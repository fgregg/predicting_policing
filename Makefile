crime_reports.csv :
	wget -O $@ https://data.cityofchicago.org/api/views/ijzp-q8t2/rows.csv?accessType=DOWNLOAD

crime_reports.sqlite : crime_reports.sql crime_reports.csv
	sqlite3 $@ -init "" $<

yearly_counts.csv : crime_reports.sqlite
	sqlite3 $< -csv -header \
            "select count(*) as count, \
                    substr(Date, 7, 4) as Date, \
                    \"Primary Type\", District \
             from crime_reports \
             where substr(Date, 7, 4) < '2020' \
             group by substr(Date, 7, 4), \"Primary Type\", District \
             order by District, \"Primary Type\"" | python scripts/fill_in_zeros.py > $@

.PHONY: analysis
analysis : yearly_counts.csv
	R analysis.R
