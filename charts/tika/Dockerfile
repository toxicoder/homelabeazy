# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-slim

# Set the working directory
WORKDIR /app

# Download the Tika server JAR
RUN apt-get update && apt-get install -y wget && \
    wget https://downloads.apache.org/tika/3.2.1/tika-server-standard-3.2.1.jar && \
    apt-get remove -y wget && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

# Make port 9998 available to the world outside this container
EXPOSE 9998

# Run the JAR file
CMD ["java", "-jar", "tika-server-standard-3.2.1.jar"]
