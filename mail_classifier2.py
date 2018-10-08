import csv
import operator
dict = {}

FILENAME = "data.csv"
count = 0   # number of processed strings in csv file

with open(FILENAME, "r", newline="") as file:
    read = csv.reader(file)

    print("scanning csv file...")
    for row in read:
        if row:
            if count % 50000 == 0:  # print statistics
                print(count, "rows checked")
            count += 1

            # if row contains no commas
            if len(row) == 1:
                headers = row[0].split(";")

            # if string is separated by single comma
            elif len(row) == 2:
                headers_before = row[0].split(";")
                headers_after =  row[1].split(";")
                troubled_header = headers_before[len(headers_before)-1] + ',' + headers_after[0]

                headers[0] = headers_before[0]
                headers[1] = troubled_header
                for i in range (1, len(headers_after)):
                    headers[i+1] = headers_after[i]

            # for counting keys in dictionary
            counter = 0
            hashcode = headers[1].strip() + " " +  headers[2] + " "  + headers[3] + " "  + headers[4]

            # is combination of headers in dict or not
            if len(dict) == 0:
                dict[hashcode] = 0
            for key in dict:
                if key == hashcode:
                    dict[key] += 1
                    break
                else:
                    counter += 1

            # add combination of headers to dict if it's not there
            if counter == len(dict) and headers[0] != "rate":
                if int(headers[0]) >= 100:
                    dict[hashcode] = 1
    print("all", count, "rows checked. Writing logs...")

    # write to file reverse sorted list of headers
    # where we can see most often used address
    log = open("log.txt", 'w')
    for key in dict:
        inverse = [(value, key) for key, value in dict.items()]
        if max(inverse)[0] >= 100:
            stri = str(max(inverse)[0]) + " " + max(inverse)[1] + "\n"
            log.write(stri)
        dict[max(inverse)[1]] = 0
    print("log file saved as log.txt in current directory.")
    log.close()