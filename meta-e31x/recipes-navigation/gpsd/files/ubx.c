/*
 * Copyright (c) 2015, National Instruments Corp.
 *
 * Utility to control GPS on USRP Project Brimstone
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <getopt.h>
#include <unistd.h>
#include <fcntl.h>

#include <arpa/inet.h>
#include <termios.h>
#include <endian.h>

struct termios ttyset, ttyset_old;

/* message classes */
static const uint8_t CLASS_ACK = 0x05;
static const uint8_t CLASS_CFG = 0x06;
static const uint8_t CLASS_MON = 0x0a;

/* message ids */
static const uint8_t ID_ACK_NAK; /* no need to initialize static to 0 */
static const uint8_t ID_ACK_ACK = 0x01;
static const uint8_t ID_CFG_ANT = 0x13;
static const uint8_t ID_CFG_TP = 0x07;

/* constants */

static const uint16_t ANT_FLAGS_ON = 0x001b;
static const uint16_t ANT_FLAGS_OFF = 0x001a;
static const uint16_t ANT_PINS = 0x8251;

static const uint32_t MAGIC_WAIT = 50 * 1000;

struct ubx_header {
	uint8_t msg_cls;
	uint8_t msg_id;
	uint16_t len;
} __attribute((packed));

struct ubx_payload_cfg_ant {
	uint16_t flags;
	uint16_t pins;
} __attribute((packed));

struct ubx_payload_cfg_tp {
	uint32_t interval;
	uint32_t length;
	int8_t  status;
	uint8_t time_ref;
	uint8_t flags;
	uint8_t reserved1;
	int16_t antenna_delay;
	int16_t rf_group_delay;
	int32_t user_delay;
} __attribute((packed));

struct ubx_cfg_ant_packet {
	uint8_t sync1;
	uint8_t sync2;
	struct ubx_header hdr;
	struct ubx_payload_cfg_ant cfg_ant;
	uint8_t checksum[2];
} __attribute((packed));

struct ubx_cfg_tp_packet {
	uint8_t sync1;
	uint8_t sync2;
	struct ubx_header hdr;
	struct ubx_payload_cfg_tp cfg_tp;
	uint8_t checksum[2];
} __attribute((packed));

/**
 * careful, packet needs two extra bytes for checksum
 * at the end, so size must be real_size - 2
 */
static void ubx_checksum(uint8_t *packet, size_t size)
{
	uint8_t a, b;
	size_t i;

	a = 0;
	b = 0;

	for (i = 0; i < size; i++) {
		a += packet[i];
		b += a & 0xff;
	}

	packet[size] = a & 0xff;
	packet[size + 1] = b & 0xff;
}

static void ubx_send_cfg_ant(int fd, uint16_t flags, uint16_t pins)
{
	uint8_t *buf_ptr;
	size_t i;

	struct ubx_cfg_ant_packet pkt = {
		.sync1 = 0xb5,
		.sync2 = 0x62,
		.hdr = {
			.msg_cls = CLASS_CFG,
			.msg_id = ID_CFG_ANT,
			.len = htole16(sizeof(struct ubx_payload_cfg_ant)),
		},
		.cfg_ant = {
			.flags = flags,
			.pins = pins,
		},
	};
	buf_ptr = (uint8_t *)&pkt;

	ubx_checksum((uint8_t *)&pkt.hdr, sizeof(pkt.hdr)
		+ sizeof(pkt.cfg_ant));

	write(fd, buf_ptr, sizeof(pkt));

	usleep(MAGIC_WAIT);

	tcdrain(fd);
}

static void ubx_send_cfg_tp(int fd, uint32_t interval, uint32_t length,
			    int8_t status, uint8_t time_ref, uint8_t flags,
			    int16_t antenna_delay, int16_t rf_group_delay,
			    int32_t user_delay)
{
	uint8_t *buf_ptr;
	size_t i;

	struct ubx_cfg_tp_packet pkt = {
		.sync1 = 0xb5,
		.sync2 = 0x62,
		.hdr = {
			.msg_cls = CLASS_CFG,
			.msg_id = ID_CFG_TP,
			.len = htole16(sizeof(struct ubx_payload_cfg_tp)),
		},
		.cfg_tp = {
			.interval = htole32(interval),
			.length = htole32(length),
			.status = status,
			.time_ref = time_ref,
			.flags = flags,
			.reserved1 = 0xbe,
			.antenna_delay = htole16(antenna_delay),
			.rf_group_delay = htole16(rf_group_delay),
			.user_delay = htole32(user_delay),
		},
	};

	buf_ptr = (uint8_t *)&pkt;

	ubx_checksum((uint8_t *)&pkt.hdr, sizeof(pkt.hdr)
		+ sizeof(pkt.cfg_tp));

	write(fd, buf_ptr, sizeof(pkt));

	usleep(MAGIC_WAIT);

	tcdrain(fd);
}

