import 'package:flutter/material.dart';

import 'package:LoliSnatcher/src/widgets/common/cancel_button.dart';
import 'package:LoliSnatcher/src/widgets/common/settings_widgets.dart';
import 'package:LoliSnatcher/src/data/tag.dart';
import 'package:LoliSnatcher/src/data/tag_type.dart';

class TagsManagerAddDialog extends StatefulWidget {
  const TagsManagerAddDialog({Key? key}) : super(key: key);

  @override
  State<TagsManagerAddDialog> createState() => _TagsManagerAddDialogState();
}

class _TagsManagerAddDialogState extends State<TagsManagerAddDialog> {
  final TextEditingController _controller = TextEditingController();
  TagType _type = TagType.none;

  @override
  Widget build(BuildContext context) {
    return SettingsDialog(
      title: const Text("Add Tag"),
      contentItems: <Widget>[
        SettingsTextInput(
          controller: _controller,
          title: "Name",
          drawBottomBorder: false,
        ),
        SettingsDropdown(
          value: _type,
          items: TagType.values,
          onChanged: (TagType? newValue) {
            setState(() {
              _type = newValue!;
            });
          },
          title: 'Type',
          drawBottomBorder: false,
        ),
      ],
      actionButtons: [
        const CancelButton(returnData: null),
        ElevatedButton.icon(
          label: const Text("Add"),
          icon: const Icon(Icons.add),
          onPressed: () {
            final String tagName = _controller.text.trim();
            if (tagName.isNotEmpty) {
              Navigator.of(context).pop(Tag(
                tagName,
                tagName,
                _type,
              ));
            } else {
              Navigator.of(context).pop(null);
            }
          },
        ),
      ],
    );
  }
}
