import '../models/vehicle.dart';

class VehicleService {
  static Future<List<Vehicle>> getFeaturedVehicles() async {
    // Demo data - replace with actual API calls
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Vehicle(
        id: '1',
        name: 'Honda Civic 2022',
        price: 45.0,
        rating: 4.8,
        reviews: 120,
        distance: 2.5,
        imageUrl: 'https://cdn.pixabay.com/photo/2016/11/23/17/24/automobile-1853936_1280.jpg',
        category: 'Cars',
      ),
      Vehicle(
        id: '2',
        name: 'Yamaha MT-15',
        price: 25.0,
        rating: 4.9,
        reviews: 95,
        distance: 1.2,
        imageUrl: 'https://cdn.pixabay.com/photo/2019/07/07/14/03/motorcycle-4322522_1280.jpg',
        category: 'Bikes',
      ),
      Vehicle(
        id: '3',
        name: 'Vespa Primavera',
        price: 18.0,
        rating: 4.7,
        reviews: 68,
        distance: 3.1,
        imageUrl: 'https://cdn.pixabay.com/photo/2017/08/01/00/38/vespa-2564669_1280.jpg',
        category: 'Scooters',
      ),
    ];
  }
}