class AccessibilityFeatures {
  final bool? wheelchairEntrance;
  final bool? wheelchairRestroom;
  final bool? wheelchairSeating;
  final bool? rampAccess;
  final bool? elevatorAccess;
  final bool? accessibleParking;
  final bool? brailleMenu;
  final bool? largePrintMenu;
  final bool? signLanguageStaff;
  final bool? serviceDogsWelcome;
  final bool? hearingLoop;
  final bool? visualAlerts;
  final bool? wideAisles;
  final bool? loweredCounters;
  final bool? grabBarsRestroom;
  final bool? accessibleRooms;
  final bool? rollInShower;
  final bool? visualDoorKnock;
  final bool? tactileSignage;
  final bool? quietHours;
  final bool? sensoryFriendly;
  final bool? staffDisabilityTraining;

  AccessibilityFeatures({
    this.wheelchairEntrance,
    this.wheelchairRestroom,
    this.wheelchairSeating,
    this.rampAccess,
    this.elevatorAccess,
    this.accessibleParking,
    this.brailleMenu,
    this.largePrintMenu,
    this.signLanguageStaff,
    this.serviceDogsWelcome,
    this.hearingLoop,
    this.visualAlerts,
    this.wideAisles,
    this.loweredCounters,
    this.grabBarsRestroom,
    this.accessibleRooms,
    this.rollInShower,
    this.visualDoorKnock,
    this.tactileSignage,
    this.quietHours,
    this.sensoryFriendly,
    this.staffDisabilityTraining,
  });

  factory AccessibilityFeatures.fromJson(Map<String, dynamic> json) {
    return AccessibilityFeatures(
      wheelchairEntrance: json['wheelchair_entrance'] as bool?,
      wheelchairRestroom: json['wheelchair_restroom'] as bool?,
      wheelchairSeating: json['wheelchair_seating'] as bool?,
      rampAccess: json['ramp_access'] as bool?,
      elevatorAccess: json['elevator_access'] as bool?,
      accessibleParking: json['accessible_parking'] as bool?,
      brailleMenu: json['braille_menu'] as bool?,
      largePrintMenu: json['large_print_menu'] as bool?,
      signLanguageStaff: json['sign_language_staff'] as bool?,
      serviceDogsWelcome: json['service_dogs_welcome'] as bool?,
      hearingLoop: json['hearing_loop'] as bool?,
      visualAlerts: json['visual_alerts'] as bool?,
      wideAisles: json['wide_aisles'] as bool?,
      loweredCounters: json['lowered_counters'] as bool?,
      grabBarsRestroom: json['grab_bars_restroom'] as bool?,
      accessibleRooms: json['accessible_rooms'] as bool?,
      rollInShower: json['roll_in_shower'] as bool?,
      visualDoorKnock: json['visual_door_knock'] as bool?,
      tactileSignage: json['tactile_signage'] as bool?,
      quietHours: json['quiet_hours'] as bool?,
      sensoryFriendly: json['sensory_friendly'] as bool?,
      staffDisabilityTraining: json['staff_disability_training'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wheelchair_entrance': wheelchairEntrance,
      'wheelchair_restroom': wheelchairRestroom,
      'wheelchair_seating': wheelchairSeating,
      'ramp_access': rampAccess,
      'elevator_access': elevatorAccess,
      'accessible_parking': accessibleParking,
      'braille_menu': brailleMenu,
      'large_print_menu': largePrintMenu,
      'sign_language_staff': signLanguageStaff,
      'service_dogs_welcome': serviceDogsWelcome,
      'hearing_loop': hearingLoop,
      'visual_alerts': visualAlerts,
      'wide_aisles': wideAisles,
      'lowered_counters': loweredCounters,
      'grab_bars_restroom': grabBarsRestroom,
      'accessible_rooms': accessibleRooms,
      'roll_in_shower': rollInShower,
      'visual_door_knock': visualDoorKnock,
      'tactile_signage': tactileSignage,
      'quiet_hours': quietHours,
      'sensory_friendly': sensoryFriendly,
      'staff_disability_training': staffDisabilityTraining,
    };
  }

  int get countTrue {
    var count = 0;
    if (wheelchairEntrance == true) count++;
    if (wheelchairRestroom == true) count++;
    if (wheelchairSeating == true) count++;
    if (rampAccess == true) count++;
    if (elevatorAccess == true) count++;
    if (accessibleParking == true) count++;
    if (brailleMenu == true) count++;
    if (largePrintMenu == true) count++;
    if (signLanguageStaff == true) count++;
    if (serviceDogsWelcome == true) count++;
    if (hearingLoop == true) count++;
    if (visualAlerts == true) count++;
    if (wideAisles == true) count++;
    if (loweredCounters == true) count++;
    if (grabBarsRestroom == true) count++;
    if (accessibleRooms == true) count++;
    if (rollInShower == true) count++;
    if (visualDoorKnock == true) count++;
    if (tactileSignage == true) count++;
    if (quietHours == true) count++;
    if (sensoryFriendly == true) count++;
    if (staffDisabilityTraining == true) count++;
    return count;
  }

  static AccessibilityFeatures empty() => AccessibilityFeatures();

  AccessibilityFeatures copyWith({
    bool? wheelchairEntrance,
    bool? wheelchairRestroom,
    bool? wheelchairSeating,
    bool? rampAccess,
    bool? elevatorAccess,
    bool? accessibleParking,
    bool? brailleMenu,
    bool? largePrintMenu,
    bool? signLanguageStaff,
    bool? serviceDogsWelcome,
    bool? hearingLoop,
    bool? visualAlerts,
    bool? wideAisles,
    bool? loweredCounters,
    bool? grabBarsRestroom,
    bool? accessibleRooms,
    bool? rollInShower,
    bool? visualDoorKnock,
    bool? tactileSignage,
    bool? quietHours,
    bool? sensoryFriendly,
    bool? staffDisabilityTraining,
  }) {
    return AccessibilityFeatures(
      wheelchairEntrance: wheelchairEntrance ?? this.wheelchairEntrance,
      wheelchairRestroom: wheelchairRestroom ?? this.wheelchairRestroom,
      wheelchairSeating: wheelchairSeating ?? this.wheelchairSeating,
      rampAccess: rampAccess ?? this.rampAccess,
      elevatorAccess: elevatorAccess ?? this.elevatorAccess,
      accessibleParking: accessibleParking ?? this.accessibleParking,
      brailleMenu: brailleMenu ?? this.brailleMenu,
      largePrintMenu: largePrintMenu ?? this.largePrintMenu,
      signLanguageStaff: signLanguageStaff ?? this.signLanguageStaff,
      serviceDogsWelcome: serviceDogsWelcome ?? this.serviceDogsWelcome,
      hearingLoop: hearingLoop ?? this.hearingLoop,
      visualAlerts: visualAlerts ?? this.visualAlerts,
      wideAisles: wideAisles ?? this.wideAisles,
      loweredCounters: loweredCounters ?? this.loweredCounters,
      grabBarsRestroom: grabBarsRestroom ?? this.grabBarsRestroom,
      accessibleRooms: accessibleRooms ?? this.accessibleRooms,
      rollInShower: rollInShower ?? this.rollInShower,
      visualDoorKnock: visualDoorKnock ?? this.visualDoorKnock,
      tactileSignage: tactileSignage ?? this.tactileSignage,
      quietHours: quietHours ?? this.quietHours,
      sensoryFriendly: sensoryFriendly ?? this.sensoryFriendly,
      staffDisabilityTraining: staffDisabilityTraining ?? this.staffDisabilityTraining,
    );
  }
}

class Venue {
  final String id;
  final String name;
  final String type;
  final String? description;
  final String address;
  final String city;
  final String state;
  final String? zip;
  final String? phone;
  final String? email;
  final String? website;
  final String? imageUrl;
  final String contactName;
  final AccessibilityFeatures accessibility;
  final String? accessibilityNotes;
  final bool verified;
  final double? rating;
  final DateTime createdAt;

