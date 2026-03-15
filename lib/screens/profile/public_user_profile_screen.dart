import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Screen for viewing a public user profile (read-only)
class PublicUserProfileScreen extends StatefulWidget {
  final String userId;

  const PublicUserProfileScreen({super.key, required this.userId});

  @override
  State<PublicUserProfileScreen> createState() =>
      _PublicUserProfileScreenState();
}

class _PublicUserProfileScreenState extends State<PublicUserProfileScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool _isLoading = true;

  String name = '';
  String studentId = '';
  String phone = '';
  String faculty = '';
  String? avatar;
  String role = 'student';

  String? bio;
  String? history;
  String? introduction;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final doc = await _db.collection('users').doc(widget.userId).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        setState(() {
          name = data['name'] ?? 'No Name';
          studentId = data['studentId'] ?? '';
          phone = data['phone'] ?? '';
          faculty = data['faculty'] ?? '';
          avatar = data['avatar'];
          role = data['role'] ?? 'student';

          bio = data['bio'];
          history = data['history'];
          introduction = data['introduction'];

          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          "User Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// AVATAR
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: avatar != null ? NetworkImage(avatar!) : null,
              child: avatar == null
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            ),

            const SizedBox(height: 16),

            /// NAME
            Text(
              name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            /// STUDENT ID
            if (studentId.isNotEmpty)
              Text(studentId, style: const TextStyle(color: Colors.black54)),

            const SizedBox(height: 30),

            /// PERSONAL INFO
            _buildSectionTitle("PERSONAL INFORMATION"),

            const SizedBox(height: 10),

            _buildInfoCard([
              _buildInfoRow(
                Icons.phone,
                "Phone",
                phone.isEmpty ? "Not provided" : phone,
              ),

              _divider(),

              _buildInfoRow(
                Icons.school,
                "Faculty",
                faculty.isEmpty ? "Not provided" : faculty,
              ),
            ]),

            const SizedBox(height: 30),

            /// CLUB PROFILE
            if (role == "club") ...[
              _buildSectionTitle("CLUB INFORMATION"),

              const SizedBox(height: 10),

              _buildInfoCard([
                if (bio != null && bio!.isNotEmpty)
                  _buildInfoRow(Icons.info, "Bio", bio!),

                if (bio != null) _divider(),

                if (history != null && history!.isNotEmpty)
                  _buildInfoRow(Icons.history, "History", history!),

                if (history != null) _divider(),

                if (introduction != null && introduction!.isNotEmpty)
                  _buildInfoRow(
                    Icons.description,
                    "Introduction",
                    introduction!,
                  ),
              ]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      child: Row(
        children: [
          Icon(icon, color: Colors.orange),

          const SizedBox(width: 12),

          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),

          const Spacer(),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(color: Colors.grey.shade200, height: 1);
  }
}