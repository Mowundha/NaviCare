import 'models/venue.dart';

class ChecklistItem {
  final String key;
  final String label;
  final String category;
  final String icon;
  final bool Function(AccessibilityFeatures) getValue;
  final AccessibilityFeatures Function(AccessibilityFeatures, bool) setValue;

  const ChecklistItem({
    required this.key,
    required this.label,
    required this.category,
    required this.icon,
    required this.getValue,
    required this.setValue,
  });
}

class AccessibilityChecklist {
  static const int total = 22;

  static const List<String> categories = [
    'Mobility',
    'Visual',
    'Hearing',
    'Sensory',
    'General',
  ];

  static final List<ChecklistItem> items = [
    ChecklistItem(
      key: 'wheelchair_entrance',
      label: 'Step-free entrance',
      category: 'Mobility',
      icon: 'Accessibility',
      getValue: (f) => f.wheelchairEntrance == true,
      setValue: (f, v) => f.copyWith(wheelchairEntrance: v),
    ),
    ChecklistItem(
      key: 'ramp_access',
      label: 'Ramp access',
      category: 'Mobility',
      icon: 'TrendingUp',
      getValue: (f) => f.rampAccess == true,
      setValue: (f, v) => f.copyWith(rampAccess: v),
    ),
    ChecklistItem(
      key: 'wheelchair_seating',
      label: 'Wheelchair-accessible seating',
      category: 'Mobility',
      icon: 'Armchair',
      getValue: (f) => f.wheelchairSeating == true,
      setValue: (f, v) => f.copyWith(wheelchairSeating: v),
    ),
    ChecklistItem(
      key: 'wheelchair_restroom',
      label: 'Accessible restroom',
      category: 'Mobility',
      icon: 'DoorOpen',
      getValue: (f) => f.wheelchairRestroom == true,
      setValue: (f, v) => f.copyWith(wheelchairRestroom: v),
    ),
    ChecklistItem(
      key: 'elevator_access',
      label: 'Elevator access',
      category: 'Mobility',
      icon: 'ArrowUpDown',
      getValue: (f) => f.elevatorAccess == true,
      setValue: (f, v) => f.copyWith(elevatorAccess: v),
    ),
    ChecklistItem(
      key: 'accessible_parking',
      label: 'Accessible parking nearby',
      category: 'Mobility',
      icon: 'Car',
      getValue: (f) => f.accessibleParking == true,
      setValue: (f, v) => f.copyWith(accessibleParking: v),
    ),
    ChecklistItem(
      key: 'wide_aisles',
      label: 'Wide aisles / pathways',
      category: 'Mobility',
      icon: 'MoveHorizontal',
      getValue: (f) => f.wideAisles == true,
      setValue: (f, v) => f.copyWith(wideAisles: v),
    ),
    ChecklistItem(
      key: 'lowered_counters',
      label: 'Lowered service counters',
      category: 'Mobility',
      icon: 'Minus',
      getValue: (f) => f.loweredCounters == true,
      setValue: (f, v) => f.copyWith(loweredCounters: v),
    ),
    ChecklistItem(
      key: 'grab_bars_restroom',
      label: 'Grab bars in restroom',
      category: 'Mobility',
      icon: 'Grip',
      getValue: (f) => f.grabBarsRestroom == true,
      setValue: (f, v) => f.copyWith(grabBarsRestroom: v),
    ),
    ChecklistItem(
      key: 'accessible_rooms',
      label: 'Accessible guest rooms',
      category: 'Mobility',
      icon: 'BedDouble',
      getValue: (f) => f.accessibleRooms == true,
      setValue: (f, v) => f.copyWith(accessibleRooms: v),
    ),
    ChecklistItem(
      key: 'roll_in_shower',
      label: 'Roll-in shower',
      category: 'Mobility',
      icon: 'ShowerHead',
      getValue: (f) => f.rollInShower == true,
      setValue: (f, v) => f.copyWith(rollInShower: v),
    ),
    ChecklistItem(
      key: 'braille_menu',
      label: 'Braille menu / signage',
      category: 'Visual',
      icon: 'Type',
      getValue: (f) => f.brailleMenu == true,
      setValue: (f, v) => f.copyWith(brailleMenu: v),
    ),
    ChecklistItem(
      key: 'large_print_menu',
      label: 'Large-print menu',
      category: 'Visual',
      icon: 'ZoomIn',
      getValue: (f) => f.largePrintMenu == true,
      setValue: (f, v) => f.copyWith(largePrintMenu: v),
    ),
    ChecklistItem(
      key: 'visual_alerts',
      label: 'Visual fire / emergency alerts',
      category: 'Visual',
      icon: 'BellRing',
      getValue: (f) => f.visualAlerts == true,
      setValue: (f, v) => f.copyWith(visualAlerts: v),
    ),
    ChecklistItem(
      key: 'visual_door_knock',
      label: 'Visual door-knock signal',
      category: 'Visual',
      icon: 'DoorClosed',
      getValue: (f) => f.visualDoorKnock == true,
      setValue: (f, v) => f.copyWith(visualDoorKnock: v),
    ),
    ChecklistItem(
      key: 'tactile_signage',
      label: 'Tactile / raised-letter signage',
      category: 'Visual',
      icon: 'Hand',
      getValue: (f) => f.tactileSignage == true,
      setValue: (f, v) => f.copyWith(tactileSignage: v),
    ),
    ChecklistItem(
      key: 'hearing_loop',
      label: 'Hearing loop / assistive listening',
      category: 'Hearing',
      icon: 'Ear',
      getValue: (f) => f.hearingLoop == true,
      setValue: (f, v) => f.copyWith(hearingLoop: v),
    ),
    ChecklistItem(
      key: 'sign_language_staff',
      label: 'Sign language-trained staff',
      category: 'Hearing',
      icon: 'Hand',
      getValue: (f) => f.signLanguageStaff == true,
      setValue: (f, v) => f.copyWith(signLanguageStaff: v),
    ),
    ChecklistItem(
      key: 'service_dogs_welcome',
      label: 'Service animals welcome',
      category: 'General',
      icon: 'Dog',
      getValue: (f) => f.serviceDogsWelcome == true,
      setValue: (f, v) => f.copyWith(serviceDogsWelcome: v),
    ),
    ChecklistItem(
      key: 'quiet_hours',
      label: 'Designated quiet hours',
      category: 'Sensory',
      icon: 'Moon',
      getValue: (f) => f.quietHours == true,
      setValue: (f, v) => f.copyWith(quietHours: v),
    ),
    ChecklistItem(
      key: 'sensory_friendly',
      label: 'Sensory-friendly environment',
      category: 'Sensory',
      icon: 'Sparkles',
      getValue: (f) => f.sensoryFriendly == true,
      setValue: (f, v) => f.copyWith(sensoryFriendly: v),
    ),
    ChecklistItem(
      key: 'staff_disability_training',
      label: 'Disability-awareness trained staff',
      category: 'General',
      icon: 'GraduationCap',
      getValue: (f) => f.staffDisabilityTraining == true,
      setValue: (f, v) => f.copyWith(staffDisabilityTraining: v),
    ),
  ];

