# Arc Ribbon Menu

A highly customizable, beautiful curved/arc ribbon selection list widget for Flutter. Ideal for creating circular/dial navigation interfaces, category selectors, or immersive visual lists.

<p align="center">
  <img src="https://raw.githubusercontent.com/dyuta6/arc_ribbon_menu/main/screenshots/preview.jpg" alt="Arc Ribbon Menu Demo" width="350"/>
</p>


## Features

- **Smooth Arc Scrolling**: Displays items on a circular curve path (ribbon dial).
- **Custom Clipping**: Uses precise custom sector clipping math to curve individual items.
- **Generic Data Type support**: Displays any list model item using customizable item builders.
- **Detailed Card Integration**: Dynamically links the selected arc element with a customizable details card overlay.

## Getting started

Add `arc_ribbon_menu` to your `pubspec.yaml` or run:

```bash
flutter pub add arc_ribbon_menu
```

## Usage

```dart
import 'package:arc_ribbon_menu/arc_ribbon_menu.dart';

ArcRibbonMenu<MyCategory>(
  items: categories,
  initialIndex: 0,
  onItemTap: (category, index) {
    print('Tapped: ${category.name}');
  },
  imageBuilder: (context, category, index) {
    return Image.asset(category.imagePath, fit: BoxFit.cover);
  },
  detailsBuilder: (context, category, index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category.name, style: TextStyle(color: Colors.white, fontSize: 16)),
        Text(category.description, style: TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  },
  themeColor: Colors.deepPurple,
)
```
