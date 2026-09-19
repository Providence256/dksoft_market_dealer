import 'package:dksoft_market_dealer/core/domain/dealer_model.dart';

final kTestDealers = [
  DealerModel(
    id: '1',
    fullName: 'A - Ngaliema Express',
    phone: '+243810000001',
    provisionDisponible: 500,
    provisionBloquee: 50,
    provisonRetirable: 75,
    status: DealerStatus.valide,
    rating: 4.7,
  ),
  DealerModel(
    id: '2',
    fullName: 'B - Lemba Plus',
    phone: '+243810000002',
    provisionDisponible: 260,
    provisionBloquee: 40,
    provisonRetirable: 32,
    status: DealerStatus.valide,
    rating: 4.5,
  ),
  DealerModel(
    id: '3',
    fullName: 'C - Gombe Premium',
    phone: '+243810000003',
    provisionDisponible: 1000,
    provisionBloquee: 0,
    provisonRetirable: 150,
    status: DealerStatus.valide,
    rating: 4.9,
  ),
  DealerModel(
    id: '4',
    fullName: 'D - Limete Rapide',
    phone: '+243810000004',
    provisionDisponible: 90,
    provisionBloquee: 0,
    // Pas encore validé : aucun gain retirable, ne peut traiter aucune
    // commande (§6.2).
    provisonRetirable: 0,
    status: DealerStatus.enAttente,
    rating: 0,
  ),
  DealerModel(
    id: '5',
    fullName: 'G - Kintambo Shop',
    phone: '+243810000005',
    // Volontairement bas pour illustrer "provision insuffisante" au checkout.
    provisionDisponible: 20,
    provisionBloquee: 0,
    provisonRetirable: 5,
    status: DealerStatus.valide,
    rating: 4.1,
  ),
];
