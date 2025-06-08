import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/providers/customer_profile_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/nest_form_fields.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomerProfileScreen extends HookConsumerWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isEditing = ref.watch(isEditingProvider);

    final originalFullName = useState('John Doe');
    final originalPhone = useState('123-456-7890');

    final formKey = useRef(GlobalKey<FormState>()).value;
    final fullNameController = useTextEditingController(text: originalFullName.value);
    final emailController = useTextEditingController(text: 'john.mclean@examplepetstore.com');
    final phoneController = useTextEditingController(text: originalPhone.value);

    final emailNotifications = ref.watch(emailNotificationsProvider);

    return NestScaffold(
      showBackButton: true,
      title: isEditing ? "edit profile" : "profile",
      actions: [
        GestureDetector(
          onTap: () {
            if (isEditing) {
              fullNameController.text = originalFullName.value;
              phoneController.text = originalPhone.value;
            }

            ref.read(isEditingProvider.notifier).state = !isEditing;
          },
          child: Container(
            margin: EdgeInsets.only(right: 4.w),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: isEditing ? theme.colorScheme.primary : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(6.w),
            ),
            child: Text(
              isEditing ? 'Cancel' : 'Edit',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isEditing ? Colors.white : theme.colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content
          Expanded(
            child: SingleChildScrollView(
              child: NestForm(
                formKey: formKey,
                fields: [
                  _buildProfilePictureSection(theme, isEditing),
                  SizedBox(height: 4.h),

                  // Personal Information Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _buildSectionHeader('Personal Information', theme),
                  ),
                  SizedBox(height: 2.h),
                  _buildPersonalInfoSection(
                    theme,
                    fullNameController,
                    emailController,
                    phoneController,
                    isEditing,
                  ),
                  SizedBox(height: 4.h),

                  // Preferences Section
                  _buildSectionHeader('Preferences', theme),
                  SizedBox(height: 2.h),
                  _buildPreferencesSection(theme, emailNotifications, ref, isEditing),
                  SizedBox(height: 4.h),

                  // Account Statistics
                  _buildSectionHeader('Account Statistics', theme),
                  SizedBox(height: 2.h),
                  _buildStatsSection(theme),
                ],
                showSubmitButton: isEditing,
                onSubmit: () {
                  if (formKey.currentState!.validate()) {
                    // Save changes
                    ref.read(isEditingProvider.notifier).state = false;

                    ToastUtil.showSuccessToast(
                      context,
                      'Profile updated successfully',
                      color: theme.colorScheme.onPrimary,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePictureSection(ThemeData theme, bool isEditing) {
    return Stack(
      children: [
        Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary, theme.colorScheme.onSurface],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15.w),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(Icons.person, color: Colors.white, size: 15.w),
        ),
        if (isEditing)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                // Handle profile picture change
              },
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(5.w),
                  border: Border.all(color: theme.colorScheme.onTertiaryContainer, width: 3),
                ),
                child: Icon(Icons.camera_alt, color: Colors.white, size: 5.w),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold));
  }

  Widget _buildPersonalInfoSection(
    ThemeData theme,
    TextEditingController fullNameController,
    TextEditingController emailController,
    TextEditingController phoneController,
    bool isEditing,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            NestFormField(
              readOnly: !isEditing,
              belowSpacing: false,
              label: 'Full Name',
              controller: fullNameController,
              hintText: 'John Doe',
              prefixIcon: Icon(Icons.person_outline),
              keyboardType: TextInputType.name,
            ),
            SizedBox(height: 3.h),
            NestFormField(
              belowSpacing: false,
              label: 'Email Address',
              controller: emailController,
              hintText: 'john.c.breckinridge@altostrat.com',
              prefixIcon: Icon(Icons.email_outlined),
              keyboardType: TextInputType.emailAddress,
              readOnly: true,
              enabled: false,
            ),
            SizedBox(height: 3.h),
            NestFormField(
              readOnly: !isEditing,
              label: 'Phone Number',
              controller: phoneController,
              hintText: '123-456-7890',
              prefixIcon: Icon(Icons.phone_outlined),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesSection(
    ThemeData theme,
    bool emailNotifications,
    WidgetRef ref,
    bool isEditing,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            _buildSwitchTile(
              'Email Notifications',
              'Receive order updates via email',
              Icons.email_outlined,
              emailNotifications,
              (value) {
                ref.read(emailNotificationsProvider.notifier).state = value;
              },
              theme,
              isEditing,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Orders',
                    '47',
                    Icons.receipt_long_outlined,
                    theme.colorScheme.primary,
                    theme,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildStatCard(
                    'This Month',
                    '8',
                    Icons.calendar_month,
                    theme.colorScheme.onSurface,
                    theme,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Money Saved',
                    '\$127',
                    Icons.savings_outlined,
                    theme.colorScheme.onPrimary,
                    theme,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildStatCard(
                    'Member Since',
                    'Jan 2023',
                    Icons.schedule_outlined,
                    theme.colorScheme.onTertiary,
                    theme,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 6.w),
          SizedBox(height: 1.h),
          Text(value, style: theme.textTheme.titleSmall),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimaryContainer),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
    ThemeData theme,
    bool isEditing,
  ) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(3.w),
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 6.w),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: isEditing ? onChanged : null,
          activeColor: theme.colorScheme.primary,
          activeTrackColor: theme.colorScheme.primary.withValues(alpha: 0.3),
          inactiveThumbColor: theme.colorScheme.primary.withValues(alpha: 0.3),
          inactiveTrackColor: theme.colorScheme.onTertiary.withValues(alpha: 0.1),
        ),
      ],
    );
  }
}
