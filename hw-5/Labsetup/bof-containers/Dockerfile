# bof-containers/Dockerfile
FROM handsonsecurity/seed-ubuntu:small-arm

# Build arg must be declared before it's used in COPY
ARG LEVEL

WORKDIR /bof

# Copy the server and the appropriate stack from the project root (build context = .)
COPY server-code/server ./server
COPY attack-code/stack-${LEVEL} ./stack

# If server is an executable script/binary, make sure it's executable
RUN chmod +x ./server || true

# Run the server
CMD ["./server"]