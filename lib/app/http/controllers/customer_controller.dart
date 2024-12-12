import 'package:api_product/app/models/customers.dart';
import 'package:vania/vania.dart';

class CustomerController extends Controller {

     Future<Response> index() async {
        try {
            final customers = await Customers().query().get();
            return Response.json({
                'success': true,
                'data': customers,
                'message': 'Berhasil mengambil data customers'
            });
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal mengambil data customers: ${e.toString()}'
            }, 500);
        }
     }

     Future<Response> create(Request request) async {
          return Response.json({});
     }

     Future<Response> store(Request request) async {
        try {
            // Ambil data dari request body
            final data = request.input();
            
            // Buat customer baru
            final customer = await Customers().query().insert(data);
            
            return Response.json({
                'success': true,
                'data': customer,
                'message': 'Berhasil menambahkan customer baru'
            }, 201);
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal menambahkan customer: ${e.toString()}'
            }, 500);
        }
     }

     Future<Response> show() async {
      
          return Response.json({});
     }

     Future<Response> edit(int id) async {
          return Response.json({});
     }

     Future<Response> update(Request request, String custId) async {
    try {
        // Ambil data dari request body
        final data = request.input();

        // Pastikan customer dengan cust_id yang diberikan ada
        final existingCustomer = await Customers()
            .query()
            .where('cust_id', custId) // Filter berdasarkan cust_id
            .first();

        if (existingCustomer == null) {
            return Response.json({
                'success': false,
                'message': 'Customer dengan ID $custId tidak ditemukan'
            }, 404);
        }

        // Filter data yang akan diupdate
        final Map<String, dynamic> updatedData = {};
        if (data.containsKey('cust_name')) updatedData['cust_name'] = data['cust_name'];
        if (data.containsKey('cust_address')) updatedData['cust_address'] = data['cust_address'];
        if (data.containsKey('cust_city')) updatedData['cust_city'] = data['cust_city'];
        if (data.containsKey('cust_state')) updatedData['cust_state'] = data['cust_state'];
        if (data.containsKey('cust_zip')) updatedData['cust_zip'] = data['cust_zip'];
        if (data.containsKey('cust_country')) updatedData['cust_country'] = data['cust_country'];
        if (data.containsKey('cust_telp')) updatedData['cust_telp'] = data['cust_telp'];

        if (updatedData.isEmpty) {
            return Response.json({
                'success': false,
                'message': 'Tidak ada data untuk diupdate'
            }, 400);
        }

        // Update customer berdasarkan cust_id
        final rowsAffected = await Customers()
            .query()
            .where('cust_id', custId) // Filter yang benar
            .update(updatedData);

        if (rowsAffected == 0) {
            return Response.json({
                'success': false,
                'message': 'Gagal mengupdate customer'
            }, 500);
        }

        // Ambil data customer yang sudah diupdate
        final updatedCustomer = await Customers()
            .query()
            .where('cust_id', custId) // Pastikan data yang diambil sesuai
            .first();

        return Response.json({
            'success': true,
            'data': updatedCustomer,
            'message': 'Berhasil mengupdate data customer'
        });
    } catch (e) {
        return Response.json({
            'success': false,
            'message': 'Gagal mengupdate customer: ${e.toString()}'
        }, 500);
    }
}

     Future<Response> destroy(String custId) async {
        try {
            // Cek apakah customer ada
            final existingCustomer = await Customers()
                .query()
                .where('cust_id', custId)
                .first();
                
            if (existingCustomer == null) {
                return Response.json({
                    'success': false,
                    'message': 'Customer dengan ID $custId tidak ditemukan'
                }, 404);
            }
            
            // Hapus customer
            await Customers()
                .query()
                .where('cust_id', custId)
                .delete();
                
            return Response.json({
                'success': true,
                'message': 'Berhasil menghapus customer'
            });
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal menghapus customer: ${e.toString()}'
            }, 500);
        }
     }
}

final CustomerController customerController = CustomerController();

