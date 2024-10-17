import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class Homescreen extends StatefulWidget {
  List<Map<String, dynamic>> creditsList;
  Homescreen({super.key, required this.creditsList});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  DateTime _selectedDate = DateTime.now();
  String selectMonth = "";
  String creditType = "Ишлайман";
  TextEditingController _controller = TextEditingController();

  final CurrencyTextInputFormatter _formatter =
      CurrencyTextInputFormatter.currency(
    locale: 'uz',
    decimalDigits: 0,
    symbol: 'сўм',
  );

  TextEditingController _controller2 = TextEditingController();

  final CurrencyTextInputFormatter _formatter2 =
      CurrencyTextInputFormatter.currency(
    locale: 'uz',
    decimalDigits: 0,
    symbol: 'сўм',
  );
  final NumberFormat _numberFormat =
      NumberFormat.currency(locale: 'uz_UZ', symbol: '', decimalDigits: 0);

  Future _selectDate(BuildContext context) async => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2050),
      ).then((DateTime? selected) {
        if (selected != null && selected != _selectedDate) {
          setState(() => _selectedDate = selected);
        }
      });

  @override
  void initState() {
    super.initState();
    selectMonth = "${widget.creditsList.first["month"]} ой";
  }

  int? getValueByMonth(List<Map<String, dynamic>> creditsList, int month) {
    for (var credit in creditsList) {
      if (credit['month'] == month) {
        return credit['value'];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.date_range),
                        SizedBox(width: 12),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Кредит олинган сана',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Text(
                              '${DateFormat.yMMMMd('uz_UZ').format(_selectedDate)}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.monetization_on_outlined),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            inputFormatters: <TextInputFormatter>[_formatter],
                            controller: _controller,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              labelText: 'Пул миқдорини киритинг',
                              labelStyle: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Icon(Icons.money),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            inputFormatters: <TextInputFormatter>[_formatter2],
                            controller: _controller2,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              labelText: 'Бошланғич сумма',
                              labelStyle: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() {
                      selectMonth = value;
                    });
                  },
                  offset: Offset(0, 48),
                  itemBuilder: (BuildContext context) {
                    return widget.creditsList.map((credit) {
                      return PopupMenuItem<String>(
                        value: '${credit["month"]} Ой',
                        child: Text('${credit["month"]} Ой'),
                      );
                    }).toList();
                  },
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.data_saver_off_sharp),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Муддат",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                "${selectMonth}",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() {
                      creditType = value;
                    });
                  },
                  offset: Offset(0, 48),
                  itemBuilder: (BuildContext context) {
                    return const [
                      PopupMenuItem(
                        child: Text("Ишлайман"),
                        value: 'Ишлайман',
                      ),
                      PopupMenuItem(
                        child: Text("Ишсизман"),
                        value: 'Ишсизман',
                      ),
                    ];
                  },
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.business_center_outlined),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ижтимоий ҳолат",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                "${creditType}",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (creditType == "Ишсизман" &&
                        _formatter2.getUnformattedValue() <
                            _formatter.getUnformattedValue() * 0.3) {
                      final snackBar = SnackBar(
                        content: Text(
                            'Ишсиз бўлсангиз бошланғич маблағ ${_formatter.getUnformattedValue() * 0.3} сўм мажбурий киритишигиз керак'),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      setState(() {
                        _controller2.text = _formatter2.formatString(
                            "${(_formatter.getUnformattedValue() * 0.3).toInt()}");
                      });
                      return;
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoanDetailsScreen(
                                  startDate: _selectedDate,
                                  loanAmount:
                                      (_formatter.getUnformattedValue() -
                                              _formatter2.getUnformattedValue())
                                          .toDouble(),
                                  interestRate: getValueByMonth(
                                          widget.creditsList,
                                          int.parse(selectMonth.split(' ')[0]))!
                                      .toDouble(),
                                  months: int.parse(selectMonth.split(' ')[0]),
                                  isDecreasingPayment: false)));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Кредитни ҳисоблаш",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.green[800])),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoanDetailsScreen extends StatefulWidget {
  final DateTime startDate;
  final double loanAmount; // Total loan amount
  final double interestRate; // Interest rate (in percentage)
  final int months; // Duration in months
  final bool isDecreasingPayment; // Payment structure type

  const LoanDetailsScreen({
    Key? key,
    required this.startDate,
    required this.loanAmount,
    required this.interestRate,
    required this.months,
    required this.isDecreasingPayment,
  }) : super(key: key);

  @override
  State<LoanDetailsScreen> createState() => _LoanDetailsScreenState();
}

