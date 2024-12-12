import 'package:vania/vania.dart';
import 'package:api_product/app/http/controllers/home_controller.dart';
import 'package:api_product/app/http/controllers/customer_controller.dart';
import 'package:api_product/app/http/controllers/order_controller.dart';
import 'package:api_product/app/http/controllers/orderitem_controller.dart';
import 'package:api_product/app/http/controllers/productnote_controller.dart';
import 'package:api_product/app/http/controllers/vendor_controller.dart';
import 'package:api_product/app/http/middleware/authenticate.dart';
import 'package:api_product/app/http/middleware/home_middleware.dart';
import 'package:api_product/app/http/middleware/error_response_middleware.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api');

    Router.get("/home", homeController.index);

    Router.get("/hello-world", () {
      return Response.html('Hello World');
    }).middleware([HomeMiddleware()]);

    // Return error code 400
    Router.get('wrong-request',
            () => Response.json({'message': 'Hi wrong request'}))
        .middleware([ErrorResponseMiddleware()]);

    // Return Authenticated user data
    Router.get("/user", () {
      return Response.json(Auth().user());
    }).middleware([AuthenticateMiddleware()]);

    // Customer Routes
    Router.get("/customers", customerController.index);
    Router.post("/customers", customerController.store);
    Router.put("/customers/{custId}", customerController.update);
    Router.delete("/customers/{custId}", customerController.destroy);

    // Order Routes
    Router.get("/orders", orderController.index);
    Router.post("/orders", orderController.store);
    Router.put("/orders/{orderId}", orderController.update);
    Router.delete("/orders/{orderId}", orderController.destroy);

    // Order Item Routes
    Router.get("/order-items", orderitemController.index);
    Router.post("/order-items", orderitemController.store);
    Router.put("/order-items/{orderItemId}", orderitemController.update);
    Router.delete("/order-items/{orderItemId}", orderitemController.destroy);

    // Product Note Routes
    Router.get("/product-notes", productnoteController.index);
    Router.post("/product-notes", productnoteController.store);
    Router.put("/product-notes/{noteId}", productnoteController.update);
    Router.delete("/product-notes/{noteId}", productnoteController.destroy);

    // Vendor Routes
    Router.get("/vendors", vendorController.index);
    Router.post("/vendors", vendorController.store);
    Router.put("/vendors/{vendorId}", vendorController.update);
    Router.delete("/vendors/{vendorId}", vendorController.destroy);
  }
}
