import xlrd
import csv

def xls_to_csv():
    x =  xlrd.open_workbook('data.xls')
    x1 = x.sheet_by_name('Sheet1')
    csvfile = open('data.csv', 'wb')
    writecsv = csv.writer(csvfile, quoting=csv.QUOTE_ALL)

    for rownum in xrange(sh.nrows):
        writecsv.writerow(x1.row_values(rownum))

    csvfile.close()