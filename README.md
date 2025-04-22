# Digital library and corpus of older Slovenian legal texts SI-IUS

This project contains the TEI encoded siIUS digital library and the scripts to
convert it to a linguistically annotated corpus and pack it for upload to the
CLARIN.SI repository at [http://hdl.handle.net/11356/2026](http://hdl.handle.net/11356/2026).

The complete workflow is run via the top level [Makefile](Makefile).
The source texts in their complex TEI encoding which are available from
[https://dihur.si/si-ius/](https://dihur.si/si-ius/) and here stored in the
[DARIAH/](DARIAH/) directory, are first modified (esp. their teiHeader is initialised)
and stored in the [CLARIN/](CLARIN/) directory, as are all output files.

The encoding of the TEI encoded files is then simplified, plain text is extracted from them,
and these are then linguistically annotated with CLASSLA, giving CoNLL-U files. Finally,
the CoNLL-U is converted to TEI and merged with the simpilified TEI files (CLARIN/*.crp.xml)
resulting in the final TEI encoded and linguistically annotated files (CLARIN/*.ana.xml).
These TEI/XML encoded files are then also down-converted into vertical format that are used
for mounting on CQP-compatbile concordancers.
Note that all linguistically annotated files are, due to their size, gitignored but are
available on the CLARIN.SI repository.

The compilation of the SI-IUS digital library was supported by DARIAH-SI,
and the compliation of the SI-IUS annotated corpus by CLARIN.SI.

