# Python-CS-Decomposition
This repository contains installer scripts for the binary distribution of the Python CS Decomposition module as well as build instructions.

The binary Python modules as well as required shared libaries for the plattforms are contained in the DIST folder.

Please note on Windows we only support 32bit Python 3.4 natively with this module.  If you have Win 10 you cam use a 64bit environment via the Bash for Windows feature as described in this stockoverflow thread (https://goo.gl/8nb52R). At the time of writing this feature is no longer restricted by MS to developers. (To enable it see these instructions: goo.gl/a1b7vK).

On the UNIX based plattforms we only support and tested the modules with the, as of writting, current Python 3 Anaconda 64bit distribution i.e. Python 3.5.2 |Anaconda 4.2.0 (x86_64). Although we noticed the module also loads with earlier 64bit Anaconda Python 3 versions.

Please note, the included Fortran files originated with the LAPACK 3.7.0 project (http://www.netlib.org/lapack/) and are governed by the license given in the LAPACK_license.txt file.
