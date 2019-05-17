import 'package:discover_deep_cove/data/models/fact_file_entry.dart';
import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';

part 'entry_media_pivot.jorm.dart';

/// Pivot table between fact file entries and the media files that belong to
/// their galleries.
class EntryToMediaPivot {
  EntryToMediaPivot();

  @BelongsTo(FactFileEntryBean)
  int factFileEntryId;

  @BelongsTo(MediaFileBean)
  int mediaFileID;
}

/// Bean class for database manipulation.
@GenBean()
class EntryToMediaPivotBean extends Bean<EntryToMediaPivot>
    with _EntryToMediaPivotBean {
  EntryToMediaPivotBean(Adapter adapter) : super(adapter);

  FactFileEntryBean _factFileEntryBean;
  MediaFileBean _mediaFileBean;

  FactFileEntryBean get factFileEntryBean =>
      _factFileEntryBean ??= FactFileEntryBean(adapter);

  MediaFileBean get mediaFileBean => _mediaFileBean ??= MediaFileBean(adapter);

  final String tableName = 'entry_images';
}
