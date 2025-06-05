import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class CandleStick {
  final double open;
  final double high;
  final double low;
  final double close;
  final int timestamp;

  CandleStick({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.timestamp,
  });
}

class StockDetailsPage extends StatefulWidget {
  final Map<String, dynamic> stock;

  const StockDetailsPage({super.key, required this.stock});

  @override
  _StockDetailsPageState createState() => _StockDetailsPageState();
}

class _StockDetailsPageState extends State<StockDetailsPage> {
  List<FlSpot> _lineChartSpots = [];
  List<CandleStick> _parsedData = [];
  List<BarChartGroupData> _barChartData = [];
  List<String> _years = []; // List to hold years
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStockData();
  }

  Future<void> _fetchStockData() async {
    try {
      final stockSymbol = widget.stock['symbol'];
      final stockUrl =
          'https://query1.finance.yahoo.com/v8/finance/chart/$stockSymbol?interval=1d&range=1mo';
      final response = await http.get(Uri.parse(stockUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _processStockData(data);

        await _fetchAssetRevenueData(stockSymbol);
      } else {
        _handleError('Failed to fetch stock data.');
      }
    } catch (e) {
      _handleError('Error fetching stock data');
    }
  }

  Future<void> _fetchAssetRevenueData(String stockSymbol) async {
    try {
      final apiUrl =
          'https://c99pd4c8n9.execute-api.ap-south-1.amazonaws.com/dev/company-assets?stock=$stockSymbol';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _processAssetRevenueData(data['data']);
      } else {
        _handleError('Failed to fetch asset and revenue data.');
      }
    } catch (e) {
      _handleError('Error fetching asset and revenue data');
    }
  }

  void _processStockData(Map<String, dynamic> data) {
    try {
      final result = data['chart']['result'][0];
      final timestamps = result['timestamp'] as List<dynamic>;
      final quotes = result['indicators']['quote'][0];
      final open = quotes['open'] as List<dynamic>;
      final high = quotes['high'] as List<dynamic>;
      final low = quotes['low'] as List<dynamic>;
      final close = quotes['close'] as List<dynamic>;

      final parsedData = <CandleStick>[];
      final lineChartSpots = <FlSpot>[];

      for (int i = 0; i < timestamps.length; i++) {
        if (open[i] != null && high[i] != null && low[i] != null &&
            close[i] != null) {
          final candle = CandleStick(
            open: open[i],
            high: high[i],
            low: low[i],
            close: close[i],
            timestamp: timestamps[i],
          );
          parsedData.add(candle);
          lineChartSpots.add(
            FlSpot(i.toDouble(), double.parse(candle.close.toStringAsFixed(2))),
          );
        }
      }

      setState(() {
        _parsedData = parsedData;
        _lineChartSpots = lineChartSpots;
      });
    } catch (e) {
      _handleError('Error processing stock data');
    }
  }

  void _processAssetRevenueData(List<dynamic> data) {
    try {
      _years =
          data.map((item) => item['year'].toString()).toList(); // Extract years

      final barChartData = data
          .asMap()
          .entries
          .map((entry) {
        final i = entry.key;
        final item = entry.value;

        // Format asset and revenue to 2 decimal places
        final asset = (item['asset'] / 1e9).toStringAsFixed(2);
        final revenue = (item['revenue'] / 1e9).toStringAsFixed(2);

        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(toY: double.parse(asset), color: Colors.blue),
            BarChartRodData(toY: double.parse(revenue), color: Colors.green),
          ],
        );
      }).toList();

      setState(() {
        _barChartData = barChartData;
        _isLoading = false;
      });
    } catch (e) {
      _handleError('Error processing asset and revenue data');
    }
  }

  void _handleError(String message) {
    debugPrint(message);
    setState(() {
      _isLoading = false;
    });
  }

  String _formatTimestampToDate(int index) {
    if (index >= 0 && index < _parsedData.length) {
      final timestamp = _parsedData[index].timestamp;
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      return '${date.day}/${date.month}';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stock['name'] ?? 'Stock Details'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStockHeader(),
              const SizedBox(height: 20),
              Text(
                'Current Price: \$${widget.stock['price']?.toStringAsFixed(2) ??
                    'N/A'}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Change: ${widget.stock['change']?.toStringAsFixed(2) ??
                    'N/A'}%',
                style: TextStyle(
                  fontSize: 16,
                  color: (widget.stock['change'] != null &&
                      widget.stock['change'] >= 0)
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Line Chart (Close Prices):',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildLineChart(),
              const SizedBox(height: 20),
              const Text(
                'Bar Chart (Assets vs Revenue in Billions):',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildBarChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget.stock['logo'] != null && widget.stock['logo'].isNotEmpty
            ? Image.network(
          widget.stock['logo'],
          height: 60,
          width: 60,
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
                widget.stock['name'] ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                widget.stock['symbol'] ?? '',
                style: const TextStyle(fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLineChart() {
    if (_lineChartSpots.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // Get screen width to adjust interval dynamically
    final screenWidth = MediaQuery.of(context).size.width;
    final interval = (_lineChartSpots.length / (screenWidth / 50)).ceil(); // Dynamic adjustment

    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  return Text(
                    _formatYAxis(value),
                    style: const TextStyle(fontSize: 10),
                  );
                },
                reservedSize: 40,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final index = value.toInt();
                  if (index % interval == 0) {
                    return Transform.rotate(
                      angle: -0.3,  // Rotate for smaller screens
                      child: Text(
                        _formatTimestampToDate(index),
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                reservedSize: 60,  // Increased for better fit
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: _lineChartSpots,
              isCurved: true,
              color: Colors.green,
              barWidth: 2,
            ),
          ],
        ),
      ),
    );
  }

// Helper function to format Y-axis labels
  String _formatYAxis(double value) {
    if (value >= 10000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toStringAsFixed(2);
  }




  Widget _buildBarChart() {
    if (_barChartData.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // Calculate the maximum Y value dynamically from the data
    final maxY = _barChartData
        .map((bar) => bar.barRods.map((rod) => rod.toY).reduce((a, b) => a > b ? a : b))
        .reduce((a, b) => a > b ? a : b);

    // Calculate an appropriate step interval for Y-axis
    final yInterval = (maxY / 5).ceilToDouble();

    // Dynamically calculate the interval for bar chart labels (X-axis)
    final interval = (_barChartData.length / 6).ceil();

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          maxY: maxY + yInterval,  // Add padding to avoid top overlap
          barGroups: _barChartData,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: yInterval,  // Use interval to space Y-axis labels
                getTitlesWidget: (value, _) => Text(
                  value.toStringAsFixed(0),  // Display Y-axis as integer
                  style: const TextStyle(fontSize: 10),
                ),
                reservedSize: 40,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final index = value.toInt();
                  if (index % interval == 0) {
                    return Text(
                      (index >= 0 && index < _years.length)
                          ? _years[index]
                          : '',
                      style: const TextStyle(fontSize: 10),
                    );
                  }
                  return const SizedBox.shrink();
                },
                reservedSize: 40,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }
}