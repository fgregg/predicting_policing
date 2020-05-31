import csv
import sys
import itertools

expected_dates = set(range(2001, 2020))

reader = csv.DictReader(sys.stdin)
writer = csv.DictWriter(sys.stdout,
                        fieldnames=reader.fieldnames,
                        extrasaction='ignore')
writer.writeheader()

grouper = lambda row: (row.get('District'), row.get('Beat'), row.get('IUCR'))

for k, grouped_rows in itertools.groupby(reader, key=grouper):
    grouped_rows = list(grouped_rows)
    existing_dates = {int(row['Date']) for row in grouped_rows}
    missing_dates = expected_dates - existing_dates
    fixed = dict(zip(('District', 'Beat', 'IUCR'), k))
    for date in missing_dates:
        row = {'Date': date, 'count': 0}
        row.update(fixed)
        grouped_rows.append(row)
    writer.writerows(grouped_rows)
    
    
