import 'package:flutter/material.dart';
import 'dart:async'; // Import for animations

void main() {
  runApp(const WavexpayApp());
}

class WavexpayApp extends StatelessWidget {
  const WavexpayApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wavexpay Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter', // You might need to add this font to your project
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// Added 'SingleTickerProviderStateMixin' for animations
class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // --- State and Handlers ---
  late PageController _pageController;
  int _currentIndex = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward(); // Start the animation
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Handle page changes from PageView
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Handle bottom nav taps
  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  // Shows a simple dialog for any action
  void _showActionDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            "Action Triggered",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }

  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(onActionClick: _showActionDialog),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          // --- Home Page Content ---
          HomeScreen(
              animationController: _animationController,
              onActionClick: _showActionDialog),
          // --- History Page Content ---
          HistoryScreen(onActionClick: _showActionDialog),
        ],
      ),
      // --- Bottom Navigation ---
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showActionDialog("Center Scan button clicked!"),
        backgroundColor: Colors.blue[600],
        elevation: 4.0,
        child: const Icon(Icons.qr_code, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        height: 70,
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(
              icon: Icons.home,
              label: "Home",
              onPressed: () => _onBottomNavTap(0),
              isActive: _currentIndex == 0,
            ),
            // Spacer for the FAB
            const SizedBox(width: 48),
            _buildBottomNavItem(
              icon: Icons.history,
              label: "History",
              onPressed: () => _onBottomNavTap(1),
              isActive: _currentIndex == 1,
            ),
          ],
        ),
      ),
    );
  }

  // Helper for bottom nav items
  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isActive = false,
  }) {
    final color = isActive ? Colors.blue[600] : Colors.grey[600];
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight:
                        isActive ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}

// --- Home Screen Widget ---
class HomeScreen extends StatelessWidget {
  final AnimationController animationController;
  final Function(String) onActionClick;

