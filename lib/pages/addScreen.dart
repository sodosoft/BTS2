import 'dart:io';

import 'package:bangtong/model/articles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
// import 'package:app/provider/service_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';
import 'package:remedi_kopo/remedi_kopo.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  _AddAppState createState() => _AddAppState();
}

class _AddAppState extends State<AddScreen> {
  // late ServiceProvider _serviceProvider;
  late TextEditingController _titleTextEditingController;
  late TextEditingController _priceTextEditingController;
  late TextEditingController _contentTextEditingController;
  late TextEditingController _startTextEditingController;
  late TextEditingController _endTextEditingController;
  late TextEditingController _startDetailTextEditingController;
  late TextEditingController _endDetailTextEditingController;



  late TextEditingController _gradeTextEditingController;

  String _selectedCategory_start = '동국제강(인천)';
  String _selectedCategory_grade = '스텐';
  String _selectedCategory_pay = '후불';
  final ImagePicker _imagePicker = ImagePicker();
  List<XFile> _pickerImgList = [];

  String postCode = '-';
  String address = '-';
  String latitude = '-';
  String longitude = '-';
  String kakaoLatitude = '-';
  String kakaoLongitude = '-';

  String strText = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _startTextEditingController = TextEditingController();
    _endTextEditingController = TextEditingController();
    _gradeTextEditingController = TextEditingController();
    _titleTextEditingController = TextEditingController();
    _priceTextEditingController = TextEditingController();
    _contentTextEditingController = TextEditingController();

    _startDetailTextEditingController = TextEditingController();
    _endDetailTextEditingController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // _serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _startTextEditingController.dispose();
    _endTextEditingController.dispose();
    _gradeTextEditingController.dispose();
    _titleTextEditingController.dispose();
    _priceTextEditingController.dispose();
    _contentTextEditingController.dispose();

