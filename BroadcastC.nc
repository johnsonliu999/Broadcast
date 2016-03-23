#include "printf.h"
#include "Broadcast.h" // for AM_BROCAST & BroadcastMsg

module BroadcastC
{
	uses interface Boot;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface Receive;
	uses interface SplitControl as AMControl;
}

implementation 
{
	message_t pkt;
	bool busy = FALSE; 
	bool b_first_time = TRUE;	
	uint8_t i;

	event void Boot.booted() 
	{ 
		call AMControl.start(); 
	}

	event void AMControl.startDone(error_t err)
	{
	}
	       	
	event void AMControl.stopDone(error_t err)
	{

	}

	event void AMSend.sendDone(message_t* msg, error_t err)
	{
		if (&pkt == msg) busy = FALSE;
	}
	
	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len)
	{
		if (b_first_time)
		{
			if (len == sizeof(BroadcastMsg))
			{
				BroadcastMsg* send_msg;
				BroadcastMsg* rec_msg = (BroadcastMsg*)payload;	
				// print info
				printf("\nData");
				for (i = 0; i < 10; i++)
					printf(" %02d", rec_msg->data[i]);
				printf("\n");
				printfflush();

				b_first_time = FALSE; // set flag to false

				// broadcast
				send_msg = call AMSend.getPayload(&pkt, sizeof(BroadcastMsg));
				memcpy(send_msg, rec_msg, sizeof(BroadcastMsg));
				if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(BroadcastMsg)) == SUCCESS) busy = TRUE;
			}
		}
		// if not first, do nothing

		printfflush();
		return msg;
	}
}	

