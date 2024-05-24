import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:provider/provider.dart';

import '../providers/planner_model.dart';

class PlannerPreview extends StatefulWidget {
  const PlannerPreview({Key? key}) : super(key: key);

  @override
  State<PlannerPreview> createState() => _PlannerPreviewState();
}

class _PlannerPreviewState extends State<PlannerPreview> {
  List _labels = ['기필', '기선', '전필', '전선', '개별', '졸연', '교필', '인선', '자선', '기타'];
  Map labels_to_category = {
    '기필': '기초필수',
    '기선': '기초선택',
    '전필': '전공필수',
    '전선': '전공선택',
    '개별': '개별연구',
    '졸연': '졸업연구',
    '교필': '교양필수',
    '인선': '인문사회선택',
    '자선': '자유선택',
    '기타': '기타'
  };


  @override
  Widget build(BuildContext context) {
    final planners = Provider.of<PlannerModel>(context);
    List additional_double = [];
    List additional_minor = [];
    List additional_INTERDISCIPLINARY = [];


    for(int i = 0; i < planners.planners[planners.selectedIndex].additional_tracks.length; i++){
      if(planners.planners[planners.selectedIndex].additional_tracks[i].type == "DOUBLE"){
        additional_double.add(planners.planners[planners.selectedIndex].additional_tracks[i].department.name);
      }
      else if(planners.planners[planners.selectedIndex].additional_tracks[i].type == "MINOR"){
        additional_minor.add(planners.planners[planners.selectedIndex].additional_tracks[i].department.name);
      }
      else if(planners.planners[planners.selectedIndex].additional_tracks[i].type == "INTERDISCIPLINARY"){
        additional_INTERDISCIPLINARY.add("자유융합전공");
      }
    }





    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color(0xFFF5F5F5)
      ),
      child: Column(
        children: [
          SizedBox(height: 2,),
          Container(
            width: double.maxFinite,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(planners.planners[planners.selectedIndex].major_track.department.name, style: labelRegular,),

                  if(additional_double.length > 0)...[
                    SizedBox(width: 6,),
                    Text('(복: ${additional_double.join(', ')})', style: labelRegular,),
                  ],
                  if(additional_minor.length > 0)...[
                    SizedBox(width: 6,),
                    Text('(부: ${additional_minor.join(', ')})', style: labelRegular, overflow: TextOverflow.fade,),
                  ],
                  if(additional_INTERDISCIPLINARY.length > 0)...[
                    SizedBox(width: 6,),
                    Text('(자유융합전공)', style: labelRegular, overflow: TextOverflow.fade,),
                  ],
                ],
              ),
            ),
          ),
          Row(
            children: [
              Text('${(100*planners.taken_lectures/planners.planners[planners.selectedIndex].general_track.total_credit).round()}%',
                style: displayBold,),
              SizedBox(width: 10,),
              Text('${planners.taken_lectures.toString()}학점 ${planners.taken_au.toString()}AU 수강', style: bodyRegular,),
              SizedBox(width: 6,),
              Text('(총 ${planners.planners[planners.selectedIndex].general_track.total_credit}학점 ${planners.planners[planners.selectedIndex].general_track.total_au}AU)', style: bodyRegular,),
              // SizedBox(width: 6,),
              // Text('(24)', style: bodyRegular.copyWith(color: OTLColor.pinksMain),),
            ],
          ),
          SizedBox(height: 8,),
          Container(
            width: double.maxFinite,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: LinearProgressIndicator(
                value: (planners.taken_lectures/planners.planners[planners.selectedIndex].general_track.total_credit),
                backgroundColor: Colors.white,
                color: Colors.black45,
                valueColor: AlwaysStoppedAnimation<Color>(OTLColor.pinksMain),
                minHeight: 10,
                semanticsLabel: 'semanticsLabel',
                semanticsValue: 'semanticsValue',
              ),
            ),
          ),
          SizedBox(height: 10,),
          GridView.builder(
            primary: false,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4,
              crossAxisSpacing: 50
            ),
            itemCount: 10,
            itemBuilder: (context, index){

              return Container(
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_labels[index], style: labelBold,),
                    // SizedBox(width: 33,),
                    Text('${planners.category_map[labels_to_category[_labels[index]]]}/${planners.category_map_required[labels_to_category[_labels[index]]]}', style: labelRegular,),
                  ],
                ),
              );
            }
          ),

        ],
      ),
    );
  }
}
