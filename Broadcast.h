#ifndef BROADCAST_H
#define BROADCAST_H

enum {
	AM_BROADCAST = 6
};

typedef nx_struct BroadcastMsg {
	nx_uint8_t data[10];
} BroadcastMsg;

#endif
