***Quickly & forcefully manage extra JDKs in base R
Simplify rJava woes***
```
# get this script:
wget https://raw.githubusercontent.com/Jesssullivan/rJDKmanager/master/JDKmanager.R
```
- - -
rJava is depended upon by lots of libraries-  XLConnect, OpenStreetMap, many db connectors and is often needed while scripting with GDAL.

```
library(XLConnect)   # YMMV
```
Errors while importing a library with depending on a JDK are many, but can (usually) be resolved by reconfiguring the version listed somewhere in the error.  

On mac OSX (on Mojave at least), check what you have installed here- (as admin, this is a system path) :
```
sudo ls  "/Library/Java/JavaVirtualMachines/ 
```
I seem to usually have at least half a dozen or more versions in there, between Oracle and openJDK.  Being Java, these are basically sandboxed as JVMs and are will not get in each others way. 

However...

Unlike JDK configuration for just about everything else, aliasing or exporting a specific release to $PATH will not cut it in R.  The shell command to reconfigure for R-
``` 
sudo R CMD javareconf
```
...seems to always choose the wrong JDK.  Renaming, hiding, otherwise trying to explain to R the one I want (lib XLConnect currently wants none other than Oracle 11.0.1) is futile.  
*The end-all solution for me is usually to temporarily move other JDKs elsewhere.*
This is not difficult to do now and again, but keeping a CLI totally in R for moving / replacing JDKs makes for organized scripting.  

```
 JDKmanager help: 
 (args are not case sensitive) 
 (usage: `sudo rscript JDKmanager.R help`) 

 list    :: prints contents of default JDK path and removed JDK path 
 reset   :: move all JDKs in removed JDK path back to default JDK path 
 config ::  configure rJava.  equivalent to `R CMD javareconf` in shell 

 specific JDK, such as 11.0.1, 1.8,openjdk-12.0.2, etc: 
    searches through both default and removed pathes for the specific JDK.  
    if found in the default path, any other JDKs will be moved to the `removed JDKs` directory. 
    the specified JDK will be configured for rJava.
                                                        
```
- - -
*really bad walkthrough video from terminal:*   
  
[![Alt text](https://img.youtube.com/vi/65OlQ7i0fPw/0.jpg)](https://www.youtube.com/watch?v=65OlQ7i0fPw)
