import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imageLibrary;

// Посилання на документ з розбіром та кодом
// https://docs.google.com/document/d/1vnKvE8zlMIp15Bt-Hw9rhYUFnHqy6y7yCczanqI07Dc/edit?usp=sharing
void main() {
  // Загрузка изображения
  imageLibrary.Image? image = imageLibrary.decodeImage(
      File('lib/image-gradient-transformations/images/camera.jpg')
          .readAsBytesSync());

  // Создание копий изображений
  imageLibrary.Image grayscaleImage =
      imageLibrary.copyResize(image!, width: image.width, height: image.height);

  imageLibrary.grayscale(grayscaleImage);

  // Создание списка изображений для отображения
  List<List> images = [
    ['Original image', imageLibrary.encodeJpg(image)],
    ['Halftone image', imageLibrary.encodeJpg(grayscaleImage)]
  ];
  imageLibrary.Image grayscaleImageGaussianNoise = imageLibrary
      .copyResize(grayscaleImage!, width: image.width, height: image.height);
  imageLibrary.Image grayscaleImageImpulseNoise = imageLibrary
      .copyResize(grayscaleImage!, width: image.width, height: image.height);
  imageLibrary.Image grayscaleImageSpeckleNoise = imageLibrary
      .copyResize(grayscaleImage!, width: image.width, height: image.height);

  // Добавление гауссовского шума
  imageLibrary.Image noisyImageGaussianNoise = imageLibrary.noise(
    grayscaleImageGaussianNoise,
    65,
    type: imageLibrary.NoiseType.gaussian,
  );
  // Добавление импульсного шума
  imageLibrary.Image noisyImageImpulseNoise = imageLibrary.noise(
    grayscaleImageImpulseNoise,
    65,
    type: imageLibrary.NoiseType.saltAndPepper,
  );
  // Добавление спекл-шума
  final variance = 20.0; // Adjust the variance as per your requirement
  addSpeckleNoise(grayscaleImageSpeckleNoise, variance);

  // Сохранение зашумленных изображений в формате JPEG
  File('lib/image-filtering/noise_images/noisy_gaussian.jpg')
      .writeAsBytesSync(imageLibrary.encodeJpg(noisyImageGaussianNoise));
  File('lib/image-filtering/noise_images/noisy_impulse.jpg')
      .writeAsBytesSync(imageLibrary.encodeJpg(noisyImageImpulseNoise));
  File('lib/image-filtering/noise_images/noisy_speckle.jpg')
      .writeAsBytesSync(imageLibrary.encodeJpg(grayscaleImageSpeckleNoise));
  File('lib/image-filtering/noise_images/grayscaleImage.jpg')
      .writeAsBytesSync(imageLibrary.encodeJpg(grayscaleImage));

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

// Реалізація спекл-шума
void addSpeckleNoise(imageLibrary.Image image, double variance) {
  final random = Random();
  final rows = image.height;
  final cols = image.width;

  for (var y = 0; y < rows!; y++) {
    for (var x = 0; x < cols!; x++) {
      imageLibrary.Pixel pixel = image.getPixel(x, y);

      final gray = pixel.b.toInt();

      final noise = variance * random.nextDouble() - variance / 2;

      final newGray = (gray + noise * gray).clamp(0, 255).toInt();

      image.setPixelRgba(x, y, newGray, newGray, newGray, 255);
    }
  }
}
