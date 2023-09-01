import 'package:flutter/material.dart';

void main() {
  runApp(NoteApp());
}

class NoteApp extends StatefulWidget {
  @override
  _NoteAppState createState() => _NoteAppState();
}

class _NoteAppState extends State<NoteApp> {
  List<Note> notes = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Notes'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddNoteDialog(
                  onNoteAdded: (Note note) {
                    setState(() {
                      notes.add(note);
                    });
                  },
                );
              },
            );
          },
        ),
        body: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                setState(() {
                  notes.removeAt(index);
                });
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: NoteCard(note: notes[index]),
            );
          },
        ),
      ),
    );
  }

  NoteCard({required Note note}) {}
}

class Note {
  final String text;
  final Color color;

  Note({
    required this.text,
    required this.color,
  });
}

class AddNoteDialog extends StatefulWidget {
  final Function(Note) onNoteAdded;

  AddNoteDialog({required this.onNoteAdded});

  @override
  _AddNoteDialogState createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  late TextEditingController _textController;
  Color _selectedColor = Colors.yellow;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Note'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              labelText: 'Text',
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Color:'),
              DropdownButton<Color>(
                value: _selectedColor,
                onChanged: (Color? color) {
                  setState(() {
                    _selectedColor = color!;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: Colors.yellow,
                    child: Text('Yellow'),
                  ),
                  DropdownMenuItem(
                    value: Colors.green,
                    child: Text('Green'),
                  ),
                  DropdownMenuItem(
                    value: Colors.blue,
                    child: Text('Blue'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Add'),
          onPressed: () {
            String text = _textController.text;
            if (text.isNotEmpty) {
              Note note = Note(
                text: text,
                color: _selectedColor,
              );
              widget.onNoteAdded(note);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
