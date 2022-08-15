import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class SearchResultItemsBlock extends StatelessWidget {
  SearchResultItemsBlock({Key? key, this.items, this.onItemTap}) : super(key: key);
// contains list of suggestions after user query
  final List<dynamic>? items;
  final Function? onItemTap;
  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    String itemTitle = '';
    String itemSubtitle = '';
    bool isThreeLines = false;

    // remove result items which don't have country, e.g. see
    if (items != null) {
      items!.removeWhere((item) => item['properties']['country'] == null);
    }

    //if item has value, show suggestions, else use a divider instead
    return items != null
        ? Scrollbar(
            thumbVisibility: true,
            controller: _controller,
            interactive: true,
            child: SingleChildScrollView(
              controller: _controller,
              physics: ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  ...items!.map((item) {
                    itemTitle = '';
                    itemSubtitle = '';
                    isThreeLines = false;

                    // take the name of the place if provided
                    if (item['properties']['name'] != null) {
                      itemTitle = item['properties']['name'];
                      // add extra city, zip and state to subtitle, when the object is not city
                      if (item['properties']['type'] != null &&
                          item['properties']['type'] != 'city' &&
                          (item['properties']['city'] != null || item['properties']['postcode'] != null || item['properties']['state'] != null)) {
                        isThreeLines = true;
                        itemSubtitle = (', ' +
                                (item['properties']['city'] ?? '') +
                                ', ' +
                                (item['properties']['postcode'] ?? '') +
                                ' ' +
                                (item['properties']['state'] ?? ''))
                            // replace repeating ", " with one ", " and multiple " " with one
                            .replaceAllMapped(RegExp(r'(, ){2,}|( ){2,}'), (Match m) => (m[1] ?? '') + (m[2] ?? ''))
                            // replace whitespaces or commas at the beginning and at the end
                            .replaceAll(RegExp(r'^[, ]+|[, ]+$'), '');
                        ;
                      }
                    }
                    // otherwise try to build the address
                    else {
                      itemTitle = ((item['properties']['housenumber'] ?? '') +
                              ' ' +
                              (item['properties']['street'] ?? '') +
                              ' ' +
                              (item['properties']['city'] ?? ''))
                          // replace repeating whitespaces with one
                          .replaceAll(RegExp(r' {2,}'), ' ')
                          .trim();
                    }

                    if (itemTitle == '') {
                      itemTitle = 'N/A';
                    }

                    // assign country name to subtitle
                    itemSubtitle += (itemSubtitle.length > 0 ? '\n' : '') + (item['properties']['country'] ?? '');

                    if (item['properties']['type'] != null) {
                      itemTitle += ' (' + item['properties']['type'] + ')';
                    }

                    return InkWell(
                        child: ListTile(
                          textColor: Colors.black,
                          isThreeLine: isThreeLines,
                          leading: Icon(
                            Icons.location_on,
                            color: Colors.grey.shade600,
                          ),
                          title: Text(
                            itemTitle,
                            style: textTheme.subtitle1,
                          ),
                          subtitle: Text(
                            itemSubtitle,
                            style: textTheme.bodyText2?.copyWith(color: Colors.grey.shade600),
                          ),
                        ),
                        onTap: () {
                          // navigate to bounds
                          if (item['properties']['extent'] != null &&
                              item['properties']['extent'][0] != null &&
                              item['properties']['extent'][1] != null &&
                              item['properties']['extent'][2] != null &&
                              item['properties']['extent'][3] != null) {
                            // navigate the map to the search result location
                            // the API returns left top (1) and right bottom (2) corners instead in the order:
                            // [long1, lat1, long2, lat2]
                            // to convert to sw and ne - coordinates need to be changed places (lat1 = ne_lat, lat2 = sw_lat)
                            onItemTap!({
                              'sw_latitude': double.parse(item['properties']['extent'][3].toString()),
                              'sw_longitude': double.parse(item['properties']['extent'][0].toString()),
                              'ne_latitude': double.parse(item['properties']['extent'][1].toString()),
                              'ne_longitude': double.parse(item['properties']['extent'][2].toString())
                            });
                          }
                          // navigate to coordinates
                          else if (item['geometry']['coordinates'] != null &&
                              item['geometry']['coordinates'][0] != null &&
                              item['geometry']['coordinates'][1] != null) {
                            onItemTap!({
                              'latitude': double.parse(item['geometry']['coordinates'][1].toString()),
                              'longitude': double.parse(item['geometry']['coordinates'][0].toString())
                            });
                          } else {
                            // showToast('Error: The coordinates of the location are not defined.');
                          }

                          //close list of suggestions
                          FloatingSearchBar.of(context)?.close();
                        });
                  }),
                ],
              ),
            ),
          )
        : Container(
            alignment: Alignment.center,
            child: const Text('Try search further...'),
          );
  }
}
