FROM golang:alpine AS build-env

# Set up dependencies
ENV PACKAGES make git curl build-base

# Set working directory for the build
WORKDIR /go/src/github.com/chainsafe/ethermint

# Install dependencies
RUN apk add --update $PACKAGES

# Add source files
COPY . .

# Make the binary
RUN make tools build

# Final image
FROM alpine

# Install ca-certificates
RUN apk add --update ca-certificates
WORKDIR /root

# Copy over binaries from the build-env
COPY --from=build-env /go/src/github.com/chainsafe/ethermint/build/emintd /usr/bin/emintd
COPY --from=build-env /go/src/github.com/chainsafe/ethermint/build/emintcli /usr/bin/emintcli

# Make the default command a sleep infinity.  This way folks
# can run the container, run any config steps they need
# then run docker commit to change the launch to eminitd start
CMD ["sleep infinity"]
