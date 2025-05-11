FROM ubuntu:latest AS builder
RUN apt update && apt install -y curl build-essential git cmake zlib1g-dev pkg-config libssl-dev && apt-get clean
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly
ENV PATH="/root/.cargo/bin:${PATH}"
ENV PATH="/root/:${PATH}"

WORKDIR /root
COPY ./target/release/rIC3 .
# RUN git clone https://github.com/xfzhou01/rIC3.git && \
#     cd rIC3 && \
#     git checkout MAB-extend && \
#     git submodule update --init --recursive 
# WORKDIR /root/rIC3
# RUN ls -a
# RUN pwd
# RUN cat Cargo.toml
# RUN cat deps/abc-rs/Cargo.toml
# RUN cargo build --release

# FROM ubuntu:latest
# COPY --from=builder /root/rIC3/target/release/rIC3 /usr/local/bin/

ENTRYPOINT ["rIC3"]