import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('Transactions', style: TextStyle(fontSize: 24))),
    Center(child: Text('Statistics', style: TextStyle(fontSize: 24))),
    Center(child: Text('Accounts', style: TextStyle(fontSize: 24))),
    Center(child: Text('More Options', style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onAddTransaction() {
    // Implement navigation to the add transaction screen
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Add Transaction')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddTransaction,
        backgroundColor: const Color(0xFFF55345),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.receipt_long,
                  color:
                      _selectedIndex == 0 ? Color(0xFFF55345) : Colors.black54,
                ),
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                icon: Icon(
                  Icons.bar_chart,
                  color:
                      _selectedIndex == 1 ? Color(0xFFF55345) : Colors.black54,
                ),
                onPressed: () => _onItemTapped(1),
              ),
              const SizedBox(width: 40), // Spacer for FAB
              IconButton(
                icon: Icon(
                  Icons.wifi_tethering,
                  color:
                      _selectedIndex == 2 ? Color(0xFFF55345) : Colors.black54,
                ),
                onPressed: () => _onItemTapped(2),
              ),
              IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  color:
                      _selectedIndex == 3 ? Color(0xFFF55345) : Colors.black54,
                ),
                onPressed: () => _onItemTapped(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
