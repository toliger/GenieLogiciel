#!/bin/bash

exportdir=$1
stylesdir="asciidoctor-stylesheet-factory"
stylename=$2

# clone asciidoctor stylesheet (we are dependent on some these)
git clone https://github.com/asciidoctor/asciidoctor-stylesheet-factory.git ${stylesdir}
# compile stylesheets
echo "Generating stylesheets ..."
cd ${stylesdir} && compass compile sass/${stylename}.scss && cd -
# copy resources and compiled css to export directory
mkdir -p ${exportdir}
cp README.adoc ${exportdir}
cp -r resources ${exportdir}/resources
cp "${stylesdir}/stylesheets/${stylename}.css" "${exportdir}/${stylename}.css"
if [ -e "${stylesdir}/images/${stylename}" ]; then
  mkdir -p "${exportdir}/images";
  cp -r "${stylesdir}/images/${stylename}" "${exportdir}/images/${stylename}";
  sed -i.tmp  -e "s/..\/images\/$stylename/.\/images\/$stylename/g" "${exportdir}/${stylename}.css";
  rm "${exportdir}/${stylename}.css.tmp";
fi
# generate HTML
echo "Generating HTML ..."
asciidoctor     core.adoc -a linkcss -a stylesheet="${stylename}.css" -o ${exportdir}/index.html
# cleanup what was cloned
rm -rf ${stylesdir}
