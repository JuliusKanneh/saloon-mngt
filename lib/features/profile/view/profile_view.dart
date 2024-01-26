import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saloon/apis/auth_api.dart';
import 'package:saloon/apis/db_api.dart';
import 'package:saloon/apis/storage_api.dart';
import 'package:saloon/common/common.dart';
import 'package:saloon/features/auth/views/login_view.dart';
import 'package:saloon/providers/user_account_provider.dart';

class ProfileView extends ConsumerStatefulWidget {
  static route({required UserAccountProvider userProvider}) =>
      MaterialPageRoute(builder: (context) => const ProfileView());
  const ProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  bool isLoadingOnLogout = false;
  Uint8List? _image;

  void uploadPhoto(String userId) async {
    Uint8List? image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });

    //upload image to storage and save image url to database
    var downloadUrl = await ref.watch(sotreDataProvider).uploadImageToStorage(
        fileName: userId, file: image!, folderName: "ProfilePhotos");

    await ref
        .watch(firebaseDBApiProvider)
        .updateProfilePhotoUrl(downloadUrl, userId);
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userAccountProvider).getUser();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          //TODO: Display the image in full screen
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: (_image != null)
                                  ? CircleAvatar(
                                      radius: 65,
                                      backgroundImage: MemoryImage(_image!),
                                    )
                                  : ClipOval(
                                      child: (user!.photoUrl == null)
                                          ? Image.asset("assets/avatar.png")
                                          : Image.network(
                                              //TODO: Add default image if user has not uploaded any image
                                              user.photoUrl!,
                                              width: 150,
                                              height: 150,
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (context, child, progress) {
                                                return progress == null
                                                    ? child
                                                    : const CircularProgressIndicator();
                                              },
                                            ),
                                    ),
                            ),
                            Positioned(
                              bottom: -10,
                              left: 80,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 20,
                                      color: Colors.black12,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    uploadPhoto(user!.id!);
                                  },
                                  icon: const Icon(
                                    Icons.add_a_photo_outlined,
                                    // size: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        '${user?.name}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${user?.email}',
                      ),
                      // Add more details here like email, address, etc.
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () async {
                          // set isLoadingOnLogout to true to start loading
                          setState(() {
                            isLoadingOnLogout = true;
                          });

                          var res = await ref.read(authApiProvider).signOut();

                          // set isLoadingOnLogout to false to stop loading
                          setState(() {
                            isLoadingOnLogout = false;
                          });

                          res.fold(
                            (failure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(failure.message),
                                ),
                              );
                            },
                            (userCredential) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Logout successful'),
                                ),
                              );
                              Navigator.of(context).push(LoginView.route());
                            },
                          );
                        },
                        child: isLoadingOnLogout
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
