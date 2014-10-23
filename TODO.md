# TODO

[ ] Tidy up script

Tidy up script for better code visibility and easy to use.  Probably
trim all the script into just one file.

[ ] Remove UAC invocation.

UAC invocation is too complex, no need to implement this.  Just do a
quick check whether the shell invoked has administrative privilege or
not.  Quit if the shell is not invoked as administrator.

[ ] Simple OS version detection

Update project wifi-cmd to use a general regular expression for OS
version detection.  Use `findstr` instead of `find`, which has better
regular expression engine.

```
ver | findstr /R 6.[1-3]
```

All `find` use should be replaced with `findstr`.

[ ] Provide good readme file.

This is optional. I am still thinking about it.  README file should give
enough information to understand how the script works.  It should give a
good explanation about running the script.

More detailed information should come with a wiki page, accessible via
github wiki.

