// lib/chapter5_page.dart
import 'package:flutter/material.dart';

class Chapter5Page extends StatelessWidget {
  const Chapter5Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapter 5: Managing Your Portfolio'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('What Is Portfolio Management, and Why Is It Important?'),
            _buildParagraph(
                'Portfolio management is the process of overseeing your investments to ensure they meet your financial goals and risk tolerance.'),
            _buildParagraph(
                'Why It’s Important:\n- Stay aligned with goals: Regular reviews ensure your portfolio matches your changing life circumstances.\n- Manage risk: Balancing investments helps protect against market downturns.\n- Optimize returns: Identifying underperforming assets allows you to reinvest in better opportunities.'),
            // _buildLocalImage('assets/images/portfolio_management.jpeg'),

            _buildSectionTitle('How Often Should You Check Your Portfolio?'),
            _buildParagraph(
                'Frequent portfolio checks can lead to unnecessary stress and emotional decisions.'),
            _buildParagraph(
                'Ideal Frequency:\n1. Monthly or Quarterly Reviews:\n   - Evaluate your portfolio’s performance.\n   - Make minor adjustments if needed.\n\n2. Annual Rebalancing:\n   - Revisit your goals and risk tolerance.\n   - Realign your asset allocation if it’s significantly off balance.'),
            // _buildLocalImage('assets/images/check_portfolio.jpeg'),

            _buildSectionTitle('What Is Rebalancing, and How Does It Work?'),
            _buildParagraph(
                'Rebalancing involves adjusting your portfolio to restore your original asset allocation. Over time, certain investments may grow faster than others, altering your desired risk level.'),
            _buildParagraph(
                'How to Rebalance:\n1. Identify your target allocation (e.g., 70% stocks, 30% bonds).\n2. Compare it to your current allocation.\n3. Sell overperforming assets or buy underperforming ones to return to your target.'),
            // _buildLocalImage('assets/images/rebalancing.jpeg'),

            _buildSectionTitle('How Do You Measure Your Portfolio’s Performance?'),
            _buildParagraph(
                'It’s essential to evaluate how well your portfolio is performing compared to your goals and benchmarks.'),
            _buildParagraph(
                'Metrics to Track:\n1. Portfolio Growth: Is your total value increasing over time?\n2. Annualized Return: Compare your portfolio’s return to benchmarks like the S&P 500.\n3. Risk-Adjusted Return: Consider the amount of risk you took to achieve those returns.'),
            // _buildLocalImage('assets/images/portfolio_performance.jpeg'),

            _buildSectionTitle('How Do You Diversify Effectively?'),
            _buildParagraph(
                'Diversification is the key to reducing risk while maintaining the potential for returns. Spread your investments across asset classes, industries, and geographies.'),
            _buildParagraph(
                'Strategies for Diversification:\n1. Across Asset Classes: Invest in stocks, bonds, real estate, and cash.\n2. Within Sectors: Spread your investments across industries (e.g., technology, healthcare, energy).\n3. Geographical Diversification: Include international stocks or funds to reduce reliance on one economy.'),
            // _buildLocalImage('assets/images/diversification.jpeg'),

            _buildSectionTitle('What Role Do Taxes Play in Portfolio Management?'),
            _buildParagraph(
                'Taxes can significantly impact your investment returns. Use tax-efficient strategies to maximize your after-tax gains.'),
            _buildParagraph(
                'Tax-Efficient Strategies:\n1. Use Tax-Advantaged Accounts: Invest through 401(k)s, IRAs, or Roth IRAs to defer or eliminate taxes.\n2. Harvest Tax Losses: Sell losing investments to offset gains and reduce your tax bill.\n3. Hold Investments Long-Term: Long-term capital gains are taxed at lower rates than short-term gains.'),
            // _buildLocalImage('assets/images/tax_strategy.jpeg'),

            _buildSectionTitle('How Do You Handle Underperforming Investments?'),
            _buildParagraph(
                'Not all investments will perform as expected. Knowing when and how to act is crucial.'),
            _buildParagraph(
                'Steps to Manage Underperformers:\n1. Analyze the Cause: Is the underperformance due to temporary market conditions or fundamental issues?\n2. Set a Sell Rule: If a stock drops by 20% without a clear recovery plan, consider selling.\n3. Avoid Emotional Attachment: Stick to your strategy and let go of poorly performing assets.'),
            // _buildLocalImage('assets/images/underperformers.jpeg'),

            _buildSectionTitle('What Is Dollar-Cost Averaging, and Why Should You Use It?'),
            _buildParagraph(
                'Dollar-cost averaging (DCA) involves investing a fixed amount at regular intervals, regardless of market conditions. It reduces timing risk and smoothens volatility.'),
            // _buildLocalImage('assets/images/dca.jpeg'),

            _buildSectionTitle('How Do You Stay on Track with Your Financial Goals?'),
            _buildParagraph(
                'Life circumstances change, so it’s essential to periodically evaluate your goals and adjust accordingly. Automate investments, track progress, and adjust for major life events.'),
            // _buildLocalImage('assets/images/financial_goals.jpeg'),

            _buildSectionTitle('What Are Common Mistakes to Avoid in Portfolio Management?'),
            _buildParagraph(
                'Avoid these pitfalls to maximize your portfolio’s potential:\n1. Overtrading: Frequent buying and selling can erode returns.\n2. Ignoring Fees: Even small fees compound into significant losses.\n3. Focusing Only on Winners: Ignoring diversification increases risk.\n4. Emotional Decisions: Reacting to short-term news often leads to poor outcomes.'),
            // _buildLocalImage('assets/images/mistakes.jpeg'),

            _buildSectionTitle('Summary'),
            _buildParagraph(
                'Managing your portfolio is an ongoing process that requires discipline, patience, and regular reviews. Rebalance periodically, diversify, and avoid emotional decisions to stay on track with your goals.'),
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

  Widget _buildLocalImage(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
      ),
    );
  }
}
