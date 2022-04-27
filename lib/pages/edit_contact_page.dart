import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'form_components/address_form.dart';
import 'form_components/name_form.dart';
import 'form_components/note_form.dart';
import 'form_components/phone_form.dart';
import 'form_components/social_media_form.dart';
import 'package:back_to_hue/util/avatar.dart';
import 'package:image_picker/image_picker.dart';

class EditContactPage extends StatefulWidget {
  @override
  _EditContactPageState createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage>
    with AfterLayoutMixin<EditContactPage> {
  var _contact = Contact();
  bool _isEdit = false;
  late void Function()? _onUpdate;

  final _imagePicker = ImagePicker();

  @override
  void afterFirstLayout(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    setState(() {
      _contact = args['contact'];
      _isEdit = true;
      _onUpdate = args['onUpdate'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_isEdit ? 'Edit' : 'New'} contact'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              if (_isEdit) {
                await _contact.update();
              } else {
                await _contact.insert();
              }
              if (_onUpdate != null) _onUpdate!();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Form(
          child: Column(
            children: _contactFields(),
          ),
        ),
      ),
    );
  }

  List<Widget> _contactFields() => [
    _photoField(),
    _starredField(),
    _nameCard(),
    _phoneCard(),
    _addressCard(),
    _socialMediaCard(),
    _noteCard(),
  ];

  Future _pickPhoto() async {
    final photo = await _imagePicker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      setState(() {
        _contact.photo = bytes;
      });
    }
  }

  Widget _photoField() => Stack(children: [
    Center(
        child: InkWell(
          onTap: _pickPhoto,
          child: avatar(_contact, 48, Icons.add),
        )),
    _contact.photo == null
        ? Container()
        : Align(
      alignment: Alignment.topRight,
      child: PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(value: 'Delete', child: Text('Delete photo'))
        ],
        onSelected: (_) => setState(() {
          _contact.photo = null;
        }),
      ),
    ),
  ]);

  Card _fieldCard(
      String fieldName,
      List<dynamic> fields,
      /* void | Future<void> */ Function()? addField,
      Widget Function(int, dynamic) formWidget,
      void Function()? clearAllFields, {
        bool createAsync = false,
      }) {
    var forms = <Widget>[
      Text(fieldName, style: TextStyle(fontSize: 18)),
    ];
    fields.asMap().forEach((int i, dynamic p) => forms.add(formWidget(i, p)));
    void Function() onPressed;
    if (createAsync) {
      onPressed = () async {
        await addField!();
        setState(() {});
      };
    } else {
      onPressed = () => setState(() {
        addField!();
      });
    }
    var buttons = <ElevatedButton>[];
    if (addField != null) {
      buttons.add(
        ElevatedButton(
          onPressed: onPressed,
          child: Text('+ New'),
        ),
      );
    }
    if (clearAllFields != null) {
      buttons.add(ElevatedButton(
        onPressed: () {
          clearAllFields();
          setState(() {});
        },
        child: Text('Delete all'),
      ));
    }
    if (buttons.isNotEmpty) {
      forms.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons,
      ));
    }

    return Card(
      margin: EdgeInsets.all(12.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: forms,
          ),
        ),
      ),
    );
  }

 Card _nameCard() => _fieldCard(
   'Name',
   [_contact.name],
   null,
       (int i, dynamic n) => NameForm(
     n,
     onUpdate: (name) => _contact.name = name,
     key: UniqueKey(),
   ),
   null,
 );

  Card _phoneCard() => _fieldCard(
    'Phones',
    _contact.phones,
        () => _contact.phones = _contact.phones + [Phone('')],
        (int i, dynamic p) => PhoneForm(
      p,
      onUpdate: (phone) => _contact.phones[i] = phone,
      onDelete: () => setState(() => _contact.phones.removeAt(i)),
      key: UniqueKey(),
    ),
        () => _contact.phones = [],
  );

  Card _addressCard() => _fieldCard(
    'Addresses',
    _contact.addresses,
        () => _contact.addresses = _contact.addresses + [Address('')],
        (int i, dynamic a) => AddressForm(
      a,
      onUpdate: (address) => _contact.addresses[i] = address,
      onDelete: () => setState(() => _contact.addresses.removeAt(i)),
      key: UniqueKey(),
    ),
        () => _contact.addresses = [],
  );

  Card _socialMediaCard() => _fieldCard(
    'Social medias',
    _contact.socialMedias,
        () => _contact.socialMedias = _contact.socialMedias + [SocialMedia('')],
        (int i, dynamic w) => SocialMediaForm(
      w,
      onUpdate: (socialMedia) => _contact.socialMedias[i] = socialMedia,
      onDelete: () => setState(() => _contact.socialMedias.removeAt(i)),
      key: UniqueKey(),
    ),
        () => _contact.socialMedias = [],
  );

  Card _noteCard() => _fieldCard(
    'Notes',
    _contact.notes,
        () => _contact.notes = _contact.notes + [Note('')],
        (int i, dynamic w) => NoteForm(
      w,
      onUpdate: (note) => _contact.notes[i] = note,
      onDelete: () => setState(() => _contact.notes.removeAt(i)),
      key: UniqueKey(),
    ),
        () => _contact.notes = [],
  );

  Card _starredField() => Card(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Starred'),
        SizedBox(width: 24.0),
        Checkbox(
          value: _contact.isStarred,
          onChanged: (bool? isStarred) =>
              setState(() => _contact.isStarred = isStarred!),
        ),
      ],
    ),
  );
}