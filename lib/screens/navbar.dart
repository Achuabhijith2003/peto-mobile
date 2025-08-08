import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peto/utils/color.dart';
import 'package:peto/utils/image.dart';
import 'package:peto/screens/dashboard.dart';
import 'package:peto/screens/owner_profile_screen.dart';
import 'package:peto/screens/pet_list_screen.dart';

final Color inActiveIconColor = AppColor.kGrayscale40;

class CustomNavBarCurved extends StatefulWidget {
  const CustomNavBarCurved({super.key});

  @override
  State<CustomNavBarCurved> createState() => _CustomNavBarCurvedState();
}

class _CustomNavBarCurvedState extends State<CustomNavBarCurved> {
  int currentSelectedIndex = 0;

  void updateCurrentIndex(int index) {
    if (!mounted) return; // Ensure the widget is still mounted
    setState(() {
      currentSelectedIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final pages = [Dashboard(), PetListScreen(), OwnerProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: updateCurrentIndex,
        currentIndex: currentSelectedIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              Svgpath
                  .kdashboard, // Replace with the correct path to your SVG file
              colorFilter: ColorFilter.mode(inActiveIconColor, BlendMode.srcIn),
              height: 27,
            ),
            activeIcon: SvgPicture.asset(
              Svgpath
                  .kdashboard, // Replace with the correct path to your SVG file
              colorFilter: ColorFilter.mode(AppColor.kPrimary, BlendMode.srcIn),
              height: 27,
            ),

            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              Svgpath.kpet,
              colorFilter: ColorFilter.mode(inActiveIconColor, BlendMode.srcIn),
              height: 27,
            ),
            activeIcon: SvgPicture.asset(
              Svgpath.kpet,
              colorFilter: ColorFilter.mode(AppColor.kPrimary, BlendMode.srcIn),
              height: 27,
            ),
            label: "Pets",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              Svgpath.kprofile,
              colorFilter: ColorFilter.mode(inActiveIconColor, BlendMode.srcIn),
              height: 27,
            ),
            activeIcon: SvgPicture.asset(
              Svgpath.kprofile,
              colorFilter: ColorFilter.mode(AppColor.kPrimary, BlendMode.srcIn),
              height: 27,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
