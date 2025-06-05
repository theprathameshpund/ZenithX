import 'package:flutter/material.dart';

class Chapter1Page extends StatelessWidget {
  const Chapter1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapter 1: Understanding the Stock Market'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle('What is the Stock Market, and How Does It Work?'),
            _Paragraph(
                'Imagine this: You own a bakery, and to grow your business, you decide to sell shares (tiny pieces of your business) to the public. The stock market is like a giant marketplace where these shares are bought and sold.'),
            _Paragraph(
                'Definition: The stock market is a platform where investors trade shares of publicly-listed companies.\nHow it works: Companies list their shares on stock exchanges (like the NYSE or NASDAQ) through a process called an IPO (Initial Public Offering). Investors can then buy and sell these shares, hoping to make a profit if the company\'s value increases.'),
            _Paragraph(
                'Example:\nIf you buy one share of a company for \$100 and its value rises to \$150, you can sell it for a \$50 profit.'),

            _SectionTitle('Why Should I Invest in the Stock Market?'),
            _Paragraph(
                'Think of investing like planting a tree: The earlier you start, the more time it has to grow.'),
            _Paragraph(
                'Key benefits:\n- Grow your money: Historically, the stock market has delivered higher returns than savings accounts or bonds over the long term.\n- Beat inflation: Investing helps ensure your money doesn’t lose its value over time.\n- Build wealth: Compounding (earning returns on your returns) can significantly grow your investment over decades.'),
            _Paragraph(
                'Relatable Scenario:\nImagine saving \$5 a day. If you invest that in a fund earning 7% annually, in 30 years, you’d have over \$200,000!'),

            _SectionTitle('What Are Stocks, and Why Do Their Prices Change?'),
            _Paragraph(
                'Stocks are ownership pieces of a company. If you own a share of Apple, you own a small part of the company!'),
            _Paragraph(
                'Why prices change:\n- Supply and demand: If more people want to buy a stock, its price goes up. If more people want to sell, it goes down.\n- Company performance: Good earnings reports, new products, or management changes can drive prices up.\n- Market sentiment: News, global events, and economic conditions can influence prices.'),
            _Paragraph(
                'Example:\nA company announces a breakthrough product—its stock price may rise due to investor excitement.'),

            _SectionTitle('How Do I Start Investing in the Stock Market?'),
            _Paragraph('Starting is simpler than you think!'),
            _Paragraph(
                'Steps to Begin:\n1. Set goals: Are you saving for retirement, a house, or your child’s education?\n2. Choose a broker: Pick a brokerage platform (like Robinhood, Fidelity, or E-Trade) to buy and sell stocks.\n3. Start small: You don’t need a fortune—many brokers offer fractional shares, allowing you to invest with as little as \$5.\n4. Diversify: Don’t put all your money in one stock. Spread your investment across sectors to reduce risk.'),
            _Paragraph(
                'Pro Tip: Many platforms offer “paper trading” accounts, where you can practice investing with fake money before using real funds.'),

            _SectionTitle('What’s the Difference Between Investing and Trading?'),
            _Paragraph(
                'Investing:\n- Long-term approach (years to decades).\n- Focuses on gradual wealth growth.\n- Example: Buying shares of a company and holding them for 10+ years.'),
            _Paragraph(
                'Trading:\n- Short-term approach (days to months).\n- Focuses on quick profits.\n- Example: Buying a stock in the morning and selling it by the afternoon.'),
            _Paragraph(
                'For beginners, investing is generally safer and easier to manage.'),

            _SectionTitle('What Are Some Basic Investment Strategies?'),
            _Paragraph(
                'Strategies for Beginners:\n1. Buy and Hold: Purchase stocks or funds and hold them for the long term.\n2. Index Investing: Invest in index funds like the S&P 500, which track a group of top-performing companies.\n3. Dollar-Cost Averaging: Invest a fixed amount regularly (e.g., \$100/month), regardless of market conditions.'),
            _Paragraph(
                'Relatable Analogy:\nThink of dollar-cost averaging like buying coffee every week. Sometimes it’s cheaper; sometimes, it’s pricier. Over time, the average price balances out.'),

            _SectionTitle('How Do I Analyze a Stock Before Buying It?'),
            _Paragraph('Stock analysis may sound intimidating, but it boils down to two main types:'),
            _Paragraph(
                '1. Fundamental Analysis:\n- Focuses on the company’s financial health and potential.\n- Check the P/E ratio (price-to-earnings ratio)—a lower number often indicates a better value.\n- Look at revenue growth and profits.\n- Research the company’s industry and competitors.'),
            _Paragraph(
                '2. Technical Analysis:\n- Uses stock price charts to predict future movements. Beginners may not need this right away—it’s more suited for traders.'),
            _Paragraph(
                'Example:\nYou research a retail company and see it has consistent revenue growth and a popular product line. This could indicate a strong investment opportunity.'),

            _SectionTitle('What Are Some Common Financial Terms I Should Know?'),
            _Paragraph(
                'Here’s a cheat sheet:\n- Dividend: A portion of a company’s profits paid to shareholders.\n- Bull market: A market that’s rising.\n- Bear market: A market that’s falling.\n- Portfolio: Your collection of investments.\n- Blue-chip stock: Shares of well-established, financially stable companies (e.g., Coca-Cola, Microsoft).'),

            _SectionTitle('What Mistakes Should I Avoid as a Beginner?'),
            _Paragraph(
                'Common Pitfalls:\n- Emotional decisions: Don’t panic-sell during market dips—it’s part of the game!\n- Lack of research: Avoid buying stocks just because someone else recommends them.\n- Over-concentration: Don’t put all your money into one stock or sector.\n- Ignoring fees: Be aware of brokerage and fund management fees.'),
            _Paragraph(
                'Golden Rule: Never invest money you can’t afford to lose.'),

            _SectionTitle('What Are Some Tips to Build Confidence as a Beginner?'),
            _Paragraph(
                'Start small: Invest an amount that won’t stress you out.\nEducate yourself: Read books, watch videos, and follow reputable financial news sources.\nTrack your progress: Use apps to monitor your portfolio and learn from your decisions.\nBe patient: Wealth-building takes time—think long-term!'),

            _SectionTitle('In Summary'),
            _Paragraph(
                'Investing in the stock market is a fantastic way to grow your wealth, but it requires patience, education, and strategy. As a beginner:\n- Focus on learning the basics.\n- Start small with diversified investments.\n- Avoid emotional decisions and common mistakes.\nRemember, even seasoned investors were beginners once. The most important step is getting started!'),
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

class _Paragraph extends StatelessWidget {
  final String text;

  const _Paragraph(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
