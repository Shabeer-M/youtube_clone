import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/service_locator.dart';
import '../../domain/entities/download_item.dart';
import '../downloads/bloc/download_bloc.dart';
import '../downloads/downloads_page.dart';
import '../home/bloc/home_bloc.dart';
import '../home/bloc/home_event.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';
import '../search/bloc/search_bloc.dart';
import '../search/search_delegate.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    if (index == 1) {
      // Open Search Delegate instead of switching tab
      showSearch(
        context: context,
        delegate: CustomSearchDelegate(sl<SearchBloc>()),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
      _pageController.jumpToPage(index);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DownloadBloc>()..add(LoadDownloadsRequested()),
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            BlocProvider(
              create: (_) => sl<HomeBloc>()..add(FetchVideosRequested()),
              child: const HomePage(),
            ),
            const SizedBox(), // Search
            const DownloadsPage(),
            const ProfilePage(),
          ],
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        bottomNavigationBar: Builder(
          builder: (context) {
            return BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: BlocBuilder<DownloadBloc, DownloadState>(
                    builder: (context, state) {
                      int count = 0;
                      if (state is DownloadsLoaded) {
                        count = state.downloads
                            .where(
                              (d) => d.status == DownloadStatus.downloading,
                            )
                            .length;
                      }
                      return Badge(
                        isLabelVisible: count > 0,
                        label: Text('$count'),
                        child: const Icon(Icons.download),
                      );
                    },
                  ),
                  label: 'Downloads',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
