import 'package:flutter/material.dart';

class DividerOr extends StatelessWidget {
  const DividerOr({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(height: 1, color: Colors.grey.withOpacity(0.5)),
          ),
          const SizedBox(width: 10),
          Text(
            'or',
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.grey.withOpacity(0.7)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(height: 1, color: Colors.grey.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}
