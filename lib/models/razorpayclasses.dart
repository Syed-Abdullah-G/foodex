class AccountCreateRequest {
  final String email; //compul
  final String phone; //compul
  final String type; // compul
  final String legalBusinessName; //compul
  final String businessType; //compul
  final Profile profile; // compul


  AccountCreateRequest({
    required this.email,
    required this.phone,
    required this.type,
    required this.legalBusinessName,
    required this.businessType,
    required this.profile,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'phone': phone,
    'type': type,
    'legal_business_name': legalBusinessName,
    'business_type': businessType,
    'profile': profile.toJson(),
  };
}

class Profile {
  final String category;
  final String subcategory;
  final Addresses addresses;

  Profile({
    required this.category,
    required this.subcategory,
    required this.addresses,
  });

  Map<String, dynamic> toJson() => {
    'category': category,
    'subcategory': subcategory,
    'addresses': addresses.toJson(),
  };
}

class Addresses {
  final Address registered;

  Addresses({required this.registered});

  Map<String, dynamic> toJson() => {
    'registered': registered.toJson(),
  };
}

class Address {
  final String street1;
  final String street2;
  final String city;
  final String state;
  final String postal_code;
  final String country;


  Address({
    required this.street1,
    required this.street2,
    required this.city,
    required this.state,
    required this.postal_code,
    required this.country,

  });

  Map<String, dynamic> toJson() => {
    'street1': street1,
    'street2': street2,
    'city': city,
    'state': state,
    'postal_code':postal_code,
    'country': country,

  };
}



// stakeholder_model.dart
class StakeholderRequest {
  final String name;
  final String email;


  StakeholderRequest({
    required this.name,
    required this.email,

  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
  };
}


// product_model.dart
class ProductRequest {
  final String productName;
  final bool tncAccepted;

  ProductRequest({
    required this.productName,
    required this.tncAccepted,
  });

  Map<String, dynamic> toJson() => {
    'product_name': productName,
    'tnc_accepted': tncAccepted,
  };
}

class ProductUpdateRequest {
  final Settlements settlements;
  final bool tncAccepted;

  ProductUpdateRequest({
    required this.settlements,
    required this.tncAccepted,
  });

  Map<String, dynamic> toJson() => {
    'settlements': settlements.toJson(),
    'tnc_accepted': tncAccepted,
  };
}

class Settlements {
  final String accountNumber;
  final String ifscCode;
  final String beneficiaryName;

  Settlements({
    required this.accountNumber,
    required this.ifscCode,
    required this.beneficiaryName,
  });

  Map<String, dynamic> toJson() => {
    'account_number': accountNumber,
    'ifsc_code': ifscCode,
    'beneficiary_name': beneficiaryName,
  };
}
