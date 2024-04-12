# Use the official Node.js 16.14.0 image as the base image
FROM node:16.14.0

# Copy the current directory (.) into the container at /shadow-role
COPY . /shadow-role

# Set the working directory to /shadow-role
WORKDIR /shadow-role

# Install Node.js dependencies defined in package.json using npm's CI (clean install) command
RUN npm ci

# Add /shadow-role/node_modules/.bin to the PATH environment variable
ENV PATH="/shadow-role/node_modules/.bin:${PATH}"

# Set the default command to run when the container starts, keeping it running by continuously tailing /dev/null
CMD ["tail", "-f", "/dev/null"]
