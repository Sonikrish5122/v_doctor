class BookAppointmentModel {
  bool success;
  String message;
  List<AppointmentData> data;

  BookAppointmentModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BookAppointmentModel.fromJson(Map<String, dynamic> json) {
    return BookAppointmentModel(
      success: json['success'],
      message: json['message'],
      data: List<AppointmentData>.from(
          json['data'].map((x) => AppointmentData.fromJson(x))),
    );
  }
}

class AppointmentData {
  List<AppointmentDatum> appointmentData;
  PaymentSessionData paymentSessionData;

  AppointmentData({
    required this.appointmentData,
    required this.paymentSessionData,
  });

  factory AppointmentData.fromJson(Map<String, dynamic> json) {
    return AppointmentData(
      appointmentData: List<AppointmentDatum>.from(
          json['appointmentData'].map((x) => AppointmentDatum.fromJson(x))),
      paymentSessionData:
          PaymentSessionData.fromJson(json['paymentSessionData']),
    );
  }
}

class AppointmentDatum {
  int uniqueId;
  String appointmentDate;
  String time;
  List<PreDiagnosisQuestion> preDiagnosisQuestions;
  String comment;
  String appointmentMode;
  String appointmentType;
  ClinicData clinicData;
  String appointmentId;
  Fees fees;
  List<TestReport> testReports;

  AppointmentDatum({
    required this.uniqueId,
    required this.appointmentDate,
    required this.time,
    required this.preDiagnosisQuestions,
    required this.comment,
    required this.appointmentMode,
    required this.appointmentType,
    required this.clinicData,
    required this.appointmentId,
    required this.fees,
    required this.testReports,
  });

  factory AppointmentDatum.fromJson(Map<String, dynamic> json) {
    return AppointmentDatum(
      uniqueId: json['unique_id'],
      appointmentDate: json['appointmentDate'],
      time: json['time'],
      preDiagnosisQuestions: List<PreDiagnosisQuestion>.from(
          json['preDiagnosisQuestions']
              .map((x) => PreDiagnosisQuestion.fromJson(x))),
      comment: json['comment'],
      appointmentMode: json['appointmentMode'],
      appointmentType: json['appointmentType'],
      clinicData: ClinicData.fromJson(json['clinicData']),
      appointmentId: json['appointment_id'],
      fees: Fees.fromJson(json['fees']),
      testReports: List<TestReport>.from(
          json['testReports'].map((x) => TestReport.fromJson(x))),
    );
  }
}

class ClinicData {
  String clinicId;
  String address;
  String addressUrl;

  ClinicData({
    required this.clinicId,
    required this.address,
    required this.addressUrl,
  });

  factory ClinicData.fromJson(Map<String, dynamic> json) {
    return ClinicData(
      clinicId: json['clinic_id'],
      address: json['address'],
      addressUrl: json['address_url'],
    );
  }
}

class Fees {
  String offlineNewCaseFees;
  String offlineOngoingCaseFees;
  String onlineNewCaseFees;
  String onlineOngoingCaseFees;
  List<String> acceptedPaymentMode;

  Fees({
    required this.offlineNewCaseFees,
    required this.offlineOngoingCaseFees,
    required this.onlineNewCaseFees,
    required this.onlineOngoingCaseFees,
    required this.acceptedPaymentMode,
  });

  factory Fees.fromJson(Map<String, dynamic> json) {
    return Fees(
      offlineNewCaseFees: json['offline_new_case_fees'],
      offlineOngoingCaseFees: json['offline_ongoing_case_fees'],
      onlineNewCaseFees: json['online_new_case_fees'],
      onlineOngoingCaseFees: json['online_ongoing_case_fees'],
      acceptedPaymentMode:
          List<String>.from(json['accepted_payment_mode'].map((x) => x)),
    );
  }
}

class PreDiagnosisQuestion {
  String question;
  String answer;

  PreDiagnosisQuestion({
    required this.question,
    required this.answer,
  });

  factory PreDiagnosisQuestion.fromJson(Map<String, dynamic> json) {
    return PreDiagnosisQuestion(
      question: json['question'] ?? '',
      answer: json['answer'] != null ? json['answer'].toString() : '',
    );
  }
}

class TestReport {
  String reportId;
  String reportName;
  String reportUrl;
  String patientName;
  String reportDate;

  TestReport({
    required this.reportId,
    required this.reportName,
    required this.reportUrl,
    required this.patientName,
    required this.reportDate,
  });

  factory TestReport.fromJson(Map<String, dynamic> json) {
    return TestReport(
      reportId: json['report_id'] ?? '',
      reportName: json['report_name'] ?? '',
      reportUrl: json['report_url'] ?? '',
      patientName: json['patientName'] ?? '',
      reportDate: json['reportDate'] ?? '',
    );
  }
}


