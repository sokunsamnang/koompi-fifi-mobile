import 'package:flutter/material.dart';
import 'package:koompi_hotspot/models/token_list.dart';

class TokenListSheet extends StatefulWidget {
  final Function(Map<String, String> token)? onTokenSelected;
  final List<Map<String, String>> tokens = TokenList().tokens;

  TokenListSheet({Key? key, this.onTokenSelected}) : super(key: key);

  @override
  createState() => _TokenListSheetState();
}

class _TokenListSheetState extends State<TokenListSheet> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0)
      ),
      child: ListView(
        shrinkWrap: true,
        children: widget.tokens.map<Widget>((e) {
          final token = e;
          return ListTile(
            subtitle: Text(token["Name"]!),
            leading: Image.asset(token["icon"]!, height: 50,),
            onTap: () {
              widget.onTokenSelected!(token);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}

