import 'package:flutter/material.dart';

class FavoritesSentFavoritesRecievedScreen extends StatefulWidget {
  const FavoritesSentFavoritesRecievedScreen({super.key});

  @override
  State<FavoritesSentFavoritesRecievedScreen> createState() => _FavoritesSentFavoritesRecievedScreenState();
}

class _FavoritesSentFavoritesRecievedScreenState extends State<FavoritesSentFavoritesRecievedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Center(
            child: Text(
              "Favorite Screen ",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            )
          ),
        );
  }
}