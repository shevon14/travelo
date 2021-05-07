// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_offline/flutter_offline.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uocportal/auth_service.dart';
// import 'package:uocportal/checkNetwork.dart';
// import 'package:uocportal/my_products.dart';
// import 'dart:io';

// //Add items Page (form)
// class Updateitems extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return OfflineBuilder(
//         debounceDuration: Duration.zero,
//         connectivityBuilder: (
//           BuildContext context,
//           ConnectivityResult connectivity,
//           Widget child,
//         ) {
//           if (connectivity == ConnectivityResult.none) {
//             return InternetOffiline();
//           }
//           return child;
//         },
//         child: MaterialApp(
//             theme: new ThemeData(primarySwatch: Colors.purple),
//             home: Scaffold(
//                 appBar: AppBar(
//                   title: Text('Update Item Details'),
//                   backgroundColor: Color(0xFF4A184C),
//                 ),
//                 body: GestureDetector(
//                   onTap: () {
//                     // call this method here to hide soft keyboard
//                     FocusScope.of(context).requestFocus(new FocusNode());
//                   },
//                   child: SingleChildScrollView(child: MyCustomForm()),
//                 ))));
//   }
// }

// //Form Widget
// class MyCustomForm extends StatefulWidget {
//   @override
//   MyCustomFormState createState() {
//     return MyCustomFormState();
//   }
// }

// //Form and Validation part ekata
// class MyCustomFormState extends State<MyCustomForm> {
//   final _formKey = GlobalKey<FormState>();
//   String _img, _itemName, _details, _price, _contact, _productdocid;
//   bool _approval = false;
//   bool showSpinner = false;

//   FirebaseStorage storage = FirebaseStorage.instance;

//   bool validate() {
//     final form = _formKey.currentState;
//     form.save();
//     if (form.validate()) {
//       form.save();
//       return true;
//     } else {
//       return false;
//     }
//   }

//   void submit() async {
//     if (validate()) {
//       setState(() {
//         showSpinner = true;
//       });
//       try {
//         final form = _formKey.currentState;
//         form.save();
//         updateDatainFirestore();
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => MyProducts()),
//         );
//         setState(() {
//           showSpinner = false;
//         });
//       } catch (e) {}
//     }
//   }

//   var categories = [
//     "Clothing",
//     "Electronics",
//     "Stationary",
//     "Tickets",
//     "Beauty",
//     "Other"
//   ];

//   getProductId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _productdocid = (prefs.getString('clickProductID'));
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getProductId();
//   }

//   updateDatainFirestore() async {
//     final _userCollectionReference = Firestore.instance;

//     final FirebaseUser user = await FirebaseAuth.instance.currentUser();
//     String userid = user.uid.toString();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       prefs.setString('currentuserid', userid);
//       print(userid);
//     });

//     await _userCollectionReference
//         .collection('Market')
//         .document(_productdocid)
//         .updateData({
//       'category': '$currentsSelectCategory',
//       'price': '$_price',
//       'image': '$_img',
//       'details': '$_details',
//       'itemName': '$_itemName',
//       'userID': '$userid',
//       'contact': '$_contact',
//       'productID': '$_productdocid',
//       'approval': _approval
//     });
//   }

