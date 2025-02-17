// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter App Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineLarge,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ),
//     );
//   }

//   @override
//   void didUpdateWidget(covariant MyHomePage oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     print("didUpdateWidget called");
//   }

//   @override
//   void deactivate() {
//     super.deactivate();
//     print("deactivate called");
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     print("dispose called");
//   }
//}
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: JobBoard(),
  ));
}

enum TaskStatus { todo, inProgress, done }

class Task {
  String name;
  TaskStatus status;

  Task(this.name, this.status);
}

class JobBoard extends StatefulWidget {
  @override
  _JobBoardState createState() => _JobBoardState();
}

class _JobBoardState extends State<JobBoard> {
  List<Task> tasks = [
    Task("QA Testing", TaskStatus.todo),
    Task("API Integration", TaskStatus.todo),
    Task("New Task", TaskStatus.inProgress),
    Task("Development", TaskStatus.done),
    Task("Design UI", TaskStatus.done),
  ];

  void addTask(String taskName) {
    setState(() {
      tasks.add(Task(taskName, TaskStatus.todo));
    });
  }

  void showAddTaskDialog() {
    TextEditingController taskController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Task"),
          content: TextField(
            controller: taskController,
            decoration: InputDecoration(hintText: "Enter task name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  addTask(taskController.text);
                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Job Board"),
        actions: [
          ElevatedButton(
            onPressed: showAddTaskDialog,
            child: Text("Add Task"),
          ),
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildTaskColumn("To Do", TaskStatus.todo),
          buildTaskColumn("In Progress", TaskStatus.inProgress),
          buildTaskColumn("Done", TaskStatus.done),
        ],
      ),
    );
  }

  Widget buildTaskColumn(String title, TaskStatus status) {
    return Expanded(
      child: DragTarget<Task>(
        onAccept: (task) {
          setState(() {
            task.status = status;
          });
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(title,
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                Divider(color: Colors.white),
                for (Task task in tasks.where((t) => t.status == status))
                  buildDraggableTask(task),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildDraggableTask(Task task) {
    return Draggable<Task>(
      data: task,
      feedback: Material(
        color: Colors.transparent,
        child: Text(task.name,
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                backgroundColor: Colors.red)),
      ),
      childWhenDragging: Opacity(opacity: 0.5, child: taskCard(task.name)),
      child: taskCard(task.name),
    );
  }

  Widget taskCard(String taskName) {
    return Card(
      color: Colors.red[700],
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(taskName, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
