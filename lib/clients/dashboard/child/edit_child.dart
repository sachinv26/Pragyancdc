import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pragyan_cdc/api/child_api.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/model/child_model.dart';
import 'package:pragyan_cdc/shared/loading.dart';

import '../../../api/auth_api.dart';

class EditChildScreen extends StatefulWidget {
  final ChildModel childData;

  const EditChildScreen({Key? key, required this.childData}) : super(key: key);

  @override
  State<EditChildScreen> createState() => _EditChildScreenState();
}

class _EditChildScreenState extends State<EditChildScreen> {
  static const List<String> relation = ['Parent', 'Guardian'];

  String _imagepath = '';
  String dropdownValue = relation.first;
  String _selectedGender = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController motherTongueController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _imagepath = "https://dev.cdcconnect.in/${widget.childData.childImage}";
    nameController.text = widget.childData.childName;
    dobController.text = widget.childData.childDob;
    dropdownValue = widget.childData.relationship;
    _selectedGender = widget.childData.childGender;
    motherTongueController.text = widget.childData.mothertounge ?? '';
    educationController.text = widget.childData.childEducation ?? '';

    print('Dropdown Value: $dropdownValue');
    print('Available Relations: $relation');
  }

  @override
  Widget build(BuildContext context) {
    if (!relation.contains(dropdownValue)) {
      dropdownValue = relation.first;
    }

    return Scaffold(
      appBar: customAppBar(title: 'Edit Child'),
      body: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildAvatarSection(),
                _buildInputField('Name', 'Child Name', Icons.person, nameController),
                _buildDateField(),
                _buildDropdownField('Relationship', dropdownValue, relation, (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                }),
                _buildGenderField(),
                _buildInputField('Mother Tongue', 'Mother Tongue', Icons.language, motherTongueController),
                _buildInputField('Education', 'Education', Icons.school, educationController),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          child: CircleAvatar(
            radius: 35,
            child: ClipOval(
              child: Image.network(
                _imagepath,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(child: Loading());
                  }
                },
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return const Icon(Icons.error);
                },
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -5,
          right: -8,
          child: Transform.scale(
            scale: 0.8,
            child: IconButton(
              style: IconButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                if (!_loading) {
                  await _requestPermissions();
                  final result = await _pickImageFromGallery(widget.childData);
                  if (result != null && result.isNotEmpty) {
                    setState(() {
                      _imagepath = result;
                    });
                  }
                }
              },
              icon: const Icon(Icons.camera_alt, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, String hintText, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: kTextStyle1),
          const SizedBox(height: 10),
          CustomTextFormField(
            hintText: hintText,
            iconData: Icon(icon),
            controller: controller,
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          const Text('Child DOB', style: khintTextStyle),
          const SizedBox(width: 25),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                dobController.text = (await _selectDate(context, dobController.text))!;
              },
              child: CustomTextFormField(
                hintText: 'DD/MM/YYYY',
                controller: dobController,
                enabled: false,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Text('$label:', style: khintTextStyle),
          const SizedBox(width: 10),
          DropdownButton<String>(
            value: value,
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          const Text('Gender:', style: khintTextStyle),
          _buildRadio('Male', 'male'),
          _buildRadio('Female', 'female'),
          _buildRadio('Other', 'other'),
        ],
      ),
    );
  }

  Widget _buildRadio(String label, String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _selectedGender,
          onChanged: (value) {
            setState(() {
              _selectedGender = value!;
            });
          },
        ),
        Text(label),
        const SizedBox(width: 4.0),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: CustomButton(
        text: 'Save Changes',
        onPressed: () async {
          final result = await submitEditForm(context, widget.childData.childId);
          if (context.mounted) {
            Navigator.of(context).pop(result);
          }
        },
      ),
    );
  }

  Future<String?> _selectDate(BuildContext context, String dobController) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2015),
      firstDate: DateTime(1997),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != DateTime.now()) {
      dobController = picked.toLocal().toString().split(' ')[0];
      return dobController;
    }
    return null;
  }

  Future submitEditForm(BuildContext context, String childId) async {
    final name = nameController.text;
    final gender = _selectedGender;
    final dob = dobController.text;
    final relation = dropdownValue;
    final motherTongue = motherTongueController.text;
    final education = educationController.text;

    Map<String, String> childDetails = {
      'prag_child_name': name,
      'prag_child_dob': dob,
      'prag_child_gender': gender,
      'prag_child_relation': relation,
      'prag_child_mother_tongue': motherTongue,
      'prag_child_education': education,
    };

    final userId = await const FlutterSecureStorage().read(key: 'userId');
    final token = await const FlutterSecureStorage().read(key: 'authToken');

    if (userId != null && token != null) {
      Map<String, dynamic> result = await ChildApi().editChild(
        userId: userId,
        userToken: token,
        childId: childId,
        childDetails: childDetails,
      );

      if (result['status'] == 1) {
        Fluttertoast.showToast(
          msg: result['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        debugPrint('Child edited successfully');
        return result;
      } else {
        Fluttertoast.showToast(
          msg: result['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        print('Failed to edit child: ${result['message']}');
      }
    }
  }

  Future<String?> _pickImageFromGallery(ChildModel childModel) async {
    final api = ApiServices();
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _loading = true;
      });

      final token = await const FlutterSecureStorage().read(key: 'authToken');
      final userId = await const FlutterSecureStorage().read(key: 'userId');
      if (userId != null && token != null) {
        try {
          File imageFile = File(image.path);
          Map<String, dynamic> response = await api.callImageUploadApi(
              {"child_id": childModel.childId, "call_from": 2},
              imageFile,
              userId,
              token);
          if (response['status'] == 1) {
            debugPrint('Image uploaded successfully');
            debugPrint('Image saved in ${response["path"]}');
            setState(() {
              _loading = false;
            });
            return "https://dev.cdcconnect.in/${response["path"]}";
          } else {
            setState(() {
              _loading = false;
            });
            print('Image upload failed: ${response['message']}');
            return null;
          }
        } catch (e) {
          setState(() {
            _loading = false;
          });
          debugPrint('Error uploading image: $e');
          return null;
        }
      }
    }
    return null;
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.storage.request();
      if (status != PermissionStatus.granted) {
        print('Storage permissions denied');
        return;
      }
    }
  }
}
