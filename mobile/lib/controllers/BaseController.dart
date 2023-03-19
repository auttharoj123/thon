
import 'package:slpod/controllers/AppController.dart';
import 'package:flutx/flutx.dart';

class BaseController extends FxController {
  late AppController appController;

  @override
  void initState() {
    super.initState();

    appController = FxControllerStore.putOrFind(AppController());
  }

  @override
  void dispose() {
    
    super.dispose();
  }
  
  @override
  String getTag() {
    throw UnimplementedError();
  }
}
