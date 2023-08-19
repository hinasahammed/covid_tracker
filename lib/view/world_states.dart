import 'package:covid_app/model/world_states_model.dart';
import 'package:covid_app/services/state_services.dart';
import 'package:covid_app/view/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({super.key});

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 3))
        ..repeat();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  final colorList = <Color>[
    const Color(0xffefba20),
    const Color(0xff3acda3),
    const Color(0xffd81b55),
  ];

  @override
  Widget build(BuildContext context) {
    final stateService = StateServices();
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * .01,
            ),
            FutureBuilder(
                future: stateService.fetchWorldStatesRecord(),
                builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(
                      flex: 1,
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50,
                        controller: _animationController,
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        PieChart(
                          dataMap: {
                            "Total":
                                double.parse(snapshot.data!.cases.toString()),
                            "Recovered": double.parse(
                                snapshot.data!.recovered.toString()),
                            "Deaths":
                                double.parse(snapshot.data!.deaths.toString()),
                          },
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValuesInPercentage: true,
                          ),
                          chartRadius: MediaQuery.sizeOf(context).width / 3.2,
                          animationDuration: const Duration(milliseconds: 1200),
                          chartType: ChartType.ring,
                          legendOptions: const LegendOptions(
                            legendPosition: LegendPosition.left,
                          ),
                          colorList: colorList,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.sizeOf(context).height * .06),
                          child: Card(
                            child: Column(
                              children: [
                                ReusableRow(
                                    value: snapshot.data!.cases.toString(),
                                    title: "Total"),
                                ReusableRow(
                                    value: snapshot.data!.recovered.toString(),
                                    title: "Recovered"),
                                ReusableRow(
                                    value: snapshot.data!.deaths.toString(),
                                    title: "Deaths"),
                                ReusableRow(
                                    value: snapshot.data!.active.toString(),
                                    title: "Active"),
                                ReusableRow(
                                    value: snapshot.data!.critical.toString(),
                                    title: "Critical"),
                                ReusableRow(
                                    value:
                                        snapshot.data!.todayDeaths.toString(),
                                    title: "Today Death"),
                                ReusableRow(
                                    value: snapshot.data!.todayRecovered
                                        .toString(),
                                    title: "Today Recovered"),
                              ],
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => const CountriesList()));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(12),
                            fixedSize: const Size(400, 50),
                          ),
                          child: const Text('Track Countries'),
                        )
                      ],
                    );
                  }
                }),
          ],
        ),
      )),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title, value;

  ReusableRow({super.key, required this.value, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        top: 10,
        right: 10,
        bottom: 5,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(),
        ],
      ),
    );
  }
}
