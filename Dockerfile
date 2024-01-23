# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set the working directory
WORKDIR /app

# update Libaries
RUN apt-get update

# Install required libraries and tools
RUN apt-get install -y --no-install-recommends \
        curl \
        libatomic1 \
        libxi6 \
        libxrandr2 \
        libxt6 \
        libegl1 \
        libglu1-mesa \
        libgomp1 \
        libsm6 \
        unzip \
		dos2unix


# Update SSL certificates
RUN apt-get install -y --no-install-recommends ca-certificates

# Create a non-root user
RUN useradd -m -s /bin/bash ove_user

# Copy the install script to /opt/ove directory in the image
COPY farm_queue_install.sh /opt/ove/

# Set the working directory to /opt/ove/
WORKDIR /opt/ove

# Convert file to Unix when running on a windows system
RUN dos2unix /opt/ove/farm_queue_install.sh

# Make the script executable
RUN chmod +x /opt/ove/farm_queue_install.sh

# Run the script to install the program
RUN /opt/ove/farm_queue_install.sh

# Clean up unnecessary packages and files to reduce image size
RUN apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Expose any required ports (if your program needs it)
EXPOSE 8222

# Set permissions for the non-root user
RUN chown -R ove_user:ove_user /opt/ove/

# Switch to the non-root user
USER ove_user

# Make the farme queue script executable
RUN chmod +x /opt/ove/ov-farm-queue/queue.sh

# Set the default command to run when the container starts
CMD ["/opt/ove/queue.sh"]