import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imageLibrary;

// Посилання на детальний розбір коду та поянення
// https://docs.google.com/document/d/1HP9fdfddAiLabBiR-HjoxC_cVV81ryv9S8EBDv_aLh0/edit?usp=sharing
void main() {
  // Загрузка изображения
  imageLibrary.Image? image = imageLibrary.decodeImage(
      File('lib/image-gradient-transformations/images/camera.jpg')
          .readAsBytesSync());

  // Создание копий изображений
  imageLibrary.Image grayscaleImage =
      imageLibrary.copyResize(image!, width: image.width, height: image.height);

  imageLibrary.grayscale(grayscaleImage);

// Вырезание фрагмента изображения
  int fragmentWidth = 95;
  int fragmentHeight = 60;
  int startX =
      (image.width - fragmentWidth) ~/ 2; // Начальная координата X для выреза
  int startY =
      (image.height - fragmentHeight) ~/ 2; // Начальная координата Y для выреза
  imageLibrary.Image fragment = imageLibrary.copyCrop(
    grayscaleImage,
    x: startX,
    y: startY,
    width: fragmentWidth,
    height: fragmentHeight,
  );

  // // Увеличение фрагмента в 1,5 раза
  // int scaledWidth = (fragmentWidth * 1.5).toInt();
  // int scaledHeight = (fragmentHeight * 1.5).toInt();
  // imageLibrary.Image scaledFragment = imageLibrary.copyResize(fragment, width: scaledWidth, height: scaledHeight);
  //
  // // Поворот фрагмента против часовой стрелки на 60 градусов
  // imageLibrary.Image rotatedFragment = imageLibrary.copyRotate(scaledFragment, angle: -60);
  //
  // // Преобразование фрагмента в размер 150x100 пикселей
  // int resizedWidth = 150;
  // int resizedHeight = 100;
  // imageLibrary.Image resizedFragment = imageLibrary.copyResize(fragment, width: resizedWidth, height: resizedHeight);
  //
  // // Поворот фрагмента против часовой стрелки на -30 градусов
  // imageLibrary.Image rotatedResizedFragment = imageLibrary.copyRotate(resizedFragment, angle:  -30,);

  // Создание списка изображений для отображения
  List<List> images = [
    ['Original image', imageLibrary.encodeJpg(image)],
    ['Halftone image', imageLibrary.encodeJpg(grayscaleImage)],
    ['Crop image', imageLibrary.encodeJpg(fragment)],
  ];

  // Запуск приложения Flutter
  runApp(MyApp(images));
}

class MyApp extends StatelessWidget {
  final List<List> images;

  MyApp(this.images, {super.key});

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
        body: SingleChildScrollView(
          child: Column(
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
                          Image.memory(
                            images[index][1],
                            height: 265,
                            width: 265,
                          ),
                          Text(
                            images[index][0],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
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
      ),
    );
  }
}
