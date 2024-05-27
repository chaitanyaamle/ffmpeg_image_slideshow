import 'dart:io';
import 'dart:typed_data';

import 'package:ffmpeg_image_slideshow/home_ui/home.dart';
import 'package:ffmpeg_image_slideshow/home_ui/home_resources.dart';
import 'package:ffmpeg_kit_flutter_video/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_video/ffmpeg_kit_config.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';


abstract class HomeViewModel extends State<Home> with HomeResources {

  // final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  // final FlutterFFmpegConfig _flutterFFmpegConfig = FlutterFFmpegConfig();
  VideoPlayerController? videoController;

  @override
  void initState() {
    assignOutputUrl();
    super.initState();
  }

  Widget buildColorPicker() => ColorPicker(
      pickerColor: color,
      onColorChanged: (_color) {
        setState(() {
          color = _color;
        });
      });

  void pickColor(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pick you Color"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildColorPicker(),
            TextButton(
              child: const Text("SELECT"),
              onPressed: () => Navigator.of(context).pop(),

            ),
          ],
        ),
      )
  );

  Future<void> openImages() async {
    var pickedFiles = await imagePicker.pickMultiImage();
    if(pickedFiles != null){
      imageFiles = pickedFiles;
      setState(() { });
    }
    else{
        print("No image is selected");
    }
  }

  static Future<Directory> get tempDirectory async {
    return await getTemporaryDirectory();
  }

  Future<void> imageFilePick1() async {
    PickedFile? result = await ImagePicker().getImage(
      source: ImageSource.gallery,
      // imageQuality: 40,
      maxWidth: 427,
      maxHeight: 640,
    );

    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['jpg'],
    // );

    if (result != null) {
      setState(() {
        imageFile = File(result.path);
        imageUrl1 = imageFile?.path;
        // ignore: avoid_print
        print(">>>>> ${imageFile?.path}");
      });
    } else {
      // User canceled the picker
    }
  }

  Future<void> imageFilePick2() async {
    PickedFile? result = await ImagePicker().getImage(
      source: ImageSource.gallery,
      // imageQuality: 40,
      maxWidth: 427,
      maxHeight: 640,
    );

    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ["jpg"]
    // );

    if (result != null) {
      setState(() {
        imageFile = File(result.path);
        imageUrl2 = imageFile?.path;
        // ignore: avoid_print
        print(">>>>> ${imageFile?.path}");
      });
    } else {
      // User canceled the picker
    }
  }

  Future<void> imageFilePick3() async {
    PickedFile? result = await ImagePicker().getImage(
      source: ImageSource.gallery,
      // imageQuality: 40,
      maxWidth: 427,
      maxHeight: 640,
    );

    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ["jpg"]
    // );

    if (result != null) {
      setState(() {
        imageFile = File(result.path);
        imageUrl3 = imageFile?.path;
        // ignore: avoid_print
        print(">>>>> ${imageFile?.path}");
      });
    } else {
      // User canceled the picker
    }
  }

  Future<void> share() async {
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    // Directory? dir = Directory('/storage/emulated/0/Download');
    File testFile = File("${directory!.path}/ISWT.mp4");
    if (!await testFile.exists()) {
      await testFile.create(recursive: true);
      testFile.writeAsStringSync("test for share documents file");
    }
    print(testFile);
    // FlutterShare.shareFile(filePath: testFile.path, title: 'Flutter App');
    Share.shareFiles([testFile.path]);
    // ShareExtend.share(testFile.path, "file");
  }

  Future<void> mergeFiles() async {

    List _textSplit = text.replaceAll("\'", "\u2019").split('\n');
    int size = _textSplit.length-1;
    print(size);

    String color = strColor;

    String assetName = font;

    final ByteData assetByteData = await rootBundle.load('fonts/$assetName');

    final List<int> byteList = assetByteData.buffer
        .asUint8List(assetByteData.offsetInBytes, assetByteData.lengthInBytes);

    final String fullTemporaryPath =
    join((await tempDirectory).path, assetName);

    Future<File> fileFuture = File(fullTemporaryPath)
        .writeAsBytes(byteList, mode: FileMode.writeOnly, flush: true);

    print('fonts/$assetName saved to file at $fullTemporaryPath');

    var fontNameMapping = <String, String>{};
    fontNameMapping["FontName"] = assetName;

    HomeViewModel.tempDirectory.then((tempDirectory) {
      FFmpegKitConfig.setFontDirectory(tempDirectory.path,fontNameMapping);
      // _flutterFFmpegConfig.setFontDirectory(tempDirectory.path,fontNameMapping);
    });

    String text1 = "Sample Text";
    String text2 = "to check";
    String text3 = "image as video";

    String alphaFilter = "alpha=if(lt(t\\\,0.3)\\\,0\\\,if(lt(t\\\,1.0)\\\,(t-0.3)/1\\\,if(lt(t\\\,2.3)\\\,1\\\,if(lt(t\\\,2.7)\\\,(1-(t-2.3))/1\\\,0))))";

    String fadeInFadeOut = "fade=t=in:st=0:d=1,fade=t=out:st=3:d=1";

    String drawText = "drawtext=$assetName:$alphaFilter:text=${_textSplit[0]}:x=(w-text_w)/2:y=(h-text_h)/2:fontsize=(w+h)/12:fontcolor=$color:line_spacing=8:shadowcolor=black:shadowx=2:shadowy=2";
    String drawText2 = "drawtext=$assetName:$alphaFilter:text='${_textSplit[1]}':x=(w-text_w)/2:y=(h-text_h)/2:fontsize=(w+h)/12:fontcolor=$color:line_spacing=8:shadowcolor=black:shadowx=2:shadowy=2";
    String drawText3 = "drawtext=$assetName:$alphaFilter:text='${_textSplit[2]}':x=(w-text_w)/2:y=(h-text_h)/2:fontsize=(w+h)/12:fontcolor=$color:line_spacing=8:shadowcolor=black:shadowx=2:shadowy=2";

    //image as video for 5 seconds
    // String commandToExecute = "-hide_banner -y -loop 1 -t 10 -i $imageUrl1 -c:v mpeg4 -qscale 15 -r 30 $outputUrl";
    //image as video with fadeIn - fadeOut text
    // String commandToExecute = "-loop 1 -t 4 -i $imageUrl1 -vf '$drawText' -shortest -c:v mpeg4 -r 30 -y $outputUrl";
    //image as video with fadeIn - fadeOut image
    // String commandToExecute = "-loop 1 -t 4 -i $imageUrl1 -filter_complex $fadeInFadeOut1 -shortest -c:v mpeg4 -r 30 -y $outputUrl";
    //one image as video with fadeIn - fadeOut image and text
    // String commandToExecute = "-loop 1 -t 4 -i $imageUrl1 -filter_complex '[0:v]$drawText[outv]' -map '[outv]' -shortest -c:v mpeg4 -r 30 -y $outputUrl";

    // String commandToExecute = "-framerate 1/5 -i $imageUrl1 -c:v mpeg4 -r 30 -pix_fmt yuv420p -s 720x480 -b:v 1000k -y $outputUrl";

    // String commandToExecute = "-loop 1 -t 3 -i $imageUrl1 -loop 1 -t 3 -i $imageUrl2 -loop 1 -t 3 -i $imageUrl3 -filter_complex $filter_complex -map '[v]' -shortest -c:v mpeg4 -r 30 -y $outputUrl";

    //three images with fadeIn - fadeOut image and text
    String commandToExecute = "-hide_banner -y -loop 1 -i '" +
        imageUrl1! +
        "' " +
        "-loop 1 -i '" +
        imageUrl2! +
        "' " +
        "-loop 1 -i '" +
        imageUrl3! +
        "' " +
        "-f lavfi -i color=black:s=427x640 " +
        "-filter_complex \"" +
        "[0:v]setpts=PTS-STARTPTS,scale=w=\'if(gte(iw/ih,640/427),min(iw,427),-1)\':h=\'if(gte(iw/ih,640/427),-1,min(ih,640))\',scale=trunc(iw/2)*2:trunc(ih/2)*2,setsar=sar=1/1[stream1out];" +
        "[1:v]setpts=PTS-STARTPTS,scale=w=\'if(gte(iw/ih,640/427),min(iw,427),-1)\':h=\'if(gte(iw/ih,640/427),-1,min(ih,640))\',scale=trunc(iw/2)*2:trunc(ih/2)*2,setsar=sar=1/1[stream2out];" +
        "[2:v]setpts=PTS-STARTPTS,scale=w=\'if(gte(iw/ih,640/427),min(iw,427),-1)\':h=\'if(gte(iw/ih,640/427),-1,min(ih,640))\',scale=trunc(iw/2)*2:trunc(ih/2)*2,setsar=sar=1/1[stream3out];" +
        "[stream1out]$drawText,pad=width=427:height=640:x=(427-iw)/2:y=(640-ih)/2:color=black,trim=duration=4,$fadeInFadeOut[stream1overlaid];" +
        "[stream2out]$drawText2,pad=width=427:height=640:x=(427-iw)/2:y=(640-ih)/2:color=black,trim=duration=4,$fadeInFadeOut[stream2overlaid];" +
        "[stream3out]$drawText3,pad=width=427:height=640:x=(427-iw)/2:y=(640-ih)/2:color=black,trim=duration=4,$fadeInFadeOut[stream3overlaid];" +
        "[stream1overlaid][stream2overlaid][stream3overlaid]concat=n=3:v=1:a=0,scale=w=426:h=639,format=yuv420p[video]\"" +
        " -map [video] -vsync 2 -async 1 -c:v mpeg4 -qscale 4 -preset slower -r 30 " +
        outputUrl;


    // String commandToExecute = "-hide_banner -y -loop 1 -i \"" +
    //     imageUrl1! +
    //     "\" " +
    //     "-loop 1 -i '" +
    //     imageUrl2! +
    //     "' " +
    //     "-loop 1 -i " +
    //     imageUrl3! +
    //     " " +
    //     "-f lavfi -i color=black:s=640x427 " +
    //     "-filter_complex \"" +
    //     "[0:v]setpts=PTS-STARTPTS,scale=w=\'if(gte(iw/ih,640/427),min(iw,640),-1)\':h=\'if(gte(iw/ih,640/427),-1,min(ih,427))\',scale=trunc(iw/2)*2:trunc(ih/2)*2,setsar=sar=1/1[stream1out];" +
    //     "[1:v]setpts=PTS-STARTPTS,scale=w=\'if(gte(iw/ih,640/427),min(iw,640),-1)\':h=\'if(gte(iw/ih,640/427),-1,min(ih,427))\',scale=trunc(iw/2)*2:trunc(ih/2)*2,setsar=sar=1/1[stream2out];" +
    //     "[2:v]setpts=PTS-STARTPTS,scale=w=\'if(gte(iw/ih,640/427),min(iw,640),-1)\':h=\'if(gte(iw/ih,640/427),-1,min(ih,427))\',scale=trunc(iw/2)*2:trunc(ih/2)*2,setsar=sar=1/1[stream3out];" +
    //     "[stream1out]pad=width=640:height=427:x=(640-iw)/2:y=(427-ih)/2:color=#00000000,trim=duration=3[stream1overlaid];" +
    //     "[stream2out]pad=width=640:height=427:x=(640-iw)/2:y=(427-ih)/2:color=#00000000,trim=duration=3[stream2overlaid];" +
    //     "[stream3out]pad=width=640:height=427:x=(640-iw)/2:y=(427-ih)/2:color=#00000000,trim=duration=3[stream3overlaid];" +
    //     "[3:v][stream1overlaid]overlay=x=\'2*mod(n,4)\':y=\'2*mod(n,2)\',trim=duration=3[stream1shaking];" +
    //     "[3:v][stream2overlaid]overlay=x=\'2*mod(n,4)\':y=\'2*mod(n,2)\',trim=duration=3[stream2shaking];" +
    //     "[3:v][stream3overlaid]overlay=x=\'2*mod(n,4)\':y=\'2*mod(n,2)\',trim=duration=3[stream3shaking];" +
    //     "[stream1shaking][stream2shaking][stream3shaking]concat=n=3:v=1:a=0,scale=w=640:h=424,format=yuv420p[video]\"" +
    //     " -map [video] -vsync 2 -async 1 -c:v mpeg4 -r 30 " +
    //     outputUrl;

    // String strCommand = "ffmpeg -loop 1 -t 3 -i " + /sdcard/videokit/1.jpg + " -loop 1 -t 3 -i " + /sdcard/videokit/2.jpg + " -loop 1 -t 3 -i " + /sdcard/videokit/3.jpg + " -loop 1 -t 3 -i " + /sdcard/videokit/4.jpg + " -filter_complex [0:v]trim=duration=3,fade=t=out:st=2.5:d=0.5[v0];[1:v]trim=duration=3,fade=t=in:st=0:d=0.5,fade=t=out:st=2.5:d=0.5[v1];[2:v]trim=duration=3,fade=t=in:st=0:d=0.5,fade=t=out:st=2.5:d=0.5[v2];[3:v]trim=duration=3,fade=t=in:st=0:d=0.5,fade=t=out:st=2.5:d=0.5[v3];[v0][v1][v2][v3]concat=n=4:v=1:a=0,format=yuv420p[v] -map [v] -preset ultrafast " + /sdcard/videolit/output.mp4;

    // _flutterFFmpeg.execute(commandToExecute).then((value) {
    //   setState(() {
    //     outputUrlName = outputUrl;
    //     videoController = VideoPlayerController.file(File(outputUrl))
    //       ..initialize().then((val) {
    //         setState(() {
    //           assetName = "";
    //         });
    //       });
    //   });
    // });

    FFmpegKit.execute(commandToExecute).then((value) {
      setState(() {
        outputUrlName = outputUrl;
        videoController = VideoPlayerController.file(File(outputUrlName!))
          ..initialize().then((val) {
            setState(() {
              HomeResources.change = false;
              assetName = "";
            });
          });
      });
      // ignore: avoid_print
      print("DURUM: $value");
    });

  }

  Future<void> storagePermissionRequest() async {
    final status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      // ignore: avoid_print
      print('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      // ignore: avoid_print
      print('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      // ignore: avoid_print
      print('Permission Permanently Denied');
    }
  }

  void assignOutputUrl() async {
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    File testFile = File("${directory!.path}/ISWT.mp4");
    // if (!await testFile.exists()) {
    //   await testFile.create(recursive: true);
    //   testFile.writeAsStringSync("test for share documents file");
    // }
    outputUrl = testFile.path;
    print("OUTPUT URL: $outputUrl");
  }

  @override
  void dispose() {
    super.dispose();
  }
}