import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class LoadMoreFooter extends StatelessWidget {
  const LoadMoreFooter({
    super.key,
    required this.state,
    this.label,
    this.onRetry,
  });

  final HexagonState state;
  final Widget? label;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        HexagonalLoadingIndicator(state: state, size: 36),
        if (label != null || onRetry != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              if (label case final label?)
                DefaultTextStyle.merge(
                  style: TextStyle(fontSize: 14, color: dimTextColor(context)),
                  child: label,
                ),
              if (onRetry case final onRetry?) RetryButton(onPressed: onRetry),
            ],
          ),
      ],
    ),
  );
}

class RetryButton extends StatelessWidget {
  const RetryButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 36),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        foregroundColor: dimTextColor(context, 0.87),
        side: BorderSide(color: AppStyle.of(context).outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStyle.of(context).smallRadius),
        ),
      ),
      child: const Text('Retry'),
    );
  }
}
