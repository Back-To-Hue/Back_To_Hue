import 'package:flutter/material.dart';
import 'package:flutter_contacts/properties/address.dart';

class AddressForm extends StatefulWidget {
  final Address address;
  final void Function(Address) onUpdate;
  final void Function() onDelete;

  AddressForm(
      this.address, {
        required this.onUpdate,
        required this.onDelete,
        Key? key,
      }) : super(key: key);

  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.address.address);
  }

  void _onChanged() {
    final address = Address(
      _addressController.text,
    );
    widget.onUpdate(address);
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
                controller: _addressController,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(hintText: 'Address'),
                maxLines: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}