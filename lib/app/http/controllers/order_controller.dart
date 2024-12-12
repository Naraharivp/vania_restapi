import 'package:api_product/app/models/orders.dart';
import 'package:vania/vania.dart';

class OrderController extends Controller {
    Future<Response> index() async {
        try {
            final orders = await Orders().query().get();
            return Response.json({
                'success': true,
                'data': orders,
                'message': 'Berhasil mengambil data orders'
            });
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal mengambil data orders: ${e.toString()}'
            }, 500);
        }
    }

    Future<Response> store(Request request) async {
        try {
            final data = request.input();
            final order = await Orders().query().insert(data);
            
            return Response.json({
                'success': true,
                'data': order,
                'message': 'Berhasil menambahkan order baru'
            }, 201);
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal menambahkan order: ${e.toString()}'
            }, 500);
        }
    }

    Future<Response> update(Request request, String orderId) async {
        try {
            final data = request.input();
            final existingOrder = await Orders()
                .query()
                .where('order_id', orderId)
                .first();

            if (existingOrder == null) {
                return Response.json({
                    'success': false,
                    'message': 'Order dengan ID $orderId tidak ditemukan'
                }, 404);
            }

            // Sesuaikan field yang bisa diupdate
            final Map<String, dynamic> updatedData = {};
            if (data.containsKey('order_date')) updatedData['order_date'] = data['order_date'];
            if (data.containsKey('cust_id')) updatedData['cust_id'] = data['cust_id'];
            if (data.containsKey('order_status')) updatedData['order_status'] = data['order_status'];
            if (data.containsKey('total_amount')) updatedData['total_amount'] = data['total_amount'];
            // Tambahkan field lainnya sesuai kebutuhan

            if (updatedData.isEmpty) {
                return Response.json({
                    'success': false,
                    'message': 'Tidak ada data untuk diupdate'
                }, 400);
            }

            await Orders()
                .query()
                .where('order_id', orderId)
                .update(updatedData);

            final updatedOrder = await Orders()
                .query()
                .where('order_id', orderId)
                .first();

            return Response.json({
                'success': true,
                'data': updatedOrder,
                'message': 'Berhasil mengupdate data order'
            });
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal mengupdate order: ${e.toString()}'
            }, 500);
        }
    }

    Future<Response> destroy(String orderId) async {
        try {
            final existingOrder = await Orders()
                .query()
                .where('order_id', orderId)
                .first();
                
            if (existingOrder == null) {
                return Response.json({
                    'success': false,
                    'message': 'Order dengan ID $orderId tidak ditemukan'
                }, 404);
            }
            
            await Orders()
                .query()
                .where('order_id', orderId)
                .delete();
                
            return Response.json({
                'success': true,
                'message': 'Berhasil menghapus order'
            });
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal menghapus order: ${e.toString()}'
            }, 500);
        }
    }
}

final OrderController orderController = OrderController();

