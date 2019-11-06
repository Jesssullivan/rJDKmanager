# Quickly & forcefully manage extra JDKs in base R
## (e.g. simplify rJava reconf)
# by Jess Sullivan 

# default JVM location on osx:
osxJDKpath <- "/Library/Java/JavaVirtualMachines/"

# move extra JDKs here:
removedJDKpath <- '~/disabledJDKs/'

### check for removedJDKpath: ###

if (!dir.exists(removedJDKpath)) {
  dir.create(removedJDKpath)
}

installedJDKs <- list.files(osxJDKpath)
removedJDKs <- list.files(removedJDKpath)
allJDKs <- list(installedJDKs, removedJDKs)


halt <- function(...) {  
  # verbatim, sweet function seen here:
  # https://www.mail-archive.com/r-help@r-project.org/msg117700.html
  # and again here:
  # https://stackoverflow.com/a/33916009
  blankMsg <- sprintf("\r%s\r", paste0(rep(" ", getOption("width")-1L), collapse=" "));
  stop(simpleError(blankMsg));
}

cmd <- 'echo ... '

helpString <- function() {
  writeLines(paste0('\n JDKmanager help: \n',
                                '(args are not case sensitive) \n',
                                '(usage: `sudo rscript JDKmanager.R help`) \n\n',
                                'list    :: prints contents of default JDK path and removed JDK path \n',
                                'reset   :: move all JDKs in removed JDK path back to default JDK path \n',
                                'config ::  configure rJava.  equivalent to `R CMD javareconf` in shell \n\n',
                                'specific JDK, such as 11.0.1, 1.8,openjdk-12.0.2, etc: \n',
                                '   searches through both default and removed pathes for the specific JDK.  \n',
                                '   if found in the default path, any other JDKs will be moved to the `removed JDKs` directory. \n',
                                '   the specified JDK will be configured for rJava.'))
}

main <- function() {  
  
  if (grepl('help', commandArgs()[5], ignore.case = TRUE)) {
    helpString()
    halt()
  }
  
  if (length(commandArgs()) != 6) {
    print("\n please use sudo and supply one argument! supply 'help' for options")
    halt()
  }

  arg <- as.character(commandArgs()[6])
  
  if (grepl('list', arg, ignore.case = TRUE)) {
    writeLines(paste0('\n listing contents of default JDK dir [ ', osxJDKpath, ' ] ... \n'))
    print(installedJDKs)
    writeLines(paste0('\n listing contents of removed JDK dir [ ', removedJDKpath, ' ] ... \n'))
    print(removedJDKs)
    halt()
    
  }
  
  if (grepl('help', arg, ignore.case = TRUE)) {
    helpString()
    halt()
  }
  
  if (grepl('config', arg, ignore.case = TRUE)) {
    if (length(installedJDKs) > 0) {
      system('R CMD javareconf -n')
      writeLines('\n completed reconf')
      halt()
    } else {
      writeLines('\n no JDK found, default path is empty!')
    }

    halt()
  }
  
  if (grepl('reset', arg, ignore.case = TRUE)) {
    
    writeLines('\n got reset arg, attempting to reset JDKs to default path ...')
    
    for (type in removedJDKs) {
      cmd = paste0(cmd, 
                  paste0(' && mv ', removedJDKpath, type, 
                         paste0(' ', osxJDKpath, type)))
    }
    # commit changes: 
    system(cmd)  # must be sudo user
    writeLines('\n reset JDKs to default path successfully!')
    return(halt())
  }
  
  if (!grepl('reset', arg, ignore.case = TRUE)) {
    
    writeLines(paste0('\n attempting to isolate JDK ', arg))
    
    writeLines('\n checking removed JDK path ... ')
   
    for (type in removedJDKs) {
      if (grepl(arg, type)) {
        print(paste0('\n not complete- JDK ', 
                     arg, ' found in ', removedJDKpath, 
                     ' please run run RESET arg before continuing'))
        halt()
      }
    }
    
    print('\n checking default JDK path')
    
    for (type in installedJDKs) {
      if (!grepl(arg, type)) {
        system(paste0('mv ', osxJDKpath, type, 
                           paste0(' ', removedJDKpath, type)))
      }
    }
  }
}

### RUN: ###

main()

### END ###
