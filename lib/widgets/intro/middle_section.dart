import 'package:flutter/material.dart';
import 'package:movie_web/assets.dart';

class MiddleSection extends StatelessWidget {
  const MiddleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      width: double.infinity,
      child: Column(
        children: [
          const Divider(
            height: 8,
            thickness: 8,
            color: Color.fromARGB(255, 35, 35, 35),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            constraints: const BoxConstraints(minHeight: 700),
            alignment: Alignment.center,
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceAround,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 0.5,
                  constraints: const BoxConstraints(minHeight: 700),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        //padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: const Text(
                          'Tải xuống và xem ngoại tuyến',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: const Text(
                          'Tiết kiệm dung lượng, xem ngoại tuyến trên máy bay, tàu lửa hoặc tàu ngầm ...',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(minWidth: 200, maxWidth: 300, minHeight: 700),
                  width: MediaQuery.of(context).size.width * 0.25,
                  alignment: Alignment.center,
                  child: Image.asset(
                    Assets.introSec1,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
          const Divider(
            height: 8,
            thickness: 8,
            color: Color.fromARGB(255, 35, 35, 35),
          ),

          // section 2
          Container(
            margin: const EdgeInsets.only(top: 20),
            constraints: const BoxConstraints(minHeight: 700),
            alignment: Alignment.center,
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceAround,
              children: [
                Container(
                  constraints: const BoxConstraints(maxHeight: 700, minWidth: 500),
                  width: MediaQuery.of(context).size.width * 0.25,
                  alignment: Alignment.center,
                  child: Image.asset(
                    Assets.introSec2,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: MediaQuery.of(context).size.width * 0.5,
                  constraints: const BoxConstraints(minHeight: 700),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: const Text(
                          'Tôi xem bằng cách nào ...',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        //padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                        //width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: const Text(
                          'Thành viên đăng ký Viovid có thể xem ngay trong ứng dụng.',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 8,
            thickness: 8,
            color: Color.fromARGB(255, 35, 35, 35),
          ),
        ],
      ),
    );
  }
}
