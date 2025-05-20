// widgets/profile/assets_modal.dart
import 'package:flutter/material.dart';
import '../../constants/profile/profile_modal_constants.dart';

// Keep AssetItem class defined or imported
class AssetItem {
  /* ... AssetItem definition ... */
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  AssetItem({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class AssetsModal extends StatelessWidget {
  final List<AssetItem> assets;

  const AssetsModal({super.key, required this.assets});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ModalConstants.modalBorderRadius),
      ),
      elevation: ModalConstants.modalElevation,
      child: ModalConstants.buildModalContainer(context, [
        ModalConstants.buildModalHeader(context, 'My Assets'),
        const Divider(height: 1, thickness: 1),

        // Conditional Content: Either list or empty state
        assets.isEmpty
            ? // Use the Empty State helper
            ModalConstants.buildEmptyState(
              context,
              Icons.inventory_2_outlined, // Suitable icon for assets
              'No assets assigned.',
            )
            : // Use Flexible + ListView for scrollable content when needed
            Flexible(
              // Allows ListView to take space but not necessarily expand fully
              child: ListView.builder(
                shrinkWrap:
                    true, // Allows listview to take only needed vertical space
                padding:
                    ModalConstants.contentPadding, // Use consistent padding
                itemCount: assets.length,
                itemBuilder: (context, index) {
                  final asset = assets[index];
                  return Card(
                    elevation: ModalConstants.itemElevation,
                    margin: ModalConstants.itemMargin,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ModalConstants.itemBorderRadius,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: ModalConstants.itemPadding,
                      leading: ModalConstants.buildIconContainer(
                        asset.icon,
                        asset.color,
                      ),
                      title: Text(
                        asset.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        asset.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        // Ensure some bottom padding inside the modal if needed
        const SizedBox(height: ModalConstants.modalSpacing),
      ]),
    );
  }
}