//   var currentsSelectCategory;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: Firestore.instance
//             .collection('Market')
//             .document(_productdocid)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return Text('Loading Data.. Please Wait...');
//           return Form(
//             key: _formKey,
//             child: Padding(
//               padding: EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   TextFormField(
//                       initialValue: snapshot.data['itemName'],
//                       validator: MarketItemName.validate,
//                       style: TextStyle(
//                           color: Color(0xFF4A184C),
//                           fontWeight: FontWeight.bold),
//                       decoration: new InputDecoration(
//                         labelText: "Item Name",
//                         labelStyle: TextStyle(color: Color(0xFF4A184C)),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.amber),
//                             borderRadius: new BorderRadius.circular(25.0)),
//                       ),
//                       onSaved: (value) => _itemName = value),
//                   Padding(padding: EdgeInsets.all(10)),
//                   FormField<String>(
//                     builder: (FormFieldState<String> state) {
//                       return InputDecorator(
//                         decoration: InputDecoration(
//                           labelText: "Item Category",
//                           labelStyle: TextStyle(
//                               color: Color(0xFF4A184C),
//                               fontWeight: FontWeight.bold),
//                           enabledBorder: OutlineInputBorder(
//                               borderSide: const BorderSide(color: Colors.amber),
//                               borderRadius: new BorderRadius.circular(25.0)),
//                         ),
//                         isEmpty: currentsSelectCategory == "Other",
//                         child: DropdownButtonHideUnderline(
//                           child: DropdownButton<String>(
//                             style: TextStyle(
//                                 color: Color(0xFF4A184C),
//                                 fontWeight: FontWeight.bold),
//                             value: currentsSelectCategory =
//                                 snapshot.data['category'],
//                             isDense: true,
//                             onChanged: (String newValue) {
//                               setState(() {
//                                 currentsSelectCategory = newValue;
//                                 state.didChange(newValue);
//                               });
//                             },
//                             items: categories.map((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   Padding(padding: EdgeInsets.all(10)),
//                   TextFormField(
//                       initialValue: snapshot.data['price'],
//                       validator: MarketItemPrice.validate,
//                       keyboardType: TextInputType.phone,
//                       style: TextStyle(
//                           color: Color(0xFF4A184C),
//                           fontWeight: FontWeight.bold),
//                       decoration: new InputDecoration(
//                         labelText: "Price",
//                         labelStyle: TextStyle(color: Color(0xFF4A184C)),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.amber),
//                             borderRadius: new BorderRadius.circular(25.0)),
//                       ),
//                       onSaved: (value) => _price = value),
//                   Padding(padding: EdgeInsets.all(10)),
//                   TextFormField(
//                       validator: MarketItemDetails.validate,
//                       initialValue: snapshot.data['details'],
//                       style: TextStyle(
//                           color: Color(0xFF4A184C),
//                           fontWeight: FontWeight.bold),
//                       decoration: new InputDecoration(
//                         labelText: "Product Details",
//                         labelStyle: TextStyle(color: Color(0xFF4A184C)),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.amber),
//                             borderRadius: new BorderRadius.circular(25.0)),
//                       ),
//                       onSaved: (value) => _details = value),
//                   Padding(padding: EdgeInsets.all(10)),
//                   TextFormField(
//                       initialValue: snapshot.data['contact'],
//                       validator: ContactValidator.validate,
//                       keyboardType: TextInputType.phone,
//                       style: TextStyle(
//                           color: Color(0xFF4A184C),
//                           fontWeight: FontWeight.bold),
//                       decoration: new InputDecoration(
//                         labelText: "Contact Number",
//                         labelStyle: TextStyle(color: Color(0xFF4A184C)),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.amber),
//                             borderRadius: new BorderRadius.circular(25.0)),
//                       ),
//                       onSaved: (value) => _contact = value),
//                   Padding(padding: EdgeInsets.all(10)),
//                   RaisedButton.icon(
//                       onPressed: () async {
//                         File tempimage = await ImagePicker.pickImage(
//                             source: ImageSource.gallery);

//                         final FirebaseUser user =
//                             await FirebaseAuth.instance.currentUser();
//                         final _userCollectionReference = Firestore.instance;
//                         DocumentReference productdocid =
//                             await _userCollectionReference
//                                 .collection('Market')
//                                 .document();

//                         StorageReference reference = storage
//                             .ref()
//                             .child("productImages/${productdocid.documentID}");

//                         //Upload the file to firebase
//                         StorageUploadTask uploadTask =
//                             reference.putFile(tempimage);

//                         setState(() {
//                           Scaffold.of(context).showSnackBar(SnackBar(
//                             content: Text(
//                               'Uploading...',
//                               style: TextStyle(color: Color(0xFF4A184C)),
//                             ),
//                             backgroundColor: Colors.amber,
//                           ));
//                         });

//                         StorageTaskSnapshot taskSnapshot =
//                             await uploadTask.onComplete;

//                         // Waits till the file is uploaded then stores the download url
//                         _img = await taskSnapshot.ref.getDownloadURL();

//                         setState(() {
//                           Scaffold.of(context).showSnackBar(SnackBar(
//                             content: Text(
//                               'Successfully Uploaded',
//                               style: TextStyle(color: Color(0xFF4A184C)),
//                             ),
//                             backgroundColor: Colors.amber,
//                           ));
//                         });
//                       },
//                       icon: Icon(
//                         Icons.add_a_photo,
//                         color: Color(0xFF4A184C),
//                       ),
//                       label: Text(
//                         'Change\nimage',
//                         style: TextStyle(color: Color(0xFF4A184C)),
//                       )),
//                   Center(
//                     child: new Container(
//                       padding: const EdgeInsets.all(15),
//                       child: ButtonTheme(
//                           minWidth: 200,
//                           height: 50,
//                           child: new RaisedButton(
//                             child: const Text(
//                               'Save Changes',
//                               style: TextStyle(color: Colors.amber),
//                             ),
//                             color: Color(0xFF4A184C),
//                             shape: new RoundedRectangleBorder(
//                               borderRadius: new BorderRadius.circular(30.0),
//                             ),
//                             onPressed: () {
//                               if (_img == null) {
//                                 _img = snapshot.data['image'];
//                               }
//                               submit();
//                             },
//                           )),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }
