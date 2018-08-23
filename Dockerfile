FROM alpine:3.8

ENV RCLONE_VERSION="1.42"

RUN apk --no-cache add \
    curl \
    ca-certificates \
    unzip \
 && addgroup -g 1000 rclone \
 && adduser -D -G rclone -s /bin/sh -u 1000 rclone

WORKDIR /tmp

RUN curl -O https://downloads.rclone.org/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-amd64.zip \
 && echo "7a623f60a5995f33cca3ed285210d8701c830f6f34d4dc50d74d75edd6a5bfa6  rclone-v1.42-linux-amd64.zip" | sha256sum -c - \
 && unzip rclone-v${RCLONE_VERSION}-linux-amd64.zip -d /tmp \
 && apk del --no-cache curl unzip \
 && mv /tmp/rclone-v${RCLONE_VERSION}-linux-amd64/rclone /usr/bin \
 && rm -r /tmp/rclone* \
 && rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

USER rclone
WORKDIR /home/rclone

ENTRYPOINT ["/usr/bin/rclone"]

CMD ["--version"]
