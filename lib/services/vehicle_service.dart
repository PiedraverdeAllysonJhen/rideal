import '../models/vehicle.dart';

class VehicleService {
  static Future<List<Vehicle>> getFeaturedVehicles() async {
    // Demo data - replace with actual API calls
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Vehicle(
        id: '1',
        name: 'Honda Civic',
        price: 100.0,
        rating: 4.8,
        reviews: 5,
        distance: 2.5,
        imageUrl: 'https://imgcdnblog.carmudi.com.ph/carmudi-ph/wp-content/uploads/2019/03/07114302/Honda-Civic-e1561724626589.jpg',
        category: 'Cars',
      ),
      Vehicle(
        id: '2',
        name: 'Yamaha MT-15',
        price: 50.0,
        rating: 4.9,
        reviews: 95,
        distance: 1.2,
        imageUrl: 'https://www.philmotors.com/image/2019-Yamaha-MT15-Black-Raven-155cc-private-58160_1.jpg',
        category: 'Bikes',
      ),
      Vehicle(
        id: '3',
        name: 'Vespa Primavera',
        price: 30.0,
        rating: 4.7,
        reviews: 68,
        distance: 3.1,
        imageUrl: 'https://scontent.fmnl30-3.fna.fbcdn.net/v/t39.30808-6/492436078_10162169135399870_861503884324893944_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=127cfc&_nc_eui2=AeFufRVRXkR4czp0hZ2rLnYuidykAVBJq6yJ3KQBUEmrrOgLEVsC5injN46--mFjei6R-KEPBedamUeG2MGeBh_o&_nc_ohc=A-wOecEWyFYQ7kNvwGRk5CZ&_nc_oc=Adko-jB-s8WQy_5FoJ7HEjDpBTyDmCppv1NAVQuR6NQ80FqrXjDXD1VLRrXgtt9SIJ4&_nc_zt=23&_nc_ht=scontent.fmnl30-3.fna&_nc_gid=i8mLjsPQ4eLA8J1xXmEyNw&oh=00_AfLcfCNBayLJuSxAmtavRC_xPGiKLz0HDVsxwpbRq8KoQQ&oe=683B4A5B',
        category: 'Scooters',
      ),
        Vehicle(
        id: '4',
        name: 'Santa Cruz',
        price: 20.0,
        rating: 4.7,
        reviews: 90,
        distance: 1.3,
        imageUrl: 'https://www.imbikemag.com/wp-content/uploads/2021/12/P1054613.jpg',
        category: 'Bikes',
        ),


    ];
  }
}