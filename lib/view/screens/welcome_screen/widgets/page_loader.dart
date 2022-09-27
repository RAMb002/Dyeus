import 'package:dyeus/view/css/css.dart';
import 'package:dyeus/view_model/provider/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageLoader extends StatelessWidget {
  const PageLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Consumer<LoadingProvider>(
        builder: (context, data, child) => Visibility(
          visible: data.loadingStatus,
          // visible:true,
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.black.withOpacity(0.6),
            child: const Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
