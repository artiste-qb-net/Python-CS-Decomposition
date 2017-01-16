# Python-CS-Decomposition
This repository contains installer scripts for the binary distribution of the Python CS Decomposition module, as well as build instructions.

The binary Python modules as well as required shared libraries for the platforms, and the install scripts are contained in the DIST folder.

To install the module you can simply clone this repository, go to the DIST folder that corresponds to your OS and execute the install script:
```bash
bash-3.2$ cd /tmp
bash-3.2$ git clone https://github.com/artiste-qb-net/Python-CS-Decomposition.git
Cloning into 'Python-CS-Decomposition'...
remote: Counting objects: 105, done.
remote: Compressing objects: 100% (92/92), done.
remote: Total 105 (delta 41), reused 55 (delta 11), pack-reused 0
Receiving objects: 100% (105/105), 8.55 MiB | 259.00 KiB/s, done.
Resolving deltas: 100% (41/41), done.
bash-3.2$ cd Python-CS-Decomposition/DIST/OSX
bash-3.2$ ./install_py_module.sh 
Found Anaconda Python install path '/Users/quax/anaconda'. Is this correct? [Y|n]

Confirmed Python '/Users/quax/anaconda/bin' directory.
Confirmed Python '/Users/quax/anaconda/lib' directory.
Found matching Python 3.5.2 .
Confirmed that /Users/quax/anaconda/lib/python3.5 is writeable.
**** Successfully installed the cuncsd module to /Users/quax/anaconda/lib/python3.5 ****
bash-3.2$ 
```
## Troubleshooting and Requirements

### UNIX like systems

The install script will exit with the following errors if it can not execute *conda-env list* to check for python environments. This can happen even if you have a working Python environment, if no path to Anaconda binaries has been added to the $PATH variable. In this case adding it to the $PATH manualy will rectify the problem:

```bash
> bash-3.2$ export PATH=/Users/quax/anaconda/bin/:$PATH 
```
If you get write errors when executing this script check if you have write accedd to your Anaconda path. If this Python was installed for globally for all users on your machine you will need to execute the install script as suoeruser:
```bash
>bash-3.2$ sudo ./install_py_module.sh 
```
The istall script will abort if it cannot detect a Python 3.5.2 |Anaconda 4.2.0 (x86_64) environment.

Also unsupported and untested it seems the module can be used with earlier Python 3 versions.  In this case you can try to copy the cuncsd-* module and contents of the lib folder to a location that is on your python path. Please refer to the [Python documentation](https://docs.python.org/3/library/sys.html#sys.path) to learn how this Path is set and determined.  

### Windows

Please note on Windows we only support 32bit Python 3.4 natively with this module.  If you have Win 10 you can use a 64bit environment via the Bash for Windows feature as described in [this stackoverflow thread](https://goo.gl/LKSNmd). At the time of writing this feature is no longer restricted by MS to developer previews. ([To enable it see these instructions](https://goo.gl/a1b7vK)).

On the UNIX based platforms we only support and tested the modules with the, as of writting, current Python 3 Anaconda 64bit distribution i.e. Python 3.5.2 |Anaconda 4.2.0 (x86_64). Although we noticed the module also loads with earlier 64bit Anaconda Python 3 versions.

Please note, the included Fortran files originated with [the LAPACK project](http://www.netlib.org/lapack/) (v3.7.0) and are governed by the license given in the LAPACK_license.txt file.