class _LoanDetailsScreenState extends State<LoanDetailsScreen> {
  late DateTime _startDate;
  late double _loanAmount;
  late double _interestRate;
  late int _months;
  late bool _isDecreasingPayment;
  List<Map<String, dynamic>> _installmentPayments = [];
  double _totalPayableAmount = 0.0; // Total amount to be paid

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _loanAmount = widget.loanAmount;
    _interestRate = widget.interestRate;
    _months = widget.months;
    _isDecreasingPayment = widget.isDecreasingPayment;

    _calculateInstallmentPayments();
  }

  void _calculateInstallmentPayments() {
    _installmentPayments.clear();

    // Umumiy qarz (asosiy qarz + foiz)
    _totalPayableAmount = _loanAmount + (_loanAmount * (_interestRate / 100));
    double remainingDebt = _totalPayableAmount;
    DateTime paymentDate = _startDate;

    // To'lov sanasini aniqlash
    if (_startDate.day <= 15) {
      // Agar 15-sanasigacha kredit olingan bo'lsa, keyingi oyning 1-sanasidan boshlanadi
      paymentDate = DateTime(_startDate.year, _startDate.month + 1, 1);
    } else {
      // Agar 15-sanasidan keyin kredit olingan bo'lsa, keyingi oyning 15-sanasidan boshlanadi
      paymentDate = DateTime(_startDate.year, _startDate.month + 1, 15);
    }

    if (_isDecreasingPayment) {
      // Kamayuvchi to'lov struktura: asosiy qarz qismi bir xil, foiz kamayib boradi
      double principalPayment = _loanAmount / _months;
      double monthlyRate = _interestRate / 100 / 12;

      for (int i = 1; i <= _months; i++) {
        // Har oyga 30 kun qo'shamiz
        paymentDate = paymentDate.add(Duration(days: 30));

        // Qolgan qarz asosida foizni hisoblaymiz
        double interestPayment = remainingDebt * monthlyRate;

        // Umumiy to'lov (asosiy qarz + foiz)
        double totalPayment = principalPayment + interestPayment;

        // Asosiy qarzni qolgan qarzdan olib tashlaymiz
        remainingDebt -= principalPayment;

        // To'lovni 1000 so'mga yaxlitlaymiz
        totalPayment = (totalPayment / 1000).ceil() * 1000;

        _installmentPayments.add({
          'paymentDate': paymentDate,
          'totalPayment': totalPayment,
          'remainingDebt': remainingDebt < 0 ? 0 : remainingDebt,
        });
      }
    } else {
      // Teng to'lov struktura: har oylik to'lovlar bir xil
      double monthlyPayment = _totalPayableAmount / _months;
      monthlyPayment = (monthlyPayment / 1000).ceil() * 1000;

      for (int i = 1; i <= _months; i++) {
        // Har oyga 30 kun qo'shamiz
        paymentDate = paymentDate.add(Duration(days: 30));

        // Oxirgi oyda qolgan qarzni o'zgartiramiz
        double actualPayment = monthlyPayment;
        if (i == _months) {
          actualPayment = remainingDebt;
        }

        remainingDebt -= actualPayment;

        _installmentPayments.add({
          'paymentDate': paymentDate,
          'totalPayment': actualPayment,
          'remainingDebt': remainingDebt < 0 ? 0 : remainingDebt,
        });
      }
    }
  }

  String _formatCurrency(double value) {
    value = (value / 1000).ceil() * 1000; // Round to nearest 1000 so'm
    final formatter = NumberFormat('#,##0', 'uz_UZ');
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Техно Ҳамкор'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  DataTable(
                    columnSpacing: 12,
                    columns: [
                      DataColumn(
                          label: Text('Сана', style: TextStyle(fontSize: 14))),
                      DataColumn(
                          label: Text('Тўланадиган пул',
                              style: TextStyle(fontSize: 14))),
                      DataColumn(
                          label: Text('Умумий қарз',
                              style: TextStyle(fontSize: 14))),
                    ],
                    rows: _installmentPayments
                        .map(
                          (payment) => DataRow(
                            cells: [
                              DataCell(Text(
                                  DateFormat.yMMMMd('uz_UZ')
                                      .format(payment['paymentDate']),
                                  style: TextStyle(fontSize: 12))),
                              DataCell(Text(
                                  '${_formatCurrency(payment['totalPayment'])} сўм',
                                  style: TextStyle(fontSize: 12))),
                              DataCell(Text(
                                  '${_formatCurrency(payment['remainingDebt'].toDouble())} сўм',
                                  style: TextStyle(fontSize: 12))),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Умумий Тўланадиган Пул: ${_formatCurrency(_totalPayableAmount)} сўм',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