    super.dispose();
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
          onPressed: (() => Navigator.pop(context))),
      backgroundColor: Colors.white,
      elevation: 1,
      title: Text(
        '배차 등록',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      actions: [
        Container(
            height: 15,
            child: TextButton(
                onPressed: () {
                  _addArticle();
                },
                child: Text(
                  '등록',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xfff08f4f)),
                ))),
      ],
    );
  }

  Widget _line() {
    return Container(
      height: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  // 중고물품 데이터 등록
  _addArticle() async {
    if (_pickerImgList.length <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("물품 사진을 1장 이상 등록해주세요."),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(
            milliseconds: 2000,
          ),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              right: 10,
              left: 10),
        ),
      );

      return;
    }
    if (_pickerImgList.length > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("사진은 최대 5장 까지 등록 가능합니다."),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(
            milliseconds: 2000,
          ),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              right: 10,
              left: 10),
        ),
      );

      return;
    }

    // 업로드할 중고물품 사진 리스트
    final List<MultipartFile> uploadImages = [];

    // 선택된 카메라 앨범 사진정보 기준으로 MultipartFile 타입 생성
    for (int i = 0; i < _pickerImgList.length; i++) {
      File imageFile = File(_pickerImgList[i].path);
      var stream = _pickerImgList[i].openRead();
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile("articlesImages", stream, length,
          filename: _pickerImgList[i].name,
          contentType: MediaType('image', 'jpg'));
      uploadImages.add(multipartFile);
    }

    // 등록될 중고물품 데이터 정보
    // Articles article = Articles(
    //     photoList: [],
    //     profile: _serviceProvider.profile!,
    //     profile: _titleTextEditingController,
    //     content: _contentTextEditingController.text,
    //     town: _serviceProvider.currentTown!,
    //     price: _priceTextEditingController.text == ''
    //         ? 0
    //         : num.parse(_priceTextEditingController.text),
    //     likeCnt: 7,
    //     readCnt: 0,
    //     category: _selectedCategory);

    try {
      // // 데이터 등록중 표시
      // _serviceProvider.dataFetching();
      //
      // // 새로운 중고물품 데이터 등록
      // bool result = await _serviceProvider.addArticle(uploadImages, article);
      bool result = false;
      if (result) {
        Fluttertoast.showToast(
            msg: "새로운 배차를 등록하였습니다.",
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            fontSize: 20,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT);

        // 데이터 등록 후 AddArticle 닫기
        Navigator.pop<bool>(context, result);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("배차 등록 도중 오류가 발생하였습니다."),
              duration: Duration(
                milliseconds: 1000,
              )),
        );
      }
    } catch (ex) {
      print("error: $ex");
      Fluttertoast.showToast(
          msg: ex.toString(),
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          fontSize: 20,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
    }
  }

  // 카레라 앨범에서 사진 선택
  Future<void> _pickImg() async {
    final List<XFile>? images = await _imagePicker.pickMultiImage();
    if (images == null) return;

    setState(() {
      _pickerImgList = images;
    });
  }

  // 선택된 사진 미리보기
  Widget _photoPreviewWidget() {
    if (_pickerImgList.length <= 0) return Container();

    return GridView.count(
        shrinkWrap: true,
        padding: EdgeInsets.all(2),
        crossAxisCount: 5, // 최대 5개
        mainAxisSpacing: 1,
        crossAxisSpacing: 5,
        children: List.generate(_pickerImgList.length, (index) {
          //return Container();
          // 대시라인 보더 위젯으로 감싸 선택한 사진을 표시한다.
          return DottedBorder(
              child: Container(
                  child: Container(
                    child: Stack(
                      children: [
                        Image.file(
                          File(_pickerImgList[index].path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                padding: EdgeInsets.only(left: 20, bottom: 30),
                                onPressed: () {
                                  setState(() {
                                    _pickerImgList.removeAt(index);
                                  });
                                },
                                icon: SvgPicture.asset(
                                  "assets/svg/close-circle.svg",
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(3))),
              dashPattern: [5, 3],
              borderType: BorderType.RRect,
              radius: Radius.circular(3));
        }).toList());
  }

  Widget _bodyWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Stack(
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.green,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(-1, 0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(5, 5, 0, 5),
                                child: AddressText(),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(-1, 0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(4,4,4,4),
                                child: TextField(
                                    controller: _startDetailTextEditingController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: '상세 주소를 입력하세요.',
                                    )
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.green,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-1, 0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(5, 5, 0, 5),
                            child: AddressText2(),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-1, 0),
                          child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                              child: TextField(
                                  controller: _endDetailTextEditingController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: '상세 주소를 입력하세요.',
                                  )
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: _priceTextEditingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: '차주운임',
                      hintText: '￦ 가격',
                      contentPadding: EdgeInsets.symmetric(vertical: 10)),
                ),
                SizedBox(
                  height: 5,
                ),
                // 지불 방식 선택 드롭다운
                DropdownButton(
                    hint: Text('지불 방식'),
                    isExpanded: true,
                    items: ['후불', '별도 협의', '선불']
                        .map((item) => DropdownMenuItem(
                              child: Text(item),
                              value: item,
                            ))
                        .toList(),
                    value: _selectedCategory_pay,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory_pay = value.toString();
                      });
                    }),
                SizedBox(
                  height: 5,
                ),
                // 비철 등급 선택 드롭다운
                DropdownButton(
                    hint: Text('비철 등급'),
                    isExpanded: true,
                    items: ['스텐', '알루미늄', '동(구리)', '피선', '작업철', '기타']
                        .map((item) => DropdownMenuItem(
                              child: Text(item),
                              value: item,
                            ))
                        .toList(),
                    value: _selectedCategory_grade,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory_grade = value.toString();
                      });
                    }),
                SizedBox(
                  height: 5,
                ),
                // 내용 입력 필드
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  )),
                  constraints: BoxConstraints(maxHeight: 50),
                  child: Scrollbar(
                    child: TextField(
                      controller: _contentTextEditingController,
                      style: TextStyle(fontSize: 17),
                      keyboardType: TextInputType.multiline,
                      maxLength: null,
                      maxLines: null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.transparent,
                          hintMaxLines: 3,
                          hintText: '기타 전달 사항',
                          hintStyle: TextStyle(
                              fontSize: 17, overflow: TextOverflow.clip)),
                    ),
                  ),
                )
              ]),
          // Consumer<ServiceProvider>(builder: ((context, value, child) {
          //   // 중고물품 데이터 등록중인 경우 로딩 위젯 표시
          //   if (value.isDataFetching) {
          //     return const Center(
          //         child: CircularProgressIndicator(
          //             color: Color.fromARGB(255, 252, 113, 49)));
          //   } else {
          //     return Container(height: 0, width: 0);
          //   }
          // }))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }

  Widget AddressText() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _addressAPI(_startTextEditingController); // 카카오 주소 API
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('상차지', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
          TextFormField(
            enabled: false,
            decoration: InputDecoration(
              isDense: false,
            ),
            controller: _startTextEditingController,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget AddressText2() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _addressAPI(_endTextEditingController); // 카카오 주소 API
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('하차지', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
          TextFormField(
            enabled: false,
            decoration: InputDecoration(
              isDense: false,
            ),
            controller: _endTextEditingController,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  _addressAPI(TextEditingController result) async {
    KopoModel model = await Navigator.push(context,
      CupertinoPageRoute(
        builder: (context) => RemediKopo(),
      ),
    );
    result.text =
    '${model.address!} ${model.buildingName!}';
    // '${model.zonecode!} ${model.address!} ${model.buildingName!}';
  }
}


