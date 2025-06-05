import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:version2/stock_detail_page.dart';

class StockMarketHomePage extends StatefulWidget {
  const StockMarketHomePage({super.key});

  @override
  _StockMarketHomePageState createState() => _StockMarketHomePageState();
}

class _StockMarketHomePageState extends State<StockMarketHomePage> {
  List<Map<String, dynamic>> stocks = [];
  List<Map<String, dynamic>> companies = [];
  List<Map<String, dynamic>> userSearchedStocks = []; // To store user-searched stocks
  List<dynamic> sectorsData = []; // New variable to store sector data
  String selectedSector = 'Default'; // Default sector
  final TextEditingController _searchController = TextEditingController();
  Timer? _timer;

  // Cache for storing stock prices
  Map<String, Map<String, dynamic>> stockPriceCache = {};

  // Add a Map to cache stocks for each sector
  Map<String, List<Map<String, dynamic>>> sectorStocksCache = {};

  @override
  void initState() {
    super.initState();
    stocks = [];
    _startPriceUpdateTimer();
    _loadSavedStocks();
    _loadCompaniesFromJson(); // Load companies and sectors from JSON
    _preloadDefaultCompanies(); // Preload 4 default companies
  }

  final List<Map<String, dynamic>> defaultCompanies = [
    {'symbol': 'AAPL', 'name': 'Apple Inc.'},
    {'symbol': 'MSFT', 'name': 'Microsoft Corporation'},
    {'symbol': 'GOOG', 'name': 'Google'},
    {'symbol': 'AMZN', 'name': 'Amazon.com, Inc.'},
  ];

  Future<void> _loadSavedStocks() async {
    // Example for Firebase Firestore retrieval (not included here, just a placeholder)
  }

  Future<void> _loadCompaniesFromJson() async {
    final String response = await rootBundle.loadString('assets/companies.json');
    final List<dynamic> data = json.decode(response);

    final String sectorResponse = await rootBundle.loadString('assets/sector.json');
    final Map<String, dynamic> sectorData = json.decode(sectorResponse);

    // Preload stocks for each sector
    for (var sector in sectorData['sectors']) {
      List<Map<String, dynamic>> fetchedStocks = [];
      for (var company in sector['stocks']) {
        fetchedStocks.add({
          'name': company['name'],
          'symbol': company['symbol'],
          'price': null,
          'change': null,
          'quantity': 1,
          'logo': _getCompanyLogoUrl(company['name']),
        });
      }
      sectorStocksCache[sector['sector name']] = fetchedStocks;
    }

    setState(() {
      companies = data.cast<Map<String, dynamic>>();
      sectorsData = sectorData['sectors'];
    });

    _preloadDefaultCompanies();
  }

  void _preloadDefaultCompanies() {
    setState(() {
      stocks = defaultCompanies.map((company) {
        return {
          'name': company['name'],
          'symbol': company['symbol'],
          'price': stockPriceCache[company['symbol']]?['price'], // Use cached price
          'change': stockPriceCache[company['symbol']]?['change'], // Use cached change
          'quantity': 1,
          'logo': _getCompanyLogoUrl(company['name']),
        };
      }).toList();

      sectorStocksCache['Default'] = stocks;

      for (var stock in stocks) {
        if (!stockPriceCache.containsKey(stock['symbol'])) {
          fetchStockData(stock['symbol'], isDefault: true);
        }
      }
    });
  }

  void _handleSectorButtonPress(String sector) {
    setState(() {
      selectedSector = sector;

      if (sector == 'Default') {
        stocks = defaultCompanies.map((company) {
          return {
            'name': company['name'],
            'symbol': company['symbol'],
            'price': stockPriceCache[company['symbol']]?['price'],
            'change': stockPriceCache[company['symbol']]?['change'],
            'quantity': 1,
            'logo': _getCompanyLogoUrl(company['name']),
          };
        }).toList();

        for (var stock in stocks) {
          if (!stockPriceCache.containsKey(stock['symbol'])) {
            fetchStockData(stock['symbol'], isDefault: true);
          }
        }
      } else {
        if (sectorStocksCache.containsKey(sector)) {
          stocks = sectorStocksCache[sector]!.map((company) {
            return {
              ...company,
              'price': stockPriceCache[company['symbol']]?['price'],
              'change': stockPriceCache[company['symbol']]?['change'],
            };
          }).toList();
        } else {
          stocks.clear();
          final sectorInfo = sectorsData.firstWhere(
                (s) => s['sector name'] == sector,
            orElse: () => null,
          );

          if (sectorInfo != null) {
            for (var company in sectorInfo['stocks']) {
              if (!stockPriceCache.containsKey(company['symbol'])) {
                fetchStockData(company['symbol']);
              } else {
                setState(() {
                  stocks.add({
                    'name': company['name'],
                    'symbol': company['symbol'],
                    'price': stockPriceCache[company['symbol']]?['price'],
                    'change': stockPriceCache[company['symbol']]?['change'],
                    'quantity': 1,
                    'logo': _getCompanyLogoUrl(company['name']),
                  });
                });
              }
            }
          }
        }
      }
    });
  }

