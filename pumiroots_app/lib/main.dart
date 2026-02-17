import 'package:flutter/material.dart';
import 'services/api_service.dart';

void main() {
  runApp(MaterialApp(home: LoginScreen()));
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController userCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  String message = "";
  String? token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PumiRoots Login")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: userCtrl,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: passCtrl,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {

                token = await ApiService.login(
                  userCtrl.text,
                  passCtrl.text,
                );

                if (token != null) {
                  setState(() {
                    message = "Login Successful!";
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductScreen(token: token!),
                    ),
                  );

                } else {
                  setState(() {
                    message = "Login Failed";
                  });
                }
              },
              child: Text("Login"),
            ),
            SizedBox(height: 20),
            Text(message),
          ],
        ),
      ),
    );
  }
}

class ProductScreen extends StatefulWidget {
  final String token;

  ProductScreen({required this.token});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    final data = await ApiService.getProducts(widget.token);
    setState(() {
      products = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Products")),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {

          final product = products[index];

          return ListTile(
            title: Text(product['name']),
            subtitle: Text(product['price']),
          );
        },
      ),
    );
  }
}
