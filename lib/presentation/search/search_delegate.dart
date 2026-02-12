import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/search_bloc.dart';

import '../player/video_details_page.dart';

class CustomSearchDelegate extends SearchDelegate {
  final SearchBloc searchBloc;

  CustomSearchDelegate(this.searchBloc);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          searchBloc.add(LoadSearchHistory());
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchBloc.add(SearchQueryChanged(query));

    return BlocBuilder<SearchBloc, SearchState>(
      bloc: searchBloc,
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SearchResultsLoaded) {
          if (state.videos.isEmpty) {
            return const Center(child: Text('No results found.'));
          }
          return ListView.builder(
            itemCount: state.videos.length,
            itemBuilder: (context, index) {
              final video = state.videos[index];
              return ListTile(
                leading: Image.network(
                  video.thumbnailUrl,
                  width: 100,
                  fit: BoxFit.cover,
                ),
                title: Text(video.title),
                subtitle: Text(video.channelName),
                onTap: () {
                  // Navigate to video details
                  // Since SearchDelegate is an overlay, we might need to close it or push from context
                  // Usually close and return result, or push directly.
                  // Let's push directly.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoDetailsPage(video: video),
                    ),
                  );
                },
              );
            },
          );
        } else if (state is SearchError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const SizedBox();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // If query is empty, show history
    if (query.isEmpty) {
      searchBloc.add(LoadSearchHistory());
    } else {
      searchBloc.add(SearchQueryChanged(query));
    }

    return BlocBuilder<SearchBloc, SearchState>(
      bloc: searchBloc,
      builder: (context, state) {
        if (state is SearchHistoryLoaded) {
          if (state.history.isEmpty) {
            return const Center(child: Text('No search history.'));
          }
          return ListView.builder(
            itemCount: state.history.length,
            itemBuilder: (context, index) {
              final historyItem = state.history[index];
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(historyItem),
                trailing: const Icon(Icons.north_west, size: 16),
                onTap: () {
                  query = historyItem;
                  showResults(context);
                },
              );
            },
          );
        } else if (state is SearchResultsLoaded) {
          return ListView.builder(
            itemCount: state.videos.length,
            itemBuilder: (context, index) {
              final video = state.videos[index];
              return ListTile(
                leading: const Icon(Icons.search),
                title: Text(video.title),
                onTap: () {
                  query = video.title; // Or handle as navigate
                  showResults(context);
                },
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
