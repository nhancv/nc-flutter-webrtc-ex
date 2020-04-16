import {
    ConnectedSocket,
    MessageBody,
    OnGatewayConnection,
    OnGatewayDisconnect,
    OnGatewayInit,
    SubscribeMessage,
    WebSocketGateway,
    WebSocketServer,
} from '@nestjs/websockets';
import {Logger} from '@nestjs/common';
import {Server, Socket} from 'socket.io';

const CLIENT_ID_EVENT = 'client-id-event';
const OFFER_EVENT = 'offer-event';
const ANSWER_EVENT = 'answer-event';
const ICE_CANDIDATE_EVENT = 'ice-candidate-event';

@WebSocketGateway()
export class EventsGateway implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect {
    @WebSocketServer()
    server: Server | undefined;

    private logger: Logger = new Logger('AppGateway');
    private clientList: any = {};
    private roomList: any = [];

    afterInit(server: Server) {
        this.logger.log(`Init socket server ${server.path()}`);
    }

    handleDisconnect(client: Socket) {
        this.logger.log(`Client disconnected: ${client.id}`);
        delete this.clientList[client.id];
        for (let i = 0; i < this.roomList.length; i++) {
            if (this.roomList[i].host == client.id ||
                this.roomList[i].peer == client.id) {
                this.roomList.splice(i, 1);
            }
        }
    }

    handleConnection(client: Socket, ...args: any[]) {
        this.logger.log(`Client connected: ${client.id}`);
        this.clientList[client.id] = client;
        // @nhancv 3/30/20: Send client id to client
        client.emit(CLIENT_ID_EVENT, client.id);
    }

    findPeerId(hostId: string) {
        for (let i = 0; i < this.roomList.length; i++) {
            if (this.roomList[i].host == hostId) {
                return this.roomList[i].peer;
            }
        }
    }

    findHostId(peerId: string) {
        for (let i = 0; i < this.roomList.length; i++) {
            if (this.roomList[i].peer == peerId) {
                return this.roomList[i].host;
            }
        }
    }

    @SubscribeMessage(OFFER_EVENT)
    async onOfferEvent(@ConnectedSocket() client: Socket, @MessageBody() data: { peerId: string, description: any }): Promise<number> {
        console.log(data);
        // @nhancv 3/30/20: Create a room contain client id with peerId;
        this.roomList.push({host: client.id, peer: data.peerId});

        const peer = this.clientList[data.peerId];
        if (peer) {
            peer.emit(OFFER_EVENT, data.description);
        } else {
          console.log('onOfferEvent: Peer does not found');
        }
        return 0;
    }

    @SubscribeMessage(ANSWER_EVENT)
    async onAnswerEvent(@ConnectedSocket() client: Socket, @MessageBody() data: { description: any }): Promise<number> {
        console.log(data);
        const hostId = this.findHostId(client.id);
        const host = this.clientList[hostId];
        if(host) {
          host.emit(ANSWER_EVENT, data.description);
        } else {
          console.log('onAnswerEvent: Host does not found');
        }
        return 0;
    }

    @SubscribeMessage(ICE_CANDIDATE_EVENT)
    async onIceCandidateEvent(@ConnectedSocket() client: Socket, @MessageBody() data: { isHost: boolean, candidate: any }): Promise<number> {
        console.log(data);
        let clientId;
        if (data.isHost) {
            clientId = this.findPeerId(client.id);
        } else {
            clientId = this.findHostId(client.id);
        }
        const peer = this.clientList[clientId];
        if(peer) {
          peer.emit(ICE_CANDIDATE_EVENT, data.candidate);
        } else {
          console.log('onIceCandidateEvent: Peer does not found');
        }
        return 0;
    }


}
