import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:npi_project/src/controller/api_end_points.dart';
import 'package:npi_project/src/controller/get_student_data.dart';
import 'package:npi_project/src/data/utils/custom_color.dart';
import 'package:npi_project/src/module/admin/home/local_widget/drop_down.dart';
import 'package:npi_project/src/module/admin/home/view/detaild_screen.dart';


class FilterBar extends StatefulWidget {
  const FilterBar({super.key});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  String? selectedTechnology = '', selectedSession = '';
  GetStudentsData getStudentsData = GetStudentsData();



  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropDown(
                apiEndpoint: ApiEndPoints.technologyList,
                onValueChanged: (selectedId){
                  setState(() {
                    if(selectedId == 'Select Technology'){
                      selectedTechnology = '';
                    }else {
                      selectedTechnology = selectedId;
                    }
                  });
                },
                hintText: 'select technology'
            ),

            DropDown(
                apiEndpoint: ApiEndPoints.sessionList,
                onValueChanged: (selectedId){
                  setState(() {
                    if(selectedId == 'Select Session'){
                      selectedSession = '';
                    }else {
                      selectedSession = selectedId;
                    }
                  });
                },
                hintText: 'select session'
            )
          ],
        ),
        Gap(18.h),


        FutureBuilder(
          future: getStudentsData.getFilteredData('$selectedTechnology', '$selectedSession'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: CustomColor.deepOrange,
                  size: 50,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching data: ${snapshot.error}'),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if(snapshot.data!.response == 'No Students Found from $selectedTechnology technology.'){
                return Text('No Students Found from $selectedTechnology technology.');
              }else if(snapshot.data!.response == 'No Students Found from $selectedSession Session'){
                return Text('No Students Found from $selectedSession Session');
              }else if(snapshot.data!.response == 'No Students Found !'){
                return Text('No Students Found from $selectedTechnology technology and $selectedSession Session');
              }else {
                return Container(
                  height: 440.h,
                  child: ListView.builder(
                    shrinkWrap: true,
                    //physics: ,
                    itemCount: snapshot.data!.students!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: CustomColor.deepOrange.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        elevation: 0,
                        child: InkWell(
                          onTap: () =>
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetaildScreen(
                                        privetKey: snapshot.data!.students![index]
                                            .privateId.toString(),
                                      ),
                                ),
                              ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.account_circle, color: Colors.grey,
                              size: 40,),
                            title: Text(
                              snapshot.data!.students![index].name.toString(),
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                                color: CustomColor.lightTeal,
                              ),
                            ),
                            subtitle: Text(
                              snapshot.data!.students![index].roll.toString(),
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                color: CustomColor.blueGrey,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              }else{
              return Text('error');
            }
            }
        )
      ],
    );
  }
}
