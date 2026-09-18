import 'package:dksoft_market_dealer/core/domain/category_modal.dart';
import 'package:dksoft_market_dealer/core/domain/sub_category.dart';

const kTestCategory = [
  CategoryModal(
    id: '1',
    name: 'Électronique',
    imageUrl: 'assets/images/categories/electronic.png',
    subCategory: [
      SubCategory(id: '1-1', name: 'Téléphones portables'),
      SubCategory(id: '1-2', name: 'Ordinateurs portables et de bureau'),
      SubCategory(id: '1-3', name: 'Imprimantes et scanners'),
      SubCategory(id: '1-4', name: 'Tablettes'),
      SubCategory(id: '1-5', name: 'Audio et écouteurs'),
      SubCategory(id: '1-6', name: 'Téléviseurs'),
      SubCategory(id: '1-7', name: 'Appareils photo et accessoires'),
    ],
  ),

  CategoryModal(
    id: '2',
    name: 'Mode',
    imageUrl: 'assets/images/categories/mode.png',
    subCategory: [
      SubCategory(id: '2-1', name: 'Vêtements pour hommes'),
      SubCategory(id: '2-2', name: 'Vêtements pour femmes'),
      SubCategory(id: '2-3', name: 'Chaussures'),
      SubCategory(id: '2-4', name: 'Sacs et sacs à main'),
      SubCategory(id: '2-5', name: 'Montres'),
      SubCategory(id: '2-6', name: 'Bijoux'),
      SubCategory(id: '2-7', name: 'Accessoires de mode'),
    ],
  ),

  CategoryModal(
    id: '3',
    name: 'Maison et cuisine',
    imageUrl: 'assets/images/categories/cuisine.png',
    subCategory: [
      SubCategory(id: '3-1', name: 'Meubles'),
      SubCategory(id: '3-2', name: 'Cuisine et salle à manger'),
      SubCategory(id: '3-3', name: 'Électroménager'),
      SubCategory(id: '3-4', name: 'Ustensiles de cuisine'),
      SubCategory(id: '3-5', name: 'Décoration intérieure'),
      SubCategory(id: '3-6', name: 'Literie'),
      SubCategory(id: '3-7', name: 'Éclairage'),
    ],
  ),

  CategoryModal(
    id: '4',
    name: 'Beauté et soins personnels',
    imageUrl: 'assets/images/categories/beauty.png',
    subCategory: [
      SubCategory(id: '4-1', name: 'Soins de la peau'),
      SubCategory(id: '4-2', name: 'Soins capillaires'),
      SubCategory(id: '4-3', name: 'Maquillage'),
      SubCategory(id: '4-4', name: 'Parfums et fragrances'),
      SubCategory(id: '4-5', name: 'Soins pour hommes'),
      SubCategory(id: '4-6', name: 'Bain et soins du corps'),
      SubCategory(id: '4-7', name: 'Accessoires de beauté'),
    ],
  ),

  CategoryModal(
    id: '5',
    name: 'Santé et bien-être',
    imageUrl: 'assets/images/categories/sante.png',
    subCategory: [
      SubCategory(id: '5-1', name: 'Équipements de fitness'),
      SubCategory(id: '5-2', name: 'Vitamines et compléments'),
      SubCategory(id: '5-3', name: 'Soins personnels'),
      SubCategory(id: '5-4', name: 'Matériel médical'),
      SubCategory(id: '5-5', name: 'Premiers secours'),
      SubCategory(id: '5-6', name: 'Produits de bien-être'),
    ],
  ),

  CategoryModal(
    id: '6',
    name: 'Alimentation et épicerie',
    imageUrl: 'assets/images/categories/grocery.png',
    subCategory: [
      SubCategory(id: '6-1', name: 'Produits frais'),
      SubCategory(id: '6-2', name: 'Fruits et légumes'),
      SubCategory(id: '6-3', name: 'Viandes et poissons'),
      SubCategory(id: '6-4', name: 'Boissons'),
      SubCategory(id: '6-5', name: 'Snacks et friandises'),
      SubCategory(id: '6-6', name: 'Aliments en conserve et emballés'),
      SubCategory(id: '6-7', name: 'Boulangerie et pâtisserie'),
    ],
  ),

  CategoryModal(
    id: '7',
    name: 'Bébé et enfants',
    imageUrl: 'assets/images/categories/enfants.png',
    subCategory: [
      SubCategory(id: '7-1', name: 'Vêtements pour bébé'),
      SubCategory(id: '7-2', name: 'Soins pour bébé'),
      SubCategory(id: '7-3', name: 'Couches'),
      SubCategory(id: '7-4', name: 'Alimentation pour bébé'),
      SubCategory(id: '7-5', name: 'Jouets'),
      SubCategory(id: '7-6', name: 'Vêtements pour enfants'),
      SubCategory(id: '7-7', name: 'Fournitures scolaires'),
    ],
  ),

  CategoryModal(
    id: '8',
    name: 'Sports et plein air',
    imageUrl: 'assets/images/categories/sports.png',
    subCategory: [
      SubCategory(id: '8-1', name: 'Fitness et musculation'),
      SubCategory(id: '8-2', name: 'Football'),
      SubCategory(id: '8-3', name: 'Basketball'),
      SubCategory(id: '8-4', name: 'Course à pied'),
      SubCategory(id: '8-5', name: 'Cyclisme'),
      SubCategory(id: '8-6', name: 'Vêtements de sport'),
      SubCategory(id: '8-7', name: 'Équipements de plein air'),
    ],
  ),

  CategoryModal(
    id: '9',
    name: 'Automobile et moto',
    imageUrl: 'assets/images/categories/automobile.png',
    subCategory: [
      SubCategory(id: '9-1', name: 'Accessoires automobiles'),
      SubCategory(id: '9-2', name: 'Accessoires pour motos'),
      SubCategory(id: '9-3', name: 'Électronique automobile'),
      SubCategory(id: '9-4', name: 'Pneus et roues'),
      SubCategory(id: '9-5', name: 'Huiles et liquides'),
      SubCategory(id: '9-6', name: 'Outils et équipements'),
      SubCategory(id: '9-7', name: 'Entretien automobile'),
    ],
  ),

  CategoryModal(
    id: '10',
    name: 'Livres, bureau et école',
    imageUrl: 'assets/images/categories/livre.png',
    subCategory: [
      SubCategory(id: '10-1', name: 'Livres'),
      SubCategory(id: '10-2', name: 'Papeterie'),
      SubCategory(id: '10-3', name: 'Fournitures scolaires'),
      SubCategory(id: '10-4', name: 'Fournitures de bureau'),
      SubCategory(id: '10-5', name: 'Imprimantes et encres'),
      SubCategory(id: '10-6', name: 'Art et loisirs créatifs'),
      SubCategory(id: '10-7', name: 'Équipements de bureau'),
    ],
  ),
];
