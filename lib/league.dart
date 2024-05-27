import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsii/team.dart';
import 'dart:convert';


class LeagueListPage extends StatefulWidget {
  @override
  _LeagueListPageState createState() => _LeagueListPageState();
}

class _LeagueListPageState extends State<LeagueListPage> {
  List<dynamic> _leagues = [];

  Future<void> _fetchTeams() async {
    try {
      final response = await http.get(Uri.parse('https://go-football-api-v44dfgjgyq-et.a.run.app/'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('Team data fetched: $jsonData');
        setState(() {
          _leagues = jsonData['Data'] ?? [];
        });
      } else {
        print('Failed to load teams: ${response.statusCode}');
        throw Exception('Failed to load teams');
      }
    } catch (e) {
      print('Error fetching teams: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('League List'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: _leagues.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(12.0), // Add padding here
        child: ListView.builder(
          itemCount: _leagues.length,
          itemBuilder: (context, index) {
            final league = _leagues[index];
            final leagueName = league['leagueName'] ?? '';
            final logoUrl = league['logoLeagueUrl'] ?? '';

            return Card(
              child: ListTile(
                leading: logoUrl.isNotEmpty
                    ? Image.network(
                  logoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error);
                  },
                  width: 50,
                  height: 50,
                )
                    : Icon(Icons.sports_soccer),
                title: Text(leagueName),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeamListPage(leagueId: league['idLeague']),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
