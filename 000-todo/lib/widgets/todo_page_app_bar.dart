import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/todo_cubit.dart';

class TodoPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TodoPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('Todo'),
          if (MediaQuery.of(context).size.width > 600) ...const [
            SizedBox(width: 20),
            _TodoStatus(),
          ]
        ],
      ),
      actions: MediaQuery.of(context).size.width > 600
          ? null
          : const [
              Center(
                widthFactor: 2,
                child: _TodoStatus(),
              ),
            ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TodoStatus extends StatelessWidget {
  const _TodoStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      buildWhen: (previous, current) {
        return previous.todos.length != current.todos.length ||
            previous.doneCount != current.doneCount;
      },
      builder: (context, state) {
        if (state.todos.isEmpty) return const SizedBox.shrink();

        return Text(
          '${state.doneCount}/${state.todos.length}',
          key: const Key('todo-status-text-key'),
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.white),
        );
      },
    );
  }
}
