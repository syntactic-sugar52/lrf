import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lrf/pages/widgets/search_item_widget.dart';
import 'package:lrf/services/api_service.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class SearchBarWidget extends StatefulWidget {
  final Function? onResultItemTap;
  const SearchBarWidget({Key? key, required this.onResultItemTap}) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  FloatingSearchBarController searchBarController = FloatingSearchBarController();

  String query = '';

  bool isSearchBarLoading = false;

  List<dynamic>? features;

  // show a response when user types in the search field
  void onQueryChanged(String search) async {
    try {
      //if search bar loading is true, show circular progress indicator
      setState(() {
        isSearchBarLoading = true;
        query = search;
      });

      final Map<String, dynamic> response = await autoCompleteSuggestions(search.trim());
      if (response != '' && query.length > 1) {
        // loop map and check the key pair values of each
        response.forEach(((key, value) {
          //if features exist in response
          if (key.contains('features')) {
            //move features from map to features list
            features = value;
          }
        }));
      }

      // else change back to search icon
      setState(() {
        isSearchBarLoading = false;
        query = search;
      });
    } on PlatformException catch (e) {
      // if something went wrong during query, show error
      Future.error(e.message.toString());
    }
  }

  Widget buildFloatingSearchBar() {
    // chamges placement of search bar
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      elevation: 0,
      backdropColor: Colors.white,
      // margins: EdgeInsets.symmetric(
      //   horizontal: 10,
      // ).copyWith(top: 45),
      automaticallyImplyBackButton: false,
      controller: searchBarController,
      clearQueryOnClose: true,
      hint: 'Where to..?',
      iconColor: Colors.grey[700],
      transitionDuration: const Duration(milliseconds: 300),
      transitionCurve: Curves.easeInOutCubic,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      debounceDelay: const Duration(milliseconds: 500),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      scrollPadding: EdgeInsets.zero,
      transition: CircularFloatingSearchBarTransition(spacing: 16),
      isScrollControlled: true,
      onQueryChanged: (String query) {
        onQueryChanged(query);
      },
      onKeyEvent: (KeyEvent keyEvent) {
        if (keyEvent.logicalKey == LogicalKeyboardKey.escape) {
          query = "";
          searchBarController.close();
        }
      },
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: SizedBox(
            height: 24,
            width: 24,
            child: isSearchBarLoading
                // if true
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                  )
                //else
                : const Icon(Icons.search),
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) => query != ''
          ? AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height: double.infinity,
              margin: EdgeInsets.only(
                top: 10,
                // resize height of container dynamically so it wont be in contact with keyboard when keyboard is shown
                bottom: MediaQuery.of(context).viewInsets.bottom +
                    10 + // space size
                    (MediaQuery.of(context).viewInsets.bottom != 0 ? -1 * 60 : 0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                // color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: SearchResultItemsBlock(items: features, onItemTap: widget.onResultItemTap),
            )
          : SizedBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildFloatingSearchBar();
  }
}
