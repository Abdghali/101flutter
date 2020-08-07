class Company {
  String status;
  Data data;
  String message;

  Company({this.status, this.data, this.message});

  Company.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  Info info;
  List<Companies> companies;

  Data({this.info, this.companies});

  Data.fromJson(Map<String, dynamic> json) {
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
    if (json['companies'] != null) {
      companies = new List<Companies>();
      json['companies'].forEach((v) {
        companies.add(new Companies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.info != null) {
      data['info'] = this.info.toJson();
    }
    if (this.companies != null) {
      data['companies'] = this.companies.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Info {
  String companyName;
  int companyCount;

  Info({this.companyName, this.companyCount});

  Info.fromJson(Map<String, dynamic> json) {
    companyName = json['Company_name'];
    companyCount = json['Company_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Company_name'] = this.companyName;
    data['Company_count'] = this.companyCount;
    return data;
  }
}

class Companies {
  int id;
  String name;
  int productsCount;
  int orderCount;
  String image;

  Companies(
      {this.id, this.name, this.productsCount, this.orderCount, this.image});

  Companies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    productsCount = json['productsCount'];
    orderCount = json['orderCount'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['productsCount'] = this.productsCount;
    data['orderCount'] = this.orderCount;
    data['image'] = this.image;
    return data;
  }
}