FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY ./demoapp .


# Make port 7272 available to the world outside this container
EXPOSE 7272

# Run server.py when the container launches
CMD ["python3" ,"server.py"]