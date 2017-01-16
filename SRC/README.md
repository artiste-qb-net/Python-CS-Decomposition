Compiling a wrapper with *f2py* especially on Windows is a non-trivial task, and a journey of trial and error.  I captured some of my eperiences in an answer to [this stockoverflow question.](https://goo.gl/xir12b)

A good description of how to work with f2py can be found at [this user guide.](https://sysbio.ioc.ee/projects/f2py2e/usersguide)

For this build we use what is described as option 2 in this guide (the "smart" way). For FORTRAN code as complex as a typical LAPACK function the "quick" way without a signature file cannot work, and the "quick and smart" way would require a lot of patching of the original LAPAC code, which we wanted to keep to a minimum. 

A f2py compile statement then looked like this (in this case for OSX):
```bash
f2py -c cuncsd.pyf cuncsd.f -L/home/quax/Projects/lapack-3.7.0 -llapack -lblaslib -ltmglib 
```
The -L flag tells the compiler where to find the lapack, blaslib and tmglib libraries.  On OSX it was required to compile these from [the latest LAPACK source](http://www.netlib.org/lapack/lapack-3.7.0.tgz).

On an Ubuntu based Linux distros this is not necessary as these libs can be installed via apt-get:
```bash
sudo apt-get install libblas-dev liblapack-dev libtmglib-dev
```
Hence on Linux the -L flag is not required and the compile statement is simply:
```bash
f2py -c cuncsd.pyf cuncsd.f -llapack -lblas -ltmglib
```
