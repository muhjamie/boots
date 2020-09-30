
import 'dart:convert';

List<BookinHistory> bookinHistoryFromMap(String str) => List<BookinHistory>.from(json.decode(str).map((x) => BookinHistory.fromMap(x)));

String bookinHistoryToMap(List<BookinHistory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class BookinHistory {
    BookinHistory({
        this.rrId,
        this.rrUserid,
        this.rrDriverid,
        this.rrPackageName,
        this.rrPackageWeight,
        this.rrPackageDetails,
        this.rrFrom,
        this.rrTodestination,
        this.rrOriginLat,
        this.rrOriginLng,
        this.rrDestinationLat,
        this.rrDestinationLng,
        this.rrType,
        this.rrTripfare,
        this.rrOtp,
        this.rrTripstatus,
        this.rrDateadded,
        this.rrTimeinitiated,
        this.rrLastupdated,
    });

    String rrId;
    String rrUserid;
    dynamic rrDriverid;
    String rrPackageName;
    String rrPackageWeight;
    String rrPackageDetails;
    String rrFrom;
    String rrTodestination;
    String rrOriginLat;
    String rrOriginLng;
    String rrDestinationLat;
    String rrDestinationLng;
    String rrType;
    dynamic rrTripfare;
    dynamic rrOtp;
    String rrTripstatus;
    dynamic rrDateadded;
    String rrTimeinitiated;
    DateTime rrLastupdated;

    factory BookinHistory.fromMap(Map<String, dynamic> json) => BookinHistory(
        rrId: json["rr_id"],
        rrUserid: json["rr_userid"],
        rrDriverid: json["rr_driverid"],
        rrPackageName: json["rr_package_name"],
        rrPackageWeight: json["rr_package_weight"],
        rrPackageDetails: json["rr_package_details"],
        rrFrom: json["rr_from"],
        rrTodestination: json["rr_todestination"],
        rrOriginLat: json["rr_origin_lat"],
        rrOriginLng: json["rr_origin_lng"],
        rrDestinationLat: json["rr_destination_lat"],
        rrDestinationLng: json["rr_destination_lng"],
        rrType: json["rr_type"],
        rrTripfare: json["rr_tripfare"],
        rrOtp: json["rr_otp"],
        rrTripstatus: json["rr_tripstatus"],
        rrDateadded: json["rr_dateadded"],
        rrTimeinitiated: json["rr_timeinitiated"],
        rrLastupdated: DateTime.parse(json["rr_lastupdated"]),
    );

    Map<String, dynamic> toMap() => {
        "rr_id": rrId,
        "rr_userid": rrUserid,
        "rr_driverid": rrDriverid,
        "rr_package_name": rrPackageName,
        "rr_package_weight": rrPackageWeight,
        "rr_package_details": rrPackageDetails,
        "rr_from": rrFrom,
        "rr_todestination": rrTodestination,
        "rr_origin_lat": rrOriginLat,
        "rr_origin_lng": rrOriginLng,
        "rr_destination_lat": rrDestinationLat,
        "rr_destination_lng": rrDestinationLng,
        "rr_type": rrType,
        "rr_tripfare": rrTripfare,
        "rr_otp": rrOtp,
        "rr_tripstatus": rrTripstatus,
        "rr_dateadded": rrDateadded,
        "rr_timeinitiated": rrTimeinitiated,
        "rr_lastupdated": rrLastupdated.toIso8601String(),
    };
}
