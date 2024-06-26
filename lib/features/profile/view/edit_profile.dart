import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart' as pick;
import 'package:twitter_x/core/core.dart';
import 'package:twitter_x/features/auth/controller/auth_controller.dart';
import 'package:twitter_x/features/profile/components/components.dart';
import 'package:twitter_x/model/user_model.dart';

class EditProfileView extends ConsumerStatefulWidget {
  static route({required UserModel currentUser}) => MaterialPageRoute(
      builder: (context) => EditProfileView(currentUser: currentUser));

  EditProfileView({super.key, required this.currentUser});
  final UserModel currentUser;

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late final _nameController;

  late final _bioController;

  late final _locationController;

  late final _websiteController;

  final _formKey = GlobalKey<FormState>();

  pick.XFile? _bannerPickedImage;
  pick.XFile? _avatarPickedImage;

  Future<void> _pickBannerImage() async {
    _bannerPickedImage = await UPickImage();

    isChanged = true;
    setState(() {});
  }

  Future<void> _pickAvatarImage() async {
    _avatarPickedImage = await UPickImage();
    isChanged = true;

    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nameController = TextEditingController(text: widget.currentUser.name);
    _bioController = TextEditingController(text: widget.currentUser.bio);
    _locationController = TextEditingController();
    _websiteController = TextEditingController();
  }

  void _profileUpdateHandler() {
    if (_formKey.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).updateProfile(
            userMode: widget.currentUser,
            name: _nameController.text.trim(),
            bio: _bioController.text.trim(),
            bannerImage: _bannerPickedImage,
            avatarImage: _avatarPickedImage,
          );
      isChanged = false;
    }
  }

  bool isChanged = false;
  @override
  Widget build(BuildContext context) {
    final authControllerP = ref.watch(authControllerProvider);
    return Stack(
      children: [
        WillPopScope(
          onWillPop: () async {
            if (isChanged == true) {
              final value = await showDialog<bool>(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    shape: ContinuousRectangleBorder(),
                    title: Text('Edit profile'),
                    content: Text('Discard changes?',
                        style: Theme.of(context).textTheme.bodyLarge!),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          'Cancel',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop(false);
                        },
                      ),
                      TextButton(
                        child: Text(
                          'Discard',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext)
                              .pop(true); // Dismiss alert dialog
                        },
                      ),
                    ],
                  );
                },
              );

              if (value != null) {
                return Future.value(value);
              } else {
                return Future.value(false);
              }
            } else {
              return await true;
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text("Edit Profile"),
              actions: [
                MaterialButton(
                  minWidth: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    _profileUpdateHandler();
                  },
                  child: Text(
                    'Save',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 15.w),
              ],
            ),
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      editBanner(
                        PickedImage: _bannerPickedImage,
                        bannerPic: widget.currentUser.bannerPic,
                        onTap: () async {
                          _pickBannerImage();
                        },
                      ),
                      Form(
                        key: _formKey,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 15.w)
                              .copyWith(top: 90),
                          child: Column(
                            children: [
                              profileTextField(
                                controller: _nameController,
                                context: context,
                                errorText: "You must provide name",
                                label: "Name",
                                hintText: 'Name cannot be blank',
                                maxLength: 50,
                              ),
                              profileTextField(
                                controller: _bioController,
                                context: context,
                                label: "Bio",
                                maxLines: 4,
                              ),
                              SizedBox(height: 20.h),
                              profileTextField(
                                controller: _locationController,
                                context: context,
                                label: "Location",
                              ),
                              SizedBox(height: 20.h),
                              profileTextField(
                                controller: _websiteController,
                                context: context,
                                label: "Website",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  editAvatar(
                    avatarPic: widget.currentUser.profilePic,
                    PickedImage: _avatarPickedImage,
                    onTap: () {
                      _pickAvatarImage();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Offstage(
            offstage: !authControllerP,
            child: Container(
              color: Colors.black.withOpacity(0.4),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        )
      ],
    );
  }
}
