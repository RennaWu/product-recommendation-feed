import { Controller, Get, Post, Patch, Param, Body } from '@nestjs/common';
import { RecommendationsService } from './recommendations.service';
import { CreateRecommendationDto } from './dto/create-recommendation.dto';

@Controller('recommendations')
export class RecommendationsController {
  constructor(private readonly recommendationsService: RecommendationsService) {}

  @Post()
  create(@Body() createDto: CreateRecommendationDto) {
    return this.recommendationsService.create(createDto);
  }

  @Get()
  findAll() {
    return this.recommendationsService.findAll();
  }

  @Patch(':id/like')
  like(@Param('id') id: string) {
    return this.recommendationsService.like(id);
  }
}
