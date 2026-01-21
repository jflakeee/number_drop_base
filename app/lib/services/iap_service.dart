import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart' hide kIsWeb;

/// Product IDs for in-app purchases
class IAPProducts {
  // Coin packages
  static const String coins500 = 'coins_500';
  static const String coins1500 = 'coins_1500';
  static const String coins5000 = 'coins_5000';

  // Remove ads
  static const String removeAds = 'remove_ads';

  // Premium (removes ads + bonus coins)
  static const String premium = 'premium';

  static const Set<String> allProducts = {
    coins500,
    coins1500,
    coins5000,
    removeAds,
    premium,
  };

  // Coin amounts for each package
  static int getCoinsForProduct(String productId) {
    switch (productId) {
      case coins500:
        return 500;
      case coins1500:
        return 1500;
      case coins5000:
        return 5000;
      case premium:
        return 2000; // Bonus coins
      default:
        return 0;
    }
  }
}

/// Service for handling in-app purchases
class IAPService {
  static IAPService? _instance;
  static IAPService get instance {
    _instance ??= IAPService._();
    return _instance!;
  }

  IAPService._();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _available = false;
  List<ProductDetails> _products = [];
  bool _removeAds = false;
  bool _isPremium = false;

  // Callbacks
  Function(int coins)? onCoinsEarned;
  Function()? onAdsRemoved;
  Function(String error)? onError;

  // Getters
  bool get available => _available;
  List<ProductDetails> get products => _products;
  bool get removeAds => _removeAds;
  bool get isPremium => _isPremium;

  /// Initialize the IAP service
  Future<void> init() async {
    // Skip on web platform - IAP not supported
    if (kIsWeb) {
      debugPrint('IAPService: Skipping on web platform');
      return;
    }

    try {
      _available = await _iap.isAvailable();

      if (!_available) {
        debugPrint('IAP not available');
        return;
      }

      // Load products
      await _loadProducts();

      // Listen to purchase updates
      _subscription = _iap.purchaseStream.listen(
        _onPurchaseUpdated,
        onDone: _onDone,
        onError: _onError,
      );

      // Restore purchases
      await restorePurchases();
    } catch (e) {
      debugPrint('IAPService init error: $e');
    }
  }

  /// Load products from store
  Future<void> _loadProducts() async {
    final response = await _iap.queryProductDetails(IAPProducts.allProducts);

    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('Products not found: ${response.notFoundIDs}');
    }

    _products = response.productDetails;
  }

  /// Purchase a product
  Future<bool> purchase(ProductDetails product) async {
    if (!_available) return false;

    final purchaseParam = PurchaseParam(productDetails: product);

    try {
      if (product.id == IAPProducts.removeAds ||
          product.id == IAPProducts.premium) {
        // Non-consumable
        return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        // Consumable (coins)
        return await _iap.buyConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
      onError?.call(e.toString());
      return false;
    }
  }

  /// Restore previous purchases
  Future<void> restorePurchases() async {
    if (!_available) return;
    await _iap.restorePurchases();
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      _handlePurchase(purchase);
    }
  }

  void _handlePurchase(PurchaseDetails purchase) {
    if (purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored) {
      // Verify and deliver product
      _deliverProduct(purchase);
    } else if (purchase.status == PurchaseStatus.error) {
      onError?.call(purchase.error?.message ?? 'Purchase failed');
    }

    // Complete pending purchases
    if (purchase.pendingCompletePurchase) {
      _iap.completePurchase(purchase);
    }
  }

  void _deliverProduct(PurchaseDetails purchase) {
    final productId = purchase.productID;

    switch (productId) {
      case IAPProducts.coins500:
      case IAPProducts.coins1500:
      case IAPProducts.coins5000:
        final coins = IAPProducts.getCoinsForProduct(productId);
        onCoinsEarned?.call(coins);
        break;

      case IAPProducts.removeAds:
        _removeAds = true;
        onAdsRemoved?.call();
        break;

      case IAPProducts.premium:
        _isPremium = true;
        _removeAds = true;
        final coins = IAPProducts.getCoinsForProduct(productId);
        onCoinsEarned?.call(coins);
        onAdsRemoved?.call();
        break;
    }
  }

  void _onDone() {
    _subscription?.cancel();
  }

  void _onError(dynamic error) {
    onError?.call(error.toString());
  }

  /// Get product by ID
  ProductDetails? getProduct(String productId) {
    try {
      return _products.firstWhere((p) => p.id == productId);
    } catch (e) {
      return null;
    }
  }

  /// Dispose resources
  void dispose() {
    _subscription?.cancel();
  }
}
