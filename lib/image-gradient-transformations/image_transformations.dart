import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as imageLibrary;
import 'package:syncfusion_flutter_charts/charts.dart';

// Ссылка на подробный разбор кода и пояснения
// https://docs.google.com/document/d/1KbGOzmIJA4gD9alM9NDqz8wrT4Vn4Cm0JdlCZIs-ja4/edit?usp=sharing
void main() {
  // Загрузка изображения
  imageLibrary.Image? image = imageLibrary.decodeImage(File('lib/image-gradient-transformations/images/camera.jpg').readAsBytesSync());

  // Создание копий изображений
  imageLibrary.Image grayscaleImage = imageLibrary.copyResize(image!, width: image.width, height: image.height);
 // imageLibrary.Image binaryImage = imageLibrary.copyResize(image, width: image.width, height: image.height);
  imageLibrary.Image unsignedByteImage = imageLibrary.copyResize(image!, width: image.width, height: image.height);
  // Преобразование в полутоновое изображение
  imageLibrary.grayscale(grayscaleImage);
  // Гамма-коррекция
  double gamma1 = 0.5; // Параметр гаммы для получения светлого изображения
  double gamma2 = 2.0; // Параметр гаммы для получения темного изображения

  imageLibrary.Image gammaCorrectedImage1 = imageLibrary.copyResize(grayscaleImage, width: image.width, height: image.height);
  imageLibrary.Image gammaCorrectedImage2 = imageLibrary.copyResize(grayscaleImage, width: image.width, height: image.height);
  imageLibrary.adjustColor(gammaCorrectedImage1, gamma: gamma1);
  imageLibrary.adjustColor(gammaCorrectedImage2, gamma: gamma2);

  imageLibrary.Image grayscaleImageEqualize = imageLibrary.copyResize(grayscaleImage, width: image.width, height: image.height);


  imageLibrary.Image equalizeHistogram(imageLibrary.Image? image) {
    // Створення гістограми яскравості
    List<int> histogram = List.filled(256, 0);
    for (int y = 0; y < image!.height; y++) {
      for (int x = 0; x < image.width; x++) {
        imageLibrary.Pixel pixel = image.getPixel(x, y);
        int luminance = imageLibrary.getLuminance(pixel).toInt();
        histogram[luminance]++;
      }
    }

    // Обчислення кумулятивної гістограми
    List<int> cumulativeHistogram = List.filled(256, 0);
    cumulativeHistogram[0] = histogram[0];
    for (int i = 1; i < 256; i++) {
      cumulativeHistogram[i] = cumulativeHistogram[i - 1] + histogram[i];
    }

    // Нормалізація кумулятивної гістограми
    int totalPixels = image.width * image.height;
    List<int> normalizedHistogram = List.filled(256, 0);
    for (int i = 0; i < 256; i++) {
      normalizedHistogram[i] = (cumulativeHistogram[i] * 255 / totalPixels).round();
    }

    // Застосування еквалізованої гістограми до зображення
    imageLibrary.Image equalizedImage = imageLibrary.copyResize(image, width: image.width, height: image.height);
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        imageLibrary.Pixel pixel = image.getPixel(x, y);
        int luminance = imageLibrary.getLuminance(pixel).toInt();
        int equalizedLuminance = normalizedHistogram[luminance];
        equalizedImage.setPixelRgba(x, y, equalizedLuminance, equalizedLuminance, equalizedLuminance, 255);
      }
    }

    return equalizedImage;
  }

  // Еквалізація гістограми
  imageLibrary.Image equalizedImage = equalizeHistogram(grayscaleImageEqualize);

  // Преобразование в бинарное изображение
 // imageLibrary.luminanceThreshold(binaryImage);

  // bool isImageLowContrast(imageLibrary.Image? image) {
  //   if (image == null) {
  //     return false;
  //   }
  //
  //   // Создание гистограммы яркости
  //   List<int> histogram = List.filled(256, 0);
  //   for (int y = 0; y < image.height; y++) {
  //     for (int x = 0; x < image.width; x++) {
  //       imageLibrary.Pixel pixel = image.getPixel(x, y);
  //       int luminance = imageLibrary.getLuminance(pixel).toInt();
  //       histogram[luminance]++;
  //     }
  //   }
  //
  //   // Анализ гистограммы
  //   int totalPixels = image.width * image.height;
  //   int nonZeroBins = histogram
  //       .where((count) => count > 0)
  //       .length;
  //   double nonZeroRatio = nonZeroBins / 256;
  //   double threshold = 0.05; // Пороговое значение для определения малоконтрастности
  //
  //   return nonZeroRatio < threshold;
  // }
  // Анализ гистограммы яркости
  // bool isLowContrast = isImageLowContrast(image);
  //
  // // Вывод результата
  // if (isLowContrast) {
  //   print('Изображение является малоконтрастным.');
  // } else {
  //   print('Изображение не является малоконтрастным.');
  // }

  // imageLibrary.Image enhanceContrast(imageLibrary.Image? image) {
  //
  //   // Создание копии входного изображения
  //   imageLibrary.Image contrastedImage = imageLibrary.copyResize(image!, width: image!.width, height: image.height);
  //
  //   // Применение логарифмического преобразования
  //   for (int y = 0; y < image.height; y++) {
  //     for (int x = 0; x < image.width; x++) {
  //       imageLibrary.Pixel pixel = image.getPixel(x, y);
  //       int luminance = imageLibrary.getLuminance(pixel).toInt();
  //       double logLuminance = log(1 + luminance.toDouble()) / log(256); // Логарифмическое преобразование
  //       int newLuminance = (logLuminance * 255).round(); // Масштабирование к диапазону 0-255
  //
  //       // Установка нового значения яркости пикселя в контрастированное изображение
  //       contrastedImage.setPixelRgba(x, y, newLuminance, newLuminance, newLuminance, 255);
  //     }
  //   }
  //
  //   return contrastedImage;
  // }
  //
  // imageLibrary.Image contrastedImage = enhanceContrast(grayscaleImage);

  // Преобразование в unsigned byte
  // for (int y = 0; y < unsignedByteImage.height; y++) {
  //   for (int x = 0; x < unsignedByteImage.width; x++) {
  //     imageLibrary.Pixel pixel = unsignedByteImage.getPixel(x, y);
  //     int luminance = pixel.b.toInt();
  //     int newLuminance = 255 - luminance; // Calculate negative value
  //
  //     // Set pixel value in unsigned byte range
  //     unsignedByteImage.setPixelRgba(x, y, newLuminance, newLuminance, newLuminance, 255);
  //   }
  // }
//  imageLibrary.invert(grayscaleImage);

  // imageLibrary.Image decreaseContrast(imageLibrary.Image? image, {double contrastFactor = 1}) {
  //   // Создание копии входного изображения
  //   imageLibrary.Image contrastedImage = imageLibrary.copyResize(image!, width: image!.width, height: image.height);
  //
  //   for (int y = 0; y < contrastedImage!.height; y++) {
  //     for (int x = 0; x < contrastedImage.width; x++) {
  //       imageLibrary.Pixel pixel = contrastedImage.getPixel(x, y);
  //       int luminance = imageLibrary.getLuminance(pixel).toInt();
  //
  //       // Обратное логарифмическое преобразование для уменьшения контраста
  //       double newLuminance = contrastFactor*(pow(2, luminance.toDouble())-1);
  //
  //
  //       // Преобразование обратно в диапазон от 0 до 255
  //       int newLuminanceInt = (newLuminance * 255).round();
  //
  //       // Установка нового значения яркости пикселя
  //       contrastedImage.setPixelRgba(x, y, newLuminanceInt, newLuminanceInt, newLuminanceInt, 255);
  //     }
  //   }
  //
  //   return contrastedImage;
  // }

//  imageLibrary.Image lowContrastedImage = decreaseContrast(grayscaleImage);

  // Создание списка изображений для отображения
  List<List> images = [
    ['Original image', imageLibrary.encodeJpg(image)],
    ['Halftone 0.5 Gamma-Corrected image', imageLibrary.encodeJpg(gammaCorrectedImage1)],
    ['Halftone Equalized image', imageLibrary.encodeJpg(equalizedImage)],
    ['Halftone image', imageLibrary.encodeJpg(grayscaleImage)]
  ];

  List<int> toneValues = [];

  for (int y = 0; y < grayscaleImage.height; y++) {
    for (int x = 0; x < grayscaleImage.width; x++) {
      imageLibrary.Pixel pixel = grayscaleImage.getPixel(x, y);
      int tone = pixel.b.toInt(); // Используем нужный канал для получения значения тонов
      toneValues.add(tone);
    }
  }

  List<int> toneValues1 = [];
  List<int> toneValues2 = [];
  List<int> toneValues3 = [];

  for (int y = 0; y < grayscaleImage.height; y++) {
    for (int x = 0; x < grayscaleImage.width; x++) {
      imageLibrary.Pixel pixel = grayscaleImage.getPixel(x, y);
      int tone = pixel.b.toInt(); // Используем нужный канал для получения значения тонов
      toneValues1.add(tone);
    }
  }
  for (int y = 0; y < gammaCorrectedImage1.height; y++) {
    for (int x = 0; x < gammaCorrectedImage1.width; x++) {
      imageLibrary.Pixel pixel = gammaCorrectedImage1.getPixel(x, y);
      int tone = pixel.b.toInt(); // Используем нужный канал для получения значения тонов
      toneValues2.add(tone);
    }
  }
  for (int y = 0; y < equalizedImage.height; y++) {
    for (int x = 0; x < equalizedImage.width; x++) {
      imageLibrary.Pixel pixel = equalizedImage.getPixel(x, y);
      int tone = pixel.b.toInt(); // Используем нужный канал для получения значения тонов
      toneValues3.add(tone);
    }
  }

  // Запуск приложения Flutter
  runApp(MyApp(images, toneValues1, toneValues2, toneValues3));
}


