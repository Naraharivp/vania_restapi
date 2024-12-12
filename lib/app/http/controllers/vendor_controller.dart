import 'package:api_product/app/models/vendors.dart';
import 'package:vania/vania.dart';

class VendorController extends Controller {
    Future<Response> index() async {
        try {
            final vendors = await Vendors().query().get();
            return Response.json({
                'success': true,
                'data': vendors,
                'message': 'Berhasil mengambil data vendors'
            });
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal mengambil data vendors: ${e.toString()}'
            }, 500);
        }
    }

    Future<Response> store(Request request) async {
        try {
            final data = request.input();
            final vendor = await Vendors().query().insert(data);
            
            return Response.json({
                'success': true,
                'data': vendor,
                'message': 'Berhasil menambahkan vendor baru'
            }, 201);
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal menambahkan vendor: ${e.toString()}'
            }, 500);
        }
    }

    Future<Response> update(Request request, String vendorId) async {
        try {
            final data = request.input();
            final existingVendor = await Vendors()
                .query()
                .where('vendor_id', vendorId)
                .first();

            if (existingVendor == null) {
                return Response.json({
                    'success': false,
                    'message': 'Vendor dengan ID $vendorId tidak ditemukan'
                }, 404);
            }

            final Map<String, dynamic> updatedData = {};
            if (data.containsKey('vendor_name')) updatedData['vendor_name'] = data['vendor_name'];
            if (data.containsKey('contact_name')) updatedData['contact_name'] = data['contact_name'];
            if (data.containsKey('address')) updatedData['address'] = data['address'];
            if (data.containsKey('city')) updatedData['city'] = data['city'];
            if (data.containsKey('phone')) updatedData['phone'] = data['phone'];
            if (data.containsKey('email')) updatedData['email'] = data['email'];

            if (updatedData.isEmpty) {
                return Response.json({
                    'success': false,
                    'message': 'Tidak ada data untuk diupdate'
                }, 400);
            }

            await Vendors()
                .query()
                .where('vendor_id', vendorId)
                .update(updatedData);

            final updatedVendor = await Vendors()
                .query()
                .where('vendor_id', vendorId)
                .first();

            return Response.json({
                'success': true,
                'data': updatedVendor,
                'message': 'Berhasil mengupdate data vendor'
            });
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal mengupdate vendor: ${e.toString()}'
            }, 500);
        }
    }

    Future<Response> destroy(String vendorId) async {
        try {
            final existingVendor = await Vendors()
                .query()
                .where('vendor_id', vendorId)
                .first();
                
            if (existingVendor == null) {
                return Response.json({
                    'success': false,
                    'message': 'Vendor dengan ID $vendorId tidak ditemukan'
                }, 404);
            }
            
            await Vendors()
                .query()
                .where('vendor_id', vendorId)
                .delete();
                
            return Response.json({
                'success': true,
                'message': 'Berhasil menghapus vendor'
            });
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal menghapus vendor: ${e.toString()}'
            }, 500);
        }
    }
}

final VendorController vendorController = VendorController();

