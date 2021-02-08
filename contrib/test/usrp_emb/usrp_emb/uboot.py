#!/usr/bin/env python3

class Uboot:
    def __init__(self, uart, prompt):
        self.prompt = prompt
        self.uart = uart

    def reset(self):
        self.uart.sendline("reset")
        self.uart.expect("resetting ...")

    def poweroff(self):
        self.uart.sendline("poweroff")
        self.uart.expect("poweroff ...")

    def wait_for_prompt(self):
        self.uart.expect(self.prompt)

    def wait_for_uboot(self):
        self.uart.expect("U-Boot SPL")
        self.uart.expect("U-Boot")

    def stop_autoboot(self):
        self.uart.expect('Enter \'noautoboot\' to enter prompt without timeout')
        self.uart.sendline('noautoboot')
        self.wait_for_prompt()

    def boot(self):
        self.uart.sendline("boot")
        self.uart.expect("Starting kernel ...")

    def run_dhcp(self):
        self.uart.sendline("dhcp")
        self.uart.expect(r"DHCP client bound to address \w+.\w+.\w+.\w+")
        ip = self.uart.after.decode('ascii').split(' ')[-1]
        self.wait_for_prompt()
        return ip

    def env_set(self, name, val):
        self.uart.sendline(f'env set {name} {val}')
        self.wait_for_prompt()

    def env_get(self, name):
        self.uart.sendline(f'env print {name}')
        self.uart.expect(f'{name}=')
        self.uart.expect(self.prompt)
        return self.uart.before.decode('ascii').strip()

    def tftp(self, ip, port, filename, addr):
        addr_hex = hex(addr)
        self.env_set('tftpdstp', port)
        self.env_set('serverip', ip)
        self.uart.sendline(f"dhcp {addr_hex} {filename}")
        self.uart.expect("done")
        self.wait_for_prompt()

    def bootm(self, addr, conf):
        addr_hex = hex(addr)
        self.uart.sendline(f"bootm {addr_hex}{conf}")
        self.uart.expect("Starting kernel ...")


class X4xxUboot(Uboot):
    def __init__(self, uart):
        super().__init__(uart=uart, prompt="ZynqMP> ")
