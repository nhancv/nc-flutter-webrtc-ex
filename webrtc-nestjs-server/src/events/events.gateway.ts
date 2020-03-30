import {
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
  
  afterInit(server: Server) {
    this.logger.log(`Init socket server ${server.path()}`);
  }
  
  handleDisconnect(client: Socket) {
    this.logger.log(`Client disconnected: ${client.id}`);
    delete this.clientList[client.id];
  }
  
  handleConnection(client: Socket, ...args: any[]) {
    this.logger.log(`Client connected: ${client.id}`);
    this.clientList[client.id] = client;
    // @nhancv 3/30/20: Send client id to client
    client.emit(CLIENT_ID_EVENT, client.id);
  }
  
  @SubscribeMessage(OFFER_EVENT)
  async onOfferEvent(@MessageBody() data: {calleeId: string, description: any}): Promise<number> {
    console.log(data);
    this.clientList[data.calleeId].emit(OFFER_EVENT, data.description);
    return 0;
  }
  
  @SubscribeMessage(ANSWER_EVENT)
  async onAnswerEvent(@MessageBody() data: {calleeId: string, description: any}): Promise<number> {
    console.log(data);
    this.clientList[data.calleeId].emit(ANSWER_EVENT, data.description);
    return 0;
  }
  
  @SubscribeMessage(ICE_CANDIDATE_EVENT)
  async onIceCandidateEvent(@MessageBody() data: {calleeId: string, candidate: any}): Promise<number> {
    console.log(data);
    this.clientList[data.calleeId].emit(ANSWER_EVENT, data.candidate);
    return 0;
  }
  
}
