// lib/chapter4_page.dart
import 'package:flutter/material.dart';

class Chapter4Page extends StatelessWidget {
  const Chapter4Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapter 4: Stock Market Strategies'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Why Is Stock Analysis Important?'),
            _buildParagraph(
                'Stock analysis helps you make informed decisions and minimize guesswork. Think of it as checking a car’s engine before buying it—ensuring it’s worth your investment.'),
            _buildList([
              'Minimizes risk: Helps you avoid poorly performing stocks.',
              'Increases confidence: You’ll know why you’re investing in a company.',
              'Improves returns: Identifying strong companies can lead to better performance.',
            ]),
            _buildExample(
                'Example: Rather than buying a stock because it’s trending on social media, analysis ensures your decision is based on solid data.'),

            _buildSectionTitle('Two Main Types of Stock Analysis'),
            _buildParagraph(
                'Stock analysis is divided into fundamental and technical analysis. Each focuses on different aspects of evaluating a stock.'),
            _buildSubSectionTitle('Fundamental Analysis (Focus on the business)'),
            _buildList([
              'Earnings reports: Is the company profitable?',
              'Debt levels: Can it manage its liabilities?',
              'Market position: Is it a leader in its industry?',
            ]),
            _buildExample(
                'Example: Apple’s strong brand, consistent profits, and innovation make it a favorite among long-term investors.'),
            _buildSubSectionTitle('Technical Analysis (Focus on stock price)'),
            _buildList([
              'Charts: Identify patterns like uptrends or downtrends.',
              'Indicators: Tools like moving averages or RSI (Relative Strength Index).',
            ]),
            _buildExample(
                'Pro Tip: Beginners should start with fundamental analysis for a deeper understanding of companies.'),

            _buildSectionTitle('Key Metrics to Evaluate a Stock'),
            _buildParagraph(
                'Understanding financial metrics helps you assess a stock’s value and potential. Here are some essential ones:'),
            _buildList([
              'Price-to-Earnings (P/E) Ratio: Measures how much investors are paying for 1 of earnings.',
              'Earnings Per Share (EPS): Indicates profitability per share.',
              'Dividend Yield: Measures return from dividends relative to the stock price.',
              'Debt-to-Equity Ratio: Shows the balance of debt versus equity in the company.',
              'Return on Equity (ROE): Indicates efficiency in generating profits from shareholder equity.',
            ]),
            _buildExample(
                'Example: A company with a debt-to-equity ratio of 0.5 has 0.50 in debt for every 1 of equity.'),

            _buildSectionTitle('How to Research a Stock'),
            _buildParagraph(
                'Effective research combines financial data, industry trends, and competitor analysis.'),
            _buildList([
              'Read earnings reports: Check quarterly or annual financial performance.',
              'Explore news and trends: Stay updated on industry developments.',
              'Understand the company’s business: Know its products and competitive edge.',
              'Compare with peers: Evaluate the stock against competitors using key metrics.',
            ]),
            _buildExample(
                'Example: When considering Nike, compare it to Adidas or Under Armour in revenue growth and market share.'),

            _buildSectionTitle('Growth vs. Value Stocks'),
            _buildParagraph(
                'Stocks fall into two broad categories based on their investment profiles:'),
            _buildSubSectionTitle('Growth Stocks'),
            _buildParagraph(
                'Companies with high growth potential, often reinvesting profits instead of paying dividends (e.g., Amazon, Tesla).'),
            _buildSubSectionTitle('Value Stocks'),
            _buildParagraph(
                'Companies trading below their intrinsic value, often offering dividends and stability (e.g., Coca-Cola, IBM).'),
            _buildExample(
                'Which to choose? Growth stocks suit aggressive investors; value stocks are ideal for stability and income.'),

            _buildSectionTitle('Red Flags to Avoid When Picking Stocks'),
            _buildParagraph(
                'Some stocks might seem attractive but carry significant risks. Watch for these warning signs:'),
            _buildList([
              'High debt levels: Excessive debt can cause instability.',
              'Declining revenue: Indicates struggles in growth.',
              'Overhyped stocks: Popular stocks may lack strong fundamentals.',
              'Negative news: Legal issues or leadership changes can affect performance.',
            ]),
            _buildExample(
                'Example: If a company’s CEO resigns suddenly amid controversy, it’s a red flag to investigate further.'),

            _buildSectionTitle('Key Takeaways'),
            _buildParagraph(
                'Stock analysis becomes second nature with practice. Here’s what to remember:'),
            _buildList([
              'Start with fundamental analysis to understand a company’s financial health.',
              'Use metrics like P/E ratio, EPS, and ROE to compare stocks.',
              'Diversify across sectors and focus on companies with strong moats.',
              'Avoid emotional decisions and stick to data-driven analysis.',
            ]),
            _buildPrompt(
                'What stocks or sectors are you most interested in researching further?'),
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

  Widget _buildSubSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

  Widget _buildList(List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("• ", style: TextStyle(fontSize: 16)),
              Expanded(
                child: Text(item, style: const TextStyle(fontSize: 16)),
              ),
            ],
          );
        }).toList(),
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
}
