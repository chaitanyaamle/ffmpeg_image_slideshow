import 'dart:io';

import 'package:ffmpeg_image_slideshow/home_ui/home_resources.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:video_player/video_player.dart';

import 'home_view_model.dart';


class HomeView extends HomeViewModel {

  List<TextEditingController> _controllers = [];
  List<TextField> _fields = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            setState(() {
              outputUrlName = null;
              HomeResources.change = false;
            });
          } , icon: const Icon(Icons.home, size: 30,))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              outputUrlName == null ? HomeResources.change == false ? Column(
                children: [
                  // const SizedBox(height: 10,),
                  // Text("Image1: >>> $imageUrl1"),
                  // Text("Image2: >>> $imageUrl2"),
                  // Text("Image3: >>> $imageUrl3"),
                  // Text("Output: >>> $outputUrlName"),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: imageUrl1 != "" ? Colors.green : Colors.redAccent
                        ),
                        child: const Text("Pick Image1"),
                        onPressed: () => imageFilePick1()
                      ),
                      const SizedBox(width: 5,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: imageUrl2 != "" ? Colors.green : Colors.redAccent
                        ),
                        child: const Text("Pick Image2"),
                        onPressed: () => imageFilePick2()
                      ),
                      const SizedBox(width: 5,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: imageUrl3 != "" ? Colors.green : Colors.redAccent
                        ),
                        child: const Text("Pick Image3"),
                        onPressed: () => imageFilePick3()
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Column(
                    children: [
                      SizedBox(
                        height: 38,
                        width: 145,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: _fields.length == 3 ? Colors.green : Colors.redAccent
                          ),
                          onPressed: () {
                            final controller = TextEditingController();
                            final field = TextField(
                              controller: controller,
                              maxLength: 20,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: "text ${_controllers.length + 1}",
                              ),
                            );

                            setState(() {
                              if(_fields.length < 3 && imageUrl1 != "" && imageUrl2 != "" && imageUrl3 != ""){
                                _controllers.add(controller);
                                _fields.add(field);
                              }
                            });
                          },
                          child: const Text("Add Input Field"),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Column(
                        children: [
                          const Text("Pick Color"),
                          const SizedBox(height: 5,),
                          GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: color,
                              ),
                              width: 320,
                              height: 40,
                            ),
                            onTap: () => pickColor(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Column(
                        children: [
                          const Text("Pick Font"),
                          DropdownButton(
                            value: fontName,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: fonts.map((items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items, style: TextStyle(fontSize: 25, fontFamily: items, fontWeight: FontWeight.w400),),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                font = fontNameList[fonts.indexOf(value!)];
                                fontName = value;
                                print("FontName: $fontName >>> Font: $font");
                              });
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ) : Container() : Container(),
              const SizedBox(height: 10,),
              outputUrlName != null ? Row(
                mainAxisAlignment: MainAxisAlignment.center ,
                children: [
                  SizedBox(
                    height: 38,
                    width: 140,
                    child: ElevatedButton(
                      onPressed: () => share(),
                      child: const Text("Share Video"),
                    ),
                  ),
                  const SizedBox(width: 30,),
                  SizedBox(
                    height: 38,
                    width: 140,
                    child: ElevatedButton(
                      onPressed: () {
                        GallerySaver.saveVideo(outputUrl);
                      },
                      child: const Text("Download Video"),
                    ),
                  ),
                ],
              ) : Container(),
              outputUrlName != null ? Column(
                children: [
                  const Divider(),
                  Container(
                    width: 270,
                    height: 600,
                    color: Colors.black,
                    child: VideoPlayer(videoController!),
                  ),
                  const Divider(),
                ],
              ) : HomeResources.change != true
                ? SizedBox(
                height: 350,
                child: Column(
                  children: [
                    Expanded(child: _listView()),
                    _fields.isNotEmpty ? ElevatedButton(
                      child: const Icon(Icons.check, size: 30, color: Colors.white,),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15),
                      ),
                      onPressed: () {
                        setState(() {
                          HomeResources.change = true;
                          text = _controllers
                              .fold("", (acc, element) => acc += "${element.text}\n");
                          strColor = color.toString().substring(10,16);
                          print(text);
                        });
                        mergeFiles(); },) : Container(),
                  ],
                ),
              ) : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: LinearProgressIndicator(),
                  ),
                  SizedBox(height: 10,),
                  Text("Loading...", style: TextStyle(fontSize: 16.0),)
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: outputUrlName != null ? FloatingActionButton(
        child: Icon(
          videoController != null
              ? videoController!.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow
              : Icons.pause,
        ),
        onPressed: () {
          setState(() {
            if (videoController != null) {
              videoController!.value.isPlaying ? videoController?.pause() : videoController?.play();
            }
          });
        },
      ) : null ,
    );
  }

  Widget _listView() {
    return ListView.builder(
      itemCount: _fields.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(5),
          child: _fields[index],
        );
      },
    );
  }

}

// imageFiles != null ? Wrap(
// children: imageFiles!.map((image) {
// return Card(
// child: SizedBox(
// height: 100,
// width: 100,
// child: Image.file(File(image.path)),
// ),
// );
// }).toList(),
// ) : Container(),