static int ubx_init_uart(int fd)
{
	int err;

	err = tcgetattr(fd, &ttyset_old);
	if (err) {
		fprintf(stderr, "Failed to get termios\n");
		return err;
	}

	memcpy(&ttyset, &ttyset_old, sizeof(ttyset));

	ttyset.c_cflag = B9600 | CS8 | CLOCAL | CREAD;
	ttyset.c_oflag = 0;
	ttyset.c_lflag &= ~ICANON;
	ttyset.c_lflag &= ~ECHO;

	cfmakeraw(&ttyset);

	err = tcsetattr(fd, TCSANOW, &ttyset);
	if (err) {
		fprintf(stderr, "Failed to set termios\n");
		return err;
	}

	tcflush(fd, TCOFLUSH);

	return 0;
}

static int ubx_restore_uart(int fd)
{
	int err;

	err = tcsetattr(fd, TCSANOW, &ttyset_old);
	if (err) {
		fprintf(stderr, "Failed to reset termios\n");
		return err;
	}

	return 0;
}

static void print_usage(void)
{
	printf("ubx - Utility to control GPS on USRP Brimstone\n\n"
	       "Options:\n"
	       "        -d (serial device, e.g. /dev/ttyPS1\n"
	       "        -a (antenna supply, either 'on' or 'off')\n"
	       "        -p (pps output, either 'on' or 'off')\n"
	       "        -t (time reference either 'utc', 'gps', 'local')\n"
	       "        -h (print this help message)\n\n"
	       "Example:\n"
	       "$ ubx -d /dev/ttyPS1 -p on -a on -t utc\n");
}

int main(int argc, char *argv[])
{
	int err;
	int pps, ant, time_ref, opt, fd;
	char *device = NULL;

	err = 0;
	ant = -1;
	pps = -1;
	/* default to utc */
	time_ref = -1;

	while ((opt = getopt(argc, argv, "qd:m:a:p:t:")) != -1) {
		switch (opt) {
		case 'd':
			device = strdup(optarg);
			break;
		case 'p':
			pps = !strcmp(optarg, "on");
			break;
		case 'a':
			ant = !strcmp(optarg, "on");
			break;
		case 't':
			if (!strcmp(optarg, "utc")) {
				time_ref = 0;
				break;
			} else if (!strcmp(optarg, "gps")) {
				time_ref = 1;
				break;
			} else if (!strcmp(optarg, "local")) {
				time_ref = 2;
				break;
			}
		default:
			print_usage();
			break;
		}
	}

	if (!device) {
		print_usage();
		return EXIT_FAILURE;
	}

	fd = open(device, O_RDWR | O_NOCTTY);
	if (fd < 0) {
		fprintf(stderr, "Failed to open device %s\n", device);
		return EXIT_FAILURE;
	}

	err = ubx_init_uart(fd);
	if (err)
		goto out_err;

	if (ant >= 0)
		ubx_send_cfg_ant(fd, ant ? ANT_FLAGS_ON : ANT_FLAGS_OFF,
				 ANT_PINS);

	if (pps >= 0) {
		time_ref = (time_ref == -1) ? 0 : time_ref;
		/* we configure as follows:
		 * interval: 0x0f4240 ns (1s)
		 * length: 0x03d090 ns (250ms)
		 * status: 1 positive pulse
		 * time_ref: 0: utc 1: gps 2: local
		 * flags: 0x1 allow for pps without lock
		 * antenna delay: 0
		 * group delay: 0
		 * user delay: 0
		 */
		ubx_send_cfg_tp(fd, 0x0f4240, 0x03d090, pps, time_ref,
				1, 0, 0, 0);
	}

	err = ubx_restore_uart(fd);

out_err:
	close(fd);

	free(device);

	return err;
}
