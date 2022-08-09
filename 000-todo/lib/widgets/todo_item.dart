import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/todo_cubit.dart';
import '../models/models.dart';
import 'todo_form.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleMedium?.copyWith(
          decoration: todo.isDone ? TextDecoration.lineThrough : null,
          fontWeight: todo.isDone ? null : FontWeight.w500,
        );
    return Dismissible(
      key: ValueKey(todo),
      direction: DismissDirection.endToStart,
      background: const ColoredBox(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 25),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      child: CheckboxListTile(
        value: todo.isDone,
        title: Text(todo.title, style: style),
        subtitle: todo.description.isNotEmpty ? Text(todo.description) : null,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (_) {
          context.read<TodoCubit>().toggleIsDone(todo);
        },
        secondary: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Edit',
              onPressed: () => _onEditTap(context),
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<TodoCubit>().deleteTodo(todo);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onEditTap(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: TodoForm(todo: todo),
      ),
    );
  }
}
