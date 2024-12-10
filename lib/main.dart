import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Extra Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 151, 112, 249)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Extra Notes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _notes = [];
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _addNote() {
    setState(() {
      _notes.add(_controller.text);
      _listKey.currentState?.insertItem(_notes.length - 1);
      _controller.clear();
    });
  }

  void _editNote(int index) {
    _controller.text = _notes[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Enter a note',
            ),
            autocorrect: false,
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _notes[index] = _controller.text;
                  _controller.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _removeNote(int index) {
    setState(() {
      final removedNote = _notes.removeAt(index);
      _listKey.currentState?.removeItem(
        index,
        (context, animation) => _buildItem(removedNote, animation),
      );
    });
  }

  void _moveNoteUp(int index) {
    if (index > 0) {
      setState(() {
        final note = _notes.removeAt(index);
        _listKey.currentState?.removeItem(
          index,
          (context, animation) => _buildItem(note, animation),
        );
        _notes.insert(index - 1, note);
        _listKey.currentState?.insertItem(index - 1);
      });
    }
  }

  void _moveNoteDown(int index) {
    if (index < _notes.length - 1) {
      setState(() {
        final note = _notes.removeAt(index);
        _listKey.currentState?.removeItem(
          index,
          (context, animation) => _buildItem(note, animation),
        );
        _notes.insert(index + 1, note);
        _listKey.currentState?.insertItem(index + 1);
      });
    }
  }

  Widget _buildItem(String note, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Text(
            note,
            style: const TextStyle(color: Colors.white),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () => _editNote(_notes.indexOf(note)),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.white),
                onPressed: () => _removeNote(_notes.indexOf(note)),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_upward, color: Colors.white),
                onPressed: () => _moveNoteUp(_notes.indexOf(note)),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_downward, color: Colors.white),
                onPressed: () => _moveNoteDown(_notes.indexOf(note)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 48, 0, 81),
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                autocorrect: false,
              ),
            ),
            ElevatedButton(
              onPressed: _addNote,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Add Note'),
            ),
            Expanded(
              child: AnimatedList(
                key: _listKey,
                initialItemCount: _notes.length,
                itemBuilder: (context, index, animation) {
                  return _buildItem(_notes[index], animation);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}