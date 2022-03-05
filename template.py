from pwn import *

"""
libc path: /glibc/2.xx/64/lib/libc-2.xx.so
libc-database: /libc-database/
"""

io = process('./<bin>')
# io = remote('xxxxx', 12345)
libc = ELF('/glibc/2.28/64/lib/libc-2.28.so')

# context.log_level = "DEBUG"
# context.terminal = ['tmux', 'splitw', '-h']
# context.update(arch='amd64|i386', os='linux')

if __name__ == '__main__':
    pass

# shellcode = shellcraft.sh()