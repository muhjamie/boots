import 'dart:convert';

List<ProfileModel> profileModelFromMap(String str) => List<ProfileModel>.from(json.decode(str).map((x) => ProfileModel.fromMap(x)));

String profileModelToMap(List<ProfileModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ProfileModel {
    ProfileModel({
        this.ruId,
        this.ruName,
        this.ruPhone,
        this.ruEmail,
        this.ruPassword,
        this.ruPhotourl,
        this.ruStatus,
        this.ruClientid,
        this.ruIpaddress,
        this.ruDevicemodel,
        this.ruRegtoken,
        this.ruUsertype,
        this.ruIsverified,
        this.ruTimeverified,
        this.ruRegdate,
        this.ruLastupdated,
    });

    String ruId;
    String ruName;
    String ruPhone;
    String ruEmail;
    String ruPassword;
    dynamic ruPhotourl;
    String ruStatus;
    String ruClientid;
    dynamic ruIpaddress;
    dynamic ruDevicemodel;
    String ruRegtoken;
    String ruUsertype;
    String ruIsverified;
    DateTime ruTimeverified;
    DateTime ruRegdate;
    DateTime ruLastupdated;

    factory ProfileModel.fromMap(Map<String, dynamic> json) => ProfileModel(
        ruId: json["ru_id"],
        ruName: json["ru_name"],
        ruPhone: json["ru_phone"],
        ruEmail: json["ru_email"],
        ruPassword: json["ru_password"],
        ruPhotourl: json["ru_photourl"],
        ruStatus: json["ru_status"],
        ruClientid: json["ru_clientid"],
        ruIpaddress: json["ru_ipaddress"],
        ruDevicemodel: json["ru_devicemodel"],
        ruRegtoken: json["ru_regtoken"],
        ruUsertype: json["ru_usertype"],
        ruIsverified: json["ru_isverified"],
        ruTimeverified: DateTime.parse(json["ru_timeverified"]),
        ruRegdate: DateTime.parse(json["ru_regdate"]),
        ruLastupdated: DateTime.parse(json["ru_lastupdated"]),
    );

    Map<String, dynamic> toMap() => {
        "ru_id": ruId,
        "ru_name": ruName,
        "ru_phone": ruPhone,
        "ru_email": ruEmail,
        "ru_password": ruPassword,
        "ru_photourl": ruPhotourl,
        "ru_status": ruStatus,
        "ru_clientid": ruClientid,
        "ru_ipaddress": ruIpaddress,
        "ru_devicemodel": ruDevicemodel,
        "ru_regtoken": ruRegtoken,
        "ru_usertype": ruUsertype,
        "ru_isverified": ruIsverified,
        "ru_timeverified": ruTimeverified.toIso8601String(),
        "ru_regdate": ruRegdate.toIso8601String(),
        "ru_lastupdated": ruLastupdated.toIso8601String(),
    };
}
