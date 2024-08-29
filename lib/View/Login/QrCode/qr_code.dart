import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../Controller/Account/LoginController.dart';

class QrGeneratePage extends StatelessWidget {
  final double size;

  QrGeneratePage({super.key, this.size = 110});

  @override
  Widget build(BuildContext context) {
    String qrCodeData = 'https://thovang5.com/?auth=register&af=}';
    return GetBuilder<QrController>(
      init: QrController(message: qrCodeData),
      builder: (controller) {
        return FutureBuilder(
          future: controller.loadQrCode(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(width: size, height: size);
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SizedBox(
                width: size,
                height: size,
                child: _buildQrImage(controller),
              );
            }
          },
        );
      },
    );
  }

  QrImageView _buildQrImage(QrController controller) {
    return QrImageView(
      data: controller.concatMsg,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Colors.black,
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: Colors.black,
      ),
      padding: EdgeInsets.zero,
      size: size,
      embeddedImage: const AssetImage('asset/images/img_embedded_qr.png'),
      embeddedImageStyle: const QrEmbeddedImageStyle(
        size: Size.square(40),
      ),
      embeddedImageEmitsError: true,
    );
  }
}
