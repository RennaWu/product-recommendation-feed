import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type RecommendationDocument = Recommendation & Document;

@Schema({ timestamps: true })
export class Recommendation {
  @Prop({ required: true })
  username: string;

  @Prop({ required: true })
  productName: string;

  @Prop({ required: true })
  productUrl: string;

  @Prop({ required: true, maxlength: 280 })
  caption: string;

  @Prop({ default: 0 })
  likes: number;
}

export const RecommendationSchema = SchemaFactory.createForClass(Recommendation);
