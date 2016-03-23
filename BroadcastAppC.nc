#include "Broadcast.h"

configuration BroadcastAppC {

}
implementation {
	components MainC;
	components BroadcastC as App;
	App.Boot -> MainC;

	// wireless
	components ActiveMessageC;
	components new AMSenderC(AM_BROADCAST);
	components new AMReceiverC(AM_BROADCAST);
	App.AMControl -> ActiveMessageC;
	App.AMSend -> AMSenderC;
	App.Receive -> AMReceiverC;

	// rssi
	components CC2420ActiveMessageC;
	App.CC2420Packet -> CC2420ActiveMessageC;
}
