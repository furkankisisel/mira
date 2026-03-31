/// Kullanıcı profil taslağı — soru döngüsü boyunca AI tarafından biriktirilir.
class ProfileDraft {
  String? currentFeeling; // şu an nasıl hissediyor
  String? desiredSelf; // kim olmak istiyor (gelecekteki benliği)
  String? obstacle; // onu ne durduruyor (önceki denemeler, engeller)
  String? energyAndTime; // enerjisi ne zaman var, ne kadar zamanı var

  ProfileDraft({
    this.currentFeeling,
    this.desiredSelf,
    this.obstacle,
    this.energyAndTime,
  });

  ProfileDraft.fromJson(Map<String, dynamic> json)
      : currentFeeling = json['current_feeling'] as String?,
        desiredSelf = json['desired_self'] as String?,
        obstacle = json['obstacle'] as String?,
        energyAndTime = json['energy_and_time'] as String?;

  Map<String, dynamic> toJson() => {
        'current_feeling': currentFeeling,
        'desired_self': desiredSelf,
        'obstacle': obstacle,
        'energy_and_time': energyAndTime,
      };

  /// AI'ın döndürdüğü profile_update ile birleştir.
  void mergeFrom(ProfileDraft other) {
    if (other.currentFeeling != null) currentFeeling = other.currentFeeling;
    if (other.desiredSelf != null) desiredSelf = other.desiredSelf;
    if (other.obstacle != null) obstacle = other.obstacle;
    if (other.energyAndTime != null) energyAndTime = other.energyAndTime;
  }

  /// Dolu olan 4 kritik alanın listesi.
  List<String> filledFields() {
    final filled = <String>[];
    if (currentFeeling != null) filled.add('current_feeling');
    if (desiredSelf != null) filled.add('desired_self');
    if (obstacle != null) filled.add('obstacle');
    if (energyAndTime != null) filled.add('energy_and_time');
    return filled;
  }

  /// Henüz boş olan 4 kritik alanın listesi.
  List<String> emptyFields() {
    final empty = <String>[];
    if (currentFeeling == null) empty.add('current_feeling');
    if (desiredSelf == null) empty.add('desired_self');
    if (obstacle == null) empty.add('obstacle');
    if (energyAndTime == null) empty.add('energy_and_time');
    return empty;
  }

  /// Kritik 4 alanın tümü dolu mu?
  bool isComplete() =>
      currentFeeling != null &&
      desiredSelf != null &&
      obstacle != null &&
      energyAndTime != null;
}
