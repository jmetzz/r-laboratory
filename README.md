# r-laboratory

Build the docker image

    docker build -t myrstudio .
    
Spin up the container

    docker run -d -p 8787:8787 -e ROOT=TRUE -e PASSWORD=your-password-goes-here myrstudio
    
Visit localhost:8787 in your browser and log in with username _rstudio_ 
and the password you set. NB: Setting a password is now *REQUIRED*. 
Container will error otherwise.