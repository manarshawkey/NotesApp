import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'NotesDBWorker.dart';
import 'NotesModel.dart' show notesModel, NotesModel;
class NotesEntry extends StatelessWidget {
  final TextEditingController _titleEditorController = TextEditingController();
  final TextEditingController _contentEditorController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  NotesEntry(){
    _titleEditorController.addListener(() {
      notesModel.entityBeingModified.title = _titleEditorController.text;
    });
    _contentEditorController.addListener(() {
      notesModel.entityBeingModified.content = _contentEditorController.text;
    });
  }
  @override
  Widget build(BuildContext context) {
    _titleEditorController.text = notesModel.entityBeingModified.title;
    _contentEditorController.text = notesModel.entityBeingModified.content;

    return ScopedModel(
      model: notesModel,
      child: ScopedModelDescendant<NotesModel>(
        builder: (BuildContext inContext, Widget inChild, NotesModel inModel){
          return Scaffold(
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Row(
                children: [
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: (){
                      FocusScope.of(inContext).requestFocus(FocusNode());
                      inModel.setStackIndex(0);
                    },
                  ),
                  Spacer(),
                  FlatButton(
                    child: Text("Save"),
                    onPressed: (){
                      _save(inContext, notesModel);
                    },
                  )
                ],
              ),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.title),
                    title: TextFormField(
                      decoration: InputDecoration(hintText: "Title"),
                      controller: _titleEditorController,
                      validator: (String inValue){
                        if(inValue.length == 0){
                          return "Please Enter a title!";
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.content_paste),
                    title: TextFormField(
                      decoration: InputDecoration(hintText: "Content"),
                      controller: _contentEditorController,
                      validator: (String inVal){
                        if(inVal.length == 0){
                          return "Please Enter some content!";
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.color_lens_rounded),
                    title: Row(
                      children: [
                        GestureDetector(
                          child: Container(
                            decoration: ShapeDecoration(
                              shape: Border.all(width: 18, color: Colors.red) +
                                Border.all(width: 6,
                                color: notesModel.color == "red"?
                                Colors.red : Theme.of(inContext).canvasColor
                                ),
                            ),
                          ),
                          onTap: (){
                            notesModel.entityBeingModified.color = "red";
                            notesModel.setColor("red");
                          },
                        ),
                        Spacer(),
                        GestureDetector(
                          child: Container(
                            decoration: ShapeDecoration(
                              shape: Border.all(width: 18, color: Colors.yellow) +
                                  Border.all(width: 6,
                                      color: notesModel.color == "yellow"?
                                      Colors.yellow : Theme.of(inContext).canvasColor
                                  ),
                            ),
                          ),
                          onTap: (){
                            notesModel.entityBeingModified.color = "yellow";
                            notesModel.setColor("yellow");
                          },
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ) ;
  }
  void _save(BuildContext inContext, NotesModel inModel) async {
    if(!_formKey.currentState.validate()){return;}
    if(inModel.entityBeingModified.id == null){
      await NotesDBWorker.db.create(inModel.entityBeingModified);
    } else {
      await NotesDBWorker.db.update(notesModel.entityBeingModified);
    }
    notesModel.loadData("notes", NotesDBWorker.db);
    inModel.setStackIndex(0);
    Scaffold.of(inContext).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
          content: Text("Note Saved Successfully!"),
      ),
    );
  }

}
