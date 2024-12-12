import 'package:api_product/app/models/products.dart';
import 'package:vania/vania.dart';

class ProductController extends Controller {
    Future<Response> index() async {
        try {
            final products = await Products().query().get();
            return Response.json({
                'success': true,
                'data': products,
                'message': 'Berhasil mengambil data products'
            });
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal mengambil data products: ${e.toString()}'
            }, 500);
        }
    }

    Future<Response> store(Request request) async {
        try {
            final data = request.input();
            final product = await Products().query().insert(data);
            
            return Response.json({
                'success': true,
                'data': product,
                'message': 'Berhasil menambahkan product baru'
            }, 201);
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal menambahkan product: ${e.toString()}'
            }, 500);
        }
    }

    Future<Response> update(Request request, String productId) async {
        try {
            final data = request.input();
            final existingProduct = await Products()
                .query()
                .where('product_id', productId)
                .first();

            if (existingProduct == null) {
                return Response.json({
                    'success': false,
                    'message': 'Product dengan ID $productId tidak ditemukan'
                }, 404);
            }

            // Sesuaikan field yang bisa diupdate
            final Map<String, dynamic> updatedData = {};
            if (data.containsKey('product_name')) updatedData['product_name'] = data['product_name'];
            if (data.containsKey('price')) updatedData['price'] = data['price'];
            // Tambahkan field lainnya sesuai kebutuhan

            await Products()
                .query()
                .where('product_id', productId)
                .update(updatedData);

            final updatedProduct = await Products()
                .query()
                .where('product_id', productId)
                .first();

            return Response.json({
                'success': true,
                'data': updatedProduct,
                'message': 'Berhasil mengupdate data product'
            });
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal mengupdate product: ${e.toString()}'
            }, 500);
        }
    }

    Future<Response> destroy(String productId) async {
        try {
            final existingProduct = await Products()
                .query()
                .where('product_id', productId)
                .first();
                
            if (existingProduct == null) {
                return Response.json({
                    'success': false,
                    'message': 'Product dengan ID $productId tidak ditemukan'
                }, 404);
            }
            
            await Products()
                .query()
                .where('product_id', productId)
                .delete();
                
            return Response.json({
                'success': true,
                'message': 'Berhasil menghapus product'
            });
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal menghapus product: ${e.toString()}'
            }, 500);
        }
    }
}

final ProductController productController = ProductController();

