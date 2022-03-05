FROM skysider/pwndocker:latest
LABEL maintainer="qrzbing <qrzbing@gmail.com>"

RUN apt -y install zsh && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    chsh -s $(which zsh) && \
    sed -i "11c ZSH_THEME=\"ys\"" ~/.zshrc && \
    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    sed -i "73c plugins=(git zsh-autosuggestions)" ~/.zshrc

COPY --from=skysider/glibc_builder64:2.26 /glibc/2.26/64 /glibc/2.26/64
COPY --from=skysider/glibc_builder32:2.26 /glibc/2.26/32 /glibc/2.26/32

COPY ./.tmux.conf /root/
COPY ./change_ld.py ./template.py /ctf/work/

RUN python3 -m pip install --no-cache-dir autopep8 && \
    pwntools_update=$(pip show pwntools | grep Version | awk -F, '{print substr($1, 10, 3)}' | awk -v num1=$1 -v num2=4.8 'BEGIN{print(num1<num2)?"1":"0"}') && \
    if [ $pwntools_update -eq 1 ]; then python3 -m pip install -U --no-cache-dir pwntools==4.8.0b0; fi && \
    unset pwntools_update && \
    mkdir /ctf/ida70 /ctf/ida75 && \
    mv /ctf/linux_server /ctf/linux_server64 /ctf/ida70 && \
    ln -s /glibc/2.23/64/lib/ld-2.23.so /lib64/ld-glibc-2.23 && \
    ln -s /glibc/2.26/64/lib/ld-2.26.so /lib64/ld-glibc-2.26 && \
    ln -s /glibc/2.27/64/lib/ld-2.27.so /lib64/ld-glibc-2.27 && \
    ln -s /glibc/2.28/64/lib/ld-2.28.so /lib64/ld-glibc-2.28 && \
    ln -s /glibc/2.29/64/lib/ld-2.29.so /lib64/ld-glibc-2.29 && \
    ln -s /glibc/2.30/64/lib/ld-2.30.so /lib64/ld-glibc-2.30 && \
    ln -s /glibc/2.31/64/lib/ld-2.31.so /lib64/ld-glibc-2.31

COPY ./ida75/linux_server ./ida75/linux_server64 /ctf/ida75/
RUN chmod a+x /ctf/ida75/linux_server /ctf/ida75/linux_server64

CMD ["/sbin/my_init"]
