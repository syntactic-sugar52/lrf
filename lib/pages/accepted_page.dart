import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lrf/pages/widgets/accepted/search_input.dart';

class AcceptedPage extends StatefulWidget {
  const AcceptedPage({Key? key}) : super(key: key);

  @override
  State<AcceptedPage> createState() => _AcceptedPageState();
}

class _AcceptedPageState extends State<AcceptedPage> {
  List<Data>? data = [
    Data(
      'Move boxes from apartment',
      [
        'Services no. 1',
      ],
    ),
    Data(
      'create a mob dance in front of the mall',
      ['Services no. 3', 'Services no. 4', 'Services no. 6'],
    ),
    Data(
      'create a mob dance in front of the mall',
      [
        'Services no. 1',
      ],
    ),
    Data(
      'Tutor needed',
      ['Services no. 3', 'Services no. 4', 'Services no. 6', 'Services no. 6', 'Services no. 6', 'Services no. 6'],
    ),
    Data(
      'Financial Advisor wanted',
      [
        'Services no. 1',
      ],
    ),
    Data(
      'Japan',
      ['Services no. 3', 'Services no. 4', 'Services no. 6'],
    ),
  ];

  final GlobalKey expansionTileKey = GlobalKey();
  List<Data>? newData;
  bool showRequest = false;

  bool _isLoading = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // copy data to newData list
    newData = List.from(data!);
  }

  void searchData(String query) {
    if (query.isNotEmpty) {
      final suggestions = data!.where((element) {
        final countryTile = element.title.toLowerCase();
        final input = query.toLowerCase();
        return countryTile.contains(input);
      }).toList();
      setState(() {
        newData = suggestions;
      });
    } else {
      setState(() {
        // upon every rebuild, newData gets reset to the original value
        newData = List.from(data!);
      });
    }
  }

  SizedBox sizedBox(double height, double width) => SizedBox(
        height: height,
        width: width,
      );

//todo: add notifications so they can choose which user will they accept
  _buildExpandableContent(Data data) {
    List<Widget> columnContent = [];

    for (String content in data.contents) {
      columnContent.add(ExpansionTile(
        controlAffinity: ListTileControlAffinity.trailing,
        tilePadding: const EdgeInsets.only(left: 50, right: 50),
        // leading: CircleAvatar(
        //   radius: 16,
        // ),
        title: Text(
          'User name',
          style: TextStyle(
            color: Colors.blueGrey.shade100,
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
        ),
        subtitle: const Text(
          '3.2 stars',
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
        iconColor: Colors.white70,
        collapsedIconColor: Colors.white70,
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Card(
              color: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                padding: const EdgeInsets.all(18.0),
                width: double.infinity,
                color: Colors.black54,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Lorem ipsum dolor sit amet. Et placeat iste ut nihil error et temporibus totam ut doloribus autem ea quos sint a delectus obcaecati et quos adipisci. Ab sapiente voluptatem qui tempora perferendis et officiis autem! Rem beatae impedit vel quia sunt et adipisci quasi.Hic voluptates nisi nam perferendis corporis ut tenetur voluptatem ex perspiciatis veniam eum placeat recusandae in excepturi delectus ut ullam dolorum. Aut sunt iure aut eaque amet est ratione galisum. Et repellat amet et possimus quia in fugiat suscipit rem explicabo voluptas?Sit minima perspiciatis aut numquam iusto et tenetur dolor aut dolore aliquid eos internos optio commodi dolore est maxime sint? Et quia possimus quo odit similique est quia vitae ex nostrum itaque. Est amet vitae quo libero eligendi libero magni id accusamus quia. Ex ducimus quis ea fugit voluptas et consequuntur sint.',
                      style: TextStyle(letterSpacing: .5, fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blueGrey.shade200),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          height: 35,
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            border: Border.all(
                              color: Colors.green,
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          height: 35,
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            border: Border.all(
                              color: Colors.pink,
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: const Center(
                              child: Icon(
                            Icons.close,
                            color: Colors.pink,
                          )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ));
    }

    return columnContent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            // todo: add chat if accepted
            // Row(
            //   children: [
            //     Icon(
            //       Icons.telegram,
            //       color: Colors.white,
            //     )
            //   ],
            // ),
            SearchInput(
              textController: _searchController,
              hintText: 'Search Request',
              onChanged: searchData,
            ),
            Card(
              color: Colors.black87,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  const Text('Show : ', style: TextStyle(color: Colors.white)),
                  const SizedBox(
                    width: 20,
                  ),
                  const Text('Requests', style: TextStyle(color: Colors.white)),
                  SizedBox(
                    width: 60,
                    height: 50,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Switch(
                        inactiveThumbColor: Colors.green,
                        activeTrackColor: Colors.grey,
                        activeColor: Colors.green,
                        inactiveTrackColor: Colors.grey,
                        value: showRequest,
                        onChanged: (value) {
                          setState(() {
                            showRequest = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const Text('Replies', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            _isLoading
                ? const Expanded(
                    child: CircularProgressIndicator(color: Colors.green),
                  )
                : Expanded(
                    child: newData!.isNotEmpty
                        ? ListView(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: newData!.map((e) {
                              return Card(
                                elevation: 12,
                                color: const Color(0xff393E46),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: ExpansionTile(
                                  collapsedIconColor: Colors.white70,
                                  iconColor: Colors.white70,
                                  title: Row(
                                    children: [
                                      Text(
                                        e.title,
                                        style: TextStyle(
                                          color: Colors.blueGrey.shade100,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Column(
                                      children: _buildExpandableContent(e),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          )
                        : Text(
                            'No results found',
                            style: TextStyle(
                              color: Theme.of(context).highlightColor,
                            ),
                          ),
                  )
          ],
        ),
      ),
    );
  }
}

class Data {
  Data(this.title, this.contents);

  List<String> contents = [];
  final String title;
}
