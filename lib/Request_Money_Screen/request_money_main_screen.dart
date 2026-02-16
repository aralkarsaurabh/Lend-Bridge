import 'package:flutter/material.dart';
import 'package:lend_bridge/Request_Money_Screen/borrow_main_screen.dart';

class RequestMoneyMainScreen extends StatefulWidget {
  const RequestMoneyMainScreen({super.key});

  @override
  State<RequestMoneyMainScreen> createState() => _RequestMoneyMainScreenState();
}

class _RequestMoneyMainScreenState extends State<RequestMoneyMainScreen> {
  bool isLoading = false;

  int _selectedIndex = 0;

  final List<String> _tabLabels = ['Borrow', 'My borrowings'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text('Request Money'),
      ),

      backgroundColor: const Color(0xFFF5F5F5),

      body: isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : Column(
              children: [
                // Toggle Tab Bar
                _buildToggleBar(),

                // Page Content
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: [BorrowScreen(), ProfilePage()],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildToggleBar() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: List.generate(_tabLabels.length, (index) {
          return _buildToggleItem(index);
        }),
      ),
    );
  }

  Widget _buildToggleItem(int index) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _tabLabels[index],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// Page 2: Profile
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[50],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 80, color: Colors.green),
            SizedBox(height: 20),
            Text(
              "Profile Page",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text("Counter: $_counter", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _counter++;
                });
              },
              child: Text("Increment"),
            ),
            SizedBox(height: 10),
            Text(
              "Notice: State is preserved when you switch tabs!",
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
