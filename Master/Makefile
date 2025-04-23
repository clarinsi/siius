# Pack for CLARIN.SI distribution:
# - SI-IUS.TEI.zip for digital library
# - SI-IUS.ana.zip for corpus
pack:
	rm -fr SI-IUS.TEI/*
	mkdir -p SI-IUS.TEI/Schema
	cp Docs/README.TEI.txt SI-IUS.TEI/00README.txt
	cp ../CLARIN/???????.xml SI-IUS.TEI
	cp ../Schema/tei_ius* SI-IUS.TEI/Schema
	cp ../docs/tei*.* SI-IUS.TEI/Schema
	rm -f SI-IUS.TEI.zip
	zip -r SI-IUS.TEI.zip SI-IUS.TEI

	rm -fr SI-IUS.ana/*
	mkdir -p SI-IUS.ana/Schema
	cp Docs/README.ana.txt SI-IUS.ana/00README.txt
	cp ../CLARIN/*.txt     SI-IUS.ana
	cp ../CLARIN/*.crp.xml SI-IUS.ana
	cp ../CLARIN/*.ana.xml SI-IUS.ana
	cp ../CLARIN/*.conllu  SI-IUS.ana
	cp ../CLARIN/*.vert    SI-IUS.ana
	cp ../Schema/tei_ius*  SI-IUS.ana/Schema
	cp ../docs/tei*.*      SI-IUS.ana/Schema
	rm -f SI-IUS.ana.zip
	zip -r SI-IUS.ana.zip SI-IUS.ana
