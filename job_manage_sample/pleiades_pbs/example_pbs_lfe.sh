#################################
## PBS #####
#################################
##### qsub for Interactive job on LDAN ###########
qsub -I -q ldan -lselect=1:mem=4GB,walltime=00:30:00
#then, ssh to the specified ldan node
##### qsub for Graphic Interactive job on LDAN ###########
qsub -I -X -q ldan -lselect=1:mem=4GB,walltime=00:30:00

