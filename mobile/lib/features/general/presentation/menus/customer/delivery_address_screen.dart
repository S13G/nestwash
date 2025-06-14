import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/model/address_model.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/providers/address_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/nest_form_fields.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DeliveryAddressesScreen extends HookConsumerWidget {
  const DeliveryAddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formKey = useRef(GlobalKey<FormState>()).value;

    // Use useState for TextEditingControllers
    final labelController = useTextEditingController();
    final addressController = useTextEditingController();
    final cityController = useTextEditingController();
    final stateController = useTextEditingController();
    final zipController = useTextEditingController();
    final instructionsController = useTextEditingController();

    final isAddingAddress = ref.watch(isAddingAddressProvider);
    final editingAddressId = ref.watch(editingAddressIdProvider);
    final addresses = ref.watch(addressListNotifierProvider);

    // Determine if we are editing an existing address
    final AddressModel? editingAddress = ref.watch(isEditingExistingAddressProvider);

    final animations = useLaundryAnimations(null);

    // Set controller values when editingAddress changes
    useEffect(() {
      if (editingAddress != null) {
        labelController.text = editingAddress.label;
        addressController.text = editingAddress.address;
        cityController.text = editingAddress.city;
        stateController.text = editingAddress.state;
        instructionsController.text = editingAddress.instructions;
      } else {
        _clearFormControllers(labelController, addressController, cityController, stateController, zipController, instructionsController);
      }
      return null;
    }, [editingAddress]);

    return NestScaffold(
      padding: EdgeInsets.zero,
      showBackButton: true,
      title: isAddingAddress ? (editingAddressId != null ? 'edit address' : 'add address') : 'delivery addresses',
      body: Column(
        children: [
          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Add Address Button
                    if (!isAddingAddress) FadeTransition(opacity: animations.fadeAnimation, child: _buildAddAddressButton(ref, theme)), // Pass ref
                    if (!isAddingAddress) SizedBox(height: 3.h),

                    // Add/Edit Address Form
                    if (isAddingAddress)
                      _buildAddressForm(
                        context,
                        ref,
                        theme,
                        formKey,
                        labelController,
                        addressController,
                        cityController,
                        stateController,
                        zipController,
                        instructionsController,
                        editingAddressId, // Pass the editing ID
                      ),
                    if (isAddingAddress) SizedBox(height: 3.h),

                    // Addresses List
                    if (addresses.isNotEmpty)
                      SlideTransition(position: animations.slideAnimation, child: _buildAddressesList(context, theme, ref, addresses)),
                    if (addresses.isEmpty && !isAddingAddress) _buildEmptyState(theme),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddAddressButton(WidgetRef ref, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        ref.read(isAddingAddressProvider.notifier).state = true; // Show form
        ref.read(editingAddressIdProvider.notifier).state = null; // Ensure no editing state
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 3.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.colorScheme.primary, theme.colorScheme.onSurface],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(4.w),
          boxShadow: [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_location_alt_outlined, color: Colors.white, size: 6.w),
            SizedBox(width: 3.w),
            Text('Add New Address', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressForm(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    GlobalKey<FormState> formKey,
    TextEditingController labelController,
    TextEditingController addressController,
    TextEditingController cityController,
    TextEditingController stateController,
    TextEditingController zipController,
    TextEditingController instructionsController,
    String? editingAddressId,
  ) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(5.w),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form Title
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(2.w)),
                  child: Icon(Icons.location_on, color: theme.colorScheme.primary, size: 5.w),
                ),
                SizedBox(width: 3.w),
                Text(
                  editingAddressId != null ? 'Edit Address Details' : 'Enter Address Details',
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Address Label
            NestFormField(
              controller: labelController,
              label: 'Address Label',
              hintText: 'e.g., Home, Office, etc.',
              prefixIcon: Icon(Icons.label_outline),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an address label';
                }
                return null;
              },
            ),

            // Street Address
            NestFormField(
              controller: addressController,
              label: 'Street Address',
              hintText: 'Enter your full address',
              prefixIcon: Icon(Icons.home_outlined),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter our address';
                }
                return null;
              },
            ),
            // City and State Row
            Row(
              children: [
                Expanded(
                  child: NestFormField(
                    controller: cityController,
                    label: 'City',
                    hintText: 'Enter city',
                    prefixIcon: Icon(Icons.location_city_outlined),
                    belowSpacing: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: NestFormField(
                    controller: stateController,
                    label: 'State',
                    hintText: 'Enter state',
                    prefixIcon: Icon(Icons.map_outlined),
                    belowSpacing: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Delivery Instructions
            NestFormField(
              controller: instructionsController,
              label: 'Special Instructions (Optional)',
              hintText: 'Any special delivery instructions',
              prefixIcon: Icon(Icons.note_outlined),
              belowSpacing: false,
              maxLines: 3,
            ),
            SizedBox(height: 4.h),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ref.read(isAddingAddressProvider.notifier).state = false; // Hide form
                      ref.read(editingAddressIdProvider.notifier).state = null;
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(3.w),
                        border: Border.all(color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.3)),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onPrimaryContainer),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: GestureDetector(
                    onTap:
                        () => _saveAddress(
                          context,
                          ref,
                          formKey,
                          labelController,
                          addressController,
                          cityController,
                          stateController,
                          zipController,
                          instructionsController,
                          editingAddressId,
                        ), // Pass all controllers and state
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [theme.colorScheme.primary, theme.colorScheme.onSurface],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                      child: Center(
                        child: Text(
                          editingAddressId != null ? 'Update' : 'Save Address',
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressesList(BuildContext context, ThemeData theme, WidgetRef ref, List<AddressModel> addresses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Saved Addresses', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: addresses.length,
          separatorBuilder: (context, index) => SizedBox(height: 2.h),
          itemBuilder: (context, index) {
            return _buildAddressCard(context, ref, theme, addresses[index]);
          },
        ),
      ],
    );
  }

  Widget _buildAddressCard(BuildContext context, WidgetRef ref, ThemeData theme, AddressModel address) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(4.w),
        border: address.isDefault ? Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3), width: 2) : null,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and Label Row
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: address.isDefault ? theme.colorScheme.primary.withValues(alpha: 0.1) : theme.colorScheme.onSurface.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Icon(
                  address.isDefault ? Icons.home : Icons.location_on,
                  color: address.isDefault ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Row(
                  children: [
                    Text(address.label, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    if (address.isDefault) ...[
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(2.w)),
                        child: Text('Default', style: theme.textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Address details
          Text("${address.address}, ${address.city}, ${address.state}", style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),

          // Instructions
          if (address.instructions.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(2.w)),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: theme.colorScheme.onSurface, size: 4.w),
                  SizedBox(width: 2.w),
                  Expanded(child: Text(address.instructions, style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic))),
                ],
              ),
            ),
          ],

          SizedBox(height: 2.h),

          // Action buttons
          Row(
            children: [
              if (!address.isDefault)
                Expanded(
                  child: GestureDetector(
                    onTap: () => _setAsDefault(context, ref, address.id),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(2.w)),
                      child: Center(
                        child: Text(
                          'Set as Default',
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.primary),
                        ),
                      ),
                    ),
                  ),
                ),
              if (!address.isDefault) SizedBox(width: 2.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => _editAddress(ref, address.id),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(color: theme.colorScheme.onSurface.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(2.w)),
                    child: Center(
                      child: Text(
                        'Edit',
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              GestureDetector(
                onTap: () => _deleteAddress(context, ref, address.id),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(2.w)),
                  child: Icon(Icons.delete_outline, color: Colors.red.shade600, size: 5.w),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10.w)),
            child: Icon(Icons.location_off_outlined, color: theme.colorScheme.primary, size: 15.w),
          ),
          SizedBox(height: 3.h),
          Text('No Addresses Added', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 1.h),
          Text(
            'Add your first delivery address to get started with our laundry service',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer),
          ),
        ],
      ),
    );
  }

  // Refactored to take controllers and ref to update providers
  void _saveAddress(
    BuildContext context,
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    TextEditingController labelController,
    TextEditingController addressController,
    TextEditingController cityController,
    TextEditingController stateController,
    TextEditingController zipController,
    TextEditingController instructionsController,
    String? editingAddressId,
  ) {
    if (formKey.currentState!.validate()) {
      final AddressModel newAddress = AddressModel(
        id: editingAddressId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        // Generate new ID if adding
        label: labelController.text,
        address: addressController.text,
        city: cityController.text,
        state: stateController.text,
        instructions: instructionsController.text,
        isDefault: false, // Default is handled by setAsDefault
      );

      if (editingAddressId != null) {
        ref.read(addressListNotifierProvider.notifier).updateAddress(newAddress.id, newAddress);
      } else {
        ref.read(addressListNotifierProvider.notifier).addAddress(newAddress);
      }

      ref.read(isAddingAddressProvider.notifier).state = false; // Hide form
      ref.read(editingAddressIdProvider.notifier).state = null; // Clear editing state

      ToastUtil.showSuccessToast(context, editingAddressId != null ? 'Address updated successfully' : 'Address added successfully');
    }
  }

  void _editAddress(WidgetRef ref, String id) {
    ref.read(isAddingAddressProvider.notifier).state = true; // Show form
    ref.read(editingAddressIdProvider.notifier).state = id; // Set editing ID
  }

  void _deleteAddress(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Address'),
            content: const Text('Are you sure you want to delete this address?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              TextButton(
                onPressed: () {
                  ref.read(addressListNotifierProvider.notifier).deleteAddress(id);
                  Navigator.pop(context);
                  ToastUtil.showSuccessToast(context, 'Address deleted successfully');
                },
                child: Text('Delete', style: TextStyle(color: Colors.red.shade600)),
              ),
            ],
          ),
    );
  }

  void _setAsDefault(BuildContext context, WidgetRef ref, String id) {
    ref.read(addressListNotifierProvider.notifier).setAsDefault(id);
    ToastUtil.showSuccessToast(context, 'Default address updated');
  }

  // Helper function to clear text controllers
  void _clearFormControllers(
    TextEditingController label,
    TextEditingController address,
    TextEditingController city,
    TextEditingController state,
    TextEditingController zip,
    TextEditingController instructions,
  ) {
    label.clear();
    address.clear();
    city.clear();
    state.clear();
    zip.clear();
    instructions.clear();
  }
}
