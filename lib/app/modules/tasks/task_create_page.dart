import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/core/notifier/todo_list_listener_notifier.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider/app/core/widgets/todo_list_field.dart';
import 'package:todo_list_provider/app/modules/tasks/task_create_controller.dart';
import 'package:todo_list_provider/app/modules/tasks/widgets/calendar_button.dart';
import 'package:validatorless/validatorless.dart';

class TaskCreatePage extends StatefulWidget {
  final TaskCreateController _controller;

  const TaskCreatePage({
    super.key,
    required TaskCreateController controller,
  }) : _controller = controller;

  @override
  State<TaskCreatePage> createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends State<TaskCreatePage> {
  final _descriptionEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    TodoListListenerNotifier(changeNotifier: widget._controller).listener(
      context: context,
      successCallback: (notifier, listenerInstance) {
        Navigator.pop(context);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final formValid = _formKey.currentState?.validate() ?? false;
          if (formValid) {
            widget._controller.save(_descriptionEC.text);
          }
        },
        label: const Text(
          'Salvar Task',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: context.primaryColor,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Criar Atividade',
                  style: context.titleStyle.copyWith(fontSize: 20),
                ),
              ),
              const SizedBox(height: 30),
              TodoListField(
                labelText: '',
                controller: _descriptionEC,
                validator: Validatorless.required('Descrição obrigatória'),
              ),
              const SizedBox(height: 20),
              const CalendarButton()
            ],
          ),
        ),
      ),
    );
  }
}
