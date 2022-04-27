import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:back_to_hue/util/avatar.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage>
    with AfterLayoutMixin<ContactPage> {
  late Contact _contact;

  @override
  void afterFirstLayout(BuildContext context) {
    final contact = ModalRoute.of(context)?.settings.arguments as Contact;
    setState(() {
      _contact = contact;
    });
    _fetchContact();
  }

  Future _fetchContact() async {
    // First fetch all contact details
    await _fetchContactWith(highRes: false);

    // Then fetch contact with high resolution photo
    await _fetchContactWith(highRes: true);
  }

  Future _fetchContactWith({required bool highRes}) async {
    final contact = await FlutterContacts.getContact(
      _contact.id,
      withThumbnail: !highRes,
      withPhoto: highRes,
    );
    setState(() {
      _contact = contact!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_contact.displayName),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) =>
            [PopupMenuItem(value: _contact, child: Text('Delete contact'))],
            onSelected: (contact) async {
              //await contact.delete();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: _body(_contact),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).pushNamed('/editContact', arguments: {
              'contact': _contact,
              // A better solution would be to make [ContactPage] listen to DB
              // changes, but this will do for now
              'onUpdate': _fetchContact,
            }),
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget _body(Contact contact) {
    if (_contact.name == null) {
      return Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _withSpacing([
          Center(child: avatar(contact)),
          _makeCard(
              'ID',
              [contact],
                  (x) => [
                Divider(),
                Text('ID: ${x.id}'),
                Text('Display name: ${x.displayName}'),
                Text('Starred: ${x.isStarred}'),
              ]),
          _makeCard(
              'Name',
              [contact.name],
                  (x) => [
                Divider(),
                Text('First: ${x.first}'),
                Text('Last: ${x.last}'),
              ]),
          _makeCard(
              'Phones',
              contact.phones,
                  (x) => [
                Divider(),
                Text('Number: ${x.number}'),
                Text('Normalized number: ${x.normalizedNumber}'),
              ]),
          _makeCard(
              'Addresses',
              contact.addresses,
                  (x) => [
                Divider(),
                Text('Address: ${x.address}'),
              ]),
          _makeCard(
              'Social medias',
              contact.socialMedias,
                  (x) => [
                Divider(),
                Text('Value: ${x.userName}'),
              ]),
          _makeCard(
              'Notes',
              contact.notes,
                  (x) => [
                Divider(),
                Text('Note: ${x.note}'),
              ]),
        ]),
      ),
    );
  }

  List<Widget> _withSpacing(List<Widget> widgets) {
    final spacer = SizedBox(height: 8);
    return <Widget>[spacer] +
        widgets.map((p) => [p, spacer]).expand((p) => p).toList();
  }

  Card _makeCard(
      String title, List fields, List<Widget> Function(dynamic) mapper) {
    var elements = <Widget>[];
    fields.forEach((field) => elements.addAll(mapper(field)));
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _withSpacing(<Widget>[
            Text(title, style: TextStyle(fontSize: 22)),
          ] +
              elements),
        ),
      ),
    );
  }
}