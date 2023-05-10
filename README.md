# R-Keras-Docker
This Docker container provides an Rstudio webui environment with the Keras deep learning library installed. The container is built on top of `nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04`
and includes the necessary dependencies for running Keras in R.

## Prerequisites
Before you can use this container, you must have the NVIDIA container toolkit installed and configured for docker. Follow the installation instructions for your operating system in the NVIDIA docuumentation.

## Usage
To run this container, use the following command:

```docker run -it --gpus all -p 8787:8787 -v `pwd`:/home/rstudio/pwd delta9000/r-keras-cuda```

This will start a container that listens on port 8787. 

You can access the RStudio server by opening a web browser and navigating to http://localhost:8787. 


Login with the credentials that were printed to the terminal at startup.
