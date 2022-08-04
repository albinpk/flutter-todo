import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo/cubit/todo_cubit.dart';
import 'package:todo/models/models.dart';
import 'package:todo/widgets/widgets.dart';

import '../mocks/fake_todo.dart';
import '../mocks/mock_todo_cubit.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(FakeTodo());
  });

  late TodoCubit todoCubit;

  setUp(() {
    todoCubit = MockTodoCubit();
  });

  testWidgets(
    'TodoForm should have a title, Form, TextFormField '
    'and Cancel & Save buttons. '
    'And it should show error text on form validation '
    'and should call TodoCubit.addTodo() on save',
    (tester) async {
      await tester.pumpWidget(
        BlocProvider<TodoCubit>(
          create: (context) => todoCubit,
          child: const MaterialApp(
            home: Scaffold(body: TodoForm()),
          ),
        ),
      );

      final todoTitleField = find.byType(TextFormField);
      final todoTitleFieldErrorText = find.text('Please enter todo title');
      final cancelButton = find.text('Cancel');
      final saveButton = find.text('Save');

      expect(find.byType(Form), findsOneWidget);
      expect(find.text('New Todo'), findsOneWidget);
      expect(todoTitleField, findsOneWidget);
      expect(todoTitleFieldErrorText, findsNothing);
      expect(cancelButton, findsOneWidget);
      expect(saveButton, findsOneWidget);

      await tester.tap(saveButton);
      await tester.pump();

      verifyNever(() => todoCubit.addTodo(any()));
      expect(todoTitleFieldErrorText, findsOneWidget);

      await tester.enterText(todoTitleField, '    ');
      await tester.tap(saveButton);
      await tester.pump();

      verifyNever(() => todoCubit.addTodo(any()));
      expect(todoTitleFieldErrorText, findsOneWidget);

      await tester.enterText(todoTitleField, 'title1');
      await tester.tap(saveButton);
      await tester.pump();

      verify(
        () => todoCubit.addTodo(
          any(
            that: isA<Todo>().having(
              (todo) => todo.title,
              'title',
              'title1',
            ),
          ),
        ),
      ).called(1);
      expect(todoTitleFieldErrorText, findsNothing);
    },
  );
}
