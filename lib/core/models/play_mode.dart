enum PlayMode { none, one, all }
enum AudioFolder {
  hymns,
  sermons,
  files,
  others,
}
/// Définit toutes les extensions de fichiers prises en charge.
enum FileExtension {
  pdf,
  mp3,
  mp4,
  doc,
}

extension AudioFolderExtension on AudioFolder {
  String get label => switch (this) {
    AudioFolder.hymns => "Hymns",
    AudioFolder.sermons => "Sermons",
    AudioFolder.files => "Files",
    AudioFolder.others => "Others",
  };
}

extension AudioFileExtension on FileExtension {
  String get label => switch (this) {
    FileExtension.pdf => "pdf",
    FileExtension.mp3 => "mp3",
    FileExtension.mp4 => "mp4",
    FileExtension.doc => "doc",
  };
}