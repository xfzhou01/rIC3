FROM ubuntu:latest AS builder

ENV PATH="/root/.cargo/bin:${PATH}"
ENV PATH="/root/:${PATH}"

WORKDIR /root
COPY ./target/release/rIC3 .

ENTRYPOINT ["timeout","3600","rIC3"]