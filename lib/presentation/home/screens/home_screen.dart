import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:global_language_distribution_map/app/router.dart';
import 'package:global_language_distribution_map/presentation/home/view_models/home_view_model.dart';
import 'package:global_language_distribution_map/presentation/home/widgets/home_header.dart';
import 'package:global_language_distribution_map/presentation/home/widgets/featured_card.dart';
import 'package:global_language_distribution_map/presentation/home/widgets/explore_card.dart';

/// The Home Dashboard screen.
///
/// Displays stats, a featured card, and explore section with grid cards.
/// Sub-widgets are extracted into separate files under `widgets/`.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final width = MediaQuery.of(context).size.width;
    final int crossAxisCount = width > 1200 ? 5 : (width > 900 ? 4 : (width > 600 ? 3 : 2));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // ─── Curved Green Header ───────────────────────────────────
          SliverToBoxAdapter(
            child: HomeHeader(vm: vm),
          ),

          // ─── Featured: Explore the Map ─────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: FeaturedCard(
                onTap: () => context.go(RoutePaths.map),
              ),
            ),
          ),

          // ─── Explore Section ───────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(
                'EXPLORE',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),

          // ─── Explore Grid ──────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 160,
              ),
              delegate: SliverChildListDelegate([
                ExploreCard(
                  title: 'Language Map',
                  subtitle: 'Explore 7,000+ languages on\nan interactive world map',
                  icon: Icons.map_rounded,
                  countLabel: _formatCount(vm.mappableCount),
                  countSublabel: 'Languages',
                  accentColor: const Color(0xFF2E7D32),
                  onTap: () => context.go(RoutePaths.map),
                ),
                ExploreCard(
                  title: 'Language Families',
                  subtitle: 'Discover major language\nfamilies globally',
                  icon: Icons.language_rounded,
                  countLabel: '${vm.totalFamilies}',
                  countSublabel: 'Families',
                  accentColor: const Color(0xFF00695C),
                  onTap: () => context.go(RoutePaths.families),
                ),
                ExploreCard(
                  title: 'Diversity Heatmap',
                  subtitle: 'Visualize linguistic hotspots\nacross continents',
                  icon: Icons.whatshot_rounded,
                  countLabel: 'Top 5',
                  countSublabel: 'Hotspots',
                  accentColor: const Color(0xFFE65100),
                  onTap: () => context.push(RoutePaths.heatmap),
                ),
                ExploreCard(
                  title: 'Endangered\nLangua...',
                  subtitle: 'Track languages at risk of\nextinction',
                  icon: Icons.warning_rounded,
                  countLabel: '${_formatCount(vm.endangeredCount)}+',
                  countSublabel: 'At Risk',
                  accentColor: const Color(0xFFC62828),
                  onTap: () => context.push(RoutePaths.endangered),
                ),
                ExploreCard(
                  title: 'AI Assistant',
                  subtitle: 'Query the global language\ndataset using AI',
                  icon: Icons.chat_bubble_outline_rounded,
                  countLabel: 'AI',
                  countSublabel: 'Helper',
                  accentColor: const Color(0xFF1565C0),
                  onTap: () => context.push(RoutePaths.chat),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
