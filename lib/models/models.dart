class Place {
  final String id;
  final String name;
  final String type;
  final double rating;
  final int reviewCount;
  final String priceDisplay;
  final String? priceRange;
  final String? cuisineType;
  final List<String> accessibilityFeatures;
  final String imageUrl;
  final String location;
  final bool isSaved;
  final double distanceKm;

  const Place({
    required this.id,
    required this.name,
    required this.type,
    required this.rating,
    required this.reviewCount,
    required this.priceDisplay,
    this.priceRange,
    this.cuisineType,
    required this.accessibilityFeatures,
    required this.imageUrl,
    required this.location,
    this.isSaved = false,
    this.distanceKm = 0.0,
  });

  Place copyWith({bool? isSaved}) => Place(
        id: id, name: name, type: type, rating: rating, reviewCount: reviewCount,
        priceDisplay: priceDisplay, priceRange: priceRange, cuisineType: cuisineType,
        accessibilityFeatures: accessibilityFeatures, imageUrl: imageUrl,
        location: location, isSaved: isSaved ?? this.isSaved, distanceKm: distanceKm,
      );
}

class Event {
  final String id;
  final String title;
  final String organizer;
  final String dateDisplay;
  final String monthAbbr;
  final int dayNum;
  final String time;
  final String location;
  final List<String> tags;
  final String imageUrl;
  final String category;
  final bool isSaved;

  const Event({
    required this.id, required this.title, required this.organizer,
    required this.dateDisplay, required this.monthAbbr, required this.dayNum,
    required this.time, required this.location, required this.tags,
    required this.imageUrl, required this.category, this.isSaved = false,
  });

  Event copyWith({bool? isSaved}) => Event(
        id: id, title: title, organizer: organizer, dateDisplay: dateDisplay,
        monthAbbr: monthAbbr, dayNum: dayNum, time: time, location: location,
        tags: tags, imageUrl: imageUrl, category: category, isSaved: isSaved ?? this.isSaved,
      );
}

class NGO {
  final String id;
  final String name;
  final String city;
  final String type;
  final String description;
  final String imageUrl;
  final bool isSaved;

  const NGO({
    required this.id, required this.name, required this.city, required this.type,
    required this.description, required this.imageUrl, this.isSaved = false,
  });

  NGO copyWith({bool? isSaved}) => NGO(
        id: id, name: name, city: city, type: type, description: description,
        imageUrl: imageUrl, isSaved: isSaved ?? this.isSaved,
      );
}

class AccessibilityPrefs {
  final bool wheelchairAccess;
  final bool accessibleRestroom;
  final bool elevator;
  final bool accessibleParking;
  final bool brailleMenu;
  final bool hearingAssistance;
  final bool stepFreeEntry;

  const AccessibilityPrefs({
    this.wheelchairAccess = true, this.accessibleRestroom = true,
    this.elevator = false, this.accessibleParking = false,
    this.brailleMenu = false, this.hearingAssistance = false, this.stepFreeEntry = false,
  });

  AccessibilityPrefs copyWith({
    bool? wheelchairAccess, bool? accessibleRestroom, bool? elevator,
    bool? accessibleParking, bool? brailleMenu, bool? hearingAssistance, bool? stepFreeEntry,
  }) => AccessibilityPrefs(
        wheelchairAccess: wheelchairAccess ?? this.wheelchairAccess,
        accessibleRestroom: accessibleRestroom ?? this.accessibleRestroom,
        elevator: elevator ?? this.elevator,
        accessibleParking: accessibleParking ?? this.accessibleParking,
        brailleMenu: brailleMenu ?? this.brailleMenu,
        hearingAssistance: hearingAssistance ?? this.hearingAssistance,
        stepFreeEntry: stepFreeEntry ?? this.stepFreeEntry,
      );
}
  