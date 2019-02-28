BASEDIR=$PWD

msgfmt -o $BASEDIR/idiomas/en/LC_MESSAGES/principal.mo $BASEDIR/idiomas/po/principal_en.po
msgfmt -o $BASEDIR/idiomas/es/LC_MESSAGES/principal.mo $BASEDIR/idiomas/po/principal_es.po

msgfmt -o $BASEDIR/idiomas/en/LC_MESSAGES/certificados.mo $BASEDIR/idiomas/po/certificados_en.po
msgfmt -o $BASEDIR/idiomas/es/LC_MESSAGES/certificados.mo $BASEDIR/idiomas/po/certificados_es.po
