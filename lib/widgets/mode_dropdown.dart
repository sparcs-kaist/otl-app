import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otlplus/constants/color.dart';

class ModeDropdown extends StatefulWidget {
  const ModeDropdown({Key? key, this.dropdownIndex = 0, required this.onTap})
      : super(key: key);
  final int dropdownIndex;
  final Function(int) onTap;

  @override
  State<ModeDropdown> createState() => _ModeDropdownPageState();
}

class _ModeDropdownPageState extends State<ModeDropdown> {
  static const List<String> _dropdownList = ['수업 시간표', '시험 시간표', '지도'];
  static const List<String> _iconList = ['classtime', 'examtime', 'map'];

  bool _isOpened = false;

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void _createOverlay() {
    if (_overlayEntry == null) {
      setState(() {
        _isOpened = true;
      });
      _overlayEntry = _customDropdown();
      Overlay.of(context)?.insert(_overlayEntry!);
    }
  }

  void _removeOverlay() {
    setState(() {
      _isOpened = false;
    });
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _overlayEntry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_isOpened)
          _removeOverlay();
        else
          _createOverlay();
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Stack(
          children: [
            Container(
              width: 56,
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 11),
              decoration: BoxDecoration(
                color: PRIMARY_COLOR,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    'assets/icons/icon_${_iconList[widget.dropdownIndex]}_mode.svg',
                  ),
                  SvgPicture.asset(
                    'assets/icons/icon_${_isOpened ? 'close' : 'open'}_dropdown.svg',
                  ),
                ],
              ),
            ),
            if (_isOpened)
              Container(
                width: 56,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
          ],
        ),
      ),
    );
  }

  OverlayEntry _customDropdown() {
    return OverlayEntry(
      maintainState: true,
      builder: (context) => Positioned(
        right: 0,
        width: 161,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          targetAnchor: Alignment.bottomRight,
          followerAnchor: Alignment.topRight,
          offset: const Offset(0, 7),
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: 32.0 * _dropdownList.length,
              decoration: BoxDecoration(
                color: Color(0xFF666666),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: _dropdownList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      widget.onTap(index);
                      _removeOverlay();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      height: (index == _dropdownList.length - 1) ? 32 : 31,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (index == widget.dropdownIndex)
                            Positioned(
                              left: 14,
                              child: SvgPicture.asset(
                                'assets/icons/icon_check_dropdown.svg',
                              ),
                            ),
                          Positioned(
                            left: 31,
                            child: Text(
                              _dropdownList[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              width: 36,
                              child: SvgPicture.asset(
                                'assets/icons/icon_${_iconList[index]}_dropdown.svg',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, index) => Divider(
                  height: 1.0,
                  thickness: 1.0,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
