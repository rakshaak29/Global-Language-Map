import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:global_language_distribution_map/app/router.dart';
import 'package:global_language_distribution_map/app/theme.dart';
import 'package:global_language_distribution_map/presentation/families/view_models/families_view_model.dart';
import 'package:global_language_distribution_map/presentation/map/view_models/map_view_model.dart';
import 'package:global_language_distribution_map/presentation/families/widgets/families_header.dart';
import 'package:global_language_distribution_map/presentation/families/widgets/families_search_bar.dart';
import 'package:global_language_distribution_map/presentation/families/widgets/family_card.dart';

/// Language Families Screen.
///
/// Displays all language families as colorful gradient cards with
/// language count and speaker count. Includes search functionality.
/// Sub-widgets are extracted into separate files under `widgets/`.
class FamiliesScreen extends StatefulWidget {
  const FamiliesScreen({super.key});

  @override
  State<FamiliesScreen> createState() => _FamiliesScreenState();
}

class _FamiliesScreenState extends State<FamiliesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _colorForIndex(int index) {
    final gradients = AppTheme.familyCardGradients;
    return gradients[index % gradients.length][0];
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FamiliesViewModel>();
    final mapVm = context.watch<MapViewModel>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // ─── Header ─────────────────────────────────────────────
          FamiliesHeader(familyCount: vm.totalFamilies),

          // ─── Search ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Transform.translate(
              offset: const Offset(0, -24),
              child: FamiliesSearchBar(
                controller: _searchController,
                onChanged: vm.search,
              ),
            ),
          ),

          // ─── Filter Mode Toggle Chips ─────────────────────────────
          if (mapVm.familyFilter != 'all')
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Transform.translate(
                offset: const Offset(0, -24),
                child: Row(
                  children: [
                    Chip(
                      label: Text(
                        'Map Filter: ${mapVm.familyFilter}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                      backgroundColor: AppTheme.primaryGreen.withValues(alpha: 0.12),
                      side: BorderSide(color: AppTheme.primaryGreen.withValues(alpha: 0.3)),
                      deleteIcon: const Icon(Icons.clear_rounded, size: 14, color: AppTheme.primaryGreen),
                      onDeleted: () {
                        mapVm.clearFamilyFilter();
                      },
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        context.go(RoutePaths.map);
                      },
                      icon: const Icon(Icons.map_rounded, size: 16),
                      label: Text(
                        'Go to Map',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ─── Family List ─────────────────────────────────────────
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -24),
              child: vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : vm.filteredFamilies.isEmpty
                      ? Center(
                          child: Text(
                            'No families found',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: const Color(0xFF52634F),
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          itemCount: vm.filteredFamilies.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final family = vm.filteredFamilies[index];
                            final color = _colorForIndex(index);
                            return FamilyCard(
                              family: family,
                              accentColor: color,
                              onTap: () => _showFamilyActions(context, family, vm),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFamilyActions(BuildContext context, FamilyStat family, FamiliesViewModel vm) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  family.name,
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                Text(
                  '${family.languageCount} languages · ${family.speakerCount} speakers',
                  style: GoogleFonts.inter(fontSize: 13, color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.map_rounded, color: AppTheme.primaryGreen),
                  title: Text('View on Map', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  subtitle: Text('Filter map to show only ${family.name} languages'),
                  onTap: () {
                    Navigator.pop(ctx);
                    final mapVm = context.read<MapViewModel>();
                    mapVm.setFamilyFilter(family.name);
                    final langs = vm.getLanguagesForFamily(family.name);
                    final withCoords = langs.where((l) => l.hasCoordinates).toList();
                    if (withCoords.isNotEmpty) {
                      mapVm.selectLanguage(withCoords.first);
                    }
                    context.go(RoutePaths.map);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.download_rounded, color: colorScheme.secondary),
                  title: Text('Export KML', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  subtitle: Text('Download KML of ${family.name} family'),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await vm.exportFamilyKml(family.name);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Exported ${family.name} KML successfully')),
                      );
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.list_rounded, color: colorScheme.primary),
                  title: Text('View Languages', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  subtitle: Text('Browse all ${family.languageCount} languages'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _showFamilyLanguages(context, family, vm);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFamilyLanguages(BuildContext context, FamilyStat family, FamiliesViewModel vm) {
    final langs = vm.getLanguagesForFamily(family.name);
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surfaceContainer,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.3,
          expand: false,
          builder: (_, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        '${family.name} (${langs.length})',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: langs.length,
                    itemBuilder: (_, i) {
                      final lang = langs[i];
                      return ListTile(
                        leading: Icon(
                          Icons.language_rounded,
                          color: AppTheme.getEndangermentColor(lang.endangeredStatus),
                        ),
                        title: Text(lang.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
                        subtitle: Text(lang.countryRegion, style: GoogleFonts.inter(fontSize: 12)),
                        trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                        onTap: () {
                          Navigator.pop(ctx);
                          context.read<MapViewModel>().flyToLanguage(lang);
                          context.go(RoutePaths.map);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
