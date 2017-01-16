#!/bin/bash

command -v conda-env >/dev/null 2>&1 || { printf >&2 "Command line tool 'conda-env' is not available.\nThis modul requires Anaconda Python 3.5.\nPlease check if you have Anaconda Python installed!\n\n"; exit 1; }


EXPORTFILE=/tmp/exportfile${RANDOM}

conda-env list | {
  while IFS= read -r line
  do
      if echo x"$line" | grep '*' > /dev/null; then
	  lastline="$line"
      fi 
  done
  for mEach in $lastline
  do
      CondaPath="$mEach"
  done

  # This won't work without the braces.
  echo $CondaPath > $EXPORTFILE
}
CondaPath=$(cat $EXPORTFILE)
read -p "Found Anaconda Python install path '$CondaPath'. Is this correct? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    if [ -d "$CondaPath/bin" ]; then
	# Control will enter here if $DIRECTORY exists.
	echo "Confirmed Python 'bin' directory."
    else
	echo "ERROR: Python 'bin' directory is missing."
	exit 1;
    fi
    if [ -d "$CondaPath/lib" ]; then
	# Control will enter here if $DIRECTORY exists.
	echo "Confirmed Python 'lib' directory."
    else
	echo "ERROR: Python 'lib' directory is missing."
	exit 1;
    fi
    FullPyVersion=$((python -V) 2>&1)
    echo "blub"
    PyVStr=${FullPyVersion%:: *} 
    echo $PyVStr
    if [ "$PyVStr" == "Python 3.5.2 " ]; then 
       echo "Found matching $PyVStr."
    else
	echo "Python 3.5.2 required but detected $PyVStr."
	exit 1;
    fi
    exit 1;
fi
