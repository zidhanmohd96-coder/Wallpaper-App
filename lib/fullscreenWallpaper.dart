import 'package:flutter/material.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class FullscreenWallpaper extends StatefulWidget {
  final String imageUrl;
  const FullscreenWallpaper({super.key, required this.imageUrl});

  @override
  State<FullscreenWallpaper> createState() => _FullscreenWallpaperState();
}

class _FullscreenWallpaperState extends State<FullscreenWallpaper> {
  bool isLoading = false;

  Future<void> setWallpaper() async {
    try {
      setState(() => isLoading = true);

      int location = WallpaperManagerFlutter.homeScreen;

      // Download image to file
      final file = await DefaultCacheManager().getSingleFile(widget.imageUrl);

      await WallpaperManagerFlutter().setWallpaper(
        file,
        WallpaperManagerFlutter.homeScreen,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Wallpaper set successfully! 🎉")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to set wallpaper: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 48, 55, 95),
          title: const Text('Set Wallpaper'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),

            InkWell(
              onTap: isLoading ? null : setWallpaper,
              child: Container(
                color: const Color.fromARGB(255, 48, 55, 95),
                height: 60,
                width: double.infinity,
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Set as Wallpaper',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
