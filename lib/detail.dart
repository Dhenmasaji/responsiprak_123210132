import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailTeamPage extends StatefulWidget {
  final int teamId;
  final int leagueId;

  DetailTeamPage({required this.teamId, required this.leagueId});

  @override
  _DetailTeamPageState createState() => _DetailTeamPageState();
}

class _DetailTeamPageState extends State<DetailTeamPage> {
  Map<String, dynamic>? _teamDetails;
  bool _isLoading = true;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _fetchTeamDetails();
    // Check if team is already in favorites
    // You can replace this with your actual logic for checking if the team is in favorites
    _isFavorite = false;
  }

  Future<void> _fetchTeamDetails() async {
    try {
      final response = await http.get(Uri.parse('https://go-football-api-v44dfgjgyq-et.a.run.app/${widget.leagueId}/${widget.teamId}'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('Team details fetched: $jsonData');
        setState(() {
          _teamDetails = jsonData['Data'];
          _isLoading = false;
        });
      } else {
        print('Failed to load team details: ${response.statusCode}');
        throw Exception('Failed to load team details');
      }
    } catch (e) {
      print('Error fetching team details: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    // Logic to add or remove team from favorites
    if (_isFavorite) {
      // Add to favorites logic
      // Show snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Added to favorites'),
      ));
    } else {
      // Remove from favorites logic
      // Show snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Removed from favorites'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Details'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _teamDetails == null
          ? Center(child: Text('No details found'))
          : SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _teamDetails!['LogoClubUrl'] != null
                      ? Image.network(
                    _teamDetails!['LogoClubUrl'],
                    height: 250,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error);
                    },
                  )
                      : Icon(Icons.sports, size: 100),
                ),
                SizedBox(height: 20),
                Text(
                  _teamDetails!['NameClub'] ?? 'Unknown Team',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text(
                  'Head Coach',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_teamDetails!['HeadCoach'] ?? 'Unknown'}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 12),
                Text(
                  'Captain',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_teamDetails!['CaptainName'] ?? 'Unknown'}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 12),
                Text(
                  'Stadium',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_teamDetails!['StadiumName'] ?? 'Unknown'}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _toggleFavorite,
                  icon: _isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                  label: _isFavorite ? Text('Remove from Favorites') : Text('Add to Favorites'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
