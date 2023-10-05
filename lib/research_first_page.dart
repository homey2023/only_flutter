import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kpostal/kpostal.dart';
import 'package:real_only/research_second_page.dart';

enum ExerciseFilter {
  doorlock('doorlock', '도어락'),
  keypad('keypad', '공동현관 키패드'),
  cctv('cctv', 'CCTV'),
  courierbox('courierbox', '택배함');

  // enum constructor
  const ExerciseFilter(this.englishName, this.koreanName);
  final String englishName;
  final String koreanName;
}

class ResearchFirstPage extends StatefulWidget {
  const ResearchFirstPage({Key? key}) : super(key: key);

  @override
  State<ResearchFirstPage> createState() => _ResearchFirstPageState();
}

class _ResearchFirstPageState extends State<ResearchFirstPage> {
  final formKey = GlobalKey<FormState>();
  String address = '';
  int? _dwellingType, _roomNumber, _toiletNumber, _floorNumber;
  List<String> facility = [];

  List<String> dwellingType = ['원룸/오피스텔', '아파트', '주택', '기타'];
  List<String> roomNumber = ['원룸', '1개', '2개', '3개', '4개', '5개 이상'];
  List<String> toiletNumber = ['1개', '2개', '3개 이상'];
  List<String> floorNumber = ['1층', '2층', '3층 이상'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '우리집 안전등급은?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/1-0.png'),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBoldText('주소'),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _selectAddress,
                      child: Image.asset('assets/research_2.png', width: 400),
                    ),
                    const SizedBox(height: 16),
                    if (address.isNotEmpty)
                      Text(address,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16.0),
                    _buildBoldText('주거 형태'),
                    _buildChips(dwellingType, _dwellingType, _setDwellingType),
                    _buildBoldText('방 수'),
                    _buildChips(roomNumber, _roomNumber, _setRoomNumber),
                    _buildBoldText('욕실'),
                    _buildChips(toiletNumber, _toiletNumber, _setToiletNumber),
                    _buildBoldText('층 수'),
                    _buildChips(floorNumber, _floorNumber, _setFloorNumber),
                    _buildBoldText('방범시설 유무'),
                    _buildFilterChips(),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
              _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBoldText(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildChips(
      List<String> values, int? selectedValue, Function(int?) onSelect) {
    return Wrap(
      spacing: 3.0,
      children: values.map((value) {
        int index = values.indexOf(value);
        return RawChip(
          side: BorderSide.none,
          showCheckmark: false,
          backgroundColor: Color(0xFFF6F6F6),
          selectedColor: Color(0xFFFFDCC1),
          padding: const EdgeInsets.all(4),
          label: Text(value),
          selected: selectedValue == index,
          onSelected: (bool selected) {
            setState(() {
              onSelect(selected ? index : null);
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildFilterChips() {
    return Wrap(
      spacing: 3.0,
      children: ExerciseFilter.values.map((exercise) {
        return FilterChip(
          side: BorderSide.none,
          showCheckmark: false,
          backgroundColor: Color(0xFFF6F6F6),
          selectedColor: Color(0xFFFFDCC1),
          padding: const EdgeInsets.all(4),
          label: Text(exercise.koreanName),
          selected: facility.contains(exercise.koreanName),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                facility.add(exercise.koreanName);
              } else {
                facility.remove(exercise.koreanName);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildNextButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: _isDataComplete()
              ? _navigateToSecondPage
              : _showIncompleteDataSnackBar,
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(vertical: 16)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
          child: const Text(
            '다음 단계로 넘어가기 (1/3)',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  bool _isDataComplete() {
    return address.isNotEmpty &&
        _dwellingType != null &&
        _roomNumber != null &&
        _toiletNumber != null &&
        _floorNumber != null;
  }

  void _selectAddress() async {
    Kpostal result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => KpostalView()),
        ) ??
        Kpostal(
            postCode: '',
            address: '',
            addressEng: '',
            roadAddress: '',
            roadAddressEng: '',
            jibunAddress: '',
            jibunAddressEng: '',
            buildingCode: '',
            buildingName: '',
            apartment: '',
            addressType: '',
            sido: '',
            sidoEng: '',
            sigungu: '',
            sigunguEng: '',
            sigunguCode: '',
            roadnameCode: '',
            roadname: '',
            roadnameEng: '',
            bcode: '',
            bname: '',
            bnameEng: '',
            query: '',
            userSelectedType: '',
            userLanguageType: '',
            bname1: '');
    setState(() {
      address = result.address;
    });
  }

  void _navigateToSecondPage() {
    Get.to(() => ResearchSecondPage(), arguments: [
      address,
      dwellingType[_dwellingType!],
      roomNumber[_roomNumber!],
      toiletNumber[_toiletNumber!],
      floorNumber[_floorNumber!],
      facility,
    ]);
  }

  void _showIncompleteDataSnackBar() {
    const snackBar = SnackBar(
      content: Text('모두 입력해주세요 🙂'),
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _setDwellingType(int? index) {
    setState(() {
      _dwellingType = index;
    });
  }

  void _setRoomNumber(int? index) {
    setState(() {
      _roomNumber = index;
    });
  }

  void _setToiletNumber(int? index) {
    setState(() {
      _toiletNumber = index;
    });
  }

  void _setFloorNumber(int? index) {
    setState(() {
      _floorNumber = index;
    });
  }
}
