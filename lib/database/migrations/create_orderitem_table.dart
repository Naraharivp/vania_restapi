import 'package:vania/vania.dart';

class CreateOrderitemTable extends Migration {

  @override
  Future<void> up() async{
   super.up();
   await createTableNotExists('orderitems', () {
      integer('order_item');
      integer('order_num');
      string('prod_id', length: 10);
      integer('quantity');
      integer('size');
    });
  }
  
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orderitems');
  }
}
