import 'package:chem_organizer/src/models/categoryEvent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesController {
  String username;

  CategoriesController(this.username);

  getCategories() async {
    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc(username)
        .collection('categories')
        .snapshots();
  }

  checkCategory(category) {
    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc(username)
        .collection('categories')
        .where('category', isEqualTo: category.toUpperCase());
  }

  addCategory(category) {
    FirebaseFirestore.instance
        .collection('usuarios')
        .doc(username)
        .collection('categories')
        .add({'category': category.text.toUpperCase()});
  }

  Future updateCategory(idCategory, category) async {
    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc(username)
        .collection('categories')
        .doc(idCategory)
        .update({'category': category.toUpperCase()});
  }

  Future<CategoryEvent?> getCategory(idCategory) async {
    final category = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(username)
        .collection('categories')
        .doc(idCategory)
        .get();
    if (category.exists)
      return new CategoryEvent(category.id, category.get('category'));
    else
      return null;
  }

  getCategoriaSelected(idCategory) async{
    String categoriaSelected = "ninguno";
    final category = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(username)
        .collection('categories')
        .doc(idCategory)
        .get();
    if (category.exists){
      categoriaSelected = category.get('category');
      return categoriaSelected;
    }
    else
      return null;
  }

  String checkName(category) {
    return category
        .replaceAll(RegExp(r'[\s]+'), ' ')
        .replaceAll(RegExp(r'\s$'), '')
        .replaceAll(RegExp(r'^\s'), '');
  }

  Future deleteCategory(idCategory) async {
    CollectionReference tareas = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(username)
        .collection('eventos');
    return tareas
        .where('categoria', isEqualTo: idCategory)
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                print(element.get('categoria'));
                tareas.doc(element.id).update({'categoria': '0001'});
              })
            })
        .then((value) => {
              FirebaseFirestore.instance
                  .collection('usuarios')
                  .doc(username)
                  .collection('categories')
                  .doc(idCategory)
                  .delete()
            });
  }
}
