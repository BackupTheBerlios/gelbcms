#!/bin/bash

# This script copies the CVS server contents into the Zope system.
# It can be run on any machine, but might be most useful when run on
# the Zope-server's machine.
#
# 2004-02-25, Jens Gulden

# --- BUG: FTP-Uploads innerhalb von Control_Panel noch nicht ok

if [ "$1" = "" ]; then
echo "usage: cvs2zope <zope-passwd>"
exit 1;
fi

#CVSROOT=:pserver:cvs@jensgulden.de:/var/local/cvsrep
CVSROOT=:pserver:anonymous@cvs.gelbcms.berlios.de:/cvsroot/gelbcms
CVSMODULE=gelbcms

ZOPESERVER=jensgulden.de
ZOPEUSER=manager
ZOPEPASSWD=$1
ZOPEFTPPORT=9021
ZOPEFTPROOT=.

TMP=/tmp
TMPEXPORT=$TMP/cvs2zope

# --- export CVS contents into tmp dir

echo "--- cvs2zope transfer ---"
echo "temporary export dir: $TMPEXPORT"

rm -r $TMPEXPORT
mkdir $TMPEXPORT
cd $TMPEXPORT

echo "--- getting CVS contents..."

cvs -d $CVSROOT login
cvs -d $CVSROOT export -D now $CVSMODULE

cd $CVSMODULE

# --- copy tmp dir contents to Zope server via FTP
# (assumes that the directory structure already exists)

echo "--- uploading via FTP..."

ftp -v -i -p -n $ZOPESERVER $ZOPEFTPPORT <<SCRIPTEND
quote USER $ZOPEUSER
quote PASS $ZOPEPASSWD
binary
cd $ZOPEFTPROOT
mput `find -printf "%p "`
quit
SCRIPTEND

#ftp -n $ZOPESERVER <<SCRIPTEND
#quote USER $ZOPEUSER
#quote PASS $ZOPEPASSWD
#cd $ZOPEFTPROOT
#mput `find -printf "%p "`
#quit
#SCRIPTEND
