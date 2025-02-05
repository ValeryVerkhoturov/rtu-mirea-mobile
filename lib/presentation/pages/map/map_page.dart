import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rtu_mirea_app/presentation/bloc/map_cubit/map_cubit.dart';
import 'package:rtu_mirea_app/presentation/pages/map/widgets/map_scaling_button.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'widgets/map_navigation_button.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
    _controller.initial = PhotoViewControllerValue(
      position: _controller.position,
      rotation: _controller.rotation,
      rotationFocusPoint: _controller.rotationFocusPoint,
      scale: defaultScale,
    );

    _controller.outputStateStream.listen((value) {
      double scale = value.scale ?? defaultScale;
      if (scale > maxScale) {
        _controller.scale = maxScale;
      } else if (scale < minScale) {
        _controller.scale = minScale;
      }
      context.read<MapCubit>().setMapScale(scale);
    });
  }

  final _controller = PhotoViewController();
  final _scaleController = PhotoViewScaleStateController();

  final maxScale = 21.0;
  final defaultScale = 11.0;
  final minScale = 1.0;

  Offset _dragGesturePositon = Offset.zero;
  bool _showMagnifier = false;

  final floors = [
    SvgPicture.asset('assets/map/floor_0.svg'),
    SvgPicture.asset('assets/map/floor_1.svg'),
    SvgPicture.asset('assets/map/floor_2.svg'),
    SvgPicture.asset('assets/map/floor_3.svg'),
    SvgPicture.asset('assets/map/floor_4.svg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: AppTheme.colors.background01,
          ),

          Stack(
            children: [
              GestureDetector(
                onLongPressMoveUpdate: (details) => setState(
                  () {
                    _dragGesturePositon = details.localPosition;
                  },
                ),
                onLongPressStart: (_) => setState(() => _showMagnifier = true),
                onLongPressEnd: (_) => setState(() => _showMagnifier = false),
                child: _buildMap(),
              ),
              if (_showMagnifier)
                Positioned(
                  left: _dragGesturePositon.dx,
                  top: _dragGesturePositon.dy,
                  child: RawMagnifier(
                    decoration: MagnifierDecoration(
                      shape: CircleBorder(
                        side: BorderSide(
                          color: AppTheme.colors.deactive,
                          width: 1,
                        ),
                      ),
                    ),
                    size: const Size(100, 100),
                    magnificationScale: 2,
                  ),
                ),
            ],
          ),
          Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 70, bottom: 16),
                child: _buildScalingButton(),
              )),
          // uncomment when this is completed
          //_buildSearchBar(),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 16),
              child: _buildNavigation(),
            ),
          ),
        ],
      ),
    );
  }

  // TODO: implement search bar without using [ImplicitlyAnimatedList].
  // Package implicitly_animated_reorderable_list is DISCONTINUED and
  // project compilation fails because of it.
  // Widget _buildSearchBar() {
  //   return FloatingSearchBar(
  //     accentColor: AppTheme.colors.primary,
  //     iconColor: AppTheme.colors.white,
  //     backgroundColor: AppTheme.colors.background02,
  //     hint: 'Что будем искать, Милорд?',
  //     hintStyle: AppTextStyle.titleS.copyWith(color: AppTheme.colors.deactive),
  //     borderRadius: const BorderRadius.all(Radius.circular(12)),
  //     onQueryChanged: (query) {
  //       context.read<MapCubit>().setSearchQuery(query);
  //     },
  //     builder: (context, transition) {
  //       return Padding(
  //         padding: const EdgeInsets.only(top: 16.0),
  //         child: Material(
  //           color: AppTheme.colors.background03,
  //           elevation: 4.0,
  //           borderRadius: BorderRadius.circular(8),
  //           child: BlocBuilder<MapCubit, MapState>(
  //             buildWhen: (prevState, currentState) =>
  //                 currentState is MapSearchFoundUpdated,
  //             builder: (context, state) {
  //               if (state is MapFloorLoaded) return Container();
  //               return ImplicitlyAnimatedList<Map<String, dynamic>>(
  //                 shrinkWrap: true,
  //                 items: (state as MapSearchFoundUpdated)
  //                     .foundRooms
  //                     .take(6)
  //                     .toList(),
  //                 physics: const NeverScrollableScrollPhysics(),
  //                 areItemsTheSame: (a, b) => a == b,
  //                 itemBuilder: (context, animation, room, i) {
  //                   return SizeFadeTransition(
  //                     animation: animation,
  //                     child: SearchItemButton(
  //                         room: room,
  //                         onClick: () {
  //                           // todo: change position
  //                           context.read<MapCubit>().goToFloor(room['floor']);
  //                         }),
  //                   );
  //                 },
  //                 updateItemBuilder: (context, animation, room) {
  //                   return FadeTransition(
  //                     opacity: animation,
  //                     child: SearchItemButton(
  //                         room: room,
  //                         onClick: () {
  //                           // todo: change position
  //                           context.read<MapCubit>().goToFloor(room['floor']);
  //                         }),
  //                   );
  //                 },
  //               );
  //             },
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildMap() {
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, state) => PhotoView.customChild(
        controller: _controller,
        scaleStateController: _scaleController,
        initialScale: defaultScale,
        maxScale: maxScale,
        minScale: minScale,
        backgroundDecoration:
            BoxDecoration(color: AppTheme.colors.background01),
        child: floors[state.floor],
      ),
    );
  }

  Widget _buildScalingButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.colors.background02,
        borderRadius: BorderRadius.circular(12),
      ),
      child: MapScalingButton(
        onClick: () => {
          _scaleController.scaleState = PhotoViewScaleState.initial,
          context.read<MapCubit>().setMapScale(_controller.scale ?? minScale)
        },
        minScale: minScale,
        maxScale: maxScale,
        defaultScale: defaultScale,
        controller: _controller,
      ),
    );
  }

  Widget _buildNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.colors.background02,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          MapNavigationButton(
              floor: 4, onClick: () => context.read<MapCubit>().goToFloor(4)),
          MapNavigationButton(
              floor: 3, onClick: () => context.read<MapCubit>().goToFloor(3)),
          MapNavigationButton(
              floor: 2, onClick: () => context.read<MapCubit>().goToFloor(2)),
          MapNavigationButton(
              floor: 1, onClick: () => context.read<MapCubit>().goToFloor(1)),
          MapNavigationButton(
              floor: 0, onClick: () => context.read<MapCubit>().goToFloor(0)),
        ],
      ),
    );
  }
}
