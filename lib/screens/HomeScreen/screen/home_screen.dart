import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:tiffsy_app/repositories/user_repository.dart';
import 'package:tiffsy_app/screens/HomeScreen/bloc/home_bloc.dart';
import 'package:tiffsy_app/screens/HomeScreen/model/home_model.dart';
import 'package:tiffsy_app/screens/LoginScreen/bloc/login_bloc.dart';
import 'package:tiffsy_app/screens/LoginScreen/screen/login_screen.dart';
import 'package:tiffsy_app/screens/ProfileScreen/screen/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Home();
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeBloc homeBloc = HomeBloc();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    homeBloc.add(HomeInitialFetchEvent());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    homeBloc.close();
    super.dispose();
  }

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            customAddress(
                context, theme, () {
                  _showTopSheet(context);
                }, "Home", "Community Center Road")
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              icon: ClipOval(
                  child: (user.photoURL != null)
                      ? Image.network('${user.photoURL}', fit: BoxFit.cover)
                      : Container(
                          height: 50,
                          width: 50,
                          child: Center(child: Text("R")),
                          color: Colors.teal[100],
                        ))),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: theme.primaryColor,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        shadowColor: theme.focusColor,
        indicatorColor: theme.focusColor,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.restaurant_menu),
            icon: Icon(Icons.restaurant_menu_outlined),
            label: 'Menu',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.credit_card),
            icon: Icon(Icons.credit_card_outlined),
            label: 'Payments',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.food_bank),
            icon: Icon(Icons.food_bank_outlined),
            label: 'Subscription',
          )
        ],
      ),
      body: <Widget>[
        Card(
            color: theme.scaffoldBackgroundColor,
            shadowColor: Colors.transparent,
            margin: const EdgeInsets.all(8.0),
            child: menu(theme, context, homeBloc)),
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Payments',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Subscription',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),
      ][currentPageIndex],
    );
  }
}



void _showTopSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    // isScrollControlled: true,  // Allows the sheet to go beyond the screen height
    builder: (BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Add some top padding to visually differentiate the sheet from the app bar
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: ElevatedButton(
              onPressed: (){},
              child: Text("Add Address"),
            )
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 50,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('Item $index'),
                );
              },
            ),
          ),
        ],
      );
    },
  );
}

Widget customAddress(BuildContext context, ThemeData theme,
    VoidCallback onPressed, String addType, String add) {
  return Container(
      child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(Icons.location_on, size: 36, color: Color(0xffFFBE1D)),
      TextButton(
          onPressed: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    addType,
                    style: const TextStyle(
                      color: Color(0xFF121212),
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 0.09,
                      letterSpacing: 0.15,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(Icons.expand_more)
                ],
              ),
              Text(
                add,
                style: TextStyle(
                  color: Color(0xFF121212),
                  fontSize: 12,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ))
    ],
  ));
}

Widget menu(ThemeData theme, BuildContext context, HomeBloc homeBloc) {
  var _mediaQuery = MediaQuery.of(context);
  return BlocConsumer<HomeBloc, HomeState>(
    bloc: homeBloc,
    listener: (context, state) {},
    builder: (context, state) {
      if (state is HomeLoadingState) {
        return CircularProgressIndicator();
      }
      if (state is HomeFetchSuccessfulState) {
        final menuState = state as HomeFetchSuccessfulState;

        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: _mediaQuery.size.height * 0.2,
                child: Container(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/images/vectors/home_banner.svg',
                    semanticsLabel: 'vector image',
                  ),
                ),
              ),
              const Text("Today´s Menu"),
              SizedBox(
                height: 2000,
                child: ListView.builder(
                  itemCount: menuState.menu.length,
                  itemBuilder: (context, index) {
                    return customCard(theme, context, menuState.menu[index]);
                  },
                ),
              ),
            ],
          ),
        );
      }
      if (state is HomeErrorState) {
        return const SnackBar(
          content: Text("Error"),
        );
      }
      return SizedBox();
    },
  );
}

Widget customCard(ThemeData theme, BuildContext context, MenuDataModel menu) {
  return Card(
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: theme.focusColor,
                    child: Text(menu.type),
                  ),
                  Text(menu.title),
                  Text(menu.description),
                  Text(menu.price.toString())
                ],
              ),
            ),
            Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(
                      color: Colors.red, // Border color
                      width: 2.0, // Border width
                    )),
                child: Image.asset(
                  'assets/images/vectors/thali1 1.png',
                  height: 100,
                  width: 100,
                )),
          ],
        ),
        SvgPicture.asset(
          'assets/images/vectors/Line 5.svg',
        )
      ],
    ),
  );
}

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//   @override
//   State<HomeScreen> createState() => __HomeScreenStateState();
// }

// class __HomeScreenStateState extends State<HomeScreen> {
  
//   // final user = FirebaseAuth.instance.currentUser!;
//   @override
//   Widget build(BuildContext context) {
//     return RepositoryProvider(
//         create: (context) => UserRepository(),
//         child: BlocProvider(
//             create: (context) =>
//                 LoginBloc(userRepository: RepositoryProvider.of(context)),
//             child: content()));
//   }

//   Widget content() {

//     return BlocConsumer<LoginBloc, LoginState>(
//       listener: (context, state) {
//         if(state is UnAuthenticated){
//           Navigator.of(context).pushAndRemoveUntil<Type>(
//             MaterialPageRoute(builder: (context) => const LoginScreen()),
//             (route) => false,
//           );
//         }
//       },
//       builder: (context, state) {
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text(
//               'Tiffsy',
//               textAlign: TextAlign.left,
//             ),
//           ),
//           body: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // const Center(
//               //   child: Text("Welcome to tiffsy"),
//               // ),
//               // Text('${user.displayName}'),
//               // if(user.photoURL !=null)
//               //   Image.network('${user.photoURL}')
//               // else
//               //   Container(),
              
//               // ElevatedButton(onPressed: (){
//               //   context.read<LoginBloc>().add(GoogleSignOutRequested());
//               // }, child: const Text("Sign Out")),
//             ],
//           )
//         );
//       },
//     );
//   }
// }
