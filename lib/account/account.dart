import 'dart:async';
import 'package:flutter/material.dart';

// in project
import '../../globals/database.dart';
import '../../globals/static/custom_widgets/icon_circle.dart';
import '../../globals/static/build_context_extension.dart';
import '../account/avatar.dart';
import '../../globals/account_service.dart';

/*
Account Page will be accessible by button in top right

Current Account Page for accounts in supabase

only displays profile picture and users name

Potential Additions
- [ ] preferences / location preferences
- [ ] account creation date 


 */

class Account extends StatefulWidget {
  Account({Key? key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String? _avatarUrl;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  void fetchProfile() async {
    await AccountService.fetchProfile();
    _loading = true;

    try {
      final userId = supabase.auth.currentSession!.user.id;
      final data =
          await supabase.from('profiles').select().eq('id', userId).single();
      _avatarUrl = (data['avatar_url'] ?? '') as String;
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unexpected error retrieving avatar occurred'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  /// Called when image has been uploaded to Supabase storage from within Avatar widget
  Future<void> _onUpload(String imageUrl) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      await supabase.from('profiles').upsert({
        'id': userId,
        'avatar_url': imageUrl,
      });
      if (mounted) {
        const SnackBar(content: Text('Updated your profile image!'));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unexpected error occurred'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _avatarUrl = imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final Map<String, dynamic> profile = AccountService.account;

    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      body: _loading
          ? Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.size.width * .05,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      boxShadow: [BoxShadow(color: colorScheme.shadow, blurRadius: 4)],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Avatar(imageUrl: _avatarUrl, onUpload: _onUpload),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          profile['name'] ?? "User",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Georama',
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          supabase.auth.currentUser?.email ?? 'Guest User',
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Account Options
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Georama',
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildAccountOption(
                          context,
                          icon: Icons.person_outline,
                          title: 'Edit Profile',
                          onTap: () {},
                        ),
                        _buildAccountOption(
                          context,
                          icon: Icons.security_outlined,
                          title: 'Privacy Settings',
                          onTap: () {},
                        ),
                        _buildAccountOption(
                          context,
                          icon: Icons.notifications_outlined,
                          title: 'Notification Preferences',
                          onTap: () {},
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Actions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Georama',
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildAccountOption(
                          context,
                          icon: Icons.logout,
                          title: 'Sign Out',
                          isDestructive: false,
                          onTap: () {
                            // Sign out logic
                          },
                        ),
                        _buildAccountOption(
                          context,
                          icon: Icons.delete_outline,
                          title: 'Delete Account',
                          isDestructive: true,
                          onTap: () {
                            // Delete account logic
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildAccountOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: colorScheme.shadow.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isDestructive ? colorScheme.error : colorScheme.onSurface,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDestructive ? colorScheme.error : colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
