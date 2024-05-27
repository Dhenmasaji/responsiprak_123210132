import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail.dart';

class TeamListPage extends StatefulWidget {
  final int leagueId;

  TeamListPage({required this.leagueId});

  @override
  _TeamListPageState createState() => _TeamListPageState();
}

class _TeamListPageState extends State<TeamListPage> {
  List<dynamic> _teams = [];

  Future<void> _fetchTeams() async {
    try {
      final response = await http.get(Uri.parse('https://go-football-api-v44dfgjgyq-et.a.run.app/${widget.leagueId}'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('Team data fetched: $jsonData');
        setState(() {
          _teams = jsonData['Data'] ?? [];
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
        title: Text('Team List'),
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
        child: _teams.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.builder(
            itemCount: _teams.length,
            itemBuilder: (context, index) {
              final team = _teams[index];
              final teamName = team['NameClub'] ?? '';
              final logoUrl = team['LogoClubUrl'] ?? '';

              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  leading: Hero(
                    tag: 'club_logo_$teamName',
                    child: logoUrl.isNotEmpty
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
                  ),
                  title: Text(
                    teamName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    // Navigate to the DetailTeamPage with leagueId and teamId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailTeamPage(teamId: team['IdClub'], leagueId: widget.leagueId),
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
