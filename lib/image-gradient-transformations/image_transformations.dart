import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imageLibrary;

void main() {
  // Загрузка изображения
  imageLibrary.Image? image = imageLibrary.decodeImage(File('lib/image-gradient-transformations/images/camera.jpg').readAsBytesSync());

  // Создание копий изображений
  imageLibrary.Image grayscaleImage = imageLibrary.copyResize(image!, width: image.width, height: image.height);
  imageLibrary.Image binaryImage = imageLibrary.copyResize(image, width: image.width, height: image.height);

  // Преобразование в полутоновое изображение
  imageLibrary.grayscale(grayscaleImage);

  // Преобразование в бинарное изображение
  imageLibrary.luminanceThreshold(binaryImage);

  // Создание списка изображений для отображения
  List<List> images = [
    ['Original image', imageLibrary.encodeJpg(image)],
    ['Halftone image', imageLibrary.encodeJpg(grayscaleImage)],
    ['Binary image', imageLibrary.encodeJpg(binaryImage)],
  ];

  // Запуск приложения Flutter
  runApp(MyApp(images));
}

class MyApp extends StatelessWidget {
  final List<List> images;

  const MyApp(this.images, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Viewer',
      home: Scaffold(
        backgroundColor: Colors.grey[800],
        appBar: AppBar(
          backgroundColor: Colors.grey[700],
          title: const Text('Image Viewer'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 300,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: Column(
                          children: [
                            Image.memory(images[index][1], height: 265, width: 265,),
                            Text(images[index][0], style: const TextStyle(fontWeight: FontWeight.bold),),
                            const SizedBox(
                              height: 8,
                            )
                          ],
                        ));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
