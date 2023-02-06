import 'package:flutter/material.dart';
import 'package:katswiri/sources/sources.dart';
import 'package:katswiri/custom_widgets/custom_widgets.dart';

class ExploreJobsScreen extends StatefulWidget {
  const ExploreJobsScreen({super.key});

  static const route = '/explore_jobs';

  @override
  State<ExploreJobsScreen> createState() => _ExploreJobsScreenState();
}

class _ExploreJobsScreenState extends State<ExploreJobsScreen>
    with SingleTickerProviderStateMixin {
  final _sources = getSources();

  late final _tabController = TabController(
    length: _sources.length,
    vsync: this,
  );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Explore'),
  //       backgroundColor: Colors.transparent,
  //       bottom: TabBar(
  //         labelColor: Colors.blue,
  //         unselectedLabelColor: Colors.white70,
  //         indicatorColor: Colors.blue,
  //         controller: _tabController,
  //         tabs: _sources
  //             .map<Widget>((source) => Tab(
  //                   text: source.title,
  //                 ))
  //             .toList(),
  //       ),
  //     ),
  //     body: TabBarView(
  //       controller: _tabController,
  //       children: _sources
  //           .map<Widget>((source) => JobListRetriever(source: source))
  //           .toList(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: const [
          ExploreLeadSection(),
        ],
      ),
    );
  }
}

class ExploreLeadSection extends StatelessWidget {
  const ExploreLeadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.explore_rounded,
                color: Colors.white70,
                size: 36.0,
              ),
              SizedBox(
                width: 12.0,
              ),
              Text(
                'Explore',
                style: TextStyle(
                  fontSize: 42.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          const Text(
            'Browse and Discover Jobs from Multiple Sources',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