class PaymentSessionData {
  String id;
  String? object;
  dynamic afterExpiration;
  dynamic allowPromotionCodes;
  int amountSubtotal;
  int amountTotal;
  AutomaticTax automaticTax;
  String billingAddressCollection;
  String cancelUrl;
  dynamic clientReferenceId;
  dynamic clientSecret;
  dynamic consent;
  dynamic consentCollection;
  int created;
  String currency;
  dynamic currencyConversion;
  List<dynamic> customFields;
  CustomText customText;
  dynamic customer;
  String customerCreation;
  dynamic customerDetails;
  dynamic customerEmail;
  int expiresAt;
  dynamic invoice;
  InvoiceCreation invoiceCreation;
  bool livemode;
  dynamic locale;
  Map<String, dynamic> metadata;
  String mode;
  dynamic paymentIntent;
  dynamic paymentLink;
  String paymentMethodCollection;
  dynamic paymentMethodConfigurationDetails;
  PaymentMethodOptions paymentMethodOptions;
  List<String> paymentMethodTypes;
  String paymentStatus;
  PhoneNumberCollection phoneNumberCollection;
  dynamic recoveredFrom;
  dynamic setupIntent;
  ShippingAddressCollection shippingAddressCollection;
  dynamic shippingCost;
  dynamic shippingDetails;
  List<dynamic> shippingOptions;
  String status;
  dynamic submitType;
  dynamic subscription;
  String successUrl;
  TotalDetails totalDetails;
  String uiMode;
  String url;

  PaymentSessionData({
    required this.id,
    this.object,
    this.afterExpiration,
    this.allowPromotionCodes,
    required this.amountSubtotal,
    required this.amountTotal,
    required this.automaticTax,
    required this.billingAddressCollection,
    required this.cancelUrl,
    this.clientReferenceId,
    this.clientSecret,
    this.consent,
    this.consentCollection,
    required this.created,
    required this.currency,
    this.currencyConversion,
    required this.customFields,
    required this.customText,
    this.customer,
    required this.customerCreation,
    this.customerDetails,
    this.customerEmail,
    required this.expiresAt,
    this.invoice,
    required this.invoiceCreation,
    required this.livemode,
    this.locale,
    required this.metadata,
    required this.mode,
    this.paymentIntent,
    this.paymentLink,
    required this.paymentMethodCollection,
    this.paymentMethodConfigurationDetails,
    required this.paymentMethodOptions,
    required this.paymentMethodTypes,
    required this.paymentStatus,
    required this.phoneNumberCollection,
    this.recoveredFrom,
    this.setupIntent,
    required this.shippingAddressCollection,
    this.shippingCost,
    this.shippingDetails,
    required this.shippingOptions,
    required this.status,
    this.submitType,
    this.subscription,
    required this.successUrl,
    required this.totalDetails,
    required this.uiMode,
    required this.url,
  });

  factory PaymentSessionData.fromJson(Map<String, dynamic> json) {
    return PaymentSessionData(
      id: json['id'],
      object: json['object'],
      afterExpiration: json['after_expiration'],
      allowPromotionCodes: json['allow_promotion_codes'],
      amountSubtotal: json['amount_subtotal'],
      amountTotal: json['amount_total'],
      automaticTax: AutomaticTax.fromJson(json['automatic_tax']),
      billingAddressCollection: json['billing_address_collection'],
      cancelUrl: json['cancel_url'],
      clientReferenceId: json['client_reference_id'],
      clientSecret: json['client_secret'],
      consent: json['consent'],
      consentCollection: json['consent_collection'],
      created: json['created'],
      currency: json['currency'],
      currencyConversion: json['currency_conversion'],
      customFields: json['custom_fields'],
      customText: CustomText.fromJson(json['custom_text']),
      customer: json['customer'],
      customerCreation: json['customer_creation'],
      customerDetails: json['customer_details'],
      customerEmail: json['customer_email'],
      expiresAt: json['expires_at'],
      invoice: json['invoice'],
      invoiceCreation: InvoiceCreation.fromJson(json['invoice_creation']),
      livemode: json['livemode'],
      locale: json['locale'],
      metadata: Map<String, dynamic>.from(json['metadata']),
      mode: json['mode'],
      paymentIntent: json['payment_intent'],
      paymentLink: json['payment_link'],
      paymentMethodCollection: json['payment_method_collection'],
      paymentMethodConfigurationDetails:
          json['payment_method_configuration_details'],
      paymentMethodOptions:
          PaymentMethodOptions.fromJson(json['payment_method_options']),
      paymentMethodTypes:
          List<String>.from(json['payment_method_types'].map((x) => x)),
      paymentStatus: json['payment_status'],
      phoneNumberCollection:
          PhoneNumberCollection.fromJson(json['phone_number_collection']),
      recoveredFrom: json['recovered_from'],
      setupIntent: json['setup_intent'],
      shippingAddressCollection: ShippingAddressCollection.fromJson(
          json['shipping_address_collection']),
      shippingCost: json['shipping_cost'],
      shippingDetails: json['shipping_details'],
      shippingOptions: json['shipping_options'],
      status: json['status'],
      submitType: json['submit_type'],
      subscription: json['subscription'],
      successUrl: json['success_url'],
      totalDetails: TotalDetails.fromJson(json['total_details']),
      uiMode: json['ui_mode'],
      url: json['url'],
    );
  }
}

