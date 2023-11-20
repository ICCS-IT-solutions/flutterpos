class Supplier
{
	final String supplierName;
	final String emailAddress;
	final String contactNum;
	final String cityName;
	final String streetAddress;
	final String postalCode;
	final double outstandingCredit;
	final double currentPayment;
	final double totalPurchases;


	Supplier({required this.supplierName, required this.emailAddress, required this.contactNum, required this.cityName, required this.streetAddress, required this.postalCode, required this.outstandingCredit, required this.currentPayment, required this.totalPurchases});
	factory Supplier.fromDictionary(Map<String,dynamic> dictionary)
	{
		return Supplier(
			supplierName: dictionary["supplier_name"],
			emailAddress: dictionary["email_address"],
			contactNum: dictionary["contact_num"],
			cityName: dictionary["city_name"],
			streetAddress: dictionary["street_address"],
			postalCode: dictionary["postal_code"],
			outstandingCredit: dictionary["outstanding_credit"],
			currentPayment: dictionary["current_payment"],
			totalPurchases: dictionary["total_purchases"],
		);
	}

	Map<String, dynamic> toDictionary()
	{
		return {
			"supplier_name": supplierName,
			"email_address": emailAddress,
			"contact_num": contactNum,
			"city_name": cityName,
			"street_address": streetAddress,
			"postal_code": postalCode,
			"outstanding_credit": outstandingCredit,
			"current_payment": currentPayment,
			"total_purchases": totalPurchases,
		};
	}
}


copyWith({supplierName,  emailAddress, contactNum, cityName, streetAddress, postalCode,outstandingCredit, currentPayment, totalPurchases})
{
	return Supplier(
		supplierName: supplierName,
		emailAddress: emailAddress,
		contactNum: contactNum,
		cityName: cityName,
		streetAddress: streetAddress,
		postalCode: postalCode,
		outstandingCredit: outstandingCredit,
		currentPayment: currentPayment,
		totalPurchases: totalPurchases
	);
}