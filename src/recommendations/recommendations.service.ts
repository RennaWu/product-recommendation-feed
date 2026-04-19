import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import {
  Recommendation,
  RecommendationDocument,
} from './schemas/recommendation.schema';
import { CreateRecommendationDto } from './dto/create-recommendation.dto';

@Injectable()
export class RecommendationsService {
  constructor(
    @InjectModel(Recommendation.name)
    private recommendationModel: Model<RecommendationDocument>,
  ) {}

  async create(dto: CreateRecommendationDto): Promise<RecommendationDocument> {
    const created = new this.recommendationModel(dto);
    return created.save();
  }

  async findAll(): Promise<RecommendationDocument[]> {
    return this.recommendationModel
      .find()
      .sort({ createdAt: -1 })
      .exec();
  }

  async like(id: string): Promise<RecommendationDocument> {
    const recommendation = await this.recommendationModel
      .findByIdAndUpdate(
        id,
        { $inc: { likes: 1 } },
        { new: true },
      )
      .exec();

    if (!recommendation) {
      throw new NotFoundException(`Recommendation with id "${id}" not found`);
    }

    return recommendation;
  }
}
