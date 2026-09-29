import '../entities/visa_entity.dart';
import '../entities/visa_request_entity.dart';

abstract class IVisaRepository {
  /// Fetch all visa countries catalog
  Future<List<VisaEntity>> getVisaCatalog();

  /// Realtime stream of visa catalog
  Stream<List<VisaEntity>> watchVisaCatalog();

  /// Get visa details by country or ID
  Future<VisaEntity?> getVisaById(String visaId);

  /// Submit a visa request (saved in visa_requests as pending)
  Future<VisaRequestEntity> createVisaRequest(VisaRequestEntity request);

  /// Fetch visa requests for a specific customer
  Future<List<VisaRequestEntity>> getCustomerVisaRequests(String userId);

  /// Stream of customer visa requests for live status updates
  Stream<List<VisaRequestEntity>> watchCustomerVisaRequests(String userId);

  // Admin Operations
  Future<List<VisaRequestEntity>> getAllVisaRequests({VisaRequestStatus? status});

  Future<void> updateVisaRequestStatus({
    required String requestId,
    required VisaRequestStatus status,
    String? adminNotes,
  });

  Future<String> addVisaCountry(VisaEntity visa);
  Future<void> updateVisaCountry(VisaEntity visa);
  Future<void> deleteVisaCountry(String visaId);
}
