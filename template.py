#!/usr/bin/python3

from pwn import *

"""
libc path: /glibc/2.xx/64/lib/libc-2.xx.so
libc-database: /libc-database/
"""

context.log_level = "DEBUG"
context.terminal = ['tmux', 'splitw', '-h']
context.update(arch='amd64', os='linux')    # arch='i386'
env = {'LD_PRELOAD': ''}

binary = './<bin>'
elf = ELF(binary)
libc = ELF('/glibc/2.28/64/lib/libc-2.28.so')

local = False
if len(sys.argv) == 1:
    local = True
    io = process(binary)
else:
    io = remote(sys.argv[1], sys.argv[2])


def p(n=None): pause(n=n)
def s(a): return io.send(a)
def r(a, numb = None): return io.recv(a, numb=numb)
def ia(): return io.interactive()
def rl(keepends=True): return io.recvline(keepends=keepends)
def ru(a, drop=False): return io.recvuntil(a, drop=drop)
def sl(a): return io.sendline(a)
def sa(a, b): return io.sendafter(a, b)
def st(a, b): return io.sendthen(a, b)
def sla(a, b): return io.sendlineafter(a, b)
def slt(a, b): return io.sendlinethen(a, b)
def info_addr(a, b): return log.info("{} addr: {}".format(a, hex(b)))


def g(b=''):
    if local:
        gdb.attach(io) if b == '' else gdb.attach(io, '{}'.format(b))


def one_gadget(filename):
    log.progress('Leak One_Gadgets...')
    one_ggs = str(subprocess.check_output(
        ['one_gadget', '--raw', '-f', filename]
    )).split(' ')
    return list(map(int, one_ggs))


if __name__ == '__main__':
    g()
    pass

# shellcode = shellcraft.sh()
