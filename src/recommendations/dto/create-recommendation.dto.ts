import { IsString, IsUrl, IsNotEmpty, MaxLength } from 'class-validator';

export class CreateRecommendationDto {
  @IsString()
  @IsNotEmpty()
  username: string;

  @IsString()
  @IsNotEmpty()
  productName: string;

  @IsUrl({}, { message: 'productUrl must be a valid URL (e.g. https://example.com)' })
  @IsNotEmpty()
  productUrl: string;

  @IsString()
  @IsNotEmpty()
  @MaxLength(280, { message: 'caption must be 280 characters or fewer' })
  caption: string;
}
