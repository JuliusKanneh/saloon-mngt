import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: ((context) => HomePage()));
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Course> cartCourses = [];

  void addToCart(Course course) {
    setState(() {
      cartCourses.add(course);
    });
  }

  void removeFromCart(Course course) {
    setState(() {
      cartCourses.remove(course);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('wellenes love 💇‍♀️'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cartCourses: cartCourses),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'your favourate house of beauty',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CartPage(cartCourses: cartCourses),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   child: Column(
            //     children: [
            //       Image(
            //         image: AssetImage(
            //           'assets/banner.jpg',
            //         ),
            //       ),
            //       SizedBox(height: 16.0),
            //       Text(
            //         'Welcome to our app!',
            //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CourseCard(
                    imagePath: 'assets/belasi.jpg',
                    courseName: 'belasi saloon',
                    price: 'location:remera',
                    inCart: cartCourses.contains(Course('assets/belasi.jpg',
                        'belasi saloon', 'location:remera')),
                    onPressed: () {
                      addToCart(Course(
                          'assets/belasi.jpg', 'Web Design Course', 'Free'));
                    },
                    onCartPressed: () {
                      removeFromCart(Course(
                          'assets/belasi.jpg', 'Web Design Course', 'Free'));
                    },
                  ),
                  CourseCard(
                    imagePath: 'assets/bty.jpg',
                    courseName: 'Bella Saloon',
                    price: 'location:Down town',
                    inCart: cartCourses.contains(Course(
                        'assets/html-training.png',
                        'Html crash course',
                        '\$29.99')),
                    onPressed: () {
                      addToCart(Course('assets/html-training.png',
                          'Html crash course', '\$29.99'));
                    },
                    onCartPressed: () {
                      removeFromCart(Course('assets/html-training.png',
                          'Html crash course', '\$29.99'));
                    },
                  ),
                  CourseCard(
                    imagePath: 'assets/moriah.jpg',
                    courseName: 'moriah salon',
                    price: 'location:rebero',
                    inCart: cartCourses.contains(Course(
                        'assets/film.png', 'Film making Course', '\$19.99')),
                    onPressed: () {
                      addToCart(Course(
                          'assets/film.png', 'Film making Course', '\$19.99'));
                    },
                    onCartPressed: () {
                      removeFromCart(Course(
                          'assets/film.png', 'Film making Course', '\$19.99'));
                    },
                  ),
                  CourseCard(
                    imagePath: 'assets/capital.jpg',
                    courseName: 'bwiza salon',
                    price: 'location:kimironko',
                    inCart: cartCourses.contains(Course(
                        'assets/arch.png', 'Arshcad Design Course', '\$19.99')),
                    onPressed: () {
                      addToCart(Course('assets/arch.png',
                          'Arshcad Design Course', '\$19.99'));
                    },
                    onCartPressed: () {
                      removeFromCart(Course('assets/arch.png',
                          'Arshcad Design Course', '\$19.99'));
                    },
                  ),
                  CourseCard(
                    imagePath: 'assets/santos.jpg',
                    courseName: 'santos salon',
                    price: 'giporoso',
                    inCart: cartCourses.contains(Course('assets/download.jpeg',
                        'Graphic Design Course', '\$19.99')),
                    onPressed: () {
                      addToCart(Course('assets/download.jpeg',
                          'Graphic Design Course', '\$19.99'));
                    },
                    onCartPressed: () {
                      removeFromCart(Course('assets/download.jpeg',
                          'Graphic Design Course', '\$19.99'));
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CourseCard(
                    imagePath: 'assets/santos.jpg',
                    courseName: 'Course 1',
                    price: 'Free',
                    inCart: cartCourses.contains(
                        Course('assets/santos.jpg', 'Course 1', 'Free')),
                    onPressed: () {
                      addToCart(
                          Course('assets/santos.jpg', 'Course 1', 'Free'));
                    },
                    onCartPressed: () {
                      removeFromCart(
                          Course('assets/santos.jpg', 'Course 1', 'Free'));
                    },
                  ),
                  CourseCard(
                    imagePath: 'assets/banner.jpg',
                    courseName: 'Course 2',
                    price: '\$29.99',
                    inCart: cartCourses.contains(
                        Course('assets/banner.jpg', 'Course 2', '\$29.99')),
                    onPressed: () {
                      addToCart(
                          Course('assets/banner.jpg', 'Course 2', '\$29.99'));
                    },
                    onCartPressed: () {
                      removeFromCart(
                          Course('assets/banner.jpg', 'Course 2', '\$29.99'));
                    },
                  ),
                  CourseCard(
                    imagePath: 'assets/banner.jpg',
                    courseName: 'Course 3',
                    price: '\$19.99',
                    inCart: cartCourses.contains(
                        Course('assets/banner.jpg', 'Course 3', '\$19.99')),
                    onPressed: () {
                      addToCart(
                          Course('assets/banner.jpg', 'Course 3', '\$19.99'));
                    },
                    onCartPressed: () {
                      removeFromCart(
                          Course('assets/banner.jpg', 'Course 3', '\$19.99'));
                    },
                  ),
                  CourseCard(
                    imagePath: 'assets/banner.jpg',
                    courseName: 'Course 4',
                    price: '\$19.99',
                    inCart: cartCourses.contains(
                        Course('assets/banner.jpg', 'Course 4', '\$19.99')),
                    onPressed: () {
                      addToCart(
                          Course('assets/banner.jpg', 'Course 4', '\$19.99'));
                    },
                    onCartPressed: () {
                      removeFromCart(
                          Course('assets/banner.jpg', 'Course 4', '\$19.99'));
                    },
                  ),
                  CourseCard(
                    imagePath: 'assets/banner.jpg',
                    courseName: 'Course 5',
                    price: '\$19.99',
                    inCart: cartCourses.contains(
                        Course('assets/banner.jpg', 'Course 5', '\$19.99')),
                    onPressed: () {
                      addToCart(
                          Course('assets/banner.jpg', 'Course 5', '\$19.99'));
                    },
                    onCartPressed: () {
                      removeFromCart(
                          Course('assets/banner.jpg', 'Course 5', '\$19.99'));
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 0,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Icon(Icons.home),
                        Text('Home'),
                      ],
                    ),
                    SizedBox(
                      width: 45,
                    ),
                    Column(
                      children: [
                        Icon(Icons.search),
                        Text('Search'),
                      ],
                    ),
                    SizedBox(
                      width: 45,
                    ),
                    Column(
                      children: [
                        Icon(Icons.list),
                        Text('Watchlist'),
                      ],
                    ),
                    SizedBox(
                      width: 45,
                    ),
                    Column(
                      children: [
                        Icon(Icons.person),
                        Text('User'),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String imagePath;
  final String courseName;
  final String price;
  final bool inCart;
  final VoidCallback onPressed;
  final VoidCallback onCartPressed;

  const CourseCard({
    required this.imagePath,
    required this.courseName,
    required this.price,
    required this.inCart,
    required this.onPressed,
    required this.onCartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courseName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    price,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                      ),
                      child: Text(
                        inCart ? 'Remove from Cart' : 'Book Now',
                      ),
                      onPressed: inCart ? onCartPressed : onPressed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Course {
  final String imagePath;
  final String courseName;
  final String price;

  Course(this.imagePath, this.courseName, this.price);
}

class CartPage extends StatelessWidget {
  final List<Course> cartCourses;

  const CartPage({Key? key, required this.cartCourses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cartCourses.length,
        itemBuilder: (context, index) {
          final course = cartCourses[index];
          return ListTile(
            leading: Image.asset(
              course.imagePath,
              width: 40,
              height: 40,
            ),
            title: Text(course.courseName),
            subtitle: Text(course.price),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Implement the checkout functionality here
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckoutPage(cartCourses: cartCourses),
            ),
          );
        },
        label: Text('Checkout'),
        icon: Icon(Icons.shopping_cart),
      ),
    );
  }
}

class CheckoutPage extends StatelessWidget {
  final List<Course> cartCourses;

  const CheckoutPage({Key? key, required this.cartCourses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Center(
        child: Text('Checkout Page'),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Selling Course App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
