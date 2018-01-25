#!/bin/bash

exportdir=$1
stylesdir="asciidoctor-stylesheet-factory"
stylename=$2

# clone asciidoctor stylesheet (we are dependent on some these)
git clone https://github.com/asciidoctor/asciidoctor-stylesheet-factory.git ${stylesdir}
# compile stylesheets
echo "Generating stylesheets ..."
cd ${stylesdir} && compass compile && cd -
# copy resources and compiled css to export directory
mkdir ${exportdir}
cp -r resources ${exportdir}/resources
if [ -e "${stylesdir}/images/${stylename}" ]; then mkdir -p "${exportdir}/images" && cp -r "${stylesdir}/images/${stylename}" "${exportdir}/images/${stylename}"; fi
cp "${stylesdir}/stylesheets/${stylename}.css" "${exportdir}/${stylename}.css"
# generate HTML
echo "Generating HTML ..."
asciidoctor     core.adoc -a linkcss -a stylesheet="${stylename}.css" -o ${exportdir}/index.html
# cleanup what was cloned
rm -rf ${stylesdir}
