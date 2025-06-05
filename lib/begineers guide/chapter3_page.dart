import 'package:flutter/material.dart';

class Chapter3Page extends StatelessWidget {
  const Chapter3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapter 3: Crafting Your Investment Plan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Why Do You Need an Investment Plan?'),
            _buildParagraph(
                'An investment plan serves as a roadmap, helping you stay disciplined and focused during market fluctuations. Without it, investing is like going on a road trip without a GPS.'),
            _buildExample('Example: A plan prevents emotional decisions during market volatility.'),

            _buildSectionTitle('Setting Clear Investment Goals'),
            _buildParagraph(
                'Your goals influence the type of investments you choose. Align them with timeframes:\n\n'
                    '- Short-Term (1–5 years): Emergency fund or vacation.\n'
                    '- Medium-Term (5–10 years): Down payment on a house.\n'
                    '- Long-Term (10+ years): Retirement savings.'),
            _buildExample('Example Goal: Save 100,000 for retirement in 20 years by investing 300 monthly.'),
            _buildPrompt('What are your short-, medium-, and long-term financial goals?'),

            _buildSectionTitle('Choosing the Right Asset Allocation'),
            _buildParagraph(
                'Asset allocation divides your portfolio across asset classes like stocks, bonds, and cash to balance risk and return. Use the "100 Minus Age Rule" for age-based allocation.'),
            _buildExample('Example: If you are 30, allocate 70% to stocks and 30% to bonds.'),
            _buildLocalImage('assets/images/asset_allocation_chart.png'),

            _buildSectionTitle('Proven Investment Strategies'),
            _buildParagraph(
                'Select a strategy that aligns with your goals:\n'
                    '- Buy and Hold: Long-term growth.\n'
                    '- Value Investing: Undervalued stocks.\n'
                    '- Growth Investing: High-potential companies.\n'
                    '- Dividend Investing: Passive income.\n'
                    '- Dollar-Cost Averaging: Invest a fixed amount regularly.'),
            _buildExample('Example: Investing 100 monthly in an S&P 500 ETF ensures consistent buying over time.'),

            _buildSectionTitle('Tracking Your Investments'),
            _buildParagraph(
                'Monitor your portfolio monthly or quarterly to ensure it aligns with your goals. Use apps like Robinhood or Personal Capital to simplify tracking.'),
            _buildExample('Tip: Rebalance your portfolio annually to maintain your desired allocation.'),

            _buildSectionTitle('Managing Emotions During Volatility'),
            _buildParagraph(
                'Fear and greed can lead to poor decisions. Stay calm by focusing on long-term goals and understanding that market corrections are normal.'),
            _buildExample(
                'Example: During the March 2020 market drop, many who stayed invested saw their portfolios recover and grow within a year.'),

            _buildSectionTitle('When to Sell an Investment'),
            _buildParagraph(
                'Good reasons to sell include achieving your target price, deteriorating fundamentals, or needing funds for a goal. Avoid selling out of fear or chasing "hot" investments.'),
            _buildExample(
                'Example: Sell a stock after achieving your target growth of 50%, then reinvest or lock in profits.'),

            _buildSectionTitle('Continuous Learning'),
            _buildParagraph(
                'The stock market evolves constantly. Keep learning through books like "The Intelligent Investor" or platforms like Investopedia. Stay updated on trends via Bloomberg or CNBC.'),
            _buildPrompt('What new investment concept or strategy would you like to learn next?'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildExample(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.lightbulb, color: Colors.amber),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrompt(String question) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            const Icon(Icons.question_mark, color: Colors.blue),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                question,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalImage(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Text(
            'Image not available',
            style: TextStyle(color: Colors.red),
          );
        },
      ),
    );
  }
}
