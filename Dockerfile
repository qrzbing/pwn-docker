FROM skysider/pwndocker:latest
LABEL maintainer="qrzbing <qrzbing@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

ENV TZ Asia/Shanghai

WORKDIR /ctf/work/

COPY --from=skysider/glibc_builder64:2.26 /glibc/2.26/64 /glibc/2.26/64
COPY --from=skysider/glibc_builder32:2.26 /glibc/2.26/32 /glibc/2.26/32

COPY ./.tmux.conf /root/

CMD ["/sbin/my_init"]
