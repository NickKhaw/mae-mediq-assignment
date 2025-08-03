import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mae_mediq_assignment/patient/patient_dashboard/patient_dashboard_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../globals.dart' as globals;

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  static String routeName = 'Notification';
  static String routePath = '/notification';

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  final _scrollController = ScrollController();
  bool _isLoadingMore = false;
  List<DocumentSnapshot> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  Set<String> _locallyMarkedRead = {}; // local read cache

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadInitialData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _notifications.clear();
        _lastDocument = null;
        _hasMore = true;
        _locallyMarkedRead.clear();
      });

      final query = FirebaseFirestore.instance
          .collection('Notifications')
          .where('patientIC', isEqualTo: globals.globalIC)
          .limit(15);

      final querySnapshot = await query.get();
      setState(() {
        _notifications = querySnapshot.docs;
        if (querySnapshot.docs.isNotEmpty) {
          _lastDocument = querySnapshot.docs.last;
        }
        _hasMore = querySnapshot.docs.length == 15;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load notifications';
      });
      debugPrint('Error fetching notifications: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMoreData() async {
    if (!_hasMore || _isLoading || _isLoadingMore) return;

    try {
      setState(() => _isLoadingMore = true);

      Query query = FirebaseFirestore.instance
          .collection('Notifications')
          .where('patientIC', isEqualTo: globals.globalIC)
          .limit(10);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final querySnapshot = await query.get();
      setState(() {
        _notifications.addAll(querySnapshot.docs);
        if (querySnapshot.docs.isNotEmpty) {
          _lastDocument = querySnapshot.docs.last;
        }
        _hasMore = querySnapshot.docs.length == 10;
      });
    } catch (e) {
      debugPrint('Error loading more notifications: $e');
    } finally {
      setState(() => _isLoadingMore = false);
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      _loadMoreData();
    }
  }

  Future<void> _markAsRead(String docId) async {
    try {
      // Update Firestore
      await FirebaseFirestore.instance
          .collection('Notifications')
          .doc(docId)
          .update({'read': true});

      // Update local cache
      setState(() {
        _locallyMarkedRead.add(docId);
      });
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  bool _isRead(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return data['read'] == true || _locallyMarkedRead.contains(doc.id);
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Date not available';
    if (timestamp is Timestamp) {
      return DateFormat('MMM dd, yyyy • hh:mm a').format(timestamp.toDate());
    }
    return 'Invalid date';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F1F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90E2),
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 48,
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {
          Navigator.pushReplacementNamed(
              context, PatientDashboardWidget.routeName);
          },
        ),
        title: Text(
          'Notifications',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: _buildNotificationContent(),
      ),
    );
  }

  Widget _buildNotificationContent() {
    if (_isLoading && _notifications.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(
            FlutterFlowTheme.of(context).primary,
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: FlutterFlowTheme.of(context).titleLarge,
        ),
      );
    }

    if (_notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.notifications_none, size: 48, color: Colors.black),
            const SizedBox(height: 12),
            Text(
              'No notifications found',
              style: FlutterFlowTheme.of(context).titleLarge.override(
                    fontFamily: 'Outfit',
                    color: Colors.black,
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadInitialData,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: _notifications.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _notifications.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }

          final doc = _notifications[index];
          final data = doc.data() as Map<String, dynamic>;
          final isRead = _isRead(doc);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isRead ? const Color(0xFFF1F6FB) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: InkWell(
              onTap: () => _markAsRead(doc.id),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isRead ? Icons.notifications_none : Icons.notifications_active,
                        size: 24,
                        color: isRead ? Colors.grey : const Color(0xFF3B82F6),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          data['title'] ?? 'Notification',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                            color: Colors.black, // <-- all text black
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isRead ? Colors.green.shade100 : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isRead ? 'Read' : 'Unread',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black, // <-- black label text
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (data['message'] != null &&
                      data['message'].toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        data['message'],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.black, // <-- black message text
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatDate(data['Timestamp']),
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.black, // <-- black date text
                        ),
                      ),
                    ],
                  ),
                  if (data['action'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.touch_app,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            data['action'],
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.black, // <-- black action text
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );

        },
      ),
    );
  }

  Widget _buildNotificationDetail({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,
              size: 22, color: FlutterFlowTheme.of(context).secondaryText),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
