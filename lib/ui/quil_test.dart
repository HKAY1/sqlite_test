import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:test_app/constants/editor.dart';

@immutable
class QuillScreenArgs {
  const QuillScreenArgs({required this.document});

  final Document document;
}

class SimpleScreen extends StatefulWidget {
  final QuillScreenArgs args;
  const SimpleScreen({super.key, required this.args});

  @override
  State<SimpleScreen> createState() => _SimpleScreenState();
}

class _SimpleScreenState extends State<SimpleScreen> {
  final _controller = QuillController.basic();

  final editorFocusNode = FocusNode();
  final editorScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // _controller.document = widget.args.document;
  }

  @override
  void dispose() {
    _controller.dispose();
    editorFocusNode.dispose();
    editorScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          QuillToolbar.simple(
            controller: _controller,
            configurations: const QuillSimpleToolbarConfigurations(),
          ),
          Expanded(
            child: MyQuillEditor(
              controller: _controller,
              configurations: const QuillEditorConfigurations(
                padding: EdgeInsets.all(16),
              ),
              scrollController: editorScrollController,
              focusNode: editorFocusNode,
            ),
          ),
        ],
      ),
    );
  }
}
