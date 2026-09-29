import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/views/pages/cart_page.dart';
import 'package:e_commerce_app/views/pages/favorites_page.dart';
import 'package:e_commerce_app/views/pages/home_page.dart';
import 'package:e_commerce_app/views/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class CustomButtomNavbar extends StatefulWidget {
  const CustomButtomNavbar({super.key});

  @override
  State<CustomButtomNavbar> createState() => _CustomButtomNavbarState();
}

List<PersistentTabConfig> _tabs() => [
  PersistentTabConfig(
    screen: const HomePage(),
    item: ItemConfig(
      icon: const Icon(Icons.home_outlined),
      title: 'Home',
      textStyle: const TextStyle(fontWeight: FontWeight.w500),
      activeForegroundColor: AppColors.primary,
      inactiveForegroundColor: AppColors.grey,
    ),
  ),
  PersistentTabConfig(
    screen: const CartPage(),
    item: ItemConfig(
      icon: const Icon(Icons.shopping_cart_outlined),
      title: 'Cart',
      textStyle: const TextStyle(fontWeight: FontWeight.w500),
      activeForegroundColor: AppColors.primary,
      inactiveForegroundColor: AppColors.grey,
    ),
  ),
  PersistentTabConfig(
    screen: const FavoritesPage(),
    item: ItemConfig(
      icon: const Icon(Icons.favorite_border_outlined),
      title: 'Favorite',
      textStyle: const TextStyle(fontWeight: FontWeight.w500),
      activeForegroundColor: AppColors.primary,
      inactiveForegroundColor: AppColors.grey,
    ),
  ),
  PersistentTabConfig(
    screen: const ProfilePage(),
    item: ItemConfig(
      icon: const Icon(Icons.person_outline),
      title: 'Profile',
      textStyle: const TextStyle(fontWeight: FontWeight.w500),
      activeForegroundColor: AppColors.primary,
      inactiveForegroundColor: AppColors.grey,
    ),
  ),
];

class _CustomButtomNavbarState extends State<CustomButtomNavbar> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 6),
          child: CircleAvatar(
            radius: 30,
            backgroundImage: CachedNetworkImageProvider(
              'https://plus.unsplash.com/premium_photo-1689977927774-401b12d137d6?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjV8fGhlYWRzaG90fGVufDB8fDB8fHww',
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi,Oliver Stone',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              'Let\'s go shopping',
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          if (currentIndex == 0) ...[
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: Icon(Icons.notifications_outlined)),
          ] else if (currentIndex == 1)
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_bag_outlined),
            ),
        ],
      ),
      body: PersistentTabView(
        onTabChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        stateManagement: false,
        tabs: _tabs(),
        navBarBuilder: (navBarConfig) => Style2BottomNavBar(
          navBarConfig: navBarConfig,
          navBarDecoration: const NavBarDecoration(color: Colors.white),
        ),
      ),
    );
  }
}
