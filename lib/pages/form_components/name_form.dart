
import 'package:flutter/material.dart';
import 'package:flutter_contacts/properties/name.dart';

class NameForm extends StatefulWidget {
  final Name name;
  final void Function(Name) onUpdate;

  NameForm(
      this.name, {
        required this.onUpdate,
        Key? key,
      }) : super(key: key);

  @override
  _NameFormState createState() => _NameFormState();
}

class _NameFormState extends State<NameForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstController;
  late TextEditingController _lastController;

  @override
  void initState() {
    super.initState();
    _firstController = TextEditingController(text: widget.name.first);
    _lastController = TextEditingController(text: widget.name.last);
  }

  void _onChanged() {
    final name = Name(
        first: _firstController.text,
        last: _lastController.text,
    );
    widget.onUpdate(name);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          onChanged: _onChanged,
          child: Column(
            children: [
              TextFormField(
                controller: _firstController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(hintText: 'First name'),
              ),
              TextFormField(
                controller: _lastController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(hintText: 'Last name'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}