import 'package:flutter/material.dart';
import 'package:flutter_contacts/properties/social_media.dart';

class SocialMediaForm extends StatefulWidget {
  final SocialMedia socialMedia;
  final void Function(SocialMedia) onUpdate;
  final void Function() onDelete;

  SocialMediaForm(
      this.socialMedia, {
        required this.onUpdate,
        required this.onDelete,
        Key? key,
      }) : super(key: key);

  @override
  _SocialMediaFormState createState() => _SocialMediaFormState();
}

class _SocialMediaFormState extends State<SocialMediaForm> {
  final _formKey = GlobalKey<FormState>();
  static final _validLabels = SocialMediaLabel.values;

  late TextEditingController _userNameController;

  @override
  void initState() {
    super.initState();
    _userNameController =
        TextEditingController(text: widget.socialMedia.userName);
  }

  void _onChanged() {
    final socialMedia = SocialMedia(
      _userNameController.text,
    );
    widget.onUpdate(socialMedia);
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
                controller: _userNameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: 'Social Media'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}