import 'package:foodex/api/razorpayApiCall.dart';
import 'package:foodex/models/razorpayclasses.dart';

class RazorpayHandler {
  final RazorpayApiService apiService;
  
  static const String keyId = "rzp_test_YourKeyHere";
  static const String keySecret = "YourSecretHere";
 

  RazorpayHandler()
      : apiService = RazorpayApiService(keyId: keyId, keySecret: keySecret);

  Future<void> initiateRazorpayProcess({
    required String razorpayId,
    required String email,
    required String phone,
    required String businessName,
    required String accountNumber,
    required String ifscCode,
    required String beneficiaryName,
    required String contactName,
    required String businessType,
    required String area,
    required String pan,
    required String gst,
  }) async {
    try {
      // 1. Create Account
      final accountRequest = AccountCreateRequest(
        email: email,
        phone: phone,
        type: 'route',
        legalBusinessName: businessName,
        businessType: businessType,
        contactName: contactName,
        profile: Profile(
          category: 'retail',
          subcategory: 'general_store',
          addresses: Addresses(
            registered: Address(
              street1: area,
              street2: '',
              city: 'Your City', 
              state: 'Your State',
             
            ),
          ),
        ),
     
      );

      final accountResponse = await apiService.createAccount(accountRequest);
      final accountId = accountResponse['id'];

      // 2. Create Stakeholder
      final stakeholderRequest = StakeholderRequest(
        name: contactName,
        email: email,
        addresses: StakeholderAddresses(
          residential: ResidentialAddress(
            street: area,
            city: 'Your City', // You might want to pass this as parameter
            state: 'Your State', // You might want to pass this as parameter
            
          ),
        ),
     
      );

      await apiService.createStakeholder(accountId, stakeholderRequest);

      // 3. Create Product
      final productRequest = ProductRequest(
        productName: 'route',
        tncAccepted: true,
      );

      final productResponse = await apiService.createProduct(accountId, productRequest);
      final productId = productResponse['id'];

      // 4. Update Product with Settlement Details
      final productUpdateRequest = ProductUpdateRequest(
        settlements: Settlements(
          accountNumber: accountNumber,
          ifscCode: ifscCode,
          beneficiaryName: beneficiaryName,
        ),
        tncAccepted: true,
      );

      await apiService.updateProduct(accountId, productId, productUpdateRequest);

    } catch (e) {
      rethrow; // Let the UI handle the error
    }
  }
}