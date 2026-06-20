import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/gradient_background.dart';

class HelpAndSupportPage extends ConsumerWidget {
  const HelpAndSupportPage({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Help & Support',
        subtitle: 'Get assistance and answers',
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contact Developer', style: AppTextStyles.h3),
              const SizedBox(height: AppSpacing.md),
              GlassCard.info(
                icon: Icons.email_outlined,
                title: 'Email Support',
                subtitle: 'developer@example.com',
                iconColor: AppColors.primaryOrange,
                onTap: () => _launchUrl('mailto:developer@example.com'),
                animate: false,
              ),
              GlassCard.info(
                icon: Icons.phone_outlined,
                title: 'Call Support',
                subtitle: '+1 (555) 123-4567',
                iconColor: AppColors.success,
                onTap: () => _launchUrl('tel:+15551234567'),
                animate: false,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text('FAQ', style: AppTextStyles.h3),
              const SizedBox(height: AppSpacing.md),
              const _FaqItem(
                question: 'How do I pay my rent?',
                answer: 'You can pay your rent through the Rent section by selecting the unpaid month and proceeding with the payment gateway.',
              ),
              const _FaqItem(
                question: 'How do I raise a complaint?',
                answer: 'Navigate to the Complaints section from the home screen, tap the + button, and fill out the details of your issue.',
              ),
              const _FaqItem(
                question: 'Can I change my room?',
                answer: 'Room change requests can be made by contacting the administrator directly or through the Help & Support email.',
              ),
              const _FaqItem(
                question: 'How do I submit a leave notice?',
                answer: 'Go to the Leave Notice section and submit your expected departure date to notify the management.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: GlassContainer(
        padding: EdgeInsets.zero,

        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            title: Text(
              question,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            iconColor: AppColors.primaryOrange,
            collapsedIconColor: Colors.grey.shade600,
            childrenPadding: const EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.lg,
            ),
            children: [
              Text(
                answer,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
