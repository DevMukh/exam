import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam/pages/wallet_history.dart';
import 'package:exam/utils/themes.dart';
import 'package:exam/widgets/app_bar_widget.dart';
import 'package:exam/widgets/recipet_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({super.key});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  // List<Map<String, dynamic>> _walletViewRecipientData = [];
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _loadData();
  // }
  //
  // Future<void> _loadData() async {
  //   List<Map<String, dynamic>> data = await fetchWalletViewRecipientData();
  //   setState(() {
  //     _walletViewRecipientData = _removeDuplicateIDs(data);
  //   });
  // }
  //
  // Future<List<Map<String, dynamic>>> fetchWalletViewRecipientData() async {
  //   try {
  //     final QuerySnapshot snapshot = await FirebaseFirestore.instance
  //         .collection('walletRecipt')
  //         .get();
  //
  //     return snapshot.docs.map((doc) {
  //       return {
  //         'id': doc['id'], // This will not be displayed as per your requirement
  //         'status': doc['status'] ?? 'Unknown', // Convert to String if necessary
  //         'dateOfRecival': doc['dateOfRecival'] ?? 'Unknown', // Convert to String if necessary
  //         'viewReceipt': doc['viewReceipt']?.toString() ?? 'false', // Convert to String if necessary
  //       };
  //     }).toList();
  //   } catch (e) {
  //     print("Error fetching data: $e");
  //     return [];
  //   }
  // }
  //
  // List<Map<String, dynamic>> _removeDuplicateIDs(List<Map<String, dynamic>> data) {
  //   final Map<String, Map<String, dynamic>> uniqueData = {};
  //
  //   for (var item in data) {
  //     final id = item['id'];
  //     if (id != null && !uniqueData.containsKey(id)) {
  //       uniqueData[id] = item;
  //     }
  //   }
  //
  //   return uniqueData.values.toList();
  // }

  @override
  Widget build(BuildContext context) {
    AppColors appClr = AppColors();
    RecipetStyling recipetStyling = RecipetStyling();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: appClr.backgroundColors,
      appBar: const AppBarWidget(
        title: 'Receipt View',
        backgroundColor: Color(0xFFFFFFFF),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            children: [
              Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xff64a81a), Color(0xff1a7b33)],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: ClipOval(
                            child: SizedBox(
                              width: screenWidth * 0.3,
                              height: screenWidth * 0.3,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Image.asset(
                                  'assets/images/tick.png',
                                  width: screenWidth * 0.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'منظر',
                          style: recipetStyling.textTextColors.copyWith(
                            fontSize: screenWidth * 0.05,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        _buildRecipetDetailsTextFields(context, '4579212842699823', 'كلارا سيوارد'),
                        _buildRecipetDetailsTextFields(context, '09/15/2024  13:56:58', 'التاريخ والوقت'),
                        _buildRecipetDetailsTextFields(context, '282476017658782', 'سكايلان إيدي'),
                        _buildRecipetDetailsTextFields(context, '6011802071733532', 'كوراه كيل'),
                        _buildRecipetDetailsTextFields(context, 'EXAM enterprise', 'سهيل حسني'),
                        _buildRecipetDetailsTextFields(context, '13284345', 'المال من العمل'),
                        _buildRecipetDetailsTextFields(context, 'activation ID', 'معرف التنشيط'),
                        _buildRecipetDetailsTextFields(context, '5800', 'المبلغ النهائي'),
                        const SizedBox(height: 30),
                        MyElevatedButton(
                          onPressed: () {},
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xffc9e0cf),
                              Color(0xff64a552),
                              Color(0xff5ba319),
                              Color(0xff71af12),
                            ],
                          ),
                          child: Text(
                            'النهاية',
                            style: recipetStyling.textTextColors.copyWith(
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const ReciptIconicData(),
                        const SizedBox(height: 20),
                        Text(
                          'البيك بدأت من 2020',
                          style: recipetStyling.textTextColors.copyWith(
                            fontSize: screenWidth * 0.04,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // _buildWalletViewRecipientTable(screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipetDetailsTextFields(BuildContext context, String title, String values) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(bottom: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: RecipetStyling().textTextColors.copyWith(
                fontSize: screenWidth * 0.04,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              values,
              style: RecipetStyling().textTextColors.copyWith(
                fontSize: screenWidth * 0.04,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildWalletViewRecipientTable(double screenWidth) {
  //   return SizedBox(
  //     width: screenWidth * 0.9,
  //     child: SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: SingleChildScrollView(
  //         scrollDirection: Axis.vertical,
  //         child: DataTable(
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(16),
  //               border: Border.all(color: appColors.colorStroke)),
  //           dataTextStyle: const TextStyle(
  //               color: Color(0xff1a1818), fontWeight: FontWeight.bold),
  //           border: TableBorder(
  //             horizontalInside:
  //             BorderSide(color: appColors.colorStroke, width: 1),
  //             verticalInside:
  //             BorderSide(color: appColors.colorStroke, width: 1),
  //           ),
  //           columns: const [
  //             DataColumn(label: Text('id')),
  //             DataColumn(label: Text('Status')),
  //             DataColumn(label: Text('Date of Recival')),
  //             DataColumn(label: Text('View Receipt')),
  //           ],
  //           rows: _walletViewRecipientData.map((data) {
  //             return DataRow(cells: [
  //               DataCell(Text(data['id'])),
  //               DataCell(Text(data['status'].toString())), // Ensure status is a string
  //               DataCell(Text(data['dateOfRecival'])),
  //               DataCell(Text(data['viewReceipt'].toString())), // Ensure viewReceipt is a string
  //             ]);
  //           }).toList(),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class ReciptIconicData extends StatelessWidget {
  const ReciptIconicData({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenWidth * 0.1,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconicDataItem('تهسيل', Icons.downloading, screenWidth),
          _buildVerticalDivider(screenWidth),
          _buildIconicDataItem('طابعة', Icons.print, screenWidth),
          _buildVerticalDivider(screenWidth),
          _buildIconicDataItem('سهم', Icons.share, screenWidth),
        ],
      ),
    );
  }

  Widget _buildIconicDataItem(String text, IconData icon, double screenWidth) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: screenWidth * 0.05),
          SizedBox(width: screenWidth * 0.02),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.03,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider(double screenWidth) {
    return Container(
      height: screenWidth * 0.1,
      width: screenWidth * 0.005,
      color: Colors.white,
    );
  }
}