class MyApp extends StatelessWidget {
  final List<List> images;
  final List<int> toneValues1;
  final List<int> toneValues2;
  final List<int> toneValues3;

  MyApp(this.images, this.toneValues1, this.toneValues2, this.toneValues3,{super.key});

  @override
  List<ChartData1> histogramData1 = [];
  List<ChartData1> histogramData2 = [];
  List<ChartData1> histogramData3 = [];

  Widget build(BuildContext context) {

    for(int i = 0; i < toneValues1.length; i++){
      histogramData1.add(ChartData1(toneValues1[i]));
    }
    for(int i = 0; i < toneValues2.length; i++){
      histogramData2.add(ChartData1(toneValues2[i]));
    }
    for(int i = 0; i < toneValues3.length; i++){
      histogramData3.add(ChartData1(toneValues3[i]));
    }

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
              const SizedBox(height: 10,),
              const Text('Gamma-Corrected Histograms', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white70),),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: SfCartesianChart(series: <ChartSeries>[
                      HistogramSeries<ChartData1, double>(
                          dataSource: histogramData1,
                          showNormalDistributionCurve: true,
                          curveColor: const Color.fromRGBO(192, 108, 132, 1),
                        //  binInterval: 20,
                          yValueMapper: (ChartData1 data, _) => data.y)]
                    ),
                  ),
                  Card(child: Column(
                    children: [
                      Image.memory(images[3][1], height: 265, width: 265,),
                      Text(images[3][0], style: const TextStyle(fontWeight: FontWeight.bold),),
                      const SizedBox(
                        height: 8,
                      )
                    ],
                  )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: SfCartesianChart(series: <ChartSeries>[
                      HistogramSeries<ChartData1, double>(
                          dataSource: histogramData2,
                          showNormalDistributionCurve: true,
                          curveColor: const Color.fromRGBO(192, 108, 132, 1),
                          //  binInterval: 20,
                          yValueMapper: (ChartData1 data, _) => data.y)]
                    ),
                  ),
                  Card(child: Column(
                    children: [
                      Image.memory(images[1][1], height: 265, width: 265,),
                      Text(images[1][0], style: const TextStyle(fontWeight: FontWeight.bold),),
                      const SizedBox(
                        height: 8,
                      )
                    ],
                  )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: SfCartesianChart(series: <ChartSeries>[
                      HistogramSeries<ChartData1, double>(
                          dataSource: histogramData3,
                          showNormalDistributionCurve: true,
                          curveColor: const Color.fromRGBO(192, 108, 132, 1),
                          //  binInterval: 20,
                          yValueMapper: (ChartData1 data, _) => data.y)]
                    ),
                  ),
                  Card(child: Column(
                    children: [
                      Image.memory(images[2][1], height: 265, width: 265,),
                      Text(images[2][0], style: const TextStyle(fontWeight: FontWeight.bold),),
                      const SizedBox(
                        height: 8,
                      )
                    ],
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
class ChartData1 {
  ChartData1(this.y);
  final int y;
}