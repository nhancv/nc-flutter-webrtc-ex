import {NestFactory} from '@nestjs/core';
import {AppModule} from './app.module';
import * as fs from 'fs';

async function bootstrap() {

  const usingHttps = true;
  const keyFile  = fs.readFileSync(__dirname + '/../keys/privatekey.pem');
  const certFile = fs.readFileSync(__dirname + '/../keys/certificate.pem');
  const app = await NestFactory.create(AppModule, usingHttps ? {
    httpsOptions: {
      key: keyFile,
      cert: certFile,
    }
  } : {});
  app.setGlobalPrefix('api');
  await app.listen(4000, '0.0.0.0');
  console.log(`Application is running on: ${await app.getUrl()}`);
}

bootstrap().then();