  static List<ChecklistItem> itemsForCategory(String category) {
    return items.where((i) => i.category == category).toList();
  }
}

int accessibilityScore(AccessibilityFeatures features) {
  return ((features.countTrue / AccessibilityChecklist.total) * 100).round();
}

class AccessibilityLabel {
  final String label;
  final int color;

  AccessibilityLabel(this.label, this.color);
}

AccessibilityLabel getAccessibilityLabel(AccessibilityFeatures features) {
  final score = accessibilityScore(features);
  if (score >= 80) return AccessibilityLabel('Excellent', 0xFF059669);
  if (score >= 60) return AccessibilityLabel('Very Good', 0xFF0D9488);
  if (score >= 40) return AccessibilityLabel('Good', 0xFFD97706);
  if (score >= 20) return AccessibilityLabel('Limited', 0xFFEA580C);
  return AccessibilityLabel('Minimal', 0xFFE11D48);
}

String getVenueImage(Venue venue) {
  if (venue.imageUrl != null && venue.imageUrl!.isNotEmpty) return venue.imageUrl!;
  return venue.type == 'restaurant'
      ? 'https://images.pexels.com/photos/67468/pexels-photo-67468.jpeg?auto=compress&cs=tinysrgb&w=800'
      : 'https://images.pexels.com/photos/261101/pexels-photo-261101.jpeg?auto=compress&cs=tinysrgb&w=800';
}
