// import 'models.dart';

// class MockData {
//   // DELHI PLACES
//   static final List<Place> delhiHotels = [
//     const Place(
//       id: 'dh1', name: 'Delhi Luxe Palace', type: 'hotel', rating: 4.7, reviewCount: 250,
//       priceDisplay: '₹3,500 / night',
//       accessibilityFeatures: ['Wheelchair Access', 'Elevator', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?w=600',
//       location: 'Connaught Place, Delhi', isSaved: false, distanceKm: 1.5,
//     ),
//     const Place(
//       id: 'dh2', name: 'Heritage Delhi Hotel', type: 'hotel', rating: 4.5, reviewCount: 180,
//       priceDisplay: '₹2,800 / night',
//       accessibilityFeatures: ['Wheelchair Friendly', 'Accessible Parking'],
//       imageUrl: 'https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg?w=600',
//       location: 'Kasturba Nagar, Delhi', isSaved: false, distanceKm: 2.3,
//     ),
//   ];

//   static final List<Place> delhiRestaurants = [
//     const Place(
//       id: 'dr1', name: 'Delhi Dine Delights', type: 'restaurant', rating: 4.6, reviewCount: 145,
//       priceDisplay: '', priceRange: '₹₹₹', cuisineType: 'North Indian',
//       accessibilityFeatures: ['Accessible Seating', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/1581384/pexels-photo-1581384.jpeg?w=600',
//       location: 'Chandni Chowk, Delhi', isSaved: false, distanceKm: 1.2,
//     ),
//     const Place(
//       id: 'dr2', name: 'Spice Symphony', type: 'restaurant', rating: 4.4, reviewCount: 112,
//       priceDisplay: '', priceRange: '₹₹', cuisineType: 'Multi-cuisine',
//       accessibilityFeatures: ['Wheelchair Access', 'Ramp'],
//       imageUrl: 'https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg?w=600',
//       location: 'New Delhi', isSaved: false, distanceKm: 2.1,
//     ),
//   ];

//   static final List<Place> delhiCafes = [
//     const Place(
//       id: 'dc1', name: 'Delhi Brew Lounge', type: 'cafe', rating: 4.5, reviewCount: 95,
//       priceDisplay: '', priceRange: '₹', cuisineType: 'Coffee & Snacks',
//       accessibilityFeatures: ['Wheelchair Access', 'Step-free Entry'],
//       imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?w=600',
//       location: 'Karol Bagh, Delhi', isSaved: false, distanceKm: 1.8,
//     ),
//     const Place(
//       id: 'dc2', name: 'Heritage Brew', type: 'cafe', rating: 4.3, reviewCount: 72,
//       priceDisplay: '', priceRange: '₹₹', cuisineType: 'Cafe & Desserts',
//       accessibilityFeatures: ['Elevator', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/208698/pexels-photo-208698.jpeg?w=600',
//       location: 'Old Delhi', isSaved: false, distanceKm: 2.5,
//     ),
//   ];

//   static final List<Place> delhiAttractions = [
//     const Place(
//       id: 'da1', name: 'Red Fort Complex', type: 'attraction', rating: 4.7, reviewCount: 290,
//       priceDisplay: '₹35 per person',
//       accessibilityFeatures: ['Wheelchair Access', 'Accessible Restroom', 'Ramp'],
//       imageUrl: 'https://images.pexels.com/photos/416676/pexels-photo-416676.jpeg?w=600',
//       location: 'Chandni Chowk, Delhi', isSaved: false, distanceKm: 1.2,
//     ),
//     const Place(
//       id: 'da2', name: 'Jama Masjid', type: 'attraction', rating: 4.5, reviewCount: 200,
//       priceDisplay: 'Free Entry',
//       accessibilityFeatures: ['Wheelchair Friendly', 'Accessible Seating'],
//       imageUrl: 'https://images.pexels.com/photos/1409140/pexels-photo-1409140.jpeg?w=600',
//       location: 'Old Delhi', isSaved: false, distanceKm: 1.5,
//     ),
//     const Place(
//       id: 'da3', name: 'National Museum', type: 'attraction', rating: 4.6, reviewCount: 175,
//       priceDisplay: '₹50 per person',
//       accessibilityFeatures: ['Wheelchair Access', 'Elevator', 'Audio Guide'],
//       imageUrl: 'https://images.pexels.com/photos/3683048/pexels-photo-3683048.jpeg?w=600',
//       location: 'Janpath, Delhi', isSaved: false, distanceKm: 2.2,
//     ),
//   ];

//   // AGRA PLACES (Taj Mahal)
//   static final List<Place> agraHotels = [
//     const Place(
//       id: 'ah1', name: 'Taj View Palace', type: 'hotel', rating: 4.8, reviewCount: 320,
//       priceDisplay: '₹4,000 / night',
//       accessibilityFeatures: ['Wheelchair Access', 'Elevator', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?w=600',
//       location: 'Fatehabad Road, Agra', isSaved: false, distanceKm: 2.0,
//     ),
//     const Place(
//       id: 'ah2', name: 'Marble City Hotel', type: 'hotel', rating: 4.6, reviewCount: 195,
//       priceDisplay: '₹2,500 / night',
//       accessibilityFeatures: ['Wheelchair Friendly', 'Accessible Parking'],
//       imageUrl: 'https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg?w=600',
//       location: 'Taj Ganj, Agra', isSaved: false, distanceKm: 1.8,
//     ),
//   ];

//   static final List<Place> agraRestaurants = [
//     const Place(
//       id: 'ar1', name: 'Moghul Mansion Dine', type: 'restaurant', rating: 4.5, reviewCount: 130,
//       priceDisplay: '', priceRange: '₹₹₹', cuisineType: 'Mughlai',
//       accessibilityFeatures: ['Accessible Seating', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/1581384/pexels-photo-1581384.jpeg?w=600',
//       location: 'Fatehabad Road, Agra', isSaved: false, distanceKm: 1.5,
//     ),
//     const Place(
//       id: 'ar2', name: 'Taj Spice Kitchen', type: 'restaurant', rating: 4.3, reviewCount: 95,
//       priceDisplay: '', priceRange: '₹₹', cuisineType: 'North Indian',
//       accessibilityFeatures: ['Wheelchair Access', 'Ramp'],
//       imageUrl: 'https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg?w=600',
//       location: 'Taj Ganj, Agra', isSaved: false, distanceKm: 2.3,
//     ),
//   ];

//   static final List<Place> agraCafes = [
//     const Place(
//       id: 'ac1', name: 'Taj Brew Cafe', type: 'cafe', rating: 4.4, reviewCount: 85,
//       priceDisplay: '', priceRange: '₹', cuisineType: 'Coffee & Desserts',
//       accessibilityFeatures: ['Wheelchair Access', 'Step-free Entry'],
//       imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?w=600',
//       location: 'Taj Road, Agra', isSaved: false, distanceKm: 1.2,
//     ),
//     const Place(
//       id: 'ac2', name: 'Heritage Cafe Agra', type: 'cafe', rating: 4.2, reviewCount: 68,
//       priceDisplay: '', priceRange: '₹', cuisineType: 'Snacks & Tea',
//       accessibilityFeatures: ['Accessible Seating', 'Braille Menu'],
//       imageUrl: 'https://images.pexels.com/photos/208698/pexels-photo-208698.jpeg?w=600',
//       location: 'Agra Downtown', isSaved: false, distanceKm: 2.8,
//     ),
//   ];

//   static final List<Place> agraAttractions = [
//     const Place(
//       id: 'aa1', name: 'Agra Fort', type: 'attraction', rating: 4.6, reviewCount: 260,
//       priceDisplay: '₹40 per person',
//       accessibilityFeatures: ['Wheelchair Access', 'Ramp', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/416676/pexels-photo-416676.jpeg?w=600',
//       location: 'Agra Fort Area', isSaved: false, distanceKm: 3.0,
//     ),
//     const Place(
//       id: 'aa2', name: 'Itmad-Ud-Daulah Tomb', type: 'attraction', rating: 4.5, reviewCount: 145,
//       priceDisplay: '₹30 per person',
//       accessibilityFeatures: ['Wheelchair Friendly', 'Accessible Seating'],
//       imageUrl: 'https://images.pexels.com/photos/1409140/pexels-photo-1409140.jpeg?w=600',
//       location: 'East of Taj Mahal, Agra', isSaved: false, distanceKm: 4.5,
//     ),
//   ];

//   // JAIPUR PLACES
//   static final List<Place> jaipurHotels = [
//     const Place(
//       id: 'jh1', name: 'Jaipur Palace Hotel', type: 'hotel', rating: 4.7, reviewCount: 280,
//       priceDisplay: '₹3,200 / night',
//       accessibilityFeatures: ['Wheelchair Access', 'Elevator', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?w=600',
//       location: 'Civil Lines, Jaipur', isSaved: false, distanceKm: 1.8,
//     ),
//     const Place(
//       id: 'jh2', name: 'Pink City Heritage Inn', type: 'hotel', rating: 4.5, reviewCount: 170,
//       priceDisplay: '₹2,300 / night',
//       accessibilityFeatures: ['Wheelchair Friendly', 'Accessible Parking'],
//       imageUrl: 'https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg?w=600',
//       location: 'Bani Park, Jaipur', isSaved: false, distanceKm: 2.5,
//     ),
//   ];

