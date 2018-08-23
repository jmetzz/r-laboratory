# r-laboratory

Build the docker image

    docker build -t myrstudio .
    
Spin up the container

    docker run -d -p 8787:8787 -e ROOT=TRUE -e PASSWORD=your-password-goes-here myrstudio
    
Access RStudio on your browser http://localhost:8787/

