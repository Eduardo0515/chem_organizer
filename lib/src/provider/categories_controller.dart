import 'package:chem_organizer/src/models/categoryEvent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesController {
  CollectionReference categories =
      FirebaseFirestore.instance.collection('usuarios').doc('hugo').collection('categories');

  checkCategory(category) {
    return categories
        .where('category', isEqualTo: category.toUpperCase())
        .get();
  }

  addCategory(category) {
    categories.add({'category': category.text.toUpperCase()});
  }

  Future updateCategory(idCategory, category) async {
    return categories
        .doc(idCategory)
        .update({'category': category.toUpperCase()});
  }

  Future<CategoryEvent> getCategory(idCategory) async {
    final category = await categories.doc(idCategory).get();
    return new CategoryEvent(category.id, category.get('category'));
  }

  String checkName(category) {
    return category
        .replaceAll(RegExp(r'[\s]+'), ' ')
        .replaceAll(RegExp(r'\s$'), '')
        .replaceAll(RegExp(r'^\s'), '');
  }

  Future deleteCategory(idCategory) async {
    CollectionReference tareas = FirebaseFirestore.instance.collection('usuarios').doc('hugo').collection('eventos');
    return tareas
        .where('categoria', isEqualTo: idCategory)
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                print(element.get('categoria'));
                tareas.doc(element.id).update({'categoria': '0001'});
              })
            })
        .then((value) => {categories.doc(idCategory).delete()});
  }
}
