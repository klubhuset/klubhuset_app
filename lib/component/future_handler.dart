import 'package:flutter/cupertino.dart';
import 'package:klubhuset/component/error_message.dart';
import 'package:klubhuset/component/loading_indicator.dart';

class FutureHandler<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext, T) onSuccess;
  final Widget Function(BuildContext)? onError;
  final Widget? loadingIndicator;
  final String? noDataFoundMessage;

  FutureHandler({
    required this.future,
    required this.onSuccess,
    this.onError,
    this.loadingIndicator,
    this.noDataFoundMessage,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingIndicator();
        }

        // Error state
        if (snapshot.hasError) {
          return ErrorMessage(
              message: 'Der skete en fejl. Prøv venligst igen senere.');
        }

        // Empty or no data
        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data is List && (snapshot.data as List).isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Text(
                (noDataFoundMessage ?? 'Ingen data tilgængelig'),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // Success state
        return onSuccess(context, snapshot.data as T);
      },
    );
  }
}
