#!/bin/bash
files="$(echo $@ | sed 's/ /,/g')"
scp -r sishen@yellowstone.ucar.edu:~/Work/Temp/{$files} .  