  const HomeScreen({
    Key? key,
    required this.animationController,
    required this.onActionClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // This Stack allows the BillReminder card to overlap the ScanToPay section
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Blue "ScanToPay" section
              ScanToPay(onActionClick: onActionClick),
              // "BillReminder" card, positioned to overlap
              Positioned(
                top: 220, // Adjust this value to control overlap
                child: BillReminder(onActionClick: onActionClick),
              ),
            ],
          ),
          // The rest of the content, with padding to account for the overlapping card
          Padding(
            padding: const EdgeInsets.only(top: 70.0, left: 16, right: 16),
            child: ServiceCreator(
                animationController: animationController,
                onActionClick: onActionClick),
          ),
          // Spacer for the bottom nav
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// --- History Screen (Placeholder) ---
class HistoryScreen extends StatelessWidget {
  final Function(String) onActionClick;
  const HistoryScreen({Key? key, required this.onActionClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          const Text(
            "No History Yet",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Your transactions will appear here.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => onActionClick("Refresh History clicked!"),
            child: const Text("Refresh"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// --- Custom Header AppBar ---
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final Function(String) onActionClick;
  const AppHeader({Key? key, required this.onActionClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Profile Icon
            GestureDetector(
              onTap: () => onActionClick("Profile icon clicked!"),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFFE5E7EB),
                    child: Icon(Icons.person, color: Color(0xFF4B5563)),
                  ),
                  const SizedBox(width: 12),
                  // Location Text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Hello, User", // Changed from "Location"
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "B-297 New ashok Nagar",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Spacer
            const Spacer(),
            // Action Icons
            IconButton(
              icon: const Icon(Icons.search, color: Color(0xFF374151)),
              onPressed: () => onActionClick("Search clicked!"),
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart,
                  color: Color(0xFF374151)),
              onPressed: () => onActionClick("Cart clicked!"),
            ),
            IconButton(
              icon: const Icon(Icons.notifications, color: Color(0xFF374151)),
              onPressed: () => onActionClick("Notifications clicked!"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

// --- "Quick Scan To Pay" Section ---
class ScanToPay extends StatelessWidget {
  final Function(String) onActionClick;
  const ScanToPay({Key? key, required this.onActionClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onActionClick("Quick Scan To Pay clicked!"),
      child: Container(
        height: 270, // Height for the blue area
        decoration: const BoxDecoration(
          // Added Gradient
          gradient: LinearGradient(
            colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Quick Scan To Pay",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Scanner Box
              Container(
                width: 180,
                height: 180,
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.qr_code,
                        color: Colors.white70,
                        size: 100,
                      ),
                    ),
                    // Scanner corners
                    _buildScannerCorner(top: 0, left: 0, isTopLeft: true),
                    _buildScannerCorner(top: 0, right: 0, isTopRight: true),
                    _buildScannerCorner(bottom: 0, left: 0, isBottomLeft: true),
                    _buildScannerCorner(
                        bottom: 0, right: 0, isBottomRight: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper for scanner corners
  Widget _buildScannerCorner({
    double? top,
    double? left,
    double? right,
    double? bottom,
    bool isTopLeft = false,
    bool isTopRight = false,
    bool isBottomLeft = false,
    bool isBottomRight = false,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border(
            top: isTopLeft || isTopRight
                ? const BorderSide(color: Colors.orangeAccent, width: 4)
                : BorderSide.none,
            left: isTopLeft || isBottomLeft
                ? const BorderSide(color: Colors.orangeAccent, width: 4)
                : BorderSide.none,
            right: isTopRight || isBottomRight
                ? const BorderSide(color: Colors.orangeAccent, width: 4)
                : BorderSide.none,
            bottom: isBottomLeft || isBottomRight
                ? const BorderSide(color: Colors.orangeAccent, width: 4)
                : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft: isTopLeft ? const Radius.circular(8) : Radius.zero,
            topRight: isTopRight ? const Radius.circular(8) : Radius.zero,
            bottomLeft: isBottomLeft ? const Radius.circular(8) : Radius.zero,
            bottomRight: isBottomRight ? const Radius.circular(8) : Radius.zero,
          ),
        ),
      ),
    );
  }
}

// --- "Bill Reminder" Card ---
class BillReminder extends StatelessWidget {
  final Function(String) onActionClick;
  const BillReminder({Key? key, required this.onActionClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // Softer shadow
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                // Icon
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFFEE2E2),
                  child: Icon(Icons.description, color: Color(0xFFDC2626)),
                ),
                const SizedBox(width: 12),
                // Text
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Credit Card-9685",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "1200 due on Wed, 25 Jan",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Buttons
          Row(
            children: [
              ElevatedButton(
                onPressed: () => onActionClick("Pay button clicked!"),
                child: const Text("Pay"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => onActionClick("My Bills clicked!"),
                child: const Text("My Bills",
                    style: TextStyle(color: Colors.black87)),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Service Grid Data Models ---
class ServiceItem {
  final IconData icon;
  final String label;
  ServiceItem({required this.icon, required this.label});
}

// --- Data for Grids ---
final List<ServiceItem> moneyTransferItems = [
  ServiceItem(icon: Icons.send, label: "Pay to Contact"),
  ServiceItem(icon: Icons.account_balance, label: "To Bank/ UPI ID"),
  ServiceItem(icon: Icons.refresh, label: "Self Account"),
  ServiceItem(icon: Icons.check_circle, label: "Check Balance"),
];

final List<ServiceItem> popularItems = [
  ServiceItem(icon: Icons.smartphone, label: "Mobile Recharge"),
  ServiceItem(
      icon: Icons.directions_car, label: "FASTag Recharge"),
  ServiceItem(icon: Icons.satellite, label: "DTH"),
  ServiceItem(icon: Icons.handshake, label: "Loan Repayment"),
];

final List<ServiceItem> utilitiesItems = [
  ServiceItem(icon: Icons.home, label: "Rent"),
  ServiceItem(icon: Icons.water_drop, label: "Water"),
  ServiceItem(icon: Icons.bolt, label: "Electricity"),
  ServiceItem(
      icon: Icons.local_gas_station, label: "Cylinder"),
  ServiceItem(icon: Icons.description, label: "Postpaid"),
  ServiceItem(icon: Icons.business, label: "Broadband"),
  ServiceItem(icon: Icons.credit_card, label: "Credit Card"),
  ServiceItem(icon: Icons.local_fire_department, label: "Piped Gas"),
];

// --- Reusable Service Grid Component ---
class ServiceGrid extends StatelessWidget {
  final String title;
  final List<ServiceItem> items;
  final Function(String) onActionClick;
  final Animation<double> animation;

  const ServiceGrid({
    Key? key,
    required this.title,
    required this.items,
    required this.onActionClick,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = items[index];
                return ServiceIcon(
                  icon: item.icon,
                  label: item.label,
                  onActionClick: onActionClick,
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// --- Reusable Service Icon ---
class ServiceIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function(String) onActionClick;

  const ServiceIcon({
    Key? key,
    required this.icon,
    required this.label,
    required this.onActionClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onActionClick("$label clicked!"),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              // Upgraded style with gradient
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade50,
                  Colors.blue.shade100.withOpacity(0.8)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20), // More rounded
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade100.withOpacity(0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Icon(icon, color: Colors.blue[800], size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// --- Component for all other service sections ---
class ServiceCreator extends StatelessWidget {
  final Function(String) onActionClick;
  final AnimationController animationController;

  const ServiceCreator(
      {Key? key,
      required this.onActionClick,
      required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Helper to create staggered animations for each grid
    Animation<double> _getAnimation(int index) {
      final double start = (0.2 * index).clamp(0.0, 1.0);
      final double end = (start + 0.4).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(start, end, curve: Curves.easeOut),
      ));
    }

    return Column(
      children: [
        ServiceGrid(
          title: "Money Transfers",
          items: moneyTransferItems,
          onActionClick: onActionClick,
          animation: _getAnimation(0),
        ),
        ServiceGrid(
          title: "Popular",
          items: popularItems,
          onActionClick: onActionClick,
          animation: _getAnimation(1),
        ),
        ServiceGrid(
          title: "Utilities",
          items: utilitiesItems,
          onActionClick: onActionClick,
          animation: _getAnimation(2),
        ),
        // Cashback Banner
        FadeTransition(
          opacity: _getAnimation(3),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF6366F1)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Get up to 500 cashback",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "on your first ever Credit Card Bill payment",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => onActionClick("Cashback Pay Now clicked!"),
                  child: const Text("Pay Now"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Other grids from the PDF...
        ServiceGrid(
          title: "Donations & Devotion",
          items: [
            ServiceItem(icon: Icons.favorite, label: "Donate"),
            ServiceItem(icon: Icons.temple_hindu, label: "Devotion"),
            ServiceItem(icon: Icons.temple_hindu, label: "Ram Mandir"),
            ServiceItem(icon: Icons.card_giftcard, label: "Donate meal"),
          ],
          onActionClick: onActionClick,
          animation: _getAnimation(4),
        ),
        ServiceGrid(
          title: "Financial Services & Taxes",
          items: [
            ServiceItem(icon: Icons.security, label: "LIC/ Insurance"),
            ServiceItem(icon: Icons.business, label: "Municipal Tax"),
            ServiceItem(icon: Icons.description, label: "Recurring Deposit"),
            ServiceItem(icon: Icons.work, label: "NPS"),
            ServiceItem(icon: Icons.handshake, label: "Loan Repayment"),
          ],
          onActionClick: onActionClick,
          animation: _getAnimation(5),
        ),
      ],
    );
  }
}
