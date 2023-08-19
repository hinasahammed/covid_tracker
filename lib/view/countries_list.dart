import 'package:covid_app/services/state_services.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountriesList extends StatefulWidget {
  const CountriesList({super.key});

  @override
  State<CountriesList> createState() => _CountriesListState();
}

class _CountriesListState extends State<CountriesList> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final countriesService = StateServices();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {

                });
              },
              decoration: InputDecoration(
                hintText: 'Search with country name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: countriesService.fetchCountriesRecord(),
                  builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (!snapshot.hasData) {
                      return ListView.builder(
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade700,
                              highlightColor: Colors.grey.shade100,
                              child: Column(
                                children: [
                                  ListTile(
                                      title: Container(
                                        height: 10,
                                        width: 89,
                                        color: Colors.white,
                                      ),
                                      subtitle: Container(
                                        height: 10,
                                        width: 89,
                                        color: Colors.white,
                                      ),
                                      leading: Container(
                                        height: 50,
                                        width: 50,
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                            );
                          });
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            String countryName =
                                snapshot.data![index]['country'];
                            if (_searchController.text.isEmpty) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(snapshot.data![index]['country']),
                                    subtitle: Text(
                                        snapshot.data![index]['cases'].toString()),
                                    leading: Image(
                                      height: 50,
                                      width: 50,
                                      image: NetworkImage(snapshot.data![index]
                                          ['countryInfo']['flag']),
                                    ),
                                  ),
                                ],
                              );
                            } else if (countryName.toLowerCase().contains(
                                _searchController.text.toLowerCase())) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(snapshot.data![index]['country']),
                                    subtitle: Text(
                                        snapshot.data![index]['cases'].toString()),
                                    leading: Image(
                                      height: 50,
                                      width: 50,
                                      image: NetworkImage(snapshot.data![index]
                                          ['countryInfo']['flag']),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              Container();
                            }
                          });
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