//   static final List<Place> jaipurRestaurants = [
//     const Place(
//       id: 'jr1', name: 'Rajasthan Royal Dine', type: 'restaurant', rating: 4.6, reviewCount: 140,
//       priceDisplay: '', priceRange: '₹₹₹', cuisineType: 'Rajasthani',
//       accessibilityFeatures: ['Accessible Seating', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/1581384/pexels-photo-1581384.jpeg?w=600',
//       location: 'M.I. Road, Jaipur', isSaved: false, distanceKm: 1.3,
//     ),
//     const Place(
//       id: 'jr2', name: 'Hawa Mahal Kitchen', type: 'restaurant', rating: 4.4, reviewCount: 105,
//       priceDisplay: '', priceRange: '₹₹', cuisineType: 'North Indian',
//       accessibilityFeatures: ['Wheelchair Access', 'Ramp'],
//       imageUrl: 'https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg?w=600',
//       location: 'Sanganeri Gate, Jaipur', isSaved: false, distanceKm: 2.1,
//     ),
//   ];

//   static final List<Place> jaipurCafes = [
//     const Place(
//       id: 'jc1', name: 'Pink Brew Cafe', type: 'cafe', rating: 4.5, reviewCount: 92,
//       priceDisplay: '', priceRange: '₹', cuisineType: 'Coffee & Pastries',
//       accessibilityFeatures: ['Wheelchair Access', 'Step-free Entry'],
//       imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?w=600',
//       location: 'C-Scheme, Jaipur', isSaved: false, distanceKm: 1.6,
//     ),
//     const Place(
//       id: 'jc2', name: 'Royal Tea House', type: 'cafe', rating: 4.3, reviewCount: 75,
//       priceDisplay: '', priceRange: '₹', cuisineType: 'Tea & Snacks',
//       accessibilityFeatures: ['Accessible Seating', 'Elevator'],
//       imageUrl: 'https://images.pexels.com/photos/208698/pexels-photo-208698.jpeg?w=600',
//       location: 'Jaipur City Center', isSaved: false, distanceKm: 2.2,
//     ),
//   ];

//   static final List<Place> jaipurAttractions = [
//     const Place(
//       id: 'ja1', name: 'City Palace', type: 'attraction', rating: 4.7, reviewCount: 315,
//       priceDisplay: '₹75 per person',
//       accessibilityFeatures: ['Wheelchair Access', 'Ramp', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/416676/pexels-photo-416676.jpeg?w=600',
//       location: 'Jaipur City Center', isSaved: false, distanceKm: 1.0,
//     ),
//     const Place(
//       id: 'ja2', name: 'Jantar Mantar Observatory', type: 'attraction', rating: 4.6, reviewCount: 225,
//       priceDisplay: '₹50 per person',
//       accessibilityFeatures: ['Wheelchair Friendly', 'Guided Tours', 'Accessible Seating'],
//       imageUrl: 'https://images.pexels.com/photos/1409140/pexels-photo-1409140.jpeg?w=600',
//       location: 'Jaipur', isSaved: false, distanceKm: 1.5,
//     ),
//   ];

//   // Default for other locations (general places)
//   static final List<Place> hotels = [
//     const Place(
//       id: 'h1', name: 'Sunrise Suites', type: 'hotel', rating: 4.7, reviewCount: 230,
//       priceDisplay: '₹2,800 / night',
//       accessibilityFeatures: ['Wheelchair Access', 'Elevator', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?w=600',
//       location: 'City Center', isSaved: false, distanceKm: 1.2,
//     ),
//     const Place(
//       id: 'h2', name: 'Comfort Vista Hotel', type: 'hotel', rating: 4.5, reviewCount: 168,
//       priceDisplay: '₹2,400 / night',
//       accessibilityFeatures: ['Wheelchair Friendly', 'Elevator'],
//       imageUrl: 'https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg?w=600',
//       location: 'Central District', isSaved: false, distanceKm: 2.1,
//     ),
//     const Place(
//       id: 'h3', name: 'Grand City Residency', type: 'hotel', rating: 4.6, reviewCount: 194,
//       priceDisplay: '₹3,100 / night',
//       accessibilityFeatures: ['Accessible Parking', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/2034335/pexels-photo-2034335.jpeg?w=600',
//       location: 'Business District', isSaved: false, distanceKm: 3.4,
//     ),
//     const Place(
//       id: 'h4', name: 'Maple Leaf Residency', type: 'hotel', rating: 4.3, reviewCount: 121,
//       priceDisplay: '₹1,900 / night',
//       accessibilityFeatures: ['Step-free Entry', 'Accessible Seating'],
//       imageUrl: 'https://images.pexels.com/photos/338504/pexels-photo-338504.jpeg?w=600',
//       location: 'North Avenue', isSaved: false, distanceKm: 4.0,
//     ),
//     const Place(
//       id: 'h5', name: 'Heritage Grand Hotel', type: 'hotel', rating: 4.8, reviewCount: 286,
//       priceDisplay: '₹4,200 / night',
//       accessibilityFeatures: ['Wheelchair Access', 'Elevator', 'Accessible Restroom', 'Accessible Parking'],
//       imageUrl: 'https://images.pexels.com/photos/261102/pexels-photo-261102.jpeg?w=600',
//       location: 'Heritage District', isSaved: false, distanceKm: 5.2,
//     ),
//   ];

//   static final List<Place> restaurants = [
//     const Place(
//       id: 'r1', name: 'The Green Kitchen', type: 'restaurant', rating: 4.4, reviewCount: 96,
//       priceDisplay: '', priceRange: '₹₹', cuisineType: 'Multi-cuisine',
//       accessibilityFeatures: ['Accessible Seating'],
//       imageUrl: 'https://images.pexels.com/photos/1581384/pexels-photo-1581384.jpeg?w=600',
//       location: 'City Area', isSaved: true, distanceKm: 1.8,
//     ),
//     const Place(
//       id: 'r2', name: 'Spice Route Kitchen', type: 'restaurant', rating: 4.5, reviewCount: 134,
//       priceDisplay: '', priceRange: '₹₹', cuisineType: 'Indian Cuisine',
//       accessibilityFeatures: ['Wheelchair Access', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg?w=600',
//       location: 'Market Street', isSaved: false, distanceKm: 2.4,
//     ),
//     const Place(
//       id: 'r3', name: 'Urban Table', type: 'restaurant', rating: 4.3, reviewCount: 98,
//       priceDisplay: '', priceRange: '₹₹₹', cuisineType: 'Multi-cuisine',
//       accessibilityFeatures: ['Accessible Seating', 'Ramp Access'],
//       imageUrl: 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?w=600',
//       location: 'Riverside Road', isSaved: false, distanceKm: 3.0,
//     ),
//     const Place(
//       id: 'r4', name: 'Royal Feast', type: 'restaurant', rating: 4.7, reviewCount: 211,
//       priceDisplay: '', priceRange: '₹₹₹', cuisineType: 'Traditional Cuisine',
//       accessibilityFeatures: ['Wheelchair Friendly', 'Braille Menu'],
//       imageUrl: 'https://images.pexels.com/photos/262978/pexels-photo-262978.jpeg?w=600',
//       location: 'Old Town', isSaved: false, distanceKm: 4.2,
//     ),
//     const Place(
//       id: 'r5', name: 'Green Garden Restaurant', type: 'restaurant', rating: 4.4, reviewCount: 156,
//       priceDisplay: '', priceRange: '₹₹', cuisineType: 'Vegetarian',
//       accessibilityFeatures: ['Accessible Parking', 'Accessible Seating'],
//       imageUrl: 'https://images.pexels.com/photos/315755/pexels-photo-315755.jpeg?w=600',
//       location: 'Garden Road', isSaved: false, distanceKm: 5.0,
//     ),
//   ];

//   static final List<Place> cafes = [
//     const Place(
//       id: 'c1', name: 'Brew Haven', type: 'cafe', rating: 4.5, reviewCount: 87,
//       priceDisplay: '', priceRange: '₹', cuisineType: 'Coffee & Pastries',
//       accessibilityFeatures: ['Wheelchair Access', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?w=600',
//       location: 'Main Area', isSaved: false, distanceKm: 2.3,
//     ),
//   ];

//   static final List<Place> attractions = [
//     const Place(
//       id: 'a1', name: 'Local Heritage Site', type: 'attraction', rating: 4.6, reviewCount: 245,
//       priceDisplay: 'Free Entry',
//       accessibilityFeatures: ['Wheelchair Access', 'Accessible Restroom', 'Ramp'],
//       imageUrl: 'https://images.pexels.com/photos/416676/pexels-photo-416676.jpeg?w=600',
//       location: 'City Center', isSaved: false, distanceKm: 4.5,
//     ),
//   ];

