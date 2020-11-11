FROM debian:sid as builder

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && \
    apt-get -y install gcc make git bzip2

# RUN git clone --depth 1 https://github.com/kkourt/busybox.git -b ping-set-icmpid xping
ADD . xping

COPY configs/xping-static.config xping/.config
RUN cd xping && \
    make

FROM docker.io/tgraf/netperf:v1.0
COPY --from=builder xping/busybox /usr/bin/xping
COPY --from=builder xping/busybox /usr/bin/xping6
CMD ["/usr/bin/netserver", "-D"]
