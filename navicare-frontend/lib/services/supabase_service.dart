import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/venue.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  static Future<List<Venue>> fetchVenues({int limit = 100}) async {
    final response = await client
        .from('venues')
        .select('*')
        .order('created_at', ascending: false)
        .limit(limit);
    return (response as List).map((e) => Venue.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<Venue?> fetchVenue(String id) async {
    final response = await client
        .from('venues')
        .select('*')
        .eq('id', id)
        .maybeSingle();
    if (response == null) return null;
    return Venue.fromJson(response);
  }

  static Future<int> fetchCount() async {
    final response = await client.from('venues').count();
    return response;
  }

  static Future<int> fetchCountByType(String type) async {
    final response = await client
        .from('venues')
        .select('id')
        .eq('type', type);
    return (response as List).length;
  }

  static Future<Venue> insertVenue(Venue venue) async {
    final response = await client
        .from('venues')
        .insert(venue.toInsertJson())
        .select()
        .single();
    return Venue.fromJson(response);
  }

  static Future<Venue> updateVenue(Venue venue) async {
    final response = await client
        .from('venues')
        .update(venue.toUpdateJson())
        .eq('id', venue.id)
        .select()
        .single();
    return Venue.fromJson(response);
  }

  static Future<void> deleteVenue(String id) async {
    await client.from('venues').delete().eq('id', id);
  }
}
