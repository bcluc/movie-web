import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_web/widgets/dialog/person_detail.dart';

class GridPersons extends StatelessWidget {
  const GridPersons({
    super.key,
    required this.personsData,
    this.isCast = true,
  });

  final List<dynamic> personsData;
  final bool isCast;

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisExtent: 371,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      children: List.generate(
        personsData.length,
        (index) {
          final profilePath = personsData[index]['person']['profile_path'];

          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => PersonDetailDialog(
                    personId: personsData[index]['person']['id'],
                    isCast: isCast,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black,
                  border: Border.all(color: const Color.fromARGB(40, 255, 255, 255)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    profilePath == null
                        ? SizedBox(
                            height: 253,
                            child: Center(
                              child: Icon(
                                personsData[index]['person']['gender'] == 0
                                    ? Icons.person_rounded
                                    : Icons.person_3_rounded,
                                color: Colors.grey,
                                size: 48,
                              ),
                            ),
                          )
                        : ClipRRect(
                            // minus border's width = 1
                            borderRadius: BorderRadius.circular(7),
                            // child: Image.network(
                            //   'https://www.themoviedb.org/t/p/w276_and_h350_face/${personsData[index]['person']['profile_path']}',
                            //   width: double.infinity,
                            //   height: 253,
                            //   fit: BoxFit.cover,
                            // ),
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://www.themoviedb.org/t/p/w276_and_h350_face/${personsData[index]['person']['profile_path']}',
                              height: 253,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              fadeInDuration: const Duration(milliseconds: 500),
                              fadeOutDuration: const Duration(milliseconds: 0),
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            personsData[index]['person']['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            personsData[index]['role'],
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
