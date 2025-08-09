import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../providers/owner_provider.dart';
import '../../providers/auth_provider.dart';

class OwnerProfileScreen extends StatefulWidget {
  final bool isNewOwner;

  const OwnerProfileScreen({super.key, this.isNewOwner = false});

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  File? _imageFile;
  String? _currentImageUrl;
  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.isNewOwner;

    if (!widget.isNewOwner) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadOwnerData();
      });
    }
  }

  void _loadOwnerData() async {
    final ownerProvider = Provider.of<OwnerProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      final currentOwner = await ownerProvider.fetchOwnerProfile();
      final user = authProvider.user;

      if (currentOwner != null) {
        _nameController.text = currentOwner.name;
        _emailController.text = currentOwner.email;
        _phoneController.text = currentOwner.phone;
        _addressController.text = currentOwner.address;
        _currentImageUrl = currentOwner.imageUrl;
      } else if (user != null) {
        _nameController.text = user.displayName ?? '';
        _emailController.text = user.email ?? '';
        _currentImageUrl = user.photoURL;
      }
    } catch (error) {
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to load owner data: ${error.toString()}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Okay'),
                ),
              ],
            ),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
    );

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
        _currentImageUrl = null;
      });
    }
  }

  Future<void> _saveOwner() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final ownerProvider = Provider.of<OwnerProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Update auth display name
      await authProvider.updateUserProfile(
        name: _nameController.text,
        photoURL: _imageFile != null ? 'pending_upload' : _currentImageUrl,
      );

      // Update owner profile
      await ownerProvider.updateOwnerProfile(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        imageFile: _imageFile,
      );

      if (mounted) {
        setState(() {
          _isEditing = false;
        });

        if (widget.isNewOwner) {
          Navigator.of(context).pop();
        }
      }
    } catch (error) {
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text('An error occurred!'),
              content: Text(error.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Okay'),
                ),
              ],
            ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ownerProvider = Provider.of<OwnerProvider>(context);
    final authprovider = Provider.of<AuthProvider>(context);
    final currentOwner = ownerProvider.currentOwner;

    if (!widget.isNewOwner && currentOwner == null && ownerProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar:
          widget.isNewOwner
              ? AppBar(title: const Text('Create Profile'))
              : null,
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile image
                      Center(
                        child: GestureDetector(
                          onTap: _isEditing ? _pickImage : null,
                          child: Stack(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(60),
                                  image:
                                      _imageFile != null
                                          ? DecorationImage(
                                            image: FileImage(_imageFile!),
                                            fit: BoxFit.cover,
                                          )
                                          : _currentImageUrl != null &&
                                              _currentImageUrl!.isNotEmpty
                                          ? DecorationImage(
                                            image: NetworkImage(
                                              _currentImageUrl!,
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                          : null,
                                ),
                                child:
                                    _imageFile == null &&
                                            (_currentImageUrl == null ||
                                                _currentImageUrl!.isEmpty)
                                        ? const Icon(
                                          Icons.person,
                                          size: 60,
                                          color: Colors.grey,
                                        )
                                        : null,
                              ),
                              if (_isEditing)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      if (_isEditing) ...[
                        // Name field
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Email field
                        TextFormField(
                          controller:
                              _emailController
                                ..text = authprovider.user?.email ?? '',
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          readOnly:
                              true, // Email can't be changed after registration
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Phone field
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),

                        // Address field
                        TextFormField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 32),

                        // Save button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _saveOwner,
                            child: Text(
                              widget.isNewOwner
                                  ? 'Create Profile'
                                  : 'Save Changes',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ] else if (currentOwner != null) ...[
                        // Display owner info
                        ProfileInfoItem(
                          title: 'Name',
                          value: currentOwner.name,
                        ),
                        ProfileInfoItem(
                          title: 'Email',
                          value: currentOwner.email,
                        ),
                        if (currentOwner.phone.isNotEmpty)
                          ProfileInfoItem(
                            title: 'Phone',
                            value: currentOwner.phone,
                          ),
                        if (currentOwner.address.isNotEmpty)
                          ProfileInfoItem(
                            title: 'Address',
                            value: currentOwner.address,
                          ),
                        const SizedBox(height: 32),

                        // Edit button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = true;
                              });
                            },
                            child: const Text(
                              'Edit Profile',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
    );
  }
}

class ProfileInfoItem extends StatelessWidget {
  final String title;
  final String value;

  const ProfileInfoItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }
}