  void _startPriceUpdateTimer() {
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _updateStockPrices();
    });
  }

  Future<void> fetchStockData(String symbol, {bool isDefault = false}) async {
    if (stockPriceCache.containsKey(symbol)) {
      final cachedStock = stockPriceCache[symbol]!;
      setState(() {
        if (!stocks.any((stock) => stock['symbol'] == symbol)) {
          final companyName = isDefault
              ? _getDefaultCompanyName(symbol)
              : _getCompanyName(symbol);
          stocks.add({
            'name': companyName,
            'symbol': cachedStock['symbol'],
            'price': cachedStock['price'],
            'change': cachedStock['change'],
            'quantity': 1,
            'logo': _getCompanyLogoUrl(companyName),
          });

          if (!isDefault) {
            userSearchedStocks.add(stocks.last);
          }
        }
      });
      return;
    }

    final response = await http.get(
      Uri.parse('https://query1.finance.yahoo.com/v8/finance/chart/$symbol'),
    );

    if (response.statusCode == 200) {
      final fetchedData = json.decode(response.body);
      final chartData = fetchedData['chart']['result']?.first;

      if (chartData != null) {
        final quote = chartData['meta'];

        if (quote != null && quote.isNotEmpty) {
          setState(() {
            final stockData = {
              'symbol': quote['symbol'],
              'price': quote['regularMarketPrice'],
              'change': quote['regularMarketChangePercent'],
            };

            stockPriceCache[symbol] = stockData;

            if (!stocks.any((stock) => stock['symbol'] == symbol)) {
              final companyName = isDefault
                  ? _getDefaultCompanyName(symbol)
                  : _getCompanyName(symbol);
              stocks.add({
                'name': companyName,
                'symbol': stockData['symbol'],
                'price': stockData['price'],
                'change': stockData['change'],
                'quantity': 1,
                'logo': _getCompanyLogoUrl(companyName),
              });

              if (!isDefault) {
                userSearchedStocks.add(stocks.last);
              }
            }
          });
          await _saveStockToFirestore(stockPriceCache[symbol]!);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to load stock data. Please try again.')),
      );
    }
  }

  Future<void> _updateStockPrices() async {
    for (var stock in stocks) {
      final response = await http.get(
        Uri.parse(
            'https://query1.finance.yahoo.com/v8/finance/chart/${stock['symbol']}'),
      );

      if (response.statusCode == 200) {
        final fetchedData = json.decode(response.body);
        final chartData = fetchedData['chart']['result']?.first;

        if (chartData != null) {
          final quote = chartData['meta'];

          if (quote != null && quote.isNotEmpty) {
            setState(() {
              stock['price'] = quote['regularMarketPrice'];
              stock['change'] = quote['regularMarketChangePercent'];

              stockPriceCache[stock['symbol']] = {
                'symbol': stock['symbol'],
                'price': stock['price'],
                'change': stock['change'],
              };
            });
          }
        }
      }
    }
  }

  void _removeStock(String symbol) {
    setState(() {
      stocks.removeWhere((stock) => stock['symbol'] == symbol);
      userSearchedStocks.removeWhere((stock) => stock['symbol'] == symbol);
    });
    _removeStockFromFirestore(symbol);
  }

  Future<void> _saveStockToFirestore(Map<String, dynamic> stock) async {
    // Implementation to save the stock to Firestore goes here.
  }

  Future<void> _removeStockFromFirestore(String symbol) async {
    // Implementation to remove the stock from Firestore goes here.
  }

  String _getCompanyLogoUrl(String companyName) {
    String domain = companyName.split(' ').first.toLowerCase();
    return 'https://logo.clearbit.com/$domain.com';
  }

  String _getCompanyName(String symbol) {
    final company = companies.firstWhere((comp) => comp['symbol'] == symbol,
        orElse: () => {'name': 'Unknown'});
    return company['name'] ?? 'Unknown';
  }

  String _getDefaultCompanyName(String symbol) {
    final company = defaultCompanies.firstWhere((comp) =>
    comp['symbol'] == symbol, orElse: () => {'name': 'Unknown'});
    return company['name'] ?? 'Unknown';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home '),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Autocomplete<Map<String, dynamic>>(
              optionsBuilder: (TextEditingValue value) {
                if (value.text.isEmpty) {
                  return const Iterable<Map<String, dynamic>>.empty();
                }
                return companies.where((company) =>
                    company['symbol'].toString().toLowerCase().startsWith(
                        value.text.toLowerCase()));
              },
              displayStringForOption: (company) => company['name'],
              onSelected: (company) {
                fetchStockData(company['symbol']);
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textController, FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return TextField(
                  controller: textController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Enter stock name or symbol (e.g. AAPL or Apple)',
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (textController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              textController.clear();
                              setState(() {});
                            },
                          ),
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            if (textController.text.isNotEmpty) {
                              fetchStockData(textController.text.toUpperCase());
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _handleSectorButtonPress('Default');
                    },
                    child: const Text('Default'),
                  ),
                  ...sectorsData.map((sector) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _handleSectorButtonPress(sector['sector name']);
                        },
                        child: Text(sector['sector name']),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: stocks.isEmpty
                ? const Center(
                child: Text('No stocks added yet. Please search for stocks.'))
                : ListView.builder(
              itemCount: stocks.length,
              itemBuilder: (context, index) {
                return StockCard(
                  stock: stocks[index],
                  onRemove: () => _removeStock(stocks[index]['symbol']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StockCard extends StatelessWidget {
  final Map<String, dynamic> stock;
  final VoidCallback onRemove;

  const StockCard({Key? key, required this.stock, required this.onRemove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double? price = stock['price'];
    final double? change = stock['change'];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StockDetailsPage(stock: stock),
          ),
        );
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              stock['logo'] != null && stock['logo'].isNotEmpty
                  ? Image.network(
                stock['logo'],
                height: 40,
                width: 40,
                errorBuilder: (context, error, stackTrace) {
                  return const CircleAvatar(
                    child: Icon(Icons.business),
                  );
                },
              )
                  : const CircleAvatar(
                child: Icon(Icons.business),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stock['name'] ?? 'Unknown',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(stock['symbol'] ?? ''),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${price?.toStringAsFixed(2) ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${change?.toStringAsFixed(2) ?? 'N/A'}%',
                    style: TextStyle(
                      color: change != null && change >= 0
                          ? Colors.green
                          : Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onRemove,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
