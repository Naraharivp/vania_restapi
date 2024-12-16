import 'package:vania/vania.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:api_product/app/models/customers.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class AuthController extends Controller {
  Future<Response> login(Request request) async {
    try {
      final email = request.input('email');
      final password = request.input('password');

      if (email == null || password == null) {
        return Response.json({
          'status': false,
          'message': 'Email dan password harus diisi'
        }, 400);
      }

      final hashedPassword = sha256.convert(utf8.encode(password)).toString();

      print('Attempting login with email: $email');
      
      final customer = await Customers().query()
          .where('email', email)
          .where('password', hashedPassword)
          .first();

      print('Query result: $customer');

      if (customer == null) {
        return Response.json({
          'status': false,
          'message': 'Email atau password salah'
        }, 401);
      }

      final jwt = JWT({
        'cust_id': customer['cust_id'],
        'cust_name': customer['cust_name'],
        'email': customer['email'],
        'exp': DateTime.now().add(Duration(days: 7)).millisecondsSinceEpoch
      });

      final token = jwt.sign(SecretKey('rahasia_jwt'));

      return Response.json({
        'status': true,
        'message': 'Login berhasil',
        'data': {
          'token': token,
          'user': {
            'cust_id': customer['cust_id'],
            'cust_name': customer['cust_name'],
            'email': customer['email'],
            'cust_address': customer['cust_address'],
            'cust_city': customer['cust_city'],
            'cust_state': customer['cust_state'],
            'cust_zip': customer['cust_zip'],
            'cust_country': customer['cust_country'],
            'cust_telp': customer['cust_telp']
          }
        }
      });
    } catch (e) {
      print('Login error: ${e.toString()}');
      return Response.json({
        'status': false,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      }, 500);
    }
  }

  Future<Response> register(Request request) async {
    try {
      final custId = request.input('cust_id');
      final custName = request.input('cust_name');
      final password = request.input('password');
      final email = request.input('email');
      final custAddress = request.input('cust_address');
      final custCity = request.input('cust_city');
      final custState = request.input('cust_state');
      final custZip = request.input('cust_zip');
      final custCountry = request.input('cust_country');
      final custTelp = request.input('cust_telp');

      if (custId == null || custName == null || password == null) {
        return Response.json({
          'status': false,
          'message': 'ID Customer, nama, dan password harus diisi'
        }, 400);
      }

      final allCustomers = await Customers().query().get();
      print('All customers in database:');
      print(allCustomers);

      final existingUser = await Customers().query()
          .where('cust_id', custId)
          .first();

      print('Checking existing user with ID: $custId');
      print('Existing user data: $existingUser');

      if (existingUser != null) {
        return Response.json({
          'status': false,
          'message': 'ID Customer sudah terdaftar'
        }, 400);
      }

      final hashedPassword = sha256.convert(utf8.encode(password)).toString();

      await Customers().query().insert({
        'cust_id': custId,
        'cust_name': custName,
        'password': hashedPassword,
        'email': email,
        'cust_address': custAddress,
        'cust_city': custCity,
        'cust_state': custState,
        'cust_zip': custZip,
        'cust_country': custCountry,
        'cust_telp': custTelp
      });

      return Response.json({
        'status': true,
        'message': 'Registrasi berhasil',
        'data': {
          'cust_id': custId,
          'cust_name': custName,
          'email': email,
          'cust_address': custAddress,
          'cust_city': custCity,
          'cust_state': custState,
          'cust_zip': custZip,
          'cust_country': custCountry,
          'cust_telp': custTelp
        }
      });
    } catch (e) {
      return Response.json({
        'status': false,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      }, 500);
    }
  }
}

final AuthController authController = AuthController();

