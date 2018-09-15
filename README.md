# r-laboratory

Use the script `lab.sh` to run the docker container with r and rstudio.

    $ lab.sh -h
    ./lab.sh [OPTIONS]
           -h    shows this message
           -b    <Location of Dockerfile> build docker image
           -t    <tag> sets docker image tag (Dafault: myrstudio)
           -r    <container name> run a docker container base on the image created with -b option
           -f    flags to force the docker container run.
                      If a container with the same name already exists it will be removed
                      This flag only applies in conjunction to '-r' option.
           -s    <container name> start an existing named container
                      A container with the given name must exists (obviously)
    
Once the container is up, visit localhost:8787 in your browser and log in with username __rstudio__ 
and the password __guest__. 
