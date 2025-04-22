all:	schema docs

PARAMS = --localsource=p5subset.xml tei_ius_schema.xml
schema:	val-odd
	Stylesheets/bin/oddtorng  ${PARAMS} tei_ius.rng
	Stylesheets/bin/teitornc  ${PARAMS} tei_ius.rnc
	rm tei_ius.rnc.rng

val-odd:
	$j tei_odds.rng tei_ius_schema.xml

H = /project/corpora/TEI-schema/bin/
docs:	val-odd
	Stylesheets/bin/teitohtml --profiledir=$H --profile=profile --odd ${PARAMS} \
	../docs/tei_ius_doc.html
	cp tei.css ../docs
	cp tei-print.css ../docs

j = java -jar /usr/share/java/jing.jar
s = java -jar /usr/share/java/saxon.jar