//   static final List<Event> events = [
//     const Event(
//       id: 'e1', title: 'Art & Inclusion Workshop', organizer: 'Ability Foundation',
//       dateDisplay: '25 May 2025 • 10:00 AM', monthAbbr: 'MAY', dayNum: 25, time: '10:00 AM',
//       location: 'Anna Nagar, Chennai', tags: ['Wheelchair Accessible', 'Inclusive'],
//       imageUrl: 'https://images.pexels.com/photos/6147369/pexels-photo-6147369.jpeg?w=400',
//       category: 'workshops', isSaved: true,
//     ),
//     const Event(
//       id: 'e2', title: 'Environment Awareness Drive', organizer: 'Green Hands NGO',
//       dateDisplay: '28 May 2025 • 9:30 AM', monthAbbr: 'MAY', dayNum: 28, time: '9:30 AM',
//       location: 'Marina Beach, Chennai', tags: ['Accessible Venue', 'Open for All'],
//       imageUrl: 'https://images.pexels.com/photos/7655912/pexels-photo-7655912.jpeg?w=400',
//       category: 'awareness', isSaved: false,
//     ),
//     const Event(
//       id: 'e3', title: 'Adaptive Sports Day', organizer: 'Enable India',
//       dateDisplay: '2 Jun 2025 • 9:00 AM', monthAbbr: 'JUN', dayNum: 2, time: '9:00 AM',
//       location: 'Jawaharlal Stadium, Chennai', tags: ['Accessible Venue', 'All are Welcome'],
//       imageUrl: 'https://images.pexels.com/photos/3621104/pexels-photo-3621104.jpeg?w=400',
//       category: 'awareness', isSaved: false,
//     ),
//     const Event(
//       id: 'e4', title: 'Disability Rights Seminar', organizer: 'Samarthya Trust',
//       dateDisplay: '10 Jun 2025 • 11:00 AM', monthAbbr: 'JUN', dayNum: 10, time: '11:00 AM',
//       location: 'IIT Madras, Chennai', tags: ['Wheelchair Accessible', 'Sign Language'],
//       imageUrl: 'https://images.pexels.com/photos/7648047/pexels-photo-7648047.jpeg?w=400',
//       category: 'workshops', isSaved: false,
//     ),
//     const Event(
//       id: 'e5', title: 'Community Volunteer Drive', organizer: 'HelpAge India',
//       dateDisplay: '15 Jun 2025 • 8:00 AM', monthAbbr: 'JUN', dayNum: 15, time: '8:00 AM',
//       location: 'Velachery, Chennai', tags: ['All are Welcome', 'Open for All'],
//       imageUrl: 'https://images.pexels.com/photos/6646918/pexels-photo-6646918.jpeg?w=400',
//       category: 'volunteering', isSaved: false,
//     ),
//   ];

//   static final List<NGO> ngos = [
//     const NGO(
//       id: 'n1', name: 'Ability Foundation', city: 'Chennai', type: 'Inclusive Community',
//       description: 'Empowering people with disabilities through art, education and advocacy.',
//       imageUrl: 'https://images.pexels.com/photos/6646918/pexels-photo-6646918.jpeg?w=400', isSaved: true,
//     ),
//     const NGO(
//       id: 'n2', name: 'Enable India', city: 'Bangalore', type: 'Employment & Skills',
//       description: 'Creating livelihood opportunities for people with disabilities.',
//       imageUrl: 'https://images.pexels.com/photos/3184418/pexels-photo-3184418.jpeg?w=400', isSaved: false,
//     ),
//     const NGO(
//       id: 'n3', name: 'Green Hands NGO', city: 'Chennai', type: 'Environment & Inclusion',
//       description: 'Building accessible green spaces for everyone.',
//       imageUrl: 'https://images.pexels.com/photos/7655912/pexels-photo-7655912.jpeg?w=400', isSaved: false,
//     ),
//   ];

//   static List<Place> placesForLocation(String location) {
//     final normalizedLocation = location.toLowerCase();
//     List<Place> selectedHotels = hotels;
//     List<Place> selectedRestaurants = restaurants;
//     List<Place> selectedCafes = cafes;
//     List<Place> selectedAttractions = attractions;

//     if (normalizedLocation.contains('agra')) {
//       selectedHotels = agraHotels;
//       selectedRestaurants = agraRestaurants;
//       selectedCafes = agraCafes;
//       selectedAttractions = agraAttractions;
//     } else if (normalizedLocation.contains('jaipur')) {
//       selectedHotels = jaipurHotels;
//       selectedRestaurants = jaipurRestaurants;
//       selectedCafes = jaipurCafes;
//       selectedAttractions = jaipurAttractions;
//     } else if (normalizedLocation.contains('delhi')) {
//       selectedHotels = delhiHotels;
//       selectedRestaurants = delhiRestaurants;
//       selectedCafes = delhiCafes;
//       selectedAttractions = delhiAttractions;
//     }

//     return [
//       ...selectedAttractions,
//       ...selectedHotels,
//       ...selectedRestaurants,
//       ...selectedCafes,
//     ];
//   }

//   static List<Place> get recommended => [hotels.first, restaurants.first];
// }











































// import 'models.dart';

// class MockData {
//   // DELHI PLACES
//   static final List<Place> delhiHotels = [
//     const Place(
//       id: 'dh1', name: 'Delhi Luxe Palace', type: 'hotel', rating: 4.7, reviewCount: 250,
//       priceDisplay: '₹3,500 / night',
//       accessibilityFeatures: ['Wheelchair Access', 'Elevator', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?w=600',
//       location: 'Connaught Place, Delhi', isSaved: false, distanceKm: 1.5,
//     ),
//     const Place(
//       id: 'dh2', name: 'Heritage Delhi Hotel', type: 'hotel', rating: 4.5, reviewCount: 180,
//       priceDisplay: '₹2,800 / night',
//       accessibilityFeatures: ['Wheelchair Friendly', 'Accessible Parking'],
//       imageUrl: 'https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg?w=600',
//       location: 'Kasturba Nagar, Delhi', isSaved: false, distanceKm: 2.3,
//     ),
//   ];

//   static final List<Place> delhiRestaurants = [
//     const Place(
//       id: 'dr1', name: 'Delhi Dine Delights', type: 'restaurant', rating: 4.6, reviewCount: 145,
//       priceDisplay: '', priceRange: '₹₹₹', cuisineType: 'North Indian',
//       accessibilityFeatures: ['Accessible Seating', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/1581384/pexels-photo-1581384.jpeg?w=600',
//       location: 'Chandni Chowk, Delhi', isSaved: false, distanceKm: 1.2,
//     ),
//     const Place(
//       id: 'dr2', name: 'Spice Symphony', type: 'restaurant', rating: 4.4, reviewCount: 112,
//       priceDisplay: '', priceRange: '₹₹', cuisineType: 'Multi-cuisine',
//       accessibilityFeatures: ['Wheelchair Access', 'Ramp'],
//       imageUrl: 'https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg?w=600',
//       location: 'New Delhi', isSaved: false, distanceKm: 2.1,
//     ),
//   ];

//   static final List<Place> delhiCafes = [
//     const Place(
//       id: 'dc1', name: 'Delhi Brew Lounge', type: 'cafe', rating: 4.5, reviewCount: 95,
//       priceDisplay: '', priceRange: '₹', cuisineType: 'Coffee & Snacks',
//       accessibilityFeatures: ['Wheelchair Access', 'Step-free Entry'],
//       imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?w=600',
//       location: 'Karol Bagh, Delhi', isSaved: false, distanceKm: 1.8,
//     ),
//     const Place(
//       id: 'dc2', name: 'Heritage Brew', type: 'cafe', rating: 4.3, reviewCount: 72,
//       priceDisplay: '', priceRange: '₹₹', cuisineType: 'Cafe & Desserts',
//       accessibilityFeatures: ['Elevator', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/208698/pexels-photo-208698.jpeg?w=600',
//       location: 'Old Delhi', isSaved: false, distanceKm: 2.5,
//     ),
//   ];

//   static final List<Place> delhiAttractions = [
//     const Place(
//       id: 'da1', name: 'Red Fort Complex', type: 'attraction', rating: 4.7, reviewCount: 290,
//       priceDisplay: '₹35 per person',
//       accessibilityFeatures: ['Wheelchair Access', 'Accessible Restroom', 'Ramp'],
//       imageUrl: 'https://images.pexels.com/photos/416676/pexels-photo-416676.jpeg?w=600',
//       location: 'Chandni Chowk, Delhi', isSaved: false, distanceKm: 1.2,
//     ),
//     const Place(
//       id: 'da2', name: 'Jama Masjid', type: 'attraction', rating: 4.5, reviewCount: 200,
//       priceDisplay: 'Free Entry',
//       accessibilityFeatures: ['Wheelchair Friendly', 'Accessible Seating'],
//       imageUrl: 'https://images.pexels.com/photos/1409140/pexels-photo-1409140.jpeg?w=600',
//       location: 'Old Delhi', isSaved: false, distanceKm: 1.5,
//     ),
//     const Place(
//       id: 'da3', name: 'National Museum', type: 'attraction', rating: 4.6, reviewCount: 175,
//       priceDisplay: '₹50 per person',
//       accessibilityFeatures: ['Wheelchair Access', 'Elevator', 'Audio Guide'],
//       imageUrl: 'https://images.pexels.com/photos/3683048/pexels-photo-3683048.jpeg?w=600',
//       location: 'Janpath, Delhi', isSaved: false, distanceKm: 2.2,
//     ),
//   ];

