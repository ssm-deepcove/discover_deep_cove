import 'dart:async';

import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/data/models/activity/track.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/widgets/misc/heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';

import 'custom_marker.dart';

class MapMaker extends StatefulWidget {
  MapMaker({
    @required this.mapController,
    @required this.context,
    @required this.onMarkerTap,
  });

  final Function(Activity) onMarkerTap;
  final MapController mapController;
  final BuildContext context;

  @override
  State createState() => _MapMakerState();
}

class _MapMakerState extends State<MapMaker> with TickerProviderStateMixin {
  LatLng center;
  double zoom;
  List<Track> tracks;
  int currentTrackNum;
  StreamController<String> trackStreamController;
  Stream<String> trackStream;

  Track get currentTrack => tracks[currentTrackNum];

  @override
  void initState() {
    super.initState();
    trackStreamController = StreamController();
    trackStream = trackStreamController.stream;
    currentTrackNum = 0;
    loadTracks();
  }

  @override
  void dispose() {
    super.dispose();
    trackStreamController.close();
  }

  Future<void> loadTracks() async {
    tracks = await TrackBean.of(context).getAllAndPreload();
    setState(() => tracks);
  }

  @override
  Widget build(BuildContext context) {
    return tracks != null
        ? Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(FontAwesomeIcons.arrowLeft),
                onPressed: () => changeTrack(increase: false),
                color: Colors.white,
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(FontAwesomeIcons.arrowRight),
                  onPressed: () => changeTrack(increase: true),
                  color: Colors.white,
                ),
              ],
              title: StreamBuilder(
                stream: trackStream,
                initialData: currentTrack.name,
                builder: (context, snapshot) {
                  return Heading(snapshot.hasData ? snapshot.data : '');
                },
              ),
              centerTitle: true,
              backgroundColor: Theme.of(context).primaryColorDark,
            ),
            body: FlutterMap(
              mapController: widget.mapController,
              options: MapOptions(
                center: /*center ?? */ Env.defaultMapCenter,
                minZoom: Env.mapMinZoom,
                maxZoom: Env.mapMaxZoom,
                zoom: zoom ?? Env.mapDefaultZoom,
                swPanBoundary: Env.swPanBoundary,
                nePanBoundary: Env.nePanBoundary,
                plugins: [MarkerClusterPlugin()],
              ),
              layers: [
                _buildTileLayerOptions(),
                _buildMarkerClusterOptions(),
              ],
            ),
          )
        : Container(
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  TileLayerOptions _buildTileLayerOptions() {
    return TileLayerOptions(
      tileProvider: MBTilesImageProvider.fromAsset("assets/map.mbtiles"),
      maxZoom: Env.mapMaxZoom,
      backgroundColor: Color(0xFF262626),
      tms: true,
    );
  }

  MarkerClusterLayerOptions _buildMarkerClusterOptions() {
    return MarkerClusterLayerOptions(
      maxClusterRadius: 40,
      height: 30,
      width: 30,
      anchorPos: AnchorPos.align(AnchorAlign.center),
      fitBoundsOptions: FitBoundsOptions(
        maxZoom: 18,
      ),
      markers: _getMarkers(),
      showPolygon: false,
      builder: (context, markers) {
        // Cluster will only show red if every marker belongs to current track.
        bool isForCurrent = markers
            .every((marker) => (marker as CustomMarker).track == currentTrack);

        return FloatingActionButton(
          child: Text(markers.length.toString()),
          backgroundColor:
              isForCurrent ? Theme.of(context).accentColor : Colors.grey,
          onPressed: null,
        );
      },
    );
  }

  List<CustomMarker> _getMarkers() {
    List<CustomMarker> markers = List<CustomMarker>();
    for (Track track in tracks) {
      for (Activity activity in track.activities) {
        markers.add(CustomMarker(
          track: track,
          point: activity.latLng,
          builder: (context) => _buildMarker(context, activity),
        ));
      }
    }
    return markers;
  }

  _buildMarker(BuildContext context, Activity activity) {
    bool isCurrentTrack = activity.trackId == currentTrack.id;
    return Container(
        child: GestureDetector(
      onTap: () => widget.onMarkerTap(activity),
      child: Icon(activity.isCompleted()
                ? FontAwesomeIcons.lockOpen
                : FontAwesomeIcons.lock,
        size: isCurrentTrack ? 30 : 20,
        color: isCurrentTrack ? Theme.of(context).accentColor : Colors.grey,
      ),
    ));
  }

  void _animatedMove({LatLng latLng, double zoom}) {
    final _latTween = Tween<double>(
        begin: widget.mapController.center.latitude, end: latLng.latitude);
    final _lngTween = Tween<double>(
        begin: widget.mapController.center.longitude, end: latLng.longitude);
    final _zoomTween =
        Tween<double>(begin: widget.mapController.zoom, end: zoom);

    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      widget.mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  ///Changes the trackTitle which is displayed on the AppBar
  ///and pans the map to the first marker within that set
  void changeTrack({bool increase}) async {
    await Future.delayed(Duration(milliseconds: 100));

    currentTrackNum = increase
        ? (currentTrackNum + 1) % tracks.length
        : (currentTrackNum + tracks.length - 1) % tracks.length;

    trackStreamController.sink.add(currentTrack.name);
    _animatedMove(latLng: currentTrack.activities[0].latLng, zoom: 16.0);
  }
}