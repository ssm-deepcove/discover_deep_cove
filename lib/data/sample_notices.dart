import 'models/notice.dart';

List<Notice> urgentNotices = [
  Notice.make(
    id: 1,
    urgent: true,
    imageId: 1,
    activatedAt: DateTime(2019, 12, 09),
    title: "This is an urgent test notice",
    shortDesc:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    longDesc:
        "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type"
        " and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic"
        "typesetting, remaining essentially unchanged.",
  ),
  Notice.make(
    id: 2,
    urgent: true,
    imageId: null,
    activatedAt: DateTime(2019, 12, 09),
    title: "This is an duplicate urgent test notice",
    shortDesc:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    longDesc:
        "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type"
        " and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic"
        "typesetting, remaining essentially unchanged.",
  ),
];

List<Notice> otherNotices = [
  Notice.make(
    id: 3,
    urgent: false,
    imageId: 2,
    activatedAt: DateTime(2019, 12, 09),
    title: "This is not an urgent test notice",
    shortDesc:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    longDesc: null,
  ),
];
