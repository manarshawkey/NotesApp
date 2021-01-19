import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'NotesDBWorker.dart';
import 'NotesModel.dart' show Note, notesModel, NotesModel;
class NotesList extends StatelessWidget {
  NotesList();
  @override
  Widget build(BuildContext context) {
    return ScopedModel<NotesModel>(
        model: notesModel,
        child: ScopedModelDescendant<NotesModel>(
            builder: (BuildContext inContext, Widget inChild, NotesModel inModel){
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add, color: Colors.white,),
                  onPressed: (){
                    notesModel.entityBeingModified = Note();
                    notesModel.setColor(null);
                    notesModel.setStackIndex(1);
                  },
                ),
                body: ListView.builder(
                  itemCount: notesModel.entityList.length,
                    itemBuilder: (BuildContext inBuildContext, int inIndex){
                      Note note = notesModel.entityList[inIndex];
                      Color color = Colors.white;
                      switch(note.color){
                        case "red": color = Colors.red; break;
                        case "green": color = Colors.green; break;
                        case "yellow": color = Colors.yellow; break;
                        case "grey": color = Colors.grey; break;
                        case "purple": color = Colors.purple; break;
                        case "blue": color = Colors.blue; break;
                      }
                      return Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Slidable(
                          delegate: SlidableDrawerDelegate(),
                          actionExtentRatio: 0.25,
                          secondaryActions: [
                            IconSlideAction(
                              icon: Icons.delete,
                              caption: "Delete",
                              color: Colors.red,
                            onTap: (){_deleteNote(inContext, note);},)
                          ],
                          child: Card(
                            elevation: 8,
                            color: color,
                            child: ListTile(
                              title: Text("${note.title}"),
                              subtitle: Text("${note.content}"),
                              onTap: () async {
                                notesModel.entityBeingModified = await NotesDBWorker.db.get(note.id);
                                notesModel.setColor(notesModel.entityBeingModified.color);
                                notesModel.setStackIndex(1);
                              },
                            ),
                          ),
                        ),
                      );
                    }
                ),
              );
            }
        )
    );
  }
  Future _deleteNote(BuildContext inContext, Note inNote) {
    return showDialog(
        context: inContext,
        barrierDismissible: false,
        builder: (BuildContext inAlertContext){
          return AlertDialog(
            title: Text("Delete Note"),
            content: Text("Are you sure you want to delete this note: ${inNote.title}?"),
            actions: [
              FlatButton(onPressed: (){Navigator.of(inAlertContext).pop();},
                  child: Text("Cancel"),
              ),
              FlatButton(
                child: Text("Delete"),
                onPressed: ()async{
                  await NotesDBWorker.db.delete(inNote.id);
                  Navigator.of(inAlertContext).pop();
                  Scaffold.of(inContext).showSnackBar(
                    SnackBar(
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                        content: Text("Note Deleted!")
                    )
                  );
                  notesModel.loadData("notes", NotesDBWorker.db);
                },
              ),
            ],
          );
        }
    );
  }
}