//   // AGRA PLACES (Taj Mahal)
//   static final List<Place> agraHotels = [
//     const Place(
//       id: 'ah1', name: 'Taj View Palace', type: 'hotel', rating: 4.8, reviewCount: 320,
//       priceDisplay: '₹4,000 / night',
//       accessibilityFeatures: ['Wheelchair Access', 'Elevator', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?w=600',
//       location: 'Fatehabad Road, Agra', isSaved: false, distanceKm: 2.0,
//     ),
//     const Place(
//       id: 'ah2', name: 'Marble City Hotel', type: 'hotel', rating: 4.6, reviewCount: 195,
//       priceDisplay: '₹2,500 / night',
//       accessibilityFeatures: ['Wheelchair Friendly', 'Accessible Parking'],
//       imageUrl: 'https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg?w=600',
//       location: 'Taj Ganj, Agra', isSaved: false, distanceKm: 1.8,
//     ),
//   ];

//   static final List<Place> agraRestaurants = [
//     const Place(
//       id: 'ar1', name: 'Moghul Mansion Dine', type: 'restaurant', rating: 4.5, reviewCount: 130,
//       priceDisplay: '', priceRange: '₹₹₹', cuisineType: 'Mughlai',
//       accessibilityFeatures: ['Accessible Seating', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/1581384/pexels-photo-1581384.jpeg?w=600',
//       location: 'Fatehabad Road, Agra', isSaved: false, distanceKm: 1.5,
//     ),
//     const Place(
//       id: 'ar2', name: 'Taj Spice Kitchen', type: 'restaurant', rating: 4.3, reviewCount: 95,
//       priceDisplay: '', priceRange: '₹₹', cuisineType: 'North Indian',
//       accessibilityFeatures: ['Wheelchair Access', 'Ramp'],
//       imageUrl: 'https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg?w=600',
//       location: 'Taj Ganj, Agra', isSaved: false, distanceKm: 2.3,
//     ),
//   ];

//   static final List<Place> agraCafes = [
//     const Place(
//       id: 'ac1', name: 'Taj Brew Cafe', type: 'cafe', rating: 4.4, reviewCount: 85,
//       priceDisplay: '', priceRange: '₹', cuisineType: 'Coffee & Desserts',
//       accessibilityFeatures: ['Wheelchair Access', 'Step-free Entry'],
//       imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?w=600',
//       location: 'Taj Road, Agra', isSaved: false, distanceKm: 1.2,
//     ),
//     const Place(
//       id: 'ac2', name: 'Heritage Cafe Agra', type: 'cafe', rating: 4.2, reviewCount: 68,
//       priceDisplay: '', priceRange: '₹', cuisineType: 'Snacks & Tea',
//       accessibilityFeatures: ['Accessible Seating', 'Braille Menu'],
//       imageUrl: 'https://images.pexels.com/photos/208698/pexels-photo-208698.jpeg?w=600',
//       location: 'Agra Downtown', isSaved: false, distanceKm: 2.8,
//     ),
//   ];

//   static final List<Place> agraAttractions = [
//     const Place(
//       id: 'aa1', name: 'Agra Fort', type: 'attraction', rating: 4.6, reviewCount: 260,
//       priceDisplay: '₹40 per person',
//       accessibilityFeatures: ['Wheelchair Access', 'Ramp', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/416676/pexels-photo-416676.jpeg?w=600',
//       location: 'Agra Fort Area', isSaved: false, distanceKm: 3.0,
//     ),
//     const Place(
//       id: 'aa2', name: 'Itmad-Ud-Daulah Tomb', type: 'attraction', rating: 4.5, reviewCount: 145,
//       priceDisplay: '₹30 per person',
//       accessibilityFeatures: ['Wheelchair Friendly', 'Accessible Seating'],
//       imageUrl: 'https://images.pexels.com/photos/1409140/pexels-photo-1409140.jpeg?w=600',
//       location: 'East of Taj Mahal, Agra', isSaved: false, distanceKm: 4.5,
//     ),
//   ];

//   // JAIPUR PLACES
//   static final List<Place> jaipurHotels = [
//     const Place(
//       id: 'jh1', name: 'Jaipur Palace Hotel', type: 'hotel', rating: 4.7, reviewCount: 280,
//       priceDisplay: '₹3,200 / night',
//       accessibilityFeatures: ['Wheelchair Access', 'Elevator', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?w=600',
//       location: 'Civil Lines, Jaipur', isSaved: false, distanceKm: 1.8,
//     ),
//     const Place(
//       id: 'jh2', name: 'Pink City Heritage Inn', type: 'hotel', rating: 4.5, reviewCount: 170,
//       priceDisplay: '₹2,300 / night',
//       accessibilityFeatures: ['Wheelchair Friendly', 'Accessible Parking'],
//       imageUrl: 'https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg?w=600',
//       location: 'Bani Park, Jaipur', isSaved: false, distanceKm: 2.5,
//     ),
//   ];

//   static final List<Place> jaipurRestaurants = [
//     const Place(
//       id: 'jr1', name: 'Rajasthan Royal Dine', type: 'restaurant', rating: 4.6, reviewCount: 140,
//       priceDisplay: '', priceRange: '₹₹₹', cuisineType: 'Rajasthani',
//       accessibilityFeatures: ['Accessible Seating', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/1581384/pexels-photo-1581384.jpeg?w=600',
//       location: 'M.I. Road, Jaipur', isSaved: false, distanceKm: 1.3,
//     ),
//     const Place(
//       id: 'jr2', name: 'Hawa Mahal Kitchen', type: 'restaurant', rating: 4.4, reviewCount: 105,
//       priceDisplay: '', priceRange: '₹₹', cuisineType: 'North Indian',
//       accessibilityFeatures: ['Wheelchair Access', 'Ramp'],
//       imageUrl: 'https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg?w=600',
//       location: 'Sanganeri Gate, Jaipur', isSaved: false, distanceKm: 2.1,
//     ),
//   ];

//   static final List<Place> jaipurCafes = [
//     const Place(
//       id: 'jc1', name: 'Pink Brew Cafe', type: 'cafe', rating: 4.5, reviewCount: 92,
//       priceDisplay: '', priceRange: '₹', cuisineType: 'Coffee & Pastries',
//       accessibilityFeatures: ['Wheelchair Access', 'Step-free Entry'],
//       imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?w=600',
//       location: 'C-Scheme, Jaipur', isSaved: false, distanceKm: 1.6,
//     ),
//     const Place(
//       id: 'jc2', name: 'Royal Tea House', type: 'cafe', rating: 4.3, reviewCount: 75,
//       priceDisplay: '', priceRange: '₹', cuisineType: 'Tea & Snacks',
//       accessibilityFeatures: ['Accessible Seating', 'Elevator'],
//       imageUrl: 'https://images.pexels.com/photos/208698/pexels-photo-208698.jpeg?w=600',
//       location: 'Jaipur City Center', isSaved: false, distanceKm: 2.2,
//     ),
//   ];

//   static final List<Place> jaipurAttractions = [
//     const Place(
//       id: 'ja1', name: 'City Palace', type: 'attraction', rating: 4.7, reviewCount: 315,
//       priceDisplay: '₹75 per person',
//       accessibilityFeatures: ['Wheelchair Access', 'Ramp', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/416676/pexels-photo-416676.jpeg?w=600',
//       location: 'Jaipur City Center', isSaved: false, distanceKm: 1.0,
//     ),
//     const Place(
//       id: 'ja2', name: 'Jantar Mantar Observatory', type: 'attraction', rating: 4.6, reviewCount: 225,
//       priceDisplay: '₹50 per person',
//       accessibilityFeatures: ['Wheelchair Friendly', 'Guided Tours', 'Accessible Seating'],
//       imageUrl: 'https://images.pexels.com/photos/1409140/pexels-photo-1409140.jpeg?w=600',
//       location: 'Jaipur', isSaved: false, distanceKm: 1.5,
//     ),
//   ];

//   // Default for other locations (general places)
//   static final List<Place> hotels = [
//     const Place(
//       id: 'h1', name: 'Sunrise Suites', type: 'hotel', rating: 4.7, reviewCount: 230,
//       priceDisplay: '₹2,800 / night',
//       accessibilityFeatures: ['Wheelchair Access', 'Elevator', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?w=600',
//       location: 'City Center', isSaved: false, distanceKm: 1.2,
//     ),
//     const Place(
//       id: 'h2', name: 'Comfort Vista Hotel', type: 'hotel', rating: 4.5, reviewCount: 168,
//       priceDisplay: '₹2,400 / night',
//       accessibilityFeatures: ['Wheelchair Friendly', 'Elevator'],
//       imageUrl: 'https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg?w=600',
//       location: 'Central District', isSaved: false, distanceKm: 2.1,
//     ),
//     const Place(
//       id: 'h3', name: 'Grand City Residency', type: 'hotel', rating: 4.6, reviewCount: 194,
//       priceDisplay: '₹3,100 / night',
//       accessibilityFeatures: ['Accessible Parking', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/2034335/pexels-photo-2034335.jpeg?w=600',
//       location: 'Business District', isSaved: false, distanceKm: 3.4,
//     ),
//     const Place(
//       id: 'h4', name: 'Maple Leaf Residency', type: 'hotel', rating: 4.3, reviewCount: 121,
//       priceDisplay: '₹1,900 / night',
//       accessibilityFeatures: ['Step-free Entry', 'Accessible Seating'],
//       imageUrl: 'https://images.pexels.com/photos/338504/pexels-photo-338504.jpeg?w=600',
//       location: 'North Avenue', isSaved: false, distanceKm: 4.0,
//     ),
//     const Place(
//       id: 'h5', name: 'Heritage Grand Hotel', type: 'hotel', rating: 4.8, reviewCount: 286,
//       priceDisplay: '₹4,200 / night',
//       accessibilityFeatures: ['Wheelchair Access', 'Elevator', 'Accessible Restroom', 'Accessible Parking'],
//       imageUrl: 'https://images.pexels.com/photos/261102/pexels-photo-261102.jpeg?w=600',
//       location: 'Heritage District', isSaved: false, distanceKm: 5.2,
//     ),
//   ];

//   static final List<Place> restaurants = [
//     const Place(
//       id: 'r1', name: 'The Green Kitchen', type: 'restaurant', rating: 4.4, reviewCount: 96,
//       priceDisplay: '', priceRange: '₹₹', cuisineType: 'Multi-cuisine',
//       accessibilityFeatures: ['Accessible Seating'],
//       imageUrl: 'https://images.pexels.com/photos/1581384/pexels-photo-1581384.jpeg?w=600',
//       location: 'City Area', isSaved: true, distanceKm: 1.8,
//     ),
//     const Place(
//       id: 'r2', name: 'Spice Route Kitchen', type: 'restaurant', rating: 4.5, reviewCount: 134,
//       priceDisplay: '', priceRange: '₹₹', cuisineType: 'Indian Cuisine',
//       accessibilityFeatures: ['Wheelchair Access', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg?w=600',
//       location: 'Market Street', isSaved: false, distanceKm: 2.4,
//     ),
//     const Place(
//       id: 'r3', name: 'Urban Table', type: 'restaurant', rating: 4.3, reviewCount: 98,
//       priceDisplay: '', priceRange: '₹₹₹', cuisineType: 'Multi-cuisine',
//       accessibilityFeatures: ['Accessible Seating', 'Ramp Access'],
//       imageUrl: 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?w=600',
//       location: 'Riverside Road', isSaved: false, distanceKm: 3.0,
//     ),
//     const Place(
//       id: 'r4', name: 'Royal Feast', type: 'restaurant', rating: 4.7, reviewCount: 211,
//       priceDisplay: '', priceRange: '₹₹₹', cuisineType: 'Traditional Cuisine',
//       accessibilityFeatures: ['Wheelchair Friendly', 'Braille Menu'],
//       imageUrl: 'https://images.pexels.com/photos/262978/pexels-photo-262978.jpeg?w=600',
//       location: 'Old Town', isSaved: false, distanceKm: 4.2,
//     ),
//     const Place(
//       id: 'r5', name: 'Green Garden Restaurant', type: 'restaurant', rating: 4.4, reviewCount: 156,
//       priceDisplay: '', priceRange: '₹₹', cuisineType: 'Vegetarian',
//       accessibilityFeatures: ['Accessible Parking', 'Accessible Seating'],
//       imageUrl: 'https://images.pexels.com/photos/315755/pexels-photo-315755.jpeg?w=600',
//       location: 'Garden Road', isSaved: false, distanceKm: 5.0,
//     ),
//   ];

//   static final List<Place> cafes = [
//     const Place(
//       id: 'c1', name: 'Brew Haven', type: 'cafe', rating: 4.5, reviewCount: 87,
//       priceDisplay: '', priceRange: '₹', cuisineType: 'Coffee & Pastries',
//       accessibilityFeatures: ['Wheelchair Access', 'Accessible Restroom'],
//       imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?w=600',
//       location: 'Main Area', isSaved: false, distanceKm: 2.3,
//     ),
//   ];

//   static final List<Place> attractions = [
//     const Place(
//       id: 'a1', name: 'Local Heritage Site', type: 'attraction', rating: 4.6, reviewCount: 245,
//       priceDisplay: 'Free Entry',
//       accessibilityFeatures: ['Wheelchair Access', 'Accessible Restroom', 'Ramp'],
//       imageUrl: 'https://images.pexels.com/photos/416676/pexels-photo-416676.jpeg?w=600',
//       location: 'City Center', isSaved: false, distanceKm: 4.5,
//     ),
//   ];

//   static final List<Event> events = [
//     const Event(
//       id: 'e1', title: 'Art & Inclusion Workshop', organizer: 'Ability Foundation',
//       dateDisplay: '30 Aug 2026 • 10:00 AM', monthAbbr: 'AUG', dayNum: 30, time: '10:00 AM',
//       location: 'Anna Nagar, Chennai', tags: ['Wheelchair Accessible', 'Inclusive'],
//       imageUrl: 'https://images.pexels.com/photos/6147369/pexels-photo-6147369.jpeg?w=400',
//       category: 'workshops', isSaved: true,
//     ),
//     const Event(
//       id: 'e2', title: 'Environment Awareness Drive', organizer: 'Green Hands NGO',
//       dateDisplay: '5 Sep 2026 • 9:30 AM', monthAbbr: 'SEP', dayNum: 5, time: '9:30 AM',
//       location: 'Marina Beach, Chennai', tags: ['Accessible Venue', 'Open for All'],
//       imageUrl: 'https://images.pexels.com/photos/7655912/pexels-photo-7655912.jpeg?w=400',
//       category: 'awareness', isSaved: false,
//     ),
//     const Event(
//       id: 'e3', title: 'Adaptive Sports Day', organizer: 'Enable India',
//       dateDisplay: '12 Sep 2026 • 9:00 AM', monthAbbr: 'SEP', dayNum: 12, time: '9:00 AM',
//       location: 'Jawaharlal Stadium, Chennai', tags: ['Accessible Venue', 'All are Welcome'],
//       imageUrl: 'https://images.pexels.com/photos/3621104/pexels-photo-3621104.jpeg?w=400',
//       category: 'awareness', isSaved: false,
//     ),
//     const Event(
//       id: 'e4', title: 'Disability Rights Seminar', organizer: 'Samarthya Trust',
//       dateDisplay: '20 Sep 2026 • 11:00 AM', monthAbbr: 'SEP', dayNum: 20, time: '11:00 AM',
//       location: 'IIT Madras, Chennai', tags: ['Wheelchair Accessible', 'Sign Language'],
//       imageUrl: 'https://images.pexels.com/photos/7648047/pexels-photo-7648047.jpeg?w=400',
//       category: 'workshops', isSaved: false,
//     ),
//     const Event(
//       id: 'e5', title: 'Community Volunteer Drive', organizer: 'HelpAge India',
//       dateDisplay: '28 Sep 2026 • 8:00 AM', monthAbbr: 'SEP', dayNum: 28, time: '8:00 AM',
//       location: 'Velachery, Chennai', tags: ['All are Welcome', 'Open for All'],
//       imageUrl: 'https://images.pexels.com/photos/6646918/pexels-photo-6646918.jpeg?w=400',
//       category: 'volunteering', isSaved: false,
//     ),
//   ];

//   static final List<NGO> ngos = [
//     const NGO(
//       id: 'n1', name: 'Ability Foundation', city: 'Chennai', type: 'Inclusive Community',
//       description: 'Empowering people with disabilities through art, education and advocacy.',
//       imageUrl: 'https://images.pexels.com/photos/6646918/pexels-photo-6646918.jpeg?w=400', isSaved: true,
//     ),
//     const NGO(
//       id: 'n2', name: 'Enable India', city: 'Bangalore', type: 'Employment & Skills',
//       description: 'Creating livelihood opportunities for people with disabilities.',
//       imageUrl: 'https://images.pexels.com/photos/3184418/pexels-photo-3184418.jpeg?w=400', isSaved: false,
//     ),
//     const NGO(
//       id: 'n3', name: 'Green Hands NGO', city: 'Chennai', type: 'Environment & Inclusion',
//       description: 'Building accessible green spaces for everyone.',
//       imageUrl: 'https://images.pexels.com/photos/7655912/pexels-photo-7655912.jpeg?w=400', isSaved: false,
//     ),
//   ];

//   static List<Place> placesForLocation(String location) {
//     final normalizedLocation = location.toLowerCase();
//     List<Place> selectedHotels = hotels;
//     List<Place> selectedRestaurants = restaurants;
//     List<Place> selectedCafes = cafes;
//     List<Place> selectedAttractions = attractions;

