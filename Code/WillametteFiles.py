# import the modules I'm gonna need
import glob, string, csv, os

# input the files to use
inputdirectory = 'C:\Users\Michele\Documents\Research\CurvilinearAnisotropy\WillametteRiver\willamette_elevations\willamette\cross_section_elevation\\'
outputfile1 = 'C:\Users\Michele\Documents\Research\CurvilinearAnisotropy\WillametteRiver\willamette_elevations\willamette\PythonOutput\\WillametteCrossSection_sensor1.txt'
#outputfile2 = 'C:\Documents and Settings\Michele Tobias\My Documents\Davis\Research\GIS Data\DataOutput\\SBV_average.txt'
filemake = open(outputfile1,'w')
filemake.close()
#filemake = open(outputfile2,'w')
#filemake.close()
data = []
fulldata = []
#add *.txt to the end of the inputdirectory
inputdirectory += '*.txt.1'


#---------Copying the $GPGGA Lines to their own File--------------
# find the text files you need to work with
textfiles = glob.glob(inputdirectory)
#print textfiles

#for writing the column names at the top of the output file
columnnames = ['Easting\tNorthing\tBed_Elevation']

#finding the lines I need and writing them to the output file under the column names
writer = csv.writer(open(outputfile1, 'w+'))
writer.writerow(columnnames)

#print textfiles

for i in textfiles:
    #shortdoc = os.path.basename(i)
    #point = shortdoc.rstrip(".txt")
    #point = shortdoc[shortdoc.find(' ')+1: shortdoc.find('.')]
    reader = csv.reader(open(i, "r"))
    data = [row for row in reader]
    rownum=0
    for j in data:
        if rownum >4:
            writer.writerow(j)
            #fulldata.append(j)
        rownum += 1

        #j.append(point)
        #if j[0] != '#':
        #    writer.writerow(j)
         #   fulldata.append(j)
          #  #print j
        #rownum += 1
print 'Finished!'




