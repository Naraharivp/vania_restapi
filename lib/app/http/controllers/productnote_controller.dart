import 'package:api_product/app/models/productnotes.dart';
import 'package:vania/vania.dart';

class ProductnoteController extends Controller {
    Future<Response> index() async {
        try {
            final productNotes = await Productnotes().query().get();
            return Response.json({
                'success': true,
                'data': productNotes,
                'message': 'Berhasil mengambil data product notes'
            });
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal mengambil data product notes: ${e.toString()}'
            }, 500);
        }
    }

    Future<Response> store(Request request) async {
        try {
            final data = request.input();
            final productNote = await Productnotes().query().insert(data);
            
            return Response.json({
                'success': true,
                'data': productNote,
                'message': 'Berhasil menambahkan product note baru'
            }, 201);
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal menambahkan product note: ${e.toString()}'
            }, 500);
        }
    }

    Future<Response> update(Request request, String noteId) async {
        try {
            final data = request.input();
            final existingNote = await Productnotes()
                .query()
                .where('note_id', noteId)
                .first();

            if (existingNote == null) {
                return Response.json({
                    'success': false,
                    'message': 'Product note dengan ID $noteId tidak ditemukan'
                }, 404);
            }

            final Map<String, dynamic> updatedData = {};
            if (data.containsKey('product_id')) updatedData['product_id'] = data['product_id'];
            if (data.containsKey('note')) updatedData['note'] = data['note'];
            if (data.containsKey('note_date')) updatedData['note_date'] = data['note_date'];

            if (updatedData.isEmpty) {
                return Response.json({
                    'success': false,
                    'message': 'Tidak ada data untuk diupdate'
                }, 400);
            }

            await Productnotes()
                .query()
                .where('note_id', noteId)
                .update(updatedData);

            final updatedNote = await Productnotes()
                .query()
                .where('note_id', noteId)
                .first();

            return Response.json({
                'success': true,
                'data': updatedNote,
                'message': 'Berhasil mengupdate data product note'
            });
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal mengupdate product note: ${e.toString()}'
            }, 500);
        }
    }

    Future<Response> destroy(String noteId) async {
        try {
            final existingNote = await Productnotes()
                .query()
                .where('note_id', noteId)
                .first();
                
            if (existingNote == null) {
                return Response.json({
                    'success': false,
                    'message': 'Product note dengan ID $noteId tidak ditemukan'
                }, 404);
            }
            
            await Productnotes()
                .query()
                .where('note_id', noteId)
                .delete();
                
            return Response.json({
                'success': true,
                'message': 'Berhasil menghapus product note'
            });
        } catch (e) {
            return Response.json({
                'success': false,
                'message': 'Gagal menghapus product note: ${e.toString()}'
            }, 500);
        }
    }
}

final ProductnoteController productnoteController = ProductnoteController();

