import 'package:vania/vania.dart';

class CreateProductsTable extends Migration {

  @override
  Future<void> up() async{
   super.up();
   await createTableNotExists('products', () {
      string('prod_id', length: 10);
      string('vend_id', length: 5);
      string('prod_name', length: 25);
      integer('prod_price');
      text('prod_desc');
      
    });
  }
  
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('products');
  }
}
