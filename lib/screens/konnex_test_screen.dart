import 'package:flutter/material.dart';
import 'package:konnex_aerothon/konnex/konnex.dart';
import 'package:konnex_aerothon/konnex/konnex_handler.dart';
import 'package:render_metrics/render_metrics.dart';

class KonnexTestScreen extends StatelessWidget {
  final String routeName;
  final konnexHandler = KonnexHandler.instance;

  KonnexTestScreen({Key key, this.routeName = '0'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Test Screen',
            style: TextStyle(color: Theme.of(context).primaryColor),
          )),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RenderMetricsObject(
              manager: this.konnexHandler.manager,
              id: "1",
              child: ElevatedButton(
                onPressed: () {
                  print('Pressed Button one');
                  changeScreen(context, '1');
                },
                child: Text('Button 1'),
              ),
            ),
            RenderMetricsObject(
              manager: this.konnexHandler.manager,
              id: "2",
              child: ElevatedButton(
                onPressed: () {
                  print('Pressed Button two');
                  changeScreen(context, '2');
                },
                child: Text('Button 2'),
              ),
            ),
            RenderMetricsObject(
              manager: this.konnexHandler.manager,
              id: "3",
              child: ElevatedButton(
                onPressed: () {
                  print('Pressed Button three');
                  changeScreen(context, '3');
                },
                child: Text('Button 3'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: KonnexWidget(
        currentRoute: this.routeName,
      ),
    );
  }

  void changeScreen(BuildContext context, String route) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => KonnexTestScreen(
        routeName: route,
      ),
    ));
  }
}