//     if (normalizedLocation.contains('agra')) {
//       selectedHotels = agraHotels;
//       selectedRestaurants = agraRestaurants;
//       selectedCafes = agraCafes;
//       selectedAttractions = agraAttractions;
//     } else if (normalizedLocation.contains('jaipur')) {
//       selectedHotels = jaipurHotels;
//       selectedRestaurants = jaipurRestaurants;
//       selectedCafes = jaipurCafes;
//       selectedAttractions = jaipurAttractions;
//     } else if (normalizedLocation.contains('delhi')) {
//       selectedHotels = delhiHotels;
//       selectedRestaurants = delhiRestaurants;
//       selectedCafes = delhiCafes;
//       selectedAttractions = delhiAttractions;
//     }

//     return [
//       ...selectedAttractions,
//       ...selectedHotels,
//       ...selectedRestaurants,
//       ...selectedCafes,
//     ];
//   }

//   static List<Place> get recommended => [hotels.first, restaurants.first];
// }













































import 'models.dart';

class MockData {
  // DELHI PLACES
  static final List<Place> delhiHotels = [
    const Place(
      id: 'dh1', name: 'Delhi Luxe Palace', type: 'hotel', rating: 4.7, reviewCount: 250,
      priceDisplay: '₹3,500 / night',
      accessibilityFeatures: ['Wheelchair Access', 'Elevator', 'Accessible Restroom'],
      imageUrl: 'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?w=600',
      location: 'Connaught Place, Delhi', isSaved: false, distanceKm: 1.5,
    ),
    const Place(
      id: 'dh2', name: 'Heritage Delhi Hotel', type: 'hotel', rating: 4.5, reviewCount: 180,
      priceDisplay: '₹2,800 / night',
      accessibilityFeatures: ['Wheelchair Friendly', 'Accessible Parking'],
      imageUrl: 'https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg?w=600',
      location: 'Kasturba Nagar, Delhi', isSaved: false, distanceKm: 2.3,
    ),
  ];

  static final List<Place> delhiRestaurants = [
    const Place(
      id: 'dr1', name: 'Delhi Dine Delights', type: 'restaurant', rating: 4.6, reviewCount: 145,
      priceDisplay: '', priceRange: '₹₹₹', cuisineType: 'North Indian',
      accessibilityFeatures: ['Accessible Seating', 'Accessible Restroom'],
      imageUrl: 'https://images.pexels.com/photos/1581384/pexels-photo-1581384.jpeg?w=600',
      location: 'Chandni Chowk, Delhi', isSaved: false, distanceKm: 1.2,
    ),
    const Place(
      id: 'dr2', name: 'Spice Symphony', type: 'restaurant', rating: 4.4, reviewCount: 112,
      priceDisplay: '', priceRange: '₹₹', cuisineType: 'Multi-cuisine',
      accessibilityFeatures: ['Wheelchair Access', 'Ramp'],
      imageUrl: 'https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg?w=600',
      location: 'New Delhi', isSaved: false, distanceKm: 2.1,
    ),
  ];

  static final List<Place> delhiCafes = [
    const Place(
      id: 'dc1', name: 'Delhi Brew Lounge', type: 'cafe', rating: 4.5, reviewCount: 95,
      priceDisplay: '', priceRange: '₹', cuisineType: 'Coffee & Snacks',
      accessibilityFeatures: ['Wheelchair Access', 'Step-free Entry'],
      imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?w=600',
      location: 'Karol Bagh, Delhi', isSaved: false, distanceKm: 1.8,
    ),
    const Place(
      id: 'dc2', name: 'Heritage Brew', type: 'cafe', rating: 4.3, reviewCount: 72,
      priceDisplay: '', priceRange: '₹₹', cuisineType: 'Cafe & Desserts',
      accessibilityFeatures: ['Elevator', 'Accessible Restroom'],
      imageUrl: 'https://images.pexels.com/photos/208698/pexels-photo-208698.jpeg?w=600',
      location: 'Old Delhi', isSaved: false, distanceKm: 2.5,
    ),
  ];

  static final List<Place> delhiAttractions = [
    const Place(
      id: 'da1', name: 'Red Fort Complex', type: 'attraction', rating: 4.7, reviewCount: 290,
      priceDisplay: '₹35 per person',
      accessibilityFeatures: ['Wheelchair Access', 'Accessible Restroom', 'Ramp'],
      imageUrl: 'https://images.pexels.com/photos/416676/pexels-photo-416676.jpeg?w=600',
      location: 'Chandni Chowk, Delhi', isSaved: false, distanceKm: 1.2,
    ),
    const Place(
      id: 'da2', name: 'Jama Masjid', type: 'attraction', rating: 4.5, reviewCount: 200,
      priceDisplay: 'Free Entry',
      accessibilityFeatures: ['Wheelchair Friendly', 'Accessible Seating'],
      imageUrl: 'https://images.pexels.com/photos/1409140/pexels-photo-1409140.jpeg?w=600',
      location: 'Old Delhi', isSaved: false, distanceKm: 1.5,
    ),
    const Place(
      id: 'da3', name: 'National Museum', type: 'attraction', rating: 4.6, reviewCount: 175,
      priceDisplay: '₹50 per person',
      accessibilityFeatures: ['Wheelchair Access', 'Elevator', 'Audio Guide'],
      imageUrl: 'https://images.pexels.com/photos/3683048/pexels-photo-3683048.jpeg?w=600',
      location: 'Janpath, Delhi', isSaved: false, distanceKm: 2.2,
    ),
  ];

  // AGRA PLACES (Taj Mahal)
  static final List<Place> agraHotels = [
    const Place(
      id: 'ah1', name: 'Taj View Palace', type: 'hotel', rating: 4.8, reviewCount: 320,
      priceDisplay: '₹4,000 / night',
      accessibilityFeatures: ['Wheelchair Access', 'Elevator', 'Accessible Restroom'],
      imageUrl: 'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?w=600',
      location: 'Fatehabad Road, Agra', isSaved: false, distanceKm: 2.0,
    ),
    const Place(
      id: 'ah2', name: 'Marble City Hotel', type: 'hotel', rating: 4.6, reviewCount: 195,
      priceDisplay: '₹2,500 / night',
      accessibilityFeatures: ['Wheelchair Friendly', 'Accessible Parking'],
      imageUrl: 'https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg?w=600',
      location: 'Taj Ganj, Agra', isSaved: false, distanceKm: 1.8,
    ),
  ];

  static final List<Place> agraRestaurants = [
    const Place(
      id: 'ar1', name: 'Moghul Mansion Dine', type: 'restaurant', rating: 4.5, reviewCount: 130,
      priceDisplay: '', priceRange: '₹₹₹', cuisineType: 'Mughlai',
      accessibilityFeatures: ['Accessible Seating', 'Accessible Restroom'],
      imageUrl: 'https://images.pexels.com/photos/1581384/pexels-photo-1581384.jpeg?w=600',
      location: 'Fatehabad Road, Agra', isSaved: false, distanceKm: 1.5,
    ),
    const Place(
      id: 'ar2', name: 'Taj Spice Kitchen', type: 'restaurant', rating: 4.3, reviewCount: 95,
      priceDisplay: '', priceRange: '₹₹', cuisineType: 'North Indian',
      accessibilityFeatures: ['Wheelchair Access', 'Ramp'],
      imageUrl: 'https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg?w=600',
      location: 'Taj Ganj, Agra', isSaved: false, distanceKm: 2.3,
    ),
  ];

  static final List<Place> agraCafes = [
    const Place(
      id: 'ac1', name: 'Taj Brew Cafe', type: 'cafe', rating: 4.4, reviewCount: 85,
      priceDisplay: '', priceRange: '₹', cuisineType: 'Coffee & Desserts',
      accessibilityFeatures: ['Wheelchair Access', 'Step-free Entry'],
      imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?w=600',
      location: 'Taj Road, Agra', isSaved: false, distanceKm: 1.2,
    ),
    const Place(
      id: 'ac2', name: 'Heritage Cafe Agra', type: 'cafe', rating: 4.2, reviewCount: 68,
      priceDisplay: '', priceRange: '₹', cuisineType: 'Snacks & Tea',
      accessibilityFeatures: ['Accessible Seating', 'Braille Menu'],
      imageUrl: 'https://images.pexels.com/photos/208698/pexels-photo-208698.jpeg?w=600',
      location: 'Agra Downtown', isSaved: false, distanceKm: 2.8,
    ),
  ];

  static final List<Place> agraAttractions = [
    const Place(
      id: 'aa1', name: 'Agra Fort', type: 'attraction', rating: 4.6, reviewCount: 260,
      priceDisplay: '₹40 per person',
      accessibilityFeatures: ['Wheelchair Access', 'Ramp', 'Accessible Restroom'],
      imageUrl: 'https://images.pexels.com/photos/416676/pexels-photo-416676.jpeg?w=600',
      location: 'Agra Fort Area', isSaved: false, distanceKm: 3.0,
    ),
    const Place(
      id: 'aa2', name: 'Itmad-Ud-Daulah Tomb', type: 'attraction', rating: 4.5, reviewCount: 145,
      priceDisplay: '₹30 per person',
      accessibilityFeatures: ['Wheelchair Friendly', 'Accessible Seating'],
      imageUrl: 'https://images.pexels.com/photos/1409140/pexels-photo-1409140.jpeg?w=600',
      location: 'East of Taj Mahal, Agra', isSaved: false, distanceKm: 4.5,
    ),
  ];

