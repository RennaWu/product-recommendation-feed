import mongoose from 'mongoose';

const MONGO_URI = 'mongodb://localhost:27017/recommendation-feed';

const RecommendationSchema = new mongoose.Schema(
  {
    username: String,
    productName: String,
    productUrl: String,
    caption: String,
    likes: { type: Number, default: 0 },
  },
  { timestamps: true },
);

const Recommendation = mongoose.model('Recommendation', RecommendationSchema);

const seedData = [
  {
    username: 'Sarah Lin',
    productName: 'Sony WH-1000XM5',
    productUrl: 'https://www.amazon.com/Sony-WH-1000XM5-Canceling-Headphones-Hands-Free/dp/B09XS7JWHH',
    caption:
      "Best noise-cancelling headphones I've ever owned. The comfort is unreal for long coding sessions.",
    likes: 24,
  },
  {
    username: 'James Chen',
    productName: 'Keychron Q1 Pro',
    productUrl: 'https://www.keychron.com/products/keychron-q1-pro-qmk-via-wireless-custom-mechanical-keyboard',
    caption:
      'Finally switched from my old mechanical board. The gasket mount makes typing feel like butter.',
    likes: 18,
  },
  {
    username: 'Amy Kim',
    productName: 'Notion Calendar',
    productUrl: 'https://www.notion.com/product/calendar',
    caption:
      'Replaced Google Calendar with this. The integration with Notion docs is a game changer for planning.',
    likes: 31,
  },
  {
    username: 'Marcus Reid',
    productName: 'Peak Design Everyday Backpack',
    productUrl: 'https://www.peakdesign.com/products/everyday-backpack-v2',
    caption:
      'Fits my 16" MacBook, camera gear, and lunch with room to spare. The side access is genius.',
    likes: 12,
  },
];

async function seed() {
  try {
    await mongoose.connect(MONGO_URI);
    console.log('Connected to MongoDB');

    await Recommendation.deleteMany({});
    console.log('Cleared existing recommendations');

    const docs = await Recommendation.insertMany(seedData);
    console.log(`Seeded ${docs.length} recommendations:`);
    docs.forEach((doc) => {
      console.log(`  - ${doc.productName} by ${doc.username} (id: ${doc._id})`);
    });

    await mongoose.disconnect();
    console.log('Done');
  } catch (error) {
    console.error('Seed failed:', error);
    process.exit(1);
  }
}

seed();
