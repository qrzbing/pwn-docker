FROM skysider/pwndocker:latest
LABEL maintainer="qrzbing <qrzbing@gmail.com>"

RUN apt -y install zsh proxychains4 && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    chsh -s $(which zsh) && \
    sed -i "11c ZSH_THEME=\"ys\"" ~/.zshrc && \
    git clone --depth 1 https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions && \
    git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting && \
    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/plugins/zsh-autosuggestions && \
    sed -i "73c plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-completions)" ~/.zshrc && \
    echo "alias pc='proxychains4 -q -f ~/proxychains4.conf'" >> /root/.zshrc && \
    git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime && \
    sh ~/.vim_runtime/install_awesome_vimrc.sh

COPY --from=skysider/glibc_builder64:2.26 /glibc/2.26/64 /glibc/2.26/64
COPY --from=skysider/glibc_builder32:2.26 /glibc/2.26/32 /glibc/2.26/32

COPY ./proxychains4.conf ./.tmux.conf /root/
COPY ./change_ld.py ./template.py /ctf/work/
COPY ./ida75/linux_server ./ida75/linux_server64 /ctf/ida75/

RUN python3 -m pip install --no-cache-dir autopep8 && \
    mkdir /ctf/ida70 && \
    mv /ctf/linux_server /ctf/linux_server64 /ctf/ida70 && \
    ln -s /glibc/2.23/64/lib/ld-2.23.so /lib64/ld-glibc-2.23 && \
    ln -s /glibc/2.26/64/lib/ld-2.26.so /lib64/ld-glibc-2.26 && \
    ln -s /glibc/2.27/64/lib/ld-2.27.so /lib64/ld-glibc-2.27 && \
    ln -s /glibc/2.28/64/lib/ld-2.28.so /lib64/ld-glibc-2.28 && \
    ln -s /glibc/2.29/64/lib/ld-2.29.so /lib64/ld-glibc-2.29 && \
    ln -s /glibc/2.30/64/lib/ld-2.30.so /lib64/ld-glibc-2.30 && \
    ln -s /glibc/2.31/64/lib/ld-2.31.so /lib64/ld-glibc-2.31 && \
    chmod a+x /ctf/ida75/linux_server /ctf/ida75/linux_server64 /ctf/work/change_ld.py

CMD ["/sbin/my_init"]