  // JAIPUR PLACES
  static final List<Place> jaipurHotels = [
    const Place(
      id: 'jh1', name: 'Jaipur Palace Hotel', type: 'hotel', rating: 4.7, reviewCount: 280,
      priceDisplay: '₹3,200 / night',
      accessibilityFeatures: ['Wheelchair Access', 'Elevator', 'Accessible Restroom'],
      imageUrl: 'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?w=600',
      location: 'Civil Lines, Jaipur', isSaved: false, distanceKm: 1.8,
    ),
    const Place(
      id: 'jh2', name: 'Pink City Heritage Inn', type: 'hotel', rating: 4.5, reviewCount: 170,
      priceDisplay: '₹2,300 / night',
      accessibilityFeatures: ['Wheelchair Friendly', 'Accessible Parking'],
      imageUrl: 'https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg?w=600',
      location: 'Bani Park, Jaipur', isSaved: false, distanceKm: 2.5,
    ),
  ];

  static final List<Place> jaipurRestaurants = [
    const Place(
      id: 'jr1', name: 'Rajasthan Royal Dine', type: 'restaurant', rating: 4.6, reviewCount: 140,
      priceDisplay: '', priceRange: '₹₹₹', cuisineType: 'Rajasthani',
      accessibilityFeatures: ['Accessible Seating', 'Accessible Restroom'],
      imageUrl: 'https://images.pexels.com/photos/1581384/pexels-photo-1581384.jpeg?w=600',
      location: 'M.I. Road, Jaipur', isSaved: false, distanceKm: 1.3,
    ),
    const Place(
      id: 'jr2', name: 'Hawa Mahal Kitchen', type: 'restaurant', rating: 4.4, reviewCount: 105,
      priceDisplay: '', priceRange: '₹₹', cuisineType: 'North Indian',
      accessibilityFeatures: ['Wheelchair Access', 'Ramp'],
      imageUrl: 'https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg?w=600',
      location: 'Sanganeri Gate, Jaipur', isSaved: false, distanceKm: 2.1,
    ),
  ];

  static final List<Place> jaipurCafes = [
    const Place(
      id: 'jc1', name: 'Pink Brew Cafe', type: 'cafe', rating: 4.5, reviewCount: 92,
      priceDisplay: '', priceRange: '₹', cuisineType: 'Coffee & Pastries',
      accessibilityFeatures: ['Wheelchair Access', 'Step-free Entry'],
      imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?w=600',
      location: 'C-Scheme, Jaipur', isSaved: false, distanceKm: 1.6,
    ),
    const Place(
      id: 'jc2', name: 'Royal Tea House', type: 'cafe', rating: 4.3, reviewCount: 75,
      priceDisplay: '', priceRange: '₹', cuisineType: 'Tea & Snacks',
      accessibilityFeatures: ['Accessible Seating', 'Elevator'],
      imageUrl: 'https://images.pexels.com/photos/208698/pexels-photo-208698.jpeg?w=600',
      location: 'Jaipur City Center', isSaved: false, distanceKm: 2.2,
    ),
  ];

  static final List<Place> jaipurAttractions = [
    const Place(
      id: 'ja1', name: 'City Palace', type: 'attraction', rating: 4.7, reviewCount: 315,
      priceDisplay: '₹75 per person',
      accessibilityFeatures: ['Wheelchair Access', 'Ramp', 'Accessible Restroom'],
      imageUrl: 'https://images.pexels.com/photos/416676/pexels-photo-416676.jpeg?w=600',
      location: 'Jaipur City Center', isSaved: false, distanceKm: 1.0,
    ),
    const Place(
      id: 'ja2', name: 'Jantar Mantar Observatory', type: 'attraction', rating: 4.6, reviewCount: 225,
      priceDisplay: '₹50 per person',
      accessibilityFeatures: ['Wheelchair Friendly', 'Guided Tours', 'Accessible Seating'],
      imageUrl: 'https://images.pexels.com/photos/1409140/pexels-photo-1409140.jpeg?w=600',
      location: 'Jaipur', isSaved: false, distanceKm: 1.5,
    ),
  ];

  // Default for other locations (general places)
  static final List<Place> hotels = [
    const Place(
      id: 'h1', name: 'Sunrise Suites', type: 'hotel', rating: 4.7, reviewCount: 230,
      priceDisplay: '₹2,800 / night',
      accessibilityFeatures: ['Wheelchair Access', 'Elevator', 'Accessible Restroom'],
      imageUrl: 'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?w=600',
      location: 'City Center', isSaved: false, distanceKm: 1.2,
    ),
    const Place(
      id: 'h2', name: 'Comfort Vista Hotel', type: 'hotel', rating: 4.5, reviewCount: 168,
      priceDisplay: '₹2,400 / night',
      accessibilityFeatures: ['Wheelchair Friendly', 'Elevator'],
      imageUrl: 'https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg?w=600',
      location: 'Central District', isSaved: false, distanceKm: 2.1,
    ),
    const Place(
      id: 'h3', name: 'Grand City Residency', type: 'hotel', rating: 4.6, reviewCount: 194,
      priceDisplay: '₹3,100 / night',
      accessibilityFeatures: ['Accessible Parking', 'Accessible Restroom'],
      imageUrl: 'https://images.pexels.com/photos/2034335/pexels-photo-2034335.jpeg?w=600',
      location: 'Business District', isSaved: false, distanceKm: 3.4,
    ),
    const Place(
      id: 'h4', name: 'Maple Leaf Residency', type: 'hotel', rating: 4.3, reviewCount: 121,
      priceDisplay: '₹1,900 / night',
      accessibilityFeatures: ['Step-free Entry', 'Accessible Seating'],
      imageUrl: 'https://images.pexels.com/photos/338504/pexels-photo-338504.jpeg?w=600',
      location: 'North Avenue', isSaved: false, distanceKm: 4.0,
    ),
    const Place(
      id: 'h5', name: 'Heritage Grand Hotel', type: 'hotel', rating: 4.8, reviewCount: 286,
      priceDisplay: '₹4,200 / night',
      accessibilityFeatures: ['Wheelchair Access', 'Elevator', 'Accessible Restroom', 'Accessible Parking'],
      imageUrl: 'https://images.pexels.com/photos/261102/pexels-photo-261102.jpeg?w=600',
      location: 'Heritage District', isSaved: false, distanceKm: 5.2,
    ),
  ];

  static final List<Place> restaurants = [
    const Place(
      id: 'r1', name: 'The Green Kitchen', type: 'restaurant', rating: 4.4, reviewCount: 96,
      priceDisplay: '', priceRange: '₹₹', cuisineType: 'Multi-cuisine',
      accessibilityFeatures: ['Accessible Seating'],
      imageUrl: 'https://images.pexels.com/photos/1581384/pexels-photo-1581384.jpeg?w=600',
      location: 'City Area', isSaved: true, distanceKm: 1.8,
    ),
    const Place(
      id: 'r2', name: 'Spice Route Kitchen', type: 'restaurant', rating: 4.5, reviewCount: 134,
      priceDisplay: '', priceRange: '₹₹', cuisineType: 'Indian Cuisine',
      accessibilityFeatures: ['Wheelchair Access', 'Accessible Restroom'],
      imageUrl: 'https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg?w=600',
      location: 'Market Street', isSaved: false, distanceKm: 2.4,
    ),
    const Place(
      id: 'r3', name: 'Urban Table', type: 'restaurant', rating: 4.3, reviewCount: 98,
      priceDisplay: '', priceRange: '₹₹₹', cuisineType: 'Multi-cuisine',
      accessibilityFeatures: ['Accessible Seating', 'Ramp Access'],
      imageUrl: 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?w=600',
      location: 'Riverside Road', isSaved: false, distanceKm: 3.0,
    ),
    const Place(
      id: 'r4', name: 'Royal Feast', type: 'restaurant', rating: 4.7, reviewCount: 211,
      priceDisplay: '', priceRange: '₹₹₹', cuisineType: 'Traditional Cuisine',
      accessibilityFeatures: ['Wheelchair Friendly', 'Braille Menu'],
      imageUrl: 'https://images.pexels.com/photos/262978/pexels-photo-262978.jpeg?w=600',
      location: 'Old Town', isSaved: false, distanceKm: 4.2,
    ),
    const Place(
      id: 'r5', name: 'Green Garden Restaurant', type: 'restaurant', rating: 4.4, reviewCount: 156,
      priceDisplay: '', priceRange: '₹₹', cuisineType: 'Vegetarian',
      accessibilityFeatures: ['Accessible Parking', 'Accessible Seating'],
      imageUrl: 'https://images.pexels.com/photos/315755/pexels-photo-315755.jpeg?w=600',
      location: 'Garden Road', isSaved: false, distanceKm: 5.0,
    ),
  ];

