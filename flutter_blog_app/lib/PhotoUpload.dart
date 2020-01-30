import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'HomePage.dart';


class UploadPhotoPage extends StatefulWidget
{
  State<StatefulWidget> createState()
  {
    return _UploadPhotoPageState();
  }
}

class _UploadPhotoPageState extends State<UploadPhotoPage>
{
  File sampleImage;
  String _myValue;
  String url;
  final formKey = new GlobalKey<FormState>();

  Future getImage() async
  {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(()
    {
      sampleImage = tempImage;
    });
  }

  bool validateAndSave()
  {
    final form = formKey.currentState;

    if(form.validate())
      {
        form.save();
        return true;
      }

      else
        {
          return false;
        }
  }

  void uploadStatusImage() async
  {
    if(validateAndSave())
      {
        final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post Images");

        var timeKey = new DateTime.now();

        final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);

        var ImageUrl = await(await uploadTask.onComplete).ref.getDownloadURL();

        url = ImageUrl.toString();
        
        print("Image Url = " + url);

        goToHomePage();
        saveToDatabase(url);
      }
  }

  void saveToDatabase(url)
  {
    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('MMM d, yyyy');
    var formatTime = new DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data =
        {
          "image" : url,
          "description": _myValue,
          "data": date,
          "time": time,
        };

    ref.child("Posts").push().set(data);

  }

  void goToHomePage()
  {
    Navigator.push
    (
        context,
        MaterialPageRoute(builder: (context)
    {
      return new HomePage();
    }
    )
    );
  }

  @override
  Widget build(BuildContext context)
  {

    return new Scaffold
      (
        appBar: new AppBar
          (
            title: new Text("Upload Image"),
            centerTitle: true,
          ),
      body: new Center
        (
          child: sampleImage == null? Text("Select an Image"): enableUpload(),
        ),

      floatingActionButton: new FloatingActionButton
        (
          onPressed: getImage,
          tooltip: 'Add Image',
          child: new Icon(Icons.add_a_photo),
        ),

      );
  }

  Widget enableUpload()
  {
    return  Container
      (
        child: new Form
          (
          key: formKey,

          child: Column
            (
            children: <Widget>
            [
              Image.file(sampleImage, height: 330.0, width: 660.0,),

              SizedBox(height: 15.0,),

              TextFormField
                (
                decoration: new InputDecoration(labelText: 'Description'),

                validator: (value)
                {
                  return value.isEmpty ? 'Blog Description is required' :null;
                },

                onSaved:(value)
                {
                  _myValue = value;
                },
              ),

              SizedBox(height: 15.0,),

              RaisedButton

                (
                  elevation: 10.0,
                  child: Text("Add New Post"),
                  textColor: Colors.white,
                  color: Colors.pink,

                  onPressed: uploadStatusImage,
                )

            ],
          ),
          ),
      );
  }
}