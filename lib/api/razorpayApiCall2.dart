import 'package:foodex/api/razorpayApiCall.dart';
import 'package:foodex/models/razorpayclasses.dart';

class RazorpayHandler {
  final RazorpayApiService apiService = RazorpayApiService(keyId: "rzp_test_0R7MGhoYIHHFTi", keySecret: "VQv09stqgGyID3id7SM187WX");
  



  Future<String> initiateRazorpayProcess({
    required String email,
    required String phone,
    required String businessName,
    required String accountNumber,
    required String ifscCode,
    required String beneficiaryName,
    required String subcategory,
    required String contactName,
    required String area,
    required String address,
  
  }) async {
    try {
      print("inside inititate functioin");
      // 1. Create Account
      final accountRequest = AccountCreateRequest(
        email: email,
        phone: phone,
        type: 'route',
        legalBusinessName: businessName,
        businessType: "proprietorship",
        profile: Profile(
          category: 'food',
          subcategory: subcategory,
          addresses: Addresses(
            registered: Address(
              street1: address,
              street2: area,
              city: 'Chennai', 
              state: 'Tamil Nadu', postal_code: '600001', country: 'IN',
             
            ),
          ),
        ),
     
      );

      final accountResponse = await apiService.createAccount(accountRequest);
      final accountId = accountResponse['id'];
      print(accountId);
    

      // 2. Create Stakeholder
      final stakeholderRequest = StakeholderRequest(
        name: contactName,
        email: email,
       
      );

      final stakeholder = await apiService.createStakeholder(accountId, stakeholderRequest);
      print(stakeholder);

      // 3. Create Product
      final productRequest = ProductRequest(
        productName: 'route',
        tncAccepted: true,
      );

      final productResponse = await apiService.createProduct(accountId, productRequest);
      final productId = productResponse['id'];
      print("--------------");
      print(productId);

      // 4. Update Product with Settlement Details
      final productUpdateRequest = ProductUpdateRequest(
        settlements: Settlements(
          accountNumber: accountNumber,
          ifscCode: ifscCode,
          beneficiaryName: beneficiaryName,
        ),
        tncAccepted: true,
      );

      final updateprod = await apiService.updateProduct(accountId, productId, productUpdateRequest);
      print(updateprod);
return accountId;

    } catch (e) {
      rethrow; // Let the UI handle the error
    }

    
  }

}