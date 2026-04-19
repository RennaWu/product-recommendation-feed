import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { RecommendationsModule } from './recommendations/recommendations.module';

@Module({
  imports: [
    MongooseModule.forRoot('mongodb://localhost:27017/recommendation-feed'),
    RecommendationsModule,
  ],
})
export class AppModule {}
