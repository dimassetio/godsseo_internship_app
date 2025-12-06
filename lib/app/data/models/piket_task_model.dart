class PiketTask {
  String title;
  String location;
  
  // Key: Tanggal, Value: LIST Nama User (Bisa lebih dari 1)
  Map<String, List<String>> completionMap; 

  // Helper UI
  bool isDone; 
  String? executorName; // Nanti isinya gabungan nama: "Budi, Asep"
  bool isOpen;

  PiketTask({
    required this.title,
    required this.location,
    this.completionMap = const {}, 
    this.isDone = false,
    this.executorName,
    this.isOpen = false,
  });

  factory PiketTask.fromJson(Map<String, dynamic> json) {
    // Parsing Map agar value-nya jadi List<String>
    var mapData = json['completionMap'] as Map<String, dynamic>? ?? {};
    Map<String, List<String>> parsedMap = {};
    
    mapData.forEach((key, value) {
      if (value is List) {
        parsedMap[key] = List<String>.from(value);
      } else if (value is String) {
        // Handle data lama kalau masih format String
        parsedMap[key] = [value];
      }
    });

    return PiketTask(
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      completionMap: parsedMap,
      isDone: false,
      isOpen: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'location': location,
      'completionMap': completionMap,
    };
  }
}