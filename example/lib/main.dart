import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arc_ribbon_menu/arc_ribbon_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arc Ribbon Menu Example',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class DemoItem {
  final String title;
  final String description;
  final String imageUrl;

  DemoItem({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DemoItem> items = [
      DemoItem(
        title: 'Morning',
        description: 'Start your day with calm energy.',
        imageUrl: 'https://picsum.photos/id/10/500/500', // Sabah ormanı
      ),
      DemoItem(
        title: 'Sleep',
        description: 'Relax deeply and sleep soundly.',
        imageUrl:
            'https://picsum.photos/id/1025/500/500', // Battaniyeye sarılmış uyuyan sevimli köpek (Sleep)
      ),
      DemoItem(
        title: 'Focus',
        description: 'Enhance concentration and productivity.',
        imageUrl:
            'https://picsum.photos/id/48/500/500', // Bilgisayar ve çalışma masası
      ),
      DemoItem(
        title: 'Anxiety',
        description: 'Ease stress and quiet the mind.',
        imageUrl: 'https://picsum.photos/id/1041/500/500', // Sakin sisli deniz
      ),
      DemoItem(
        title: 'Gratitude',
        description: 'Cultivate appreciation and positivity.',
        imageUrl: 'https://picsum.photos/id/306/500/500', // Çiçek tarlası
      ),
      DemoItem(
        title: 'Energy',
        description: 'Boost your vitality and stay active.',
        imageUrl:
            'https://picsum.photos/id/170/500/500', // Güneşli orman yolu / koşu rotası
      ),
      DemoItem(
        title: 'Mindfulness',
        description: 'Be present in the current moment.',
        imageUrl: 'https://picsum.photos/id/327/500/500', // Sessiz ahşap yol
      ),
      DemoItem(
        title: 'Creativity',
        description: 'Spark fresh ideas and inspiration.',
        imageUrl:
            'https://picsum.photos/id/145/500/500', // Defter ve vintage kamera
      ),
      DemoItem(
        title: 'Confidence',
        description: 'Build inner strength and self-belief.',
        imageUrl: 'https://picsum.photos/id/343/500/500', // Dağ zirveleri
      ),
      DemoItem(
        title: 'Nature',
        description: 'Connect with the grounding energy of the earth.',
        imageUrl: 'https://picsum.photos/id/28/500/500', // Ağaçlar / Doğa
      ),
    ];

    return Scaffold(
      body: Column(
        children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Drag on the left side to spin the ribbon dial:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ArcRibbonMenu<DemoItem>(
                items: items,
                initialIndex: 1,
                themeColor: Colors.deepPurple,
                onItemTap: (item, index) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Selected category: ${item.title}')),
                  );
                },
                imageBuilder: (context, item, index) {
                  return Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.white54,
                          ),
                        ),
                      );
                    },
                  );
                },
                detailsBuilder: (context, item, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
    );
  }
}
