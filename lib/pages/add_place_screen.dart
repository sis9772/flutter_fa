import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_places_flutter/model/prediction.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final List<Prediction> _selectedPlaces = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isEditing = false; // 편집 모드 여부

  Future<void> _addPlaceToFirestore(Prediction prediction) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('itineraries')
          .add({
        'name': prediction.description,
        'location': GeoPoint(double.parse(prediction.lat!), double.parse(prediction.lng!)),
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  bool _isSelected(Prediction prediction) {
    return _selectedPlaces.contains(prediction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("장소 추가"),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.done : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing; // 편집 모드 토글
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GooglePlaceAutoCompleteTextField(
              textEditingController: _searchController,
              googleAPIKey: "AIzaSyAyvveCFRA-uYPE5JqiYIgN_BLVNEtKFb4",
              inputDecoration: const InputDecoration(
                hintText: "장소 검색",
                border: OutlineInputBorder(),
              ),
              debounceTime: 800,
              isLatLngRequired: true,
              getPlaceDetailWithLatLng: (Prediction prediction) {
                setState(() {
                  _selectedPlaces.add(prediction);
                });
              },
              itemClick: (Prediction prediction) {
                _searchController.text = prediction.description ?? '';
                setState(() {
                  _selectedPlaces.add(prediction);
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded( // 선택한 장소 표시
              child: ListView.builder(
                itemCount: _selectedPlaces.length,
                itemBuilder: (context, index) {
                  final place = _selectedPlaces[index];
                  return ListTile(
                    title: Text(place.description ?? ''),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                for (var place in _selectedPlaces) {
                  await _addPlaceToFirestore(place);
                }
                Navigator.of(context).pop(); // 캘린더 화면으로 돌아가기
              },
              child: const Text('선택 완료'),
            ),
          ],
        ),
      ),
    );
  }
}