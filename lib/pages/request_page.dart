import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/main.dart';
import 'package:lrf/pages/feed_page.dart';

import 'package:lrf/pages/widgets/request/general_widgets.dart';
import 'package:image/image.dart' as Im;
import 'package:lrf/services/database.dart';
import 'package:lrf/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key, required this.user}) : super(key: key);

  final Map<String, dynamic>? user;

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  String? currentUserId;
  late Database db;
  bool isLoading = false;
  final ImagePicker picker = ImagePicker();
  File? selectedPhoto;
  Map<String, dynamic>? user;
  String? token;
// text controllers for textfield
  final TextEditingController _contactEmailController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _dropDownValue;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final bool _validate = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contactEmailController.dispose();
    _contactNumberController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    db = Database();
    currentUserId = sharedPreferences.getString('currentUserUid');
    token = sharedPreferences.getString('token');

    user = widget.user;

    super.initState();
  }

  Future<void> postRequest(String catgeory) async {
    setState(() {
      isLoading = true;
    });

    // start the loading
    try {
      final postId = const Uuid().v4();
      String mediaUrl = '';
      selectedPhoto != null
          ? mediaUrl = await uploadimageToStorage(
              postId,
            )
          : mediaUrl = '';

      // upload to  db
      String res = await db.createPostRequest(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          userId: user?['id'] ?? currentUserId,
          category: catgeory,
          contactNumber: _contactNumberController.text.isNotEmpty ? _contactNumberController.text.trim() : '',
          contactEmail: _contactEmailController.text.trim(),
          username: user?['username'],
          photoURL: user?['photoUrl'],
          postId: postId,
          token: user?['token'] ?? token,
          imagePath: mediaUrl);

      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        clearImage();
        if (mounted) {
          showSnackBar(
            context,
            'Posted!',
          );
          Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedPage()));
        }
      } else {
        if (mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, 'Something went wrong. Try again');
    }
  }

  handleCamera() async {
    Navigator.pop(context);
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    setState(() {
      selectedPhoto = File(image!.path.toString());
    });
  }

  Future<String> uploadimageToStorage(
    String postId,
  ) async {
    await compressImage(postId, user?['id']);
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': selectedPhoto!.path},
    );
    UploadTask uploadTask;
    //storage path
    Reference ref = FirebaseStorage.instance.ref().child('post').child('post_$postId$currentUserId.jpg');
    uploadTask = ref.putData(await selectedPhoto!.readAsBytes(), metadata);
    String imgUrl = await (await uploadTask).ref.getDownloadURL();

    return imgUrl;
  }

  handleGallery() async {
    // pop dialog
    Navigator.pop(context);
    //upload to db
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery, maxHeight: 675, maxWidth: 960);
    setState(() {
      selectedPhoto = File(image!.path);
    });
  }

  selectImage() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Add Image'),
            children: [
              SimpleDialogOption(
                onPressed: handleCamera,
                child: const Text('Camera'),
              ),
              SimpleDialogOption(
                onPressed: handleGallery,
                child: const Text('Gallery'),
              ),
              SimpleDialogOption(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      selectedPhoto = null;
    });
  }

  Future<void> compressImage(String postId, String userId) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image? imageFile = Im.decodeImage(await selectedPhoto!.readAsBytes());
    final compressedImage = File('$path/img_$postId$userId.jpg')..writeAsBytesSync(Im.encodeJpg(imageFile!, quality: 85));
    setState(() {
      selectedPhoto = compressedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text(
          'Post Ad',
        ),
        centerTitle: false,
        actions: [
          !isLoading
              ? IconButton(
                  onPressed: () async {
                    final formState = _formKey.currentState;
                    //if form is not empty
                    if (formState!.validate() && _dropDownValue != null) {
                      // add to post collection in db
                      await postRequest(_dropDownValue.toString());
                    } else {
                      if (mounted) {
                        showSnackBar(context, 'Please enter all fields.');
                      }
                    }
                  },
                  icon: const Icon(Icons.check))
              : const SizedBox.shrink(),
        ],
      ),
      body: user != null
          ? isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                )
              : Form(
                  key: _formKey,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(8),
                    margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          title: const Text('(Required) Select Category: '),
                          dense: true,
                          subtitle: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18.0),
                                ),
                              ),
                            ),
                            hint: _dropDownValue == null
                                ? const Text(
                                    'Category',
                                    style: TextStyle(color: Colors.black),
                                  )
                                : Text(
                                    _dropDownValue!,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                            isExpanded: true,
                            value: _dropDownValue,
                            iconSize: 30.0,
                            validator: (String? value) {
                              if (value == null) {
                                return 'Category is required';
                              }
                              return null;
                            },
                            items: ['Art', 'Watches', 'Antiques', 'Others'].map(
                              (val) {
                                return DropdownMenuItem<String>(
                                  value: val,
                                  child: Text(val),
                                );
                              },
                            ).toList(),
                            onChanged: (String? val) {
                              setState(() {
                                _dropDownValue = val;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          dense: true,
                          title: const Text('(Required) Interesting title : ',
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: textFieldRequest(
                                  controller: _titleController,
                                  maxLines: 2,
                                  hintText: 'Looking for..',
                                  onChanged: (value) {},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Title is Required';
                                    }
                                    return null;
                                  },
                                  maxLength: 120,
                                  validate: _validate,
                                  textCapitalization: TextCapitalization.sentences,
                                  textInputType: TextInputType.text)),
                        ),
                        ListTile(
                            title: const Text('(Optional) Image: '),
                            subtitle: ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.blue.shade800),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(selectedPhoto == null ? Colors.blue.shade900 : Colors.blue)),
                                onPressed: selectImage,
                                child: selectedPhoto == null ? const Text('Upload Image') : const Text('Image Saved'))),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          dense: true,
                          title: const Text('(Optional)  Contact Number : ', style: TextStyle(fontSize: 16, color: mobileBackgroundColor)),
                          subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: textFieldRequest(
                                  controller: _contactNumberController,
                                  maxLines: null,
                                  maxLength: null,
                                  validate: _validate,
                                  // validator: (value) {
                                  //   String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                                  //   RegExp regExp = RegExp(patttern);
                                  //   if (value!.isEmpty) {
                                  //     return 'Mobile Number is Required';
                                  //   } else if (!regExp.hasMatch(value)) {
                                  //     return 'Please enter a valid mobile number';
                                  //   }
                                  //   return null;
                                  // },
                                  onChanged: (value) {},
                                  hintText: '+1234567',
                                  textCapitalization: TextCapitalization.none,
                                  textInputType: TextInputType.number)),
                        ),
                        ListTile(
                          dense: true,
                          title: const Text('(Required) Contact Email : ', style: TextStyle(fontSize: 16, color: mobileBackgroundColor)),
                          subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: textFieldRequest(
                                  controller: _contactEmailController,
                                  maxLines: null,
                                  maxLength: null,
                                  validate: _validate,
                                  onChanged: (value) {},
                                  hintText: 'hello@bountybay.net',
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Email is Required';
                                    }
                                    if (!RegExp(r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$").hasMatch(value)) {
                                      return 'Please enter a valid Email';
                                    }
                                    return null;
                                  },
                                  textCapitalization: TextCapitalization.none,
                                  textInputType: TextInputType.emailAddress)),
                        ),
                        ListTile(
                          dense: true,
                          title: const Text('(Required) Body : ',
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: textFieldRequest(
                                  controller: _descriptionController,
                                  maxLines: 20,
                                  hintText: '',
                                  validate: _validate,
                                  onChanged: (value) {},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Body is Required';
                                    }
                                    return null;
                                  },
                                  maxLength: 820,
                                  textCapitalization: TextCapitalization.sentences,
                                  textInputType: TextInputType.multiline)),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                )
          : const CircularProgressIndicator(),
    );
  }
}
