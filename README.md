# Digital library and corpus of older Slovenian legal texts SI-IUS

This project contains the TEI encoded siIUS digital library and the scripts to
convert it to a linguistically annotated corpus and pack it for upload to the
CLARIN.SI repository at [http://hdl.handle.net/11356/2026](http://hdl.handle.net/11356/2026).

The complete workflow is run via the top level [Makefile](Makefile).
The source texts in their complex TEI encoding which are available from
[https://dihur.si/si-ius/](https://dihur.si/si-ius/) and here stored in the
[DARIAH/](DARIAH/) directory, are first modified (esp. their teiHeader is initialised)
and stored in the [CLARIN/](CLARIN/) directory, as are all output files.

....

The complete Git sources are stored in the gitignored GitGroup/ directory,
just the TEI XML documents in the DARIAH/ directory, 
the conversion scripts in the bin/ directory (and the Makefile),
and the output corpus files in the CLARIN/ directory.

As further work it will be PoS tagged, and lemmatised with annotated
term candidates, converted to vertical file and made available under
the CLARIN.SI concordancers.




The compilation of the siIUS digital library is supported by
DARIAH-SI, and the compliation of the siIUS annotated corpus by
CLARIN.SI.

