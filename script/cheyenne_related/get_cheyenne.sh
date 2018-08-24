#!/bin/bash
files="$(echo $@ | sed 's/ /,/g')"
scp -r sishen@cheyenne.ucar.edu:~/Work/Temp/{$files} .  
