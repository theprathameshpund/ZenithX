import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Company {
  final String name;
  final String symbol;

  Company(this.name, this.symbol);

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(json['name'], json['symbol']);
  }
}

class FinancialMetricsPage extends StatefulWidget {
  const FinancialMetricsPage({super.key});

  @override
  _FinancialMetricsPageState createState() => _FinancialMetricsPageState();
}

class _FinancialMetricsPageState extends State<FinancialMetricsPage> {
  final TextEditingController _stockController = TextEditingController();
  Map<String, dynamic> _metricsData = {}; // Initialize as an empty map
  bool _loading = false;
  bool _hasError = false;
  String _errorMessage = ''; // Variable to hold error message
  List<Company> _companies = []; // List to store companies

  @override
  void initState() {
    super.initState();
    _loadCompanyData(); // Load company data from JSON file
  }

  Future<void> _loadCompanyData() async {
    final String response = await rootBundle.loadString('assets/companies.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      _companies = data.map((json) => Company.fromJson(json)).toList();
    });
  }

  Future<void> fetchMetrics(String stock) async {
    setState(() {
      _loading = true;
      _hasError = false;
      _errorMessage = ''; // Clear previous error messages
    });

    try {
      final response = await http.get(Uri.parse('https://c99pd4c8n9.execute-api.ap-south-1.amazonaws.com/dev/financial-metrics?stock=$stock'));

      if (response.statusCode == 200) {
        setState(() {
          _metricsData = json.decode(response.body);
          _loading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _errorMessage = 'Error fetching data. Please try again.';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'An error occurred while fetching data';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Metrics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Autocomplete<Company>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<Company>.empty();
                }
                return _companies.where((Company company) {
                  return company.name.toLowerCase().contains(textEditingValue.text.toLowerCase()) ||
                      company.symbol.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },
              displayStringForOption: (Company option) => option.name,
              onSelected: (Company selection) {
                _stockController.text = selection.symbol;
              },
              fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Enter Stock Name',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        textEditingController.clear();
                        _stockController.clear(); // Clear the stock input field
                      },
                    ),
                  ),
                );
              },
              optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<Company> onSelected, Iterable<Company> options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 32,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Company option = options.elementAt(index);
                          return ListTile(
                            title: Text(option.name),
                            subtitle: Text(option.symbol),
                            onTap: () {
                              onSelected(option);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                fetchMetrics(_stockController.text);
              },
              child: const Text('Fetch Metrics'),
            ),
            const SizedBox(height: 24),
            _loading
                ? const CircularProgressIndicator()
                : _hasError
                ? Text(_errorMessage) // Display error message
                : _metricsData.isEmpty
                ? const Text('Enter a stock name to get financial metrics.')
                : Expanded(
              child: ListView(
                children: [
                  Wrap(
                    spacing: 16.0, // Space between cards
                    runSpacing: 16.0, // Space between rows
                    children: List.generate(_metricsData['metrics'].length, (index) {
                      final metric = _metricsData['metrics'][index];
                      return SizedBox(
                        width: (MediaQuery.of(context).size.width / 2) - 24, // Adjust card width
                        child: Card(
                          child: ListTile(
                            title: Text(metric[0]),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Value: ${metric[1]}'),
                                Text('Benchmark: ${metric[2]}'),
                                Text('Status: ${metric[3]}'),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const Divider(), // Divider between metrics and questions
                  const ExpansionTile(
                    title: Text("What is Market Cap?"),
                    children: <Widget>[
                      ListTile(
                        title: Text("Market capitalization refers to the total market value of a company's outstanding shares of stock."),
                      ),
                    ],
                  ),
                  const ExpansionTile(
                    title: Text("What is ROE?"),
                    children: <Widget>[
                      ListTile(
                        title: Text("Return on Equity (ROE) is a measure of a corporation's profitability in relation to stockholders’ equity."),
                      ),
                    ],
                  ),
                  const ExpansionTile(
                    title: Text("What is PE Ratio?"),
                    children: <Widget>[
                      ListTile(
                        title: Text("The Price-Earnings Ratio (P/E Ratio) is the ratio for valuing a company that measures its current share price relative to its per-share earnings."),
                      ),
                    ],
                  ),
                  const ExpansionTile(
                    title: Text("What is PB Ratio?"),
                    children: <Widget>[
                      ListTile(
                        title: Text("The Price-to-Book (P/B) ratio is used to compare a company's market value to its book value."),
                      ),
                    ],
                  ),
                  const ExpansionTile(
                    title: Text("What is Debt to Equity?"),
                    children: <Widget>[
                      ListTile(
                        title: Text("The Debt-to-Equity (D/E) ratio is calculated by dividing a company’s total liabilities by its shareholder equity."),
                      ),
                    ],
                  ),
                  const ExpansionTile(
                    title: Text("What is Dividend Yield?"),
                    children: <Widget>[
                      ListTile(
                        title: Text("Dividend yield is a financial ratio that shows how much a company pays out in dividends each year relative to its stock price."),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