  Venue({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    required this.address,
    required this.city,
    required this.state,
    this.zip,
    this.phone,
    this.email,
    this.website,
    this.imageUrl,
    required this.contactName,
    required this.accessibility,
    this.accessibilityNotes,
    required this.verified,
    this.rating,
    required this.createdAt,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String?,
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zip: json['zip'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      imageUrl: json['image_url'] as String?,
      contactName: json['contact_name'] as String,
      accessibility: AccessibilityFeatures.fromJson(
        (json['accessibility'] as Map<String, dynamic>?) ?? {},
      ),
      accessibilityNotes: json['accessibility_notes'] as String?,
      verified: json['verified'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'type': type,
      'description': description,
      'address': address,
      'city': city,
      'state': state,
      'zip': zip,
      'phone': phone,
      'email': email,
      'website': website,
      'image_url': imageUrl,
      'contact_name': contactName,
      'accessibility': accessibility.toJson(),
      'accessibility_notes': accessibilityNotes,
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'name': name,
      'type': type,
      'description': description,
      'address': address,
      'city': city,
      'state': state,
      'zip': zip,
      'phone': phone,
      'email': email,
      'website': website,
      'image_url': imageUrl,
      'contact_name': contactName,
      'accessibility': accessibility.toJson(),
      'accessibility_notes': accessibilityNotes,
    };
  }

  Venue copyWith({
    String? id,
    String? name,
    String? type,
    String? description,
    String? address,
    String? city,
    String? state,
    String? zip,
    String? phone,
    String? email,
    String? website,
    String? imageUrl,
    String? contactName,
    AccessibilityFeatures? accessibility,
    String? accessibilityNotes,
    bool? verified,
    double? rating,
    DateTime? createdAt,
  }) {
    return Venue(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      imageUrl: imageUrl ?? this.imageUrl,
      contactName: contactName ?? this.contactName,
      accessibility: accessibility ?? this.accessibility,
      accessibilityNotes: accessibilityNotes ?? this.accessibilityNotes,
      verified: verified ?? this.verified,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
