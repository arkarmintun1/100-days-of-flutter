import 'package:freezed_annotation/freezed_annotation.dart';

part 'place.freezed.dart';
part 'place.g.dart';

/// A place the user picked from the city search.
@freezed
abstract class Place with _$Place {
  const Place._();

  const factory Place({
    required String name,
    required String country,
    String? state,
    required double lat,
    required double lon,
  }) = _Place;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

  /// "Mandalay, MM" or "Springfield, Illinois, US".
  String get label => [name, ?state, country].join(', ');
}
