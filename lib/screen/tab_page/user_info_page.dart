import 'package:acha/model/api/login_api.dart';
import 'package:acha/model/api/user_info_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';
import '../component/app_bar.dart';
import '../component/assets.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage>
    with AutomaticKeepAliveClientMixin {
  String username = '';
  String email = '';
  String userProfileImgUrl = 'images/placeholder.png';
  bool hasProfileImage = false;

  @override
  void initState() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    super.initState();
    username =
        userProvider.username != null ? userProvider.username! : username;
    email = userProvider.email != null ? userProvider.email! : email;
    if (userProvider.profileImageUrl != null) {
      userProfileImgUrl = userProvider.profileImageUrl!;
      hasProfileImage = true;
    }
  }

  void onLogoutPressed(UserProvider userProvider) async {
    try {
      await LoginApi().logout();
    } catch (e) {}
    userProvider.deleteState(false);
  }

  void onEditInfoPressed(UserProvider userProvider) async {
    final TextEditingController usernameEditingController =
        TextEditingController();

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    RoundedRectangleBorder customRoundedRectangleBorder =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15));

    Map<String, dynamic>? editedValues = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) {
          return Dialog(
            shape: customRoundedRectangleBorder,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '유저 정보 수정',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: usernameEditingController,
                      decoration: InputDecoration(
                        labelText: '닉네임',
                        hintText: username,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                      onChanged: (value) {
                        formKey.currentState!.validate();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '닉네임을 입력해주세요';
                        } else if (value.length > 10) {
                          return '닉네임은 10 글자보다 작아야 합니다.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              String newUsername =
                                  usernameEditingController.text;
                              Navigator.pop(context, {'username': newUsername});
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 35, vertical: 15),
                            backgroundColor: Colors.blue,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('저장'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 35, vertical: 15),
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.red.shade200),
                            ),
                          ),
                          child: const Text('취소'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });

    if (editedValues != null && editedValues.isNotEmpty) {
      try {
        await UserInfoApi()
            .editUsername(userProvider, editedValues['username']);
        setState(() {
          username = editedValues['username'];
        });
      } catch (e) {
        return Assets().showErrorSnackBar(context, "회원 이름 업데이트에 실패했습니다.");
      }
    }
  }

  void onDeleteUserPressed() async {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userProvider = Provider.of<UserProvider>(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const CustomAppBar(title: 'User Information'),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: screenSize.width * 0.80,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: hasProfileImage
                          ? Image.network(
                              userProfileImgUrl,
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            )
                          : Image.asset(
                              userProfileImgUrl,
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  userInfoActionButton(
                    onPressed: onDeleteUserPressed,
                    backgroundColor: Colors.red,
                    text: '계정 삭제',
                    context: context,
                  ),
                  userInfoActionButton(
                    onPressed: () => onEditInfoPressed(userProvider),
                    backgroundColor: const Color(0xFF66ABF2),
                    text: '정보 수정',
                    context: context,
                  ),
                  userInfoActionButton(
                    onPressed: () => onLogoutPressed(userProvider),
                    backgroundColor: const Color.fromARGB(255, 255, 95, 95),
                    text: '로그아웃',
                    context: context,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget userInfoActionButton({
    required Function() onPressed,
    required Color backgroundColor,
    required String text,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          textStyle: const TextStyle(fontSize: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
