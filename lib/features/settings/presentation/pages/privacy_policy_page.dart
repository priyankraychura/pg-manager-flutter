import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/gradient_background.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Privacy Policy',
        subtitle: 'How we handle your data',
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlassContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1. Introduction', style: AppTextStyles.h3),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Welcome to PG Manager. We are committed to protecting your personal information and your right to privacy. If you have any questions or concerns about our policy, or our practices with regards to your personal information, please contact us.',
                      style: AppTextStyles.body.copyWith(color: AppColors.secondarySlate),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    
                    Text('2. Information We Collect', style: AppTextStyles.h3),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'We collect personal information that you voluntarily provide to us when registering at the application, expressing an interest in obtaining information about us or our products and services, when participating in activities on the application or otherwise contacting us.',
                      style: AppTextStyles.body.copyWith(color: AppColors.secondarySlate),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    
                    Text('3. How We Use Your Information', style: AppTextStyles.h3),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'We use personal information collected via our application for a variety of business purposes described below. We process your personal information for these purposes in reliance on our legitimate business interests, in order to enter into or perform a contract with you, with your consent, and/or for compliance with our legal obligations.',
                      style: AppTextStyles.body.copyWith(color: AppColors.secondarySlate),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    
                    Text('4. Sharing Your Information', style: AppTextStyles.h3),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'We only share information with your consent, to comply with laws, to provide you with services, to protect your rights, or to fulfill business obligations.',
                      style: AppTextStyles.body.copyWith(color: AppColors.secondarySlate),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
