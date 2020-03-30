import {
  ConnectedSocket,
  MessageBody,
  OnGatewayConnection,
  OnGatewayDisconnect,
  OnGatewayInit,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
  WsResponse,
} from '@nestjs/websockets';
import {Logger} from '@nestjs/common';
import {from, Observable} from 'rxjs';
import {map} from 'rxjs/operators';
import {Server, Socket} from 'socket.io';

@WebSocketGateway()
export class EventsGateway implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server | undefined;
  
  private logger: Logger = new Logger('AppGateway');
  
  private clientList: any = {};
  
  @SubscribeMessage('webrtc-signaling')
  handleEvent(@MessageBody() data: string): string {
    console.log(data);
    return 'ok';
  }
  
  // @SubscribeMessage('events')
  // findAll(@MessageBody() data: any): Observable<WsResponse<number>> {
  //   console.log(data);
  //   return from([1, 2, 3]).pipe(map(item => ({event: 'events', data: item})));
  // }
  //
  // @SubscribeMessage('identity')
  // async identity(@MessageBody() data: number): Promise<number> {
  //   console.log(data);
  //   return data;
  // }
  
  afterInit(server: Server) {
    this.logger.log('Init');
  }
  
  handleDisconnect(client: Socket) {
    this.logger.log(`Client disconnected: ${client.id}`);
    delete this.clientList[client.id];
  }
  
  handleConnection(client: Socket, ...args: any[]) {
    this.logger.log(`Client connected: ${client.id}`);
    this.clientList[client.id] = client;
    client.emit('client-id', client.id);
  }
  
}
