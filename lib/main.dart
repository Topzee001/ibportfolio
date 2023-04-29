import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class Portfolio {
  final String name;
  final String location;
  final String about;
  final int yearsOfExperience;
  final int projectsHandled;
  final int clientsWorkedFor;
  final Map<String, String> socialMediaHandles;

  Portfolio({
    required this.name,
    required this.location,
    required this.about,
    required this.yearsOfExperience,
    required this.projectsHandled,
    required this.clientsWorkedFor,
    required this.socialMediaHandles,
  });

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      name: json['name'],
      location: json['location'],
      about: json['about'],
      yearsOfExperience: json['yearsOfExperience'],
      projectsHandled: json['projectsHandled'],
      clientsWorkedFor: json['clientsWorkedFor'],
      socialMediaHandles: Map<String, String>.from(json['socialMediaHandles']),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatefulWidget {
  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  late List<Portfolio> _portfolioList;

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/data.json');
  }

  Future<List<Portfolio>> loadPortfolio() async {
    String jsonString = await loadAsset();
    final List<dynamic> jsonList = json.decode(jsonString);
    List<Portfolio> portfolioList = jsonList.map((e) => Portfolio.fromJson(e)).toList();
    return portfolioList;
  }

  @override
  void initState() {
    super.initState();
    loadPortfolio().then((value) => setState(() {
          _portfolioList = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Portfolio'),
      ),
      body: _portfolioList == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _portfolioList.length,
              itemBuilder: (context, index) {
                Portfolio portfolio = _portfolioList[index];
                return Card(
                  child: ListTile(
                    title: Text(portfolio.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(portfolio.location),
                        SizedBox(height: 8),
                        Text(portfolio.about),
                        SizedBox(height: 8),
                        Text('Years of experience: ${portfolio.yearsOfExperience}'),
                        Text('Projects handled: ${portfolio.projectsHandled}'),
                        Text('Clients worked for: ${portfolio.clientsWorkedFor}'),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            InkWell(
                              child: Icon(Icons.twitter),
                              onTap: () => launchUrl(portfolio.socialMediaHandles['twitter']!),
                            ),
                            SizedBox(width: 8),
                            InkWell(
                              child: Icon(Icons.instagram),
                              onTap: () => launchUrl(portfolio.socialMediaHandles['instagram']!),
                            ),
                            SizedBox(width: 8),
                            InkWell(
                              child: Icon(Icons.linkedin),
                              onTap: () => launchUrl(portfolio.socialMediaHandles['linkedin']!),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
