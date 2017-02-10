# Python-CS-Decomposition
This repository contains installer scripts for the binary distribution of the Python CS Decomposition module as contained in [LAPACK 3.7.0](https://goo.gl/z2Nzvi), as well as build instructions.

As described in the netlib.org documentation the _cuncsd_ module computes the CS decomposition of an M-by-M partitioned unitary matrix X:
```

                                 [  I  0  0 |  0  0  0 ]
                                 [  0  C  0 |  0 -S  0 ]
     [ X11 | X12 ]   [ U1 |    ] [  0  0  0 |  0  0 -I ] [ V1 |    ]**H
 X = [-----------] = [---------] [---------------------] [---------]   .
     [ X21 | X22 ]   [    | U2 ] [  0  0  0 |  I  0  0 ] [    | V2 ]
                                 [  0  S  0 |  0  C  0 ]
                                 [  0  0  I |  0  0  0 ]

 X11 is P-by-Q. The unitary matrices U1, U2, V1, and V2 are P-by-P,
 (M-P)-by-(M-P), Q-by-Q, and (M-Q)-by-(M-Q), respectively. C and S are
 R-by-R nonnegative diagonal matrices satisfying C^2 + S^2 = I, in
 which R = MIN(P,M-P,Q,M-Q).
```
The binary Python modules, the required shared libraries for the various OS platforms, and the install scripts are contained in the _DIST_ folder.

For the purpose of [artiste-qb.net](http://artiste-qb.net) we only require CS decompositions with square submatrices. I.e. Q=P, M=2P, R=P

We compiled a sub-module for this special case which is provided as a separate shared libary _cuncsd_sq*_.  I.e. if you want to use this less general CS decomposition, you can import it via _cuncsd_sq_ in Python after a successfull installation of this module. 
```python
>>> import cuncsd_sq as csd
>>> print(csd.__doc__)
This module 'cuncsd_sq' is auto-generated with f2py (version:2).
Functions:
  x11,x12,x21,x22,theta,u1,u2,v1t,v2t,work,rwork,iwork,info = cuncsd(p,x11,x12,x21,x22,lwork,lrwork,jobu1='Y',jobu2='Y',jobv1t='Y',jobv2t='Y',trans='T',signs='O',credit=0)
.
...
# It can be invoked like this:
            x11, x12, x21, x22, theta, u1, u2, v1t, v2t, work, rwork, iwork, info =\
                    csd.cuncsd(p, x11, x12, x21, x22, lwork=lw, lrwork=lrw, trans='F', credit=1)
```
Otherwise you have the full range of parameters available with the general module: 
```python
>>> import cuncsd
>>> print(cuncsd.__doc__)
This module 'cuncsd' is auto-generated with f2py (version:2).
Functions:
  x11,x12,x21,x22,theta,u1,u2,v1t,v2t,work,rwork,iwork,info = cuncsd(m,p,q,x11,ldx11,x12,ldx12,x21,ldx21,x22,ldx22,ldu1,ldu2,ldv1t,ldv2t,lwork,lrwork,jobu1='Y',jobu2='Y',jobv1t='Y',jobv2t='Y',trans='T',signs='O',credit=0)
.
```
Please note that this version has only been tested to import error free, but has not been functionally tested like the SQ one, as we only required the latter for our [Qubiter project](https://github.com/artiste-qb-net/qubiter)

## Installation
We plan to bundle this module into a Conda package, but for the time being, the installation is script driven.

To install the module you simply clone this repository, go to the _DIST_ folder that corresponds to your OS and execute the install script.

### UNIX like systems

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
### Windows

Please note, on Windows we only support 32bit Python 3.4 natively with this module.  If you have Win 10 you can use a 64bit environment via the Bash for Windows feature as described in [this stackoverflow thread](https://goo.gl/LKSNmd). At the time of writing this feature is no longer restricted by MS to developer previews. (To enable it see [these instructions](https://goo.gl/a1b7vK)). If you install the current 64bit Anaconda distribution for Linux into this environment, then you can use the Linux install script to deploy the cuncsd module.

Due to limited compile support from Microsoft, 32bit native Windows modules can only be build for older Python versions. No recent Anaconda distribution will work with our modules.  Rather the newest version that we were able to compile for was [Python 3.4.4](https://www.python.org/ftp/python/3.4.4/python-3.4.4.msi) (v3.4.4:737efcadf5a6, Dec 20 2015, 19:28:18) [MSC v.1600 32 bit (Intel)] for win32.

You can start the installation by double clicking on the Install_Py_Module.bat batch file and a Window will open that prompts you to confirm or enter a path:
```
C:\Projects\cuncsd-install-script>powershell -ExecutionPolicy ByPass -File .\Install_Py_Module.ps1   & pause
Found Default Value For Python Install Path:  C:\Python34
Is this the correct Python install path? [y,n]: n
Please enter the correct Python install path: C:\Python34_4
Executing: copy lib\* C:\Python34_4\DLLS
Executing: copy cuncsd.pyd* C:\Python34_4\DLLS
Press any key to continue . . .
```
This script is not very sophisticated, and performs a straight copy based on the path without any further checks.

## Troubleshooting and Requirements

### UNIX like systems

The install script will exit with the following errors if it cannot execute *conda-env list* to check for python environments. Even if you have a working Python environment this can happen if no path to Anaconda exectables have been added to the $PATH variable. In this case adding it to $PATH manualy will rectify the problem:

```bash
> bash-3.2$ export PATH=/Users/quax/anaconda/bin/:$PATH 
```
If you get write errors when executing this script check the permissions on your Anaconda Python install path. If your Python environment was installed globally for all users on your machine, you will need to execute the install script as superuser:
```bash
>bash-3.2$ sudo ./install_py_module.sh 
```
The install script will abort if it cannot detect **a Python 3.5.2 |Anaconda 4.2.0 (x86_64) or newer environment ***.

Although unsupported and untested, it seems the module can be used with earlier Python 3 versions.  In this case you can try to copy the _cuncsd-*_ module and contents of the lib folder to a location that is on your python path. Please refer to the [Python documentation](https://docs.python.org/3/library/sys.html#sys.path) to learn how this Path is set and determined.

Depending on you Linux dsitribution you may not have a BLAS library:

```python
Python 3.5.2 |Anaconda 4.2.0 (64-bit)| (default, Jul  2 2016, 17:53:06) 
[GCC 4.4.7 20120313 (Red Hat 4.4.7-1)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import cuncsd
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ImportError: libblas.so.3: cannot open shared object file: No such file or directory
>>> 
```
If you have a Readhead/CentOS based dsitribution use the yum package manager to install the missing library: 

```bash
[ec2-user@ip-172-31-28-29 ~]$ sudo yum install libblas```
```
On Ubuntu/Debian 
```
sudo apt-get install libatlas-base-dev
```

### Windows

You will see errors like the following if you enter an non existing install path:
```
copy : Could not find a part of the path 'C:\to_nowhere\DLLS'.
At C:\Projects\cuncsd-install-script\Install_Py_Module.ps1:66 char:1
+ copy lib\* $DefaultVal\DLLS
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (:) [Copy-Item], DirectoryNotFoundException
    + FullyQualifiedErrorId : System.IO.DirectoryNotFoundException,Microsoft.PowerShell.Commands.CopyItemCommand
```
You will also encounter a copy failure if you don't have write access to the python install folder, in which case you should try to run the batch file as administrator or adjust the folders permissions.

## License Disclaimer

Please note, the included Fortran files originated with [the LAPACK project](http://www.netlib.org/lapack/) (v3.7.0) and are governed by the license given in the LAPACK_license.txt file.
