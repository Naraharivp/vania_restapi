import 'package:api_product/app/models/orderitems.dart';
import 'package:vania/vania.dart';

class OrderitemController extends Controller {
    Future<Response> index() async {
        try {
            final orderItems = await Orderitems().query().get();
            return Response.json({
                'success': true,
                'data': orderItems,
                'message': 'Berhasil mengambil data order items'
            });
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal mengambil data order items: ${e.toString()}'
            }, 500);
        }
    }

    Future<Response> store(Request request) async {
        try {
            final data = request.input();
            final orderItem = await Orderitems().query().insert(data);
            
            return Response.json({
                'success': true,
                'data': orderItem,
                'message': 'Berhasil menambahkan order item baru'
            }, 201);
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal menambahkan order item: ${e.toString()}'
            }, 500);
        }
    }

    Future<Response> update(Request request, String orderItemId) async {
        try {
            final data = request.input();
            final existingOrderItem = await Orderitems()
                .query()
                .where('order_item_id', orderItemId)
                .first();

            if (existingOrderItem == null) {
                return Response.json({
                    'success': false,
                    'message': 'Order item dengan ID $orderItemId tidak ditemukan'
                }, 404);
            }

            // Sesuaikan field yang bisa diupdate
            final Map<String, dynamic> updatedData = {};
            if (data.containsKey('order_id')) updatedData['order_id'] = data['order_id'];
            if (data.containsKey('product_id')) updatedData['product_id'] = data['product_id'];
            if (data.containsKey('quantity')) updatedData['quantity'] = data['quantity'];
            if (data.containsKey('unit_price')) updatedData['unit_price'] = data['unit_price'];
            if (data.containsKey('subtotal')) updatedData['subtotal'] = data['subtotal'];

            if (updatedData.isEmpty) {
                return Response.json({
                    'success': false,
                    'message': 'Tidak ada data untuk diupdate'
                }, 400);
            }

            await Orderitems()
                .query()
                .where('order_item_id', orderItemId)
                .update(updatedData);

            final updatedOrderItem = await Orderitems()
                .query()
                .where('order_item_id', orderItemId)
                .first();

            return Response.json({
                'success': true,
                'data': updatedOrderItem,
                'message': 'Berhasil mengupdate data order item'
            });
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal mengupdate order item: ${e.toString()}'
            }, 500);
        }
    }

    Future<Response> destroy(String orderItemId) async {
        try {
            final existingOrderItem = await Orderitems()
                .query()
                .where('order_item_id', orderItemId)
                .first();
                
            if (existingOrderItem == null) {
                return Response.json({
                    'success': false,
                    'message': 'Order item dengan ID $orderItemId tidak ditemukan'
                }, 404);
            }
            
            await Orderitems()
                .query()
                .where('order_item_id', orderItemId)
                .delete();
                
            return Response.json({
                'success': true,
                'message': 'Berhasil menghapus order item'
            });
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal menghapus order item: ${e.toString()}'
            }, 500);
        }
    }
}

final OrderitemController orderitemController = OrderitemController();

