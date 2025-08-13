import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/model/clothes_model.dart';

// Provider for all clothing items organized by service type
final clothingItemsProvider = Provider<Map<String, List<ClothingItemModel>>>((
  ref,
) {
  return {
    'wash_fold': [
      ClothingItemModel(
        name: 'T-shirts / Polos',
        price: 3.0,
        icon: 'tshirt_icon',
      ),
      ClothingItemModel(
        name: 'Shirts / Blouses',
        price: 4.0,
        icon: 'shirt_icon',
      ),
      ClothingItemModel(
        name: 'Trousers / Jeans',
        price: 5.0,
        icon: 'jeans_icon',
      ),
      ClothingItemModel(name: 'Shorts', price: 3.0, icon: 'shorts_icon'),
      ClothingItemModel(name: 'Dresses', price: 6.0, icon: 'dress_icon'),
      ClothingItemModel(name: 'Skirts', price: 4.0, icon: 'skirt_icon'),
      ClothingItemModel(
        name: 'Undergarments',
        price: 2.0,
        icon: 'underwear_icon',
      ),
      ClothingItemModel(name: 'Towels', price: 3.0, icon: 'towel_icon'),
      ClothingItemModel(
        name: 'Bedsheets & Pillowcases',
        price: 5.0,
        icon: 'bedsheet_icon',
      ),
    ],
    'dry_clean': [
      ClothingItemModel(name: 'Suits', price: 20.0, icon: 'suit_icon'),
      ClothingItemModel(
        name: 'Jackets / Blazers',
        price: 12.0,
        icon: 'jacket_icon',
      ),
      ClothingItemModel(name: 'Dresses', price: 10.0, icon: 'dress_icon'),
      ClothingItemModel(name: 'Gowns', price: 25.0, icon: 'gown_icon'),
      ClothingItemModel(name: 'Coats', price: 18.0, icon: 'coat_icon'),
      ClothingItemModel(name: 'Trousers', price: 8.0, icon: 'jeans_icon'),
      ClothingItemModel(
        name: 'Sweaters / Cardigans',
        price: 10.0,
        icon: 'sweater_icon',
      ),
      ClothingItemModel(
        name: 'Scarves & Shawls',
        price: 6.0,
        icon: 'scarf_icon',
      ),
      ClothingItemModel(name: 'Ties & Bow Ties', price: 4.0, icon: 'tie_icon'),
    ],
    'ironing': [
      ClothingItemModel(
        name: 'Shirts / Blouses',
        price: 2.0,
        icon: 'shirt_icon',
      ),
      ClothingItemModel(
        name: 'Trousers / Slacks',
        price: 3.0,
        icon: 'pants_icon',
      ),
      ClothingItemModel(name: 'Skirts', price: 2.5, icon: 'skirt_icon'),
      ClothingItemModel(name: 'Dresses', price: 4.0, icon: 'dress_icon'),
      ClothingItemModel(name: 'Suits', price: 8.0, icon: 'suit_icon'),
      ClothingItemModel(
        name: 'Traditional Wear',
        price: 6.0,
        icon: 'traditional_icon',
      ),
      ClothingItemModel(
        name: 'Bedsheets & Pillowcases',
        price: 3.0,
        icon: 'bedsheet_icon',
      ),
    ],
    'premium': [
      ClothingItemModel(
        name: 'Wedding Gowns',
        price: 50.0,
        icon: 'wedding_dress_icon',
      ),
      ClothingItemModel(
        name: 'Designer Suits',
        price: 35.0,
        icon: 'designer_suit_icon',
      ),
      ClothingItemModel(
        name: 'Leather Jackets',
        price: 30.0,
        icon: 'leather_jacket_icon',
      ),
      ClothingItemModel(
        name: 'Silk Dresses',
        price: 28.0,
        icon: 'silk_dress_icon',
      ),
      ClothingItemModel(
        name: 'Beaded/Embroidered Wear',
        price: 40.0,
        icon: 'beaded_icon',
      ),
      ClothingItemModel(
        name: 'Luxury Coats',
        price: 45.0,
        icon: 'luxury_coat_icon',
      ),
    ],
    'household': [
      ClothingItemModel(
        name: 'Curtains & Drapes',
        price: 15.0,
        icon: 'curtain_icon',
      ),
      ClothingItemModel(
        name: 'Duvets & Comforters',
        price: 20.0,
        icon: 'duvet_icon',
      ),
      ClothingItemModel(name: 'Blankets', price: 12.0, icon: 'blanket_icon'),
      ClothingItemModel(
        name: 'Tablecloths & Runners',
        price: 8.0,
        icon: 'tablecloth_icon',
      ),
      ClothingItemModel(
        name: 'Cushion Covers',
        price: 5.0,
        icon: 'cushion_icon',
      ),
      ClothingItemModel(name: 'Small Rugs', price: 18.0, icon: 'rug_icon'),
    ],
    'footwears': [
      ClothingItemModel(name: 'Sneakers', price: 8.0, icon: 'sneaker_icon'),
      ClothingItemModel(
        name: 'Leather Shoes',
        price: 12.0,
        icon: 'leather_shoe_icon',
      ),
      ClothingItemModel(
        name: 'Suede Shoes',
        price: 15.0,
        icon: 'suede_shoe_icon',
      ),
      ClothingItemModel(name: 'Boots', price: 10.0, icon: 'boot_icon'),
      ClothingItemModel(name: 'Sandals', price: 6.0, icon: 'sandal_icon'),
      ClothingItemModel(name: 'Heels', price: 9.0, icon: 'heel_icon'),
    ],
  };
});

// Provider to get items for a specific service
final serviceClothingItemsProvider =
    Provider.family<List<ClothingItemModel>, String>((ref, serviceId) {
      final allItems = ref.watch(clothingItemsProvider);
      return allItems[serviceId] ?? [];
    });

// Future provider for when you integrate with backend
final clothingItemsFromBackendProvider =
    FutureProvider<Map<String, List<ClothingItemModel>>>((ref) async {
      // TODO: Replace with actual API call
      // final response = await ApiService.getClothingItems();
      // return response.data;

      // For now, return the static data
      return ref.watch(clothingItemsProvider);
    });

// Provider to get items for a specific service from backend
final serviceClothingItemsFromBackendProvider =
    FutureProvider.family<List<ClothingItemModel>, String>((
      ref,
      serviceId,
    ) async {
      final allItems = await ref.watch(clothingItemsFromBackendProvider.future);
      return allItems[serviceId] ?? [];
    });
