import 'package:discover_deep_cove/data/database_adapter.dart';
import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/data/models/activity/activity_images.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_entry_images.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_nugget.dart';
import 'package:discover_deep_cove/data/models/notice.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_answer.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_question.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';
import 'package:meta/meta.dart';

part 'media_file.jorm.dart';

/// The media file types supported by the application.
/// TODO: Monitor Jaguar's support of enum persistence
enum MediaFileType {
  jpg,
  png,
  mp3,
  wav,
}

/// A media file that is stored on the device.
class MediaFile {
  MediaFile();

  MediaFile.create({
    @required this.fileType,
    @required this.path,
    @required this.name,
  });

  MediaFile.make(
      {@required this.id,
      @required this.fileType,
      @required this.path,
      this.name});

  @PrimaryKey(auto: true)
  int id;

  /// TODO: Persist as a [MediaFileType] enum when Jaguar supports it.
  /// The file type.
  @Column()
  int fileType;

  /// Description of the media file's contents.
  @Column()
  String name;

  /// Path to the file, relative to the apps root storage directory.
  @Column()
  String path;

  /// String to display for image attribution
  @Column(isNullable: true)
  String source;

  /// Whether to display copyright symbol next to source
  @Column()
  bool showCopyright;

  /// List of the entries that use this media file as their main image.
  /// TODO: Should these be using @BelongsTo.many() ???
  @HasMany(FactFileEntryBean)
  List<FactFileEntry> mainImageEntries;

  /// List of the entries that use this media file for their bird call.
  @HasMany(FactFileEntryBean)
  List<FactFileEntry> listenEntries;

  /// List of the entries that use this media file for their pronunciation.
  @HasMany(FactFileEntryBean)
  List<FactFileEntry> pronunciationEntries;

  /// List of the entries that use this media file in their image gallery.
  @ManyToMany(FactFileEntryImageBean, FactFileEntryBean)
  List<FactFileEntry> galleryImageEntries;

  /// List of the fact file nuggets that use this media file as their image.
  @HasMany(FactFileNuggetBean)
  List<FactFileNugget> nuggets;

  @HasMany(ActivityBean)
  List<Activity> activities;

  @ManyToMany(ActivityImageBean, ActivityBean)
  List<Activity> multiSelectActivities;

  @HasMany(QuizBean)
  List<Quiz> quizzes;

  @HasMany(QuizQuestionBean)
  List<QuizQuestion> quizQuestions;

  @HasMany(QuizAnswerBean)
  List<QuizAnswer> quizAnswers;

  @HasMany(NoticeBean)
  List<Notice> notices;
}

/// Bean class used for database manipulation - auto generated mixin code
@GenBean()
class MediaFileBean extends Bean<MediaFile> with _MediaFileBean {
  MediaFileBean(Adapter adapter)
      : factFileNuggetBean = FactFileNuggetBean(adapter),
        factFileEntryBean = FactFileEntryBean(adapter),
        factFileEntryImageBean = FactFileEntryImageBean(adapter),
        activityBean = ActivityBean(adapter),
        activityImageBean = ActivityImageBean(adapter),
        quizBean = QuizBean(adapter),
        quizQuestionBean = QuizQuestionBean(adapter),
        quizAnswerBean = QuizAnswerBean(adapter),
        noticeBean = NoticeBean(adapter),
        super(adapter);

  MediaFileBean.of(BuildContext context)
      : factFileNuggetBean = FactFileNuggetBean(DatabaseAdapter.of(context)),
        factFileEntryBean = FactFileEntryBean(DatabaseAdapter.of(context)),
        factFileEntryImageBean =
            FactFileEntryImageBean(DatabaseAdapter.of(context)),
        activityBean = ActivityBean(DatabaseAdapter.of(context)),
        activityImageBean = ActivityImageBean(DatabaseAdapter.of(context)),
        quizBean = QuizBean(DatabaseAdapter.of(context)),
        quizQuestionBean = QuizQuestionBean(DatabaseAdapter.of(context)),
        quizAnswerBean = QuizAnswerBean(DatabaseAdapter.of(context)),
        noticeBean = NoticeBean(DatabaseAdapter.of(context)),
        super(DatabaseAdapter.of(context));

  final FactFileNuggetBean factFileNuggetBean;
  final FactFileEntryBean factFileEntryBean;
  final FactFileEntryImageBean factFileEntryImageBean;
  final ActivityBean activityBean;
  final ActivityImageBean activityImageBean;
  final QuizBean quizBean;
  final QuizQuestionBean quizQuestionBean;
  final QuizAnswerBean quizAnswerBean;
  final NoticeBean noticeBean;

  final String tableName = 'media_files';
}
