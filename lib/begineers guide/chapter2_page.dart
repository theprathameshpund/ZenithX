import 'package:flutter/material.dart';

class Chapter2Page extends StatelessWidget {
  const Chapter2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapter 2: Building a Solid Foundation'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle('What Are the Different Types of Stocks?'),
            _Paragraph(
                'Not all stocks are created equal. Here’s a breakdown of the main types:'),
            _SubsectionTitle('Common Stocks'),
            _Paragraph(
                '- Represent ownership in a company.\n- Shareholders have voting rights.\n- Dividends are not guaranteed but can grow over time.'),
            _SubsectionTitle('Preferred Stocks'),
            _Paragraph(
                '- Priority over common stockholders when dividends are paid.\n- Typically don’t come with voting rights.\n- Often more stable but less potential for high growth.'),
            _SubsectionTitle('Growth Stocks'),
            _Paragraph(
                '- Companies expected to grow faster than the market average (e.g., tech startups).\n- May not pay dividends but have significant capital appreciation potential.'),
            _SubsectionTitle('Dividend Stocks'),
            _Paragraph(
                '- Companies that regularly pay dividends (e.g., utilities, consumer goods).\n- Ideal for steady income.'),
            _Paragraph(
                'Relatable Scenario: Think of common stocks as attending a wedding where you’re part of the main crowd, while preferred stocks are like sitting at the VIP table—you get served first, but you don’t get a say in the music!'),

            _SectionTitle(
                'What Are ETFs and Mutual Funds, and Why Are They Popular?'),
            _Paragraph(
                'For beginners, buying individual stocks might feel overwhelming. This is where ETFs (Exchange-Traded Funds) and Mutual Funds come in handy.'),
            _SubsectionTitle('ETFs'),
            _Paragraph(
                '- A basket of stocks or bonds that you can trade like a single stock.\n- Lower fees than mutual funds.\n- Examples: S&P 500 ETF (tracks the 500 largest U.S. companies).'),
            _SubsectionTitle('Mutual Funds'),
            _Paragraph(
                '- A professionally managed portfolio of stocks or bonds.\n- Bought and sold at the end of the trading day.\n- May have higher fees but can offer expert management.'),
            _Paragraph(
                'Pro Tip: Beginners often start with ETFs because they’re simple, diversified, and cost-effective.'),

            _SectionTitle(
                'What’s the Difference Between a Bull Market and a Bear Market?'),
            _Paragraph(
                'The stock market has moods, just like people. Understanding these cycles can help you make better decisions.'),
            _SubsectionTitle('Bull Market'),
            _Paragraph(
                '- Prices are rising, and investors are optimistic.\n- Example: The U.S. stock market from 2009 to 2020 was a bull market.'),
            _SubsectionTitle('Bear Market'),
            _Paragraph(
                '- Prices are falling, and investors are cautious or fearful.\n- Example: The market during the 2008 financial crisis.'),
            _Paragraph(
                'Analogy: Think of the market as a rollercoaster. A bull market feels like the upward climb, while a bear market is the descent. Staying strapped in (long-term investing) helps you enjoy the ride.'),

            _SectionTitle('How Do Dividends Work?'),
            _Paragraph(
                '- Dividends are a great way to earn passive income while holding onto your stocks.\n- What are dividends? A portion of a company’s profits distributed to shareholders.'),
            _Paragraph(
                'Pro Tip: Dividend reinvestment plans (DRIPs) allow you to automatically reinvest dividends to buy more shares, accelerating growth.'),

            _SectionTitle('What Are Stock Market Indexes?'),
            _Paragraph(
                'Indexes measure the overall performance of the stock market or specific sectors. Examples include the S&P 500, Dow Jones Industrial Average, and NASDAQ.'),

            _SectionTitle('What Is Risk Tolerance, and Why Is It Important?'),
            _Paragraph(
                '- Risk tolerance determines how much market volatility you can handle emotionally and financially. Younger investors often have a higher tolerance.'),

            _SectionTitle('What Is Market Capitalization (Market Cap)?'),
            _Paragraph(
                'Market cap categorizes companies into large-cap (e.g., Apple), mid-cap, and small-cap stocks, helping investors understand their potential risk and growth.'),

            _SectionTitle(
                'What Are Sector Stocks, and Why Diversify Across Them?'),
            _Paragraph(
                'Sectors like technology, healthcare, or energy diversify your portfolio. If one underperforms, gains in another can offset losses.'),

            _SectionTitle('What Are Stop-Loss and Limit Orders?'),
            _Paragraph(
                '- Stop-loss order: Automatically sells a stock when it falls to a certain price.\n- Limit order: Buys or sells a stock at a specific price or better.'),

            _SectionTitle('What Are the Key Metrics for Evaluating Stocks?'),
            _Paragraph(
                '- P/E Ratio: Measures how much investors are paying for each dollar of earnings.\n- EPS: Indicates profitability per share.\n- Debt-to-Equity Ratio: Lower ratios suggest less risk.'),

            _SectionTitle('In Summary'),
            _Paragraph(
                'Diversify your investments, align them with your risk tolerance, and continue building your financial knowledge. Chapter 3 will take your skills to the next level!'),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _SubsectionTitle extends StatelessWidget {
  final String title;

  const _SubsectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  final String text;

  const _Paragraph(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
