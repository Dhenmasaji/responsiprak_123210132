import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'team.dart';

class LeagueListPage extends StatefulWidget {
  @override
  _LeagueListPageState createState() => _LeagueListPageState();
}

class _LeagueListPageState extends State<LeagueListPage> {
  List<dynamic> _leagues = [];

  Future<void> _fetchLeagues() async {
    try {
      final response = await http.get(Uri.parse('https://go-football-api-v44dfgjgyq-et.a.run.app/'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('League data fetched: $jsonData');
        setState(() {
          _leagues = jsonData['Data'] ?? [];
        });
      } else {
        print('Failed to load leagues: ${response.statusCode}');
        throw Exception('Failed to load leagues');
      }
    } catch (e) {
      print('Error fetching leagues: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLeagues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('League List'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.green.shade100],
          ),
        ),
        child: _leagues.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.builder(
            itemCount: _leagues.length,
            itemBuilder: (context, index) {
              final league = _leagues[index];
              final leagueName = league['leagueName'] ?? '';
              final logoUrl = league['logoLeagueUrl'] ?? '';

              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                  title: Text(
                    leagueName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
      ),
    );
  }
}
