import 'package:flutter/material.dart';

// Model data sederhana untuk item latihan
class WorkoutTileData {
  final String title;
  final String details;
  final String imagePath; 

  const WorkoutTileData({
    required this.title,
    required this.details,
    required this.imagePath,
  });
}

// Data dummy (lengkap) yang akan disaring
const List<WorkoutTileData> _fullWorkoutList = [
  WorkoutTileData(
    title: '5-Min Fast Burn',
    details: '5 minutes, 2 exercises',
    imagePath: 'assets/workouts/Cardio/images/5-Min Fast Burn.jfif',
  ),
  WorkoutTileData(
    title: '5-Min Quick Stretch',
    details: '5 minutes, 2 exercises',
    imagePath: 'assets/workouts/Flexibility/images/5-Min Quick Stretch.jfif',
  ),
  WorkoutTileData(
    title: '5-Min Strong Arms',
    details: '5 minutes, 2 exercises',
    imagePath: 'assets/workouts/Strength/images/5-Min Strong Arms.jfif',
  ),
  // Tambahkan data lain untuk simulasi
  WorkoutTileData(
    title: '10-Min Easy Mobility',
    details: '10 minutes, 5 exercises',
    imagePath: 'assets/workouts/Flexibility/images/10-Min Easy Mobility.jfif',
  ),
];


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<WorkoutTileData> _searchResults = _fullWorkoutList;
  final TextEditingController _searchController = TextEditingController();


  void _performSearch(String query) {
    final lowerCaseQuery = query.toLowerCase();

    if (query.isEmpty) {

      setState(() {
        _searchResults = _fullWorkoutList; 
      });
      return;
    }

    final filteredResults = _fullWorkoutList.where((item) => item.title.toLowerCase().startsWith(lowerCaseQuery)).toList();

    setState(() {
      _searchResults = filteredResults;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchResults = _fullWorkoutList; 
    _searchController.addListener(() {
      _performSearch(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black, 
      appBar: _buildCustomAppBar(context, screenWidth, screenHeight),
      body: _searchResults.isEmpty
          ? _buildNoResultsFound(screenWidth) 
          : _buildSearchResultsList(screenWidth), 
    );
  }

  Widget _buildNoResultsFound(double screenWidth) {

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          'Result Not Found',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white, 
            fontSize: screenWidth * 0.12, 
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

Widget _buildSearchResultsList(double screenWidth) {
    return ListView.separated(
      padding: EdgeInsets.only(top: screenWidth * 0.04), 
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => Divider(
        color: Colors.white,
        height: 1,
        indent: screenWidth * 0.05,
        endIndent: screenWidth * 0.05,
      ),
      itemBuilder: (context, index) {
        final data = _searchResults[index];
        return _WorkoutTile(
          data: data,
          onTap: () {
            print('${data.title} clicked!');
          },
          screenWidth: screenWidth, 
        );
      },
    );
  }

  PreferredSizeWidget _buildCustomAppBar(BuildContext context, double screenWidth, double screenHeight) {
    final searchBarHeight = screenHeight * 0.05;
    final cancelFontSize = screenWidth * 0.04;

    return AppBar(
      backgroundColor: Colors.black,
      automaticallyImplyLeading: false, 
      titleSpacing: 0,
      title: Row(
        children: <Widget>[
          Expanded( 
            child: Container(
              height: searchBarHeight,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Color(0xFFF4F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField( 
                controller: _searchController,
                style: const TextStyle(color: Color(0xff000000)),
                decoration: const InputDecoration(
                  hintText: 'Search workouts...', 
                  hintStyle: TextStyle(color: Color(0xFF9999A1)),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF9999A1)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 8),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
                fontSize: cancelFontSize, 
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class _WorkoutTile extends StatelessWidget {
  final WorkoutTileData data;
  final VoidCallback? onTap;
  final double screenWidth; 

  const _WorkoutTile({
    required this.data,
    this.onTap,
    required this.screenWidth, 
  });

  @override
  Widget build(BuildContext context) {
    final imageSize = screenWidth * 0.15;
    final titleFontSize = screenWidth * 0.045;
    final detailsFontSize = screenWidth * 0.035;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03, horizontal:  screenWidth * 0.04),
        child: Row(
          children: <Widget>[
            Container(
              width: imageSize, 
              height: imageSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white10,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image(
                  image: AssetImage(data.imagePath),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(Icons.image_not_supported, color: Colors.white, size: imageSize * 0.5),
                  ), 
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    data.title,
                    maxLines: 1, 
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleFontSize, 
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.details,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: detailsFontSize, 
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}