import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({Key? key}) : super(key: key);

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  final _pageViewController = PageController();
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    final _myLocation = LatLng(
      cubit.userModel!.latitude!,
      cubit.userModel!.longitude!,
    );
    return BlocConsumer<AppCubit, AppStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                minZoom: 5.0,
                maxZoom: 18.0,
                zoom: 13.0,
                center: _myLocation,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: MAPBOX_URL,
                  additionalOptions: {
                    'accessToken': MAPBOX_ACCESS_TOKEN,
                    'id': MAPBOX_STYLE
                  },
                  // attributionBuilder: (_) {
                  //   return Text("© OpenStreetMap contributors");
                  // },
                ),
                MarkerLayerOptions(
                  markers: cubit.buildMarkers(_pageViewController),
                ),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      height: 60.0,
                      width: 60.0,
                      point: _myLocation,
                      builder: (ctx) => MyLocationMarker(_animationController),
                    ),
                  ],
                ),
              ],
            ),

            // Add page view
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 20.0,
              height: MediaQuery.of(context).size.height * 0.3,
              child: PageView.builder(
                controller: _pageViewController,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = cubit.usersLocations[index];
                  return mapItemDetails(
                    mapMarker: item,
                    context: context,
                  );
                },
                itemCount: cubit.usersLocations.length,
              ),
            ),
          ],
        );
      },
    );
  }
}
