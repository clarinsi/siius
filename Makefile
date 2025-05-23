### From DARIAH from-Word generated digital library in TEI
### to CLARIN linguistically annotated and published corpus

#################################################
## System variables / location of prerequisites
p = parallel --gnu --halt 0 --jobs 5
j = java -jar /usr/share/java/jing.jar
s = java -jar /usr/share/java/saxon-he-10.2.jar
classla = /usr/local/classla-venv
venv = ${classla}/bin/activate
python = ${classla}/bin/python

### Test run on one file:
# Annotate with CLASSLA
test-ana:
	source ${venv}; ${python} bin/tag.py < CLARIN/SlP1920.txt > CLARIN/SlP1920.conllu

# Run everything off line
nohup:
	nohup time make all > Master/process.log &
# Active workflow
all:	dariah2tei val-tei html tei2crp val-crp text ana conllu2tei val-ana cqp vert pack 
# Complete workflow
xall:	val-origin dariah2tei val-tei html tei2crp val-crp text ana conllu2tei val-ana cqp vert pack

# Make two zip files for CLARIN.SI repo
pack:
	cd Master; make pack

## Prepare for concordancers outside of git
## in clarinsi-cqp/config/general.tbl:
## siius monolingual new-tantra.ijs.si /project/corpora/SI-IUS/CQP/siius.vert.gz
CQPDIR = /project/corpora/SI-IUS/CQP/
vert:
	cat CLARIN/*.vert > ${CQPDIR}/siius.vert
	rm -f ${CQPDIR}/siius.vert.gz
	gzip ${CQPDIR}/siius.vert

## Prepare vertical files
l = bin/polish-ud.pl
cqp:
	$s -xsl:bin/siius2vert.xsl CLARIN/CPZ1906.ana.xml | $l > CLARIN/CPZ1906.vert
	$s -xsl:bin/siius2vert.xsl CLARIN/ODZ1928.ana.xml | $l > CLARIN/ODZ1928.vert
	$s -xsl:bin/siius2vert.xsl CLARIN/SlP1917.ana.xml | $l > CLARIN/SlP1917.vert
	$s -xsl:bin/siius2vert.xsl CLARIN/SlP1920.ana.xml | $l > CLARIN/SlP1920.vert
	$s -xsl:bin/siius2vert.xsl CLARIN/UsV1910.ana.xml | $l > CLARIN/UsV1910.vert
	$s -xsl:bin/siius2vert.xsl CLARIN/ZKP1890.ana.xml | $l > CLARIN/ZKP1890.vert
	$s -xsl:bin/siius2vert.xsl CLARIN/ZKP1929.ana.xml | $l > CLARIN/ZKP1929.vert
val-ana:
	-$j Schema/tei_ius.rng CLARIN/*.ana.xml
	-$s -xsl:bin/check-links.xsl CLARIN/CPZ1906.ana.xml
	-$s -xsl:bin/check-links.xsl CLARIN/ODZ1928.ana.xml
	-$s -xsl:bin/check-links.xsl CLARIN/SlP1917.ana.xml
	-$s -xsl:bin/check-links.xsl CLARIN/SlP1920.ana.xml
	-$s -xsl:bin/check-links.xsl CLARIN/UsV1910.ana.xml
	-$s -xsl:bin/check-links.xsl CLARIN/ZKP1890.ana.xml
	-$s -xsl:bin/check-links.xsl CLARIN/ZKP1929.ana.xml
conllu2tei:
	bin/conllu2tei.pl CLARIN/CPZ1906.conllu < CLARIN/CPZ1906.crp.xml > CLARIN/CPZ1906.ana.xml
	bin/conllu2tei.pl CLARIN/ODZ1928.conllu < CLARIN/ODZ1928.crp.xml > CLARIN/ODZ1928.ana.xml
	bin/conllu2tei.pl CLARIN/SlP1917.conllu < CLARIN/SlP1917.crp.xml > CLARIN/SlP1917.ana.xml
	bin/conllu2tei.pl CLARIN/SlP1920.conllu < CLARIN/SlP1920.crp.xml > CLARIN/SlP1920.ana.xml
	bin/conllu2tei.pl CLARIN/UsV1910.conllu < CLARIN/UsV1910.crp.xml > CLARIN/UsV1910.ana.xml
	bin/conllu2tei.pl CLARIN/ZKP1890.conllu < CLARIN/ZKP1890.crp.xml > CLARIN/ZKP1890.ana.xml
	bin/conllu2tei.pl CLARIN/ZKP1929.conllu < CLARIN/ZKP1929.crp.xml > CLARIN/ZKP1929.ana.xml
ana:
	source ${venv}; ${python} bin/tag.py < CLARIN/CPZ1906.txt > CLARIN/CPZ1906.conllu
	source ${venv}; ${python} bin/tag.py < CLARIN/ODZ1928.txt > CLARIN/ODZ1928.conllu
	source ${venv}; ${python} bin/tag.py < CLARIN/SlP1917.txt > CLARIN/SlP1917.conllu
	source ${venv}; ${python} bin/tag.py < CLARIN/SlP1920.txt > CLARIN/SlP1920.conllu
	source ${venv}; ${python} bin/tag.py < CLARIN/UsV1910.txt > CLARIN/UsV1910.conllu
	source ${venv}; ${python} bin/tag.py < CLARIN/ZKP1890.txt > CLARIN/ZKP1890.conllu
	source ${venv}; ${python} bin/tag.py < CLARIN/ZKP1929.txt > CLARIN/ZKP1929.conllu
text:
	$s -xsl:bin/ana2txt.xsl CLARIN/CPZ1906.crp.xml > CLARIN/CPZ1906.txt
	$s -xsl:bin/ana2txt.xsl CLARIN/ODZ1928.crp.xml > CLARIN/ODZ1928.txt
	$s -xsl:bin/ana2txt.xsl CLARIN/SlP1917.crp.xml > CLARIN/SlP1917.txt
	$s -xsl:bin/ana2txt.xsl CLARIN/SlP1920.crp.xml > CLARIN/SlP1920.txt
	$s -xsl:bin/ana2txt.xsl CLARIN/UsV1910.crp.xml > CLARIN/UsV1910.txt
	$s -xsl:bin/ana2txt.xsl CLARIN/ZKP1890.crp.xml > CLARIN/ZKP1890.txt
	$s -xsl:bin/ana2txt.xsl CLARIN/ZKP1929.crp.xml > CLARIN/ZKP1929.txt
val-crp:
	-$j Schema/tei_ius.rng CLARIN/*.crp.xml
tei2crp:
	$s -xsl:bin/siius2crp.xsl CLARIN/CPZ1906.xml > CLARIN/CPZ1906.crp.xml
	$s -xsl:bin/siius2crp.xsl CLARIN/ODZ1928.xml > CLARIN/ODZ1928.crp.xml
	$s -xsl:bin/siius2crp.xsl CLARIN/SlP1917.xml > CLARIN/SlP1917.crp.xml
	$s -xsl:bin/siius2crp.xsl CLARIN/SlP1920.xml > CLARIN/SlP1920.crp.xml
	$s -xsl:bin/siius2crp.xsl CLARIN/UsV1910.xml > CLARIN/UsV1910.crp.xml
	$s -xsl:bin/siius2crp.xsl CLARIN/ZKP1890.xml > CLARIN/ZKP1890.crp.xml
	$s -xsl:bin/siius2crp.xsl CLARIN/ZKP1929.xml > CLARIN/ZKP1929.crp.xml

S = bin/Stylesheets/bin/teitohtml --profiledir=/project/corpora/SI-IUS/siius/bin --profile=profile --localsource=bin/p5subset.xml 
html:	
	$S CLARIN/CPZ1906.xml docs/CPZ1906.html
	$S CLARIN/ODZ1928.xml docs/ODZ1928.html
	$S CLARIN/SlP1917.xml docs/SlP1917.html
	$S CLARIN/SlP1920.xml docs/SlP1920.html
	$S CLARIN/UsV1910.xml docs/UsV1910.html
	$S CLARIN/ZKP1890.xml docs/ZKP1890.html
	$S CLARIN/ZKP1929.xml docs/ZKP1929.html
val-tei:
	-$j Schema/tei_ius.rng CLARIN/*.xml
pdfs:
	cp DARIAH/cpz/A1CPP1906.pdf CLARIN/CPZ1906.pdf
	cp DARIAH/odz/Obcni_drzavljanski_zakonik_novo.pdf CLARIN/ODZ1928.pdf
	cp DARIAH/slovenskipravnik1917/Slovenski_URN_NBN_SI_doc-4RRLU5S5.pdf CLARIN/SlP1917-1.pdf
	cp DARIAH/slovenskipravnik1917/Slovenski_URN_NBN_SI_doc-WVXGJ01V.pdf CLARIN/SlP1917-2.pdf
	cp DARIAH/slovenskipravnik1920/id-4695299.pdf CLARIN/SlP1920.pdf
	cp DARIAH/ustvol/A1UstVol1860.pdf CLARIN/UsV1910.pdf
	cp DARIAH/zkp1890/A1ZKP1890.pdf CLARIN/ZKP1890.pdf
	cp DARIAH/zkp1929/id-243499_1929.pdf CLARIN/ZKP1929.pdf

dariah2tei:
	$s id=CPZ1906 -xsl:bin/siius2tei.xsl DARIAH/cpz/CPZ.xml > CLARIN/CPZ1906.xml
	$s id=ODZ1928 -xsl:bin/siius2tei.xsl DARIAH/odz/ODZ.xml > CLARIN/ODZ1928.xml
	$s id=SlP1917 -xsl:bin/siius2tei.xsl DARIAH/slovenskipravnik1917/SlPr1917.xml > CLARIN/SlP1917.xml
	$s id=SlP1920 -xsl:bin/siius2tei.xsl DARIAH/slovenskipravnik1920/SlPr1920.xml > CLARIN/SlP1920.xml
	$s id=UsV1910 -xsl:bin/siius2tei.xsl DARIAH/ustvol/UstVol.xml > CLARIN/UsV1910.xml
	$s id=ZKP1890 -xsl:bin/siius2tei.xsl DARIAH/zkp1890/ZKP.xml > CLARIN/ZKP1890.xml
	$s id=ZKP1929 -xsl:bin/siius2tei.xsl DARIAH/zkp1929/ZKP1929.xml > CLARIN/ZKP1929.xml
val-origin:
	-$j Schema/tei_ius.rng DARIAH/cpz/CPZ.xml
	-$j Schema/tei_ius.rng DARIAH/odz/ODZ.xml
	-$j Schema/tei_ius.rng DARIAH/slovenskipravnik1917/SlPr1917.xml
	-$j Schema/tei_ius.rng DARIAH/slovenskipravnik1920/SlPr1920.xml
	-$j Schema/tei_ius.rng DARIAH/ustvol/UstVol.xml
	-$j Schema/tei_ius.rng DARIAH/zkp1890/ZKP.xml
	-$j Schema/tei_ius.rng DARIAH/zkp1929/ZKP1929.xml
