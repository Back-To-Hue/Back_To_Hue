import 'package:flutter/material.dart';
import 'package:flutter_contacts/properties/phone.dart';

class PhoneForm extends StatefulWidget {
  final Phone phone;
  final void Function(Phone) onUpdate;
  final void Function() onDelete;

  PhoneForm(
      this.phone, {
        required this.onUpdate,
        required this.onDelete,
        Key? key,
      }) : super(key: key);

  @override
  _PhoneFormState createState() => _PhoneFormState();
}

class _PhoneFormState extends State<PhoneForm> {
  final _formKey = GlobalKey<FormState>();
  static final _validLabels = PhoneLabel.values;

  late TextEditingController _numberController;

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController(text: widget.phone.number);
  }

  void _onChanged() {
    final phone = Phone(_numberController.text);
    widget.onUpdate(phone);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: PopupMenuButton(
        itemBuilder: (context) =>
        [PopupMenuItem(value: 'Delete', child: Text('Delete'))],
        onSelected: (_) => widget.onDelete(),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          onChanged: _onChanged,
          child: Column(
            children: [
              TextFormField(
                controller: _numberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(hintText: 'Phone'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}