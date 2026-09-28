import 'package:e_commerce_app/models/payment_card_model.dart';
import 'package:e_commerce_app/services/firestore_services.dart';
import 'package:e_commerce_app/utils/api_pathes.dart';

abstract class CheckoutServices {
  Future<void> setCard(String userId, PaymentCardModel paymentCard);
  Future<List<PaymentCardModel>> fetchPaymentMethods(
    String userId, [
    bool chosen = false,
  ]);
  Future<PaymentCardModel> fetchSinglePaymentMethod(String userId, String paymentId);
}

class CheckoutServicesImpl implements CheckoutServices {
  final fireStoreServices = FirestoreServices.instance;
  @override
  Future<void> setCard(String userId, PaymentCardModel paymentCard) async =>
      await fireStoreServices.setData(
        path: ApiPathes.paymentCard(userId, paymentCard.id),
        data: paymentCard.toMap(),
      );

  @override
  Future<List<PaymentCardModel>> fetchPaymentMethods(
    String userId, [
    bool chosen = false,
  ]) async => await fireStoreServices.getCollection(
    path: ApiPathes.paymentCards(userId),
    builder: ((data, documentId) => PaymentCardModel.fromMap(data)),
    queryBuilder: chosen
        ? (query) => query.where('isChosen', isEqualTo: true)
        : null,
  );

  @override
  Future<PaymentCardModel> fetchSinglePaymentMethod(
    String userId,
    String paymentId,
  ) async => await fireStoreServices.getDocument(
    path: ApiPathes.paymentCard(userId, paymentId),
    builder: ((data, documentID) => PaymentCardModel.fromMap(data)),
  );
}
