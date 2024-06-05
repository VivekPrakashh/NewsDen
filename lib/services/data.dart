import 'package:newsden/models/categorymodel.dart';

List<CategoryModel> getCategories(){

  List<CategoryModel> category=[];
  CategoryModel categoryModel= new CategoryModel();


  categoryModel.categoryName="Business";
  categoryModel.image="images/business.jpeg";
  category.add(categoryModel);
  categoryModel=new CategoryModel();

   categoryModel.categoryName="Entertainment";
  categoryModel.image="images/enterteinment.jpeg";
  category.add(categoryModel);
  categoryModel=new CategoryModel();

   categoryModel.categoryName="General";
  categoryModel.image="images/general.jpeg";
  category.add(categoryModel);
  categoryModel=new CategoryModel();

   categoryModel.categoryName="Sports";
  categoryModel.image="images/sports.jpeg";
  category.add(categoryModel);
  categoryModel=new CategoryModel();

   categoryModel.categoryName="Health";
  categoryModel.image="images/health.jpeg";
  category.add(categoryModel);
  categoryModel=new CategoryModel();

   categoryModel.categoryName="Science";
  categoryModel.image="images/science.jpeg";
  category.add(categoryModel);
  categoryModel=new CategoryModel();

  return category;
}