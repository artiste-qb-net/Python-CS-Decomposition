Compiling a wrapper with f2py especially on Windows is a non-trivial task, and a journey of trial and error.  I captured some of my eperiences in an answer to this stockoverflow question: https://goo.gl/xir12b

A good description of how to work with f2py can be found at https://sysbio.ioc.ee/projects/f2py2e/usersguide/

For this build we use what is described as option 2 (the smart way) in this user guide. For FORTRAN code as complex as this LAPACK function the 'quick way' without a signature file cannot work, and the 'quick and smart' way would require a lot of patching of the original LAPAC code which we wanted to keep to a minimum. 
