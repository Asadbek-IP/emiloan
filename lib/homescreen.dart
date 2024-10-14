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
  String creditType = "Стандарт";
  TextEditingController _controller = TextEditingController();

  final CurrencyTextInputFormatter _formatter =
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
                            Text(
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
                        Icon(Icons.monetization_on_outlined),
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
                        child: Text("Стандарт"),
                        value: 'Стандарт',
                      ),
                      PopupMenuItem(
                        child: Text("Камаювчи"),
                        value: 'Камаювчи',
                      ),
                    ];
                  },
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.view_compact_alt_outlined),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Кредит тури",
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoanDetailsScreen(
                                startDate: _selectedDate,
                                loanAmount:
                                    _formatter.getUnformattedValue().toDouble(),
                                interestRate: getValueByMonth(
                                        widget.creditsList,
                                        int.parse(selectMonth.split(' ')[0]))!
                                    .toDouble(),
                                months: int.parse(selectMonth.split(' ')[0]),
                                isDecreasingPayment:
                                    creditType != "Стандарт")));
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
  final double interestRate; // Interest rate
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
  List<Map<String, dynamic>> _loanPayments = [];

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _loanAmount = widget.loanAmount;
    _interestRate = widget.interestRate;
    _months = widget.months;
    _isDecreasingPayment = widget.isDecreasingPayment;

    _calculateLoanPayments();
  }

  void _calculateLoanPayments() {
    _loanPayments.clear();
    double monthlyRate = _interestRate / 100 / 12;
    double remainingDebt = _loanAmount;
    DateTime paymentDate = _startDate;

    for (int i = 1; i <= _months; i++) {
      paymentDate = paymentDate.add(Duration(days: 30));

      double interestPayment = remainingDebt * monthlyRate;

      double principalPayment;
      double totalPayment;

      if (_isDecreasingPayment) {
        principalPayment = (_loanAmount / _months);
        totalPayment = principalPayment + interestPayment;

        if (totalPayment > remainingDebt) {
          totalPayment = remainingDebt + interestPayment;
          principalPayment = remainingDebt;
        }
      } else {
        double monthlyPayment =
            (_loanAmount * monthlyRate) / (1 - pow(1 + monthlyRate, -_months));
        totalPayment = monthlyPayment;
        principalPayment = totalPayment - interestPayment;
      }

      remainingDebt -= principalPayment;

      _loanPayments.add({
        'paymentDate': paymentDate,
        'totalPayment': totalPayment,
        'principal': principalPayment,
        'interest': interestPayment,
        'remainingDebt': remainingDebt < 0 ? 0 : remainingDebt,
      });
    }
  }

  String _formatCurrency(double value) {
    // Round value to the nearest thousand
    value = (value / 1000).ceil() * 1000;

    // Format the number with spaces as thousands separators
    final formatter =
        NumberFormat('#,##0', 'uz_UZ'); // Use uz_UZ for correct spacing
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.green[800],
        title: Text(
          'Техно Ҳамкор',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: 12,
                columns: [
                  DataColumn(
                      label: Text('Cанаси', style: TextStyle(fontSize: 14))),
                  DataColumn(
                    label: Center(
                        child: Text('Тўланадиган Пул',
                            style: TextStyle(fontSize: 14))),
                  ),
                  DataColumn(
                      label: Text('Қолдиқ', style: TextStyle(fontSize: 14))),
                ],
                rows: _loanPayments
                    .map(
                      (payment) => DataRow(
                        cells: [
                          DataCell(
                            Row(
                              children: [
                                Text(
                                    DateFormat.yMMMMd('uz_UZ')
                                        .format(payment['paymentDate']),
                                    style: TextStyle(fontSize: 12)),
                                SizedBox(
                                  width: 8,
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            Center(
                              child: Row(
                                children: [
                                  Text(
                                      '${_formatCurrency(payment['totalPayment'])} сўм',
                                      style: TextStyle(fontSize: 12)),
                                  SizedBox(
                                    width: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                                '${_formatCurrency(payment['remainingDebt'].toDouble())} сўм',
                                style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