  static final List<Place> cafes = [
    const Place(
      id: 'c1', name: 'Brew Haven', type: 'cafe', rating: 4.5, reviewCount: 87,
      priceDisplay: '', priceRange: '₹', cuisineType: 'Coffee & Pastries',
      accessibilityFeatures: ['Wheelchair Access', 'Accessible Restroom'],
      imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?w=600',
      location: 'Main Area', isSaved: false, distanceKm: 2.3,
    ),
  ];

  static final List<Place> attractions = [
    const Place(
      id: 'a1', name: 'Local Heritage Site', type: 'attraction', rating: 4.6, reviewCount: 245,
      priceDisplay: 'Free Entry',
      accessibilityFeatures: ['Wheelchair Access', 'Accessible Restroom', 'Ramp'],
      imageUrl: 'https://images.pexels.com/photos/416676/pexels-photo-416676.jpeg?w=600',
      location: 'City Center', isSaved: false, distanceKm: 4.5,
    ),
  ];

  static final List<Event> events = [
    const Event(
      id: 'e1', title: 'Art & Inclusion Workshop', organizer: 'Ability Foundation',
      dateDisplay: '30 Aug 2026 • 10:00 AM', monthAbbr: 'AUG', dayNum: 30, time: '10:00 AM',
      location: 'Anna Nagar, Chennai', tags: ['Wheelchair Accessible', 'Inclusive'],
      imageUrl: 'https://images.pexels.com/photos/6147369/pexels-photo-6147369.jpeg?w=400',
      category: 'workshops', isSaved: true,
    ),
    const Event(
      id: 'e2', title: 'Environment Awareness Drive', organizer: 'Green Hands NGO',
      dateDisplay: '5 Sep 2026 • 9:30 AM', monthAbbr: 'SEP', dayNum: 5, time: '9:30 AM',
      location: 'Marina Beach, Chennai', tags: ['Accessible Venue', 'Open for All'],
      imageUrl: 'https://images.pexels.com/photos/7655912/pexels-photo-7655912.jpeg?w=400',
      category: 'awareness', isSaved: false,
    ),
    const Event(
      id: 'e3', title: 'Adaptive Sports Day', organizer: 'Enable India',
      dateDisplay: '12 Sep 2026 • 9:00 AM', monthAbbr: 'SEP', dayNum: 12, time: '9:00 AM',
      location: 'Jawaharlal Stadium, Chennai', tags: ['Accessible Venue', 'All are Welcome'],
      imageUrl: 'https://images.pexels.com/photos/3621104/pexels-photo-3621104.jpeg?w=400',
      category: 'awareness', isSaved: false,
    ),
    const Event(
      id: 'e4', title: 'Disability Rights Seminar', organizer: 'Samarthya Trust',
      dateDisplay: '20 Sep 2026 • 11:00 AM', monthAbbr: 'SEP', dayNum: 20, time: '11:00 AM',
      location: 'IIT Madras, Chennai', tags: ['Wheelchair Accessible', 'Sign Language'],
      imageUrl: 'https://images.pexels.com/photos/7648047/pexels-photo-7648047.jpeg?w=400',
      category: 'workshops', isSaved: false,
    ),
    const Event(
      id: 'e5', title: 'Community Volunteer Drive', organizer: 'HelpAge India',
      dateDisplay: '28 Sep 2026 • 8:00 AM', monthAbbr: 'SEP', dayNum: 28, time: '8:00 AM',
      location: 'Velachery, Chennai', tags: ['All are Welcome', 'Open for All'],
      imageUrl: 'https://images.pexels.com/photos/6646918/pexels-photo-6646918.jpeg?w=400',
      category: 'volunteering', isSaved: false,
    ),
  ];

  static final List<NGO> ngos = [
    const NGO(
      id: 'n1', name: 'Ability Foundation', city: 'Chennai', type: 'Inclusive Community',
      description: 'Empowering people with disabilities through art, education and advocacy.',
      imageUrl: 'https://images.pexels.com/photos/6646918/pexels-photo-6646918.jpeg?w=400', isSaved: true,
    ),
    const NGO(
      id: 'n2', name: 'Enable India', city: 'Bangalore', type: 'Employment & Skills',
      description: 'Creating livelihood opportunities for people with disabilities.',
      imageUrl: 'https://images.pexels.com/photos/3184418/pexels-photo-3184418.jpeg?w=400', isSaved: false,
    ),
    const NGO(
      id: 'n3', name: 'Green Hands NGO', city: 'Chennai', type: 'Environment & Inclusion',
      description: 'Building accessible green spaces for everyone.',
      imageUrl: 'https://images.pexels.com/photos/7655912/pexels-photo-7655912.jpeg?w=400', isSaved: false,
    ),
  ];

  // ── Chennai places ────────────────────────────────────────────
  static const List<Place> chennaiHotels = [
    Place(id: 'chh1', name: 'ITC Grand Chola', type: 'hotel', rating: 4.8,
      reviewCount: 1240, location: 'Guindy, Chennai', distanceKm: 1.2,
      priceDisplay: '₹8,000 / night',
      imageUrl: 'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?w=400',
      accessibilityFeatures: ['Wheelchair Access', 'Elevator', 'Accessible Rooms'], isSaved: false),
    Place(id: 'chh2', name: 'Taj Coromandel', type: 'hotel', rating: 4.7,
      reviewCount: 980, location: 'Nungambakkam, Chennai', distanceKm: 2.1,
      priceDisplay: '₹7,000 / night',
      imageUrl: 'https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg?w=400',
      accessibilityFeatures: ['Roll-in Shower', 'Step-free Access', 'Elevator'], isSaved: false),
    Place(id: 'chh3', name: 'Residency Towers', type: 'hotel', rating: 4.5,
      reviewCount: 650, location: 'T Nagar, Chennai', distanceKm: 3.4,
      priceDisplay: '₹4,500 / night',
      imageUrl: 'https://images.pexels.com/photos/338504/pexels-photo-338504.jpeg?w=400',
      accessibilityFeatures: ['Wheelchair Ramp', 'Accessible Parking'], isSaved: false),
  ];
  static const List<Place> chennaiRestaurants = [
    Place(id: 'chr1', name: 'Peshawri - ITC Grand', type: 'restaurant', rating: 4.6,
      reviewCount: 540, location: 'Guindy, Chennai', distanceKm: 1.2,
      priceDisplay: '',
      imageUrl: 'https://images.pexels.com/photos/1581384/pexels-photo-1581384.jpeg?w=400',
      accessibilityFeatures: ['Wheelchair Access', 'Accessible Restroom'], isSaved: false),
    Place(id: 'chr2', name: 'Southern Spice - Taj', type: 'restaurant', rating: 4.5,
      reviewCount: 430, location: 'Nungambakkam, Chennai', distanceKm: 2.1,
      priceDisplay: '',
      imageUrl: 'https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg?w=400',
      accessibilityFeatures: ['Step-free Entry', 'Wide Aisles'], isSaved: false),
    Place(id: 'chr3', name: 'Murugan Idli Shop', type: 'restaurant', rating: 4.4,
      reviewCount: 820, location: 'T Nagar, Chennai', distanceKm: 3.0,
      priceDisplay: '',
      imageUrl: 'https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg?w=400',
      accessibilityFeatures: ['Ground Level', 'Wide Entrance'], isSaved: false),
  ];
  static const List<Place> chennaiCafes = [];
  static const List<Place> chennaiAttractions = [];

  static List<Place> placesForLocation(String location) {
    final normalizedLocation = location.toLowerCase();
    List<Place> selectedHotels = hotels;
    List<Place> selectedRestaurants = restaurants;
    List<Place> selectedCafes = cafes;
    List<Place> selectedAttractions = attractions;

    if (normalizedLocation.contains('agra')) {
      selectedHotels = agraHotels;
      selectedRestaurants = agraRestaurants;
      selectedCafes = agraCafes;
      selectedAttractions = agraAttractions;
    } else if (normalizedLocation.contains('jaipur')) {
      selectedHotels = jaipurHotels;
      selectedRestaurants = jaipurRestaurants;
      selectedCafes = jaipurCafes;
      selectedAttractions = jaipurAttractions;
    } else if (normalizedLocation.contains('delhi')) {
      selectedHotels = delhiHotels;
      selectedRestaurants = delhiRestaurants;
      selectedCafes = delhiCafes;
      selectedAttractions = delhiAttractions;
    } else if (normalizedLocation.contains('chennai') || normalizedLocation.contains('marina') || normalizedLocation.contains('meenakshi')) {
      selectedHotels = chennaiHotels;
      selectedRestaurants = chennaiRestaurants;
      selectedCafes = chennaiCafes;
      selectedAttractions = chennaiAttractions;
    }

    return [
      ...selectedAttractions,
      ...selectedHotels,
      ...selectedRestaurants,
      ...selectedCafes,
    ];
  }

  static List<Place> get recommended => [hotels.first, restaurants.first];
}
