#!/bin/bash

exportdir=$1
projectname=$2

# we have to wait 'a few seconds' for current version of gh-pages to show up 
# ... kind of ugly tho'
sleep 30s
# get the latest version of wkhtmltopdf and untar it
wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
tar xf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz

echo "Generating PDF ..."
generate_pdf()
{
  ./wkhtmltox/bin/wkhtmltopdf --enable-internal-links --enable-external-links https://wiztigers.github.io/${projectname}/ ${exportdir}/${projectname}.pdf
}
# /!\ wkhtml currently exits on error if there are relative links in the html.
#     However, pdf is generated despite this error status.
#     So for now I'll just consider it a success if the output file exists at all.
#  ( @see https://github.com/wkhtmltopdf/wkhtmltopdf/issues/2051 )
! generate_pdf
rm -rf wkhtmltox*
if [ ! -f ${exportdir}/${projectname}.pdf ]; then
  echo ERROR: ${exportdir}/${projectname}.pdf not generated !
  exit 1
fi