class AutomaticTax {
  bool enabled;
  dynamic liability;
  dynamic status;

  AutomaticTax({
    required this.enabled,
    this.liability,
    this.status,
  });

  factory AutomaticTax.fromJson(Map<String, dynamic> json) {
    return AutomaticTax(
      enabled: json['enabled'] ?? false,
      liability: json['liability'],
      status: json['status'],
    );
  }
}

class CustomText {
  dynamic afterSubmit;
  dynamic shippingAddress;
  dynamic submit;
  dynamic termsOfServiceAcceptance;

  CustomText({
    this.afterSubmit,
    this.shippingAddress,
    this.submit,
    this.termsOfServiceAcceptance,
  });

  factory CustomText.fromJson(Map<String, dynamic> json) {
    return CustomText(
      afterSubmit: json['after_submit'],
      shippingAddress: json['shipping_address'],
      submit: json['submit'],
      termsOfServiceAcceptance: json['terms_of_service_acceptance'],
    );
  }
}

class InvoiceCreation {
  bool enabled;
  InvoiceData invoiceData;

  InvoiceCreation({
    required this.enabled,
    required this.invoiceData,
  });

  factory InvoiceCreation.fromJson(Map<String, dynamic> json) {
    return InvoiceCreation(
      enabled: json['enabled'],
      invoiceData: InvoiceData.fromJson(json['invoice_data']),
    );
  }
}

class InvoiceData {
  dynamic accountTaxIds;
  dynamic customFields;
  dynamic description;
  dynamic footer;
  Issuer issuer;
  Map<String, dynamic> metadata;
  dynamic renderingOptions;

  InvoiceData({
    this.accountTaxIds,
    this.customFields,
    this.description,
    this.footer,
    required this.issuer,
    required this.metadata,
    this.renderingOptions,
  });

  factory InvoiceData.fromJson(Map<String, dynamic> json) {
    return InvoiceData(
      accountTaxIds: json['account_tax_ids'],
      customFields: json['custom_fields'],
      description: json['description'],
      footer: json['footer'],
      issuer: Issuer.fromJson(json['issuer']),
      metadata: Map<String, dynamic>.from(json['metadata']),
      renderingOptions: json['rendering_options'],
    );
  }
}

class Issuer {
  String type;

  Issuer({
    required this.type,
  });

  factory Issuer.fromJson(Map<String, dynamic> json) {
    return Issuer(
      type: json['type'],
    );
  }
}

class PaymentMethodOptions {
  Card card;

  PaymentMethodOptions({
    required this.card,
  });

  factory PaymentMethodOptions.fromJson(Map<String, dynamic> json) {
    return PaymentMethodOptions(
      card: Card.fromJson(json['card']),
    );
  }
}

class Card {
  String requestThreeDSecure;

  Card({
    required this.requestThreeDSecure,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      requestThreeDSecure: json['request_three_d_secure'],
    );
  }
}

class PhoneNumberCollection {
  bool enabled;

  PhoneNumberCollection({
    required this.enabled,
  });

  factory PhoneNumberCollection.fromJson(Map<String, dynamic> json) {
    return PhoneNumberCollection(
      enabled: json['enabled'],
    );
  }
}

class ShippingAddressCollection {
  List<String> allowedCountries;

  ShippingAddressCollection({
    required this.allowedCountries,
  });

  factory ShippingAddressCollection.fromJson(Map<String, dynamic> json) {
    return ShippingAddressCollection(
      allowedCountries:
          List<String>.from(json['allowed_countries'].map((x) => x)),
    );
  }
}

class TotalDetails {
  int amountDiscount;
  int amountShipping;
  int amountTax;

  TotalDetails({
    required this.amountDiscount,
    required this.amountShipping,
    required this.amountTax,
  });

  factory TotalDetails.fromJson(Map<String, dynamic> json) {
    return TotalDetails(
      amountDiscount: json['amount_discount'],
      amountShipping: json['amount_shipping'],
      amountTax: json['amount_tax'],
    );
  }
}
