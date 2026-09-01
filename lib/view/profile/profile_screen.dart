import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  
  const ProfileScreen({ Key? key}) : super(key: key);

  static 
  const Color primaryBlue = Color(0xFF0052CC);
  static 
  const Color lightBlueBg = Color(0xFFF1F5FE);
  static 
  const Color darkTextColor = Color(0xFF1A1D26);
  static 
  const Color secondaryTextColor = Color(0xFF757D8A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: 
       Color(0xFFFAF8FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: 
         Text(
          'RideSharePro',
          style: TextStyle(
            color: primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: 
             Icon(Icons.notifications_none, color: darkTextColor),
            onPressed: () {},
          ),
          Padding(
            padding: 
             EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: primaryBlue,
              child: 
               Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: 
         EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            
             SizedBox(height: 16),
            _buildActionButtons(),
            
             SizedBox(height: 16),
            _buildStatsRow(),
            
             SizedBox(height: 16),
            _buildAiInsightsBanner(),
            
             SizedBox(height: 20),
            _buildSectionHeader('Verification Status'),
            
             SizedBox(height: 8),
            _buildVerificationCard(),
            
             SizedBox(height: 20),
            _buildSectionHeader('Personal Information', actionText: 'Update'),
            
             SizedBox(height: 8),
            _buildPersonalInfoCard(),
            
             SizedBox(height: 20),
            _buildSectionHeader('Emergency Contact'),
            
             SizedBox(height: 8),
            _buildEmergencyContactCard(),
            
             SizedBox(height: 20),
            _buildSectionHeader('Account Settings'),
            
             SizedBox(height: 8),
            _buildAccountSettingsList(),
            
             SizedBox(height: 20),
            _buildLogoutButton(),
            
             SizedBox(height: 12),
            
             Center(
              child: Text(
                'Version 2.4.1 (Build 4401)',
                style: TextStyle(color: secondaryTextColor, fontSize: 11),
              ),
            ),
            
             SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              
               CircleAvatar(
                radius: 40,
                backgroundColor: primaryBlue,
                child: Text(
                  'MJ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: 
                   EdgeInsets.all(4),
                  decoration: 
                   BoxDecoration(
                    color: primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: 
                   Icon(Icons.camera_alt, color: Colors.white, size: 12),
                ),
              ),
            ],
          ),
          
           SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
               Text(
                'Muhammed Jefri',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkTextColor,
                ),
              ),
              
               SizedBox(width: 6),
              Container(
                padding: 
                 EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: 
                   Color(0xFFE3EDFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: 
                   [
                    Icon(Icons.check_circle, color: primaryBlue, size: 10),
                    SizedBox(width: 3),
                    Text(
                      'VERIFIED',
                      style: TextStyle(
                        color: primaryBlue,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
           SizedBox(height: 4),
          
           Text(
            'tikov53956@kierko.com',
            style: TextStyle(color: secondaryTextColor, fontSize: 13),
          ),
        ],
      ),
    );
  }


  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: 
               Icon(Icons.edit, size: 16, color: Colors.white),
              label: 
               Text('Edit Profile', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
        
         SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 40,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: 
               Icon(Icons.share_outlined, size: 16, color: primaryBlue),
              label: 
               Text('Share', style: TextStyle(color: primaryBlue)),
              style: ElevatedButton.styleFrom(
                backgroundColor: lightBlueBg,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard('1', 'HOSTED'),
        
         SizedBox(width: 8),
        _buildStatCard('0', 'TAKEN'),
        
         SizedBox(width: 8),
        _buildStatCard('₹0', 'EARNED'),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: 
         EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: 
               TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            
             SizedBox(height: 2),
            Text(
              label,
              style: 
               TextStyle(
                fontSize: 10,
                color: secondaryTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildAiInsightsBanner() {
    return Container(
      width: double.infinity,
      padding: 
       EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: 
         LinearGradient(
          colors: [Color(0xFF2962FF), Color(0xFF1565C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: 
             [
              Icon(Icons.auto_awesome, color: Colors.white, size: 16),
              SizedBox(width: 6),
              Text(
                'AI INSIGHTS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          
           SizedBox(height: 8),
          
           Text(
            'You\'ve completed your first trip!\nPassengers love your reliability. Keep it up to reach \'Super Host\' status.',
            style: TextStyle(color: Colors.white, fontSize: 12, height: 1.4),
          ),
          
           SizedBox(height: 12),
          Row(
            children: [
              _buildBadge('Reliable'),
              
               SizedBox(width: 8),
              _buildBadge('Fast Responder'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String title) {
    return Container(
      padding: 
       EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        title,
        style: 
         TextStyle(color: Colors.white, fontSize: 10),
      ),
    );
  }


  Widget _buildVerificationCard() {
    return Container(
      padding: 
       EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildVerificationRow(Icons.email_outlined, 'Email Address', 'VERIFIED', isVerified: true),
          
           Divider(height: 16),
          _buildVerificationRow(Icons.phone_outlined, 'Phone Number', 'VERIFIED', isVerified: true),
          
           Divider(height: 16),
          _buildVerificationRow(Icons.badge_outlined, 'Government ID', 'PENDING', isVerified: false),
        ],
      ),
    );
  }

  Widget _buildVerificationRow(IconData icon, String title, String statusText, {required bool isVerified}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: secondaryTextColor),
        
         SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: 
             TextStyle(fontSize: 13, color: darkTextColor, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          padding: 
           EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: isVerified ? 
             Color(0xFFE3EDFF) : 
             Color(0xFFF2F4F7),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            statusText,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isVerified ? primaryBlue : secondaryTextColor,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildPersonalInfoCard() {
    return Container(
      padding: 
       EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildInfoField('FULL NAME', 'Muhammed Jefri'),
              _buildInfoField('GENDER', 'Male'),
            ],
          ),
          
           SizedBox(height: 12),
          _buildInfoField('EMAIL', 'tikov53956@kierko.com'),
          
           SizedBox(height: 12),
          Row(
            children: [
              _buildInfoField('DATE OF BIRTH', 'Not set'),
              _buildInfoField('LOCATION', 'Not set'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: 
             TextStyle(fontSize: 10, color: secondaryTextColor, fontWeight: FontWeight.bold),
          ),
          
           SizedBox(height: 2),
          Text(
            value,
            style: 
             TextStyle(fontSize: 13, color: darkTextColor, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }


  Widget _buildEmergencyContactCard() {
    return Container(
      padding: 
       EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: 
         Color(0xFFFFF2F2),
        borderRadius: BorderRadius.circular(12),
        border: 
         Border(
          left: BorderSide(color: Colors.red, width: 4),
        ),
      ),
      child: Row(
        children: [
          
           CircleAvatar(
            radius: 14,
            backgroundColor: Color(0xFFFFD6D6),
            child: Icon(Icons.emergency, color: Colors.red, size: 16),
          ),
          
           SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: 
               [
                Text(
                  'Not set',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: darkTextColor),
                ),
                SizedBox(height: 2),
                Text(
                  'Add an emergency contact for safety during your trips.',
                  style: TextStyle(fontSize: 11, color: secondaryTextColor),
                ),
              ],
            ),
          ),
          IconButton(
            icon: 
             Icon(Icons.edit_outlined, size: 18, color: darkTextColor),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettingsList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSettingsTile(Icons.notifications_none, 'Notifications', 'Push, email & SMS alerts'),
          
           Divider(height: 1),
          _buildSettingsTile(Icons.account_balance_wallet_outlined, 'Payment Methods', 'UPI, cards, wallets'),
          
           Divider(height: 1),
          _buildSettingsTile(Icons.shield_outlined, 'Privacy & Security', '2FA, login history'),
          
           Divider(height: 1),
          _buildSettingsTile(Icons.tune_outlined, 'Preference', 'Customize your experience'),
          
           Divider(height: 1),
          _buildSettingsTile(Icons.help_outline, 'Support Center', 'Help, FAQs, contact us'),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: secondaryTextColor, size: 20),
      title: Text(title, style: 
       TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: darkTextColor)),
      subtitle: Text(subtitle, style: 
       TextStyle(fontSize: 11, color: secondaryTextColor)),
      trailing: 
       Icon(Icons.chevron_right, size: 18, color: secondaryTextColor),
      onTap: () {},
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: 
         Icon(Icons.logout, color: Colors.red, size: 18),
        label: 
         Text(
          'Log Out',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: 
           Color(0xFFFFF2F2),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 3,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryBlue,
      unselectedItemColor: secondaryTextColor,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      items: 
       [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.directions_car_outlined), label: 'My Trips'),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Earnings'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }


  Widget _buildSectionHeader(String title, {String? actionText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: 
           TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: darkTextColor),
        ),
        if (actionText != null)
          GestureDetector(
            onTap: () {},
            child: Text(
              actionText,
              style: 
               TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryBlue),
            ),
          ),
      ],
    );
  }
}