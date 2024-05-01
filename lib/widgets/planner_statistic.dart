import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';

const TYPES_SHORT = [
  "br",
  "be",
  "mr",
  "me",
  "hse",
  "etc",
];

class PlannerStatistic extends StatefulWidget {
  const PlannerStatistic({Key? key}) : super(key: key);

  @override
  State<PlannerStatistic> createState() => _PlannerStatisticState();
}

class _PlannerStatisticState extends State<PlannerStatistic> {

  List statisticLabel = ['전체', '기초', '전공', '부전', '연구', '교양', '전공'];
  List statisticLabeladdi = ['', '', '전산학부', '산업디자인학과', '', '', '산업디자인학과'];
  List statisticBarLabel1 = ['학점', '기필', '전필', '전필', '졸업', '교필', '자선'];
  List statisticBarLabel2 = ['AU', '기선', '전선', '전선', '개별', '인선', ''];


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth*0.08),
      height: 660,
      child: GridView.builder(
        primary: false,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: screenWidth*0.1),
        itemCount: 7,
        itemBuilder: (context, index) => statisticBlock(index, 0.9, 0.3),
      ),
    );
  }



  Widget statisticBlock(int index, double value1, double value2){
    return Container(
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: 30,
                  child: Text(statisticLabel[index], style: bodyBold, textAlign: TextAlign.start)
              ),
              SizedBox(width: 10,),
              Text(statisticLabeladdi[index], style: labelRegular,)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 30,
                child: Text(statisticBarLabel1[index], style: bodyRegular,)
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('123/123', style: labelRegular.copyWith(color: OTLColor.gray6),),
                  SizedBox(height: 3,),
                  Container(
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: LinearProgressIndicator(
                        value: value1,
                        backgroundColor: OTLColor.grayE,
                        color: Colors.black45,
                        valueColor: AlwaysStoppedAnimation<Color>(OTLColor.plannerBlockColors[index]),
                        minHeight: 7.0,
                        semanticsLabel: 'semanticsLabel',
                        semanticsValue: 'semanticsValue',
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          if(index != 6)...[
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    width: 30,
                    child: Text(statisticBarLabel2[index], style: bodyRegular,)
                ),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('123/123', style: labelRegular.copyWith(color: OTLColor.gray6),),
                    SizedBox(height: 3,),
                    Container(
                      width: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: LinearProgressIndicator(
                          value: value2,
                          backgroundColor: OTLColor.grayE,
                          color: Colors.black45,
                          valueColor: AlwaysStoppedAnimation<Color>(OTLColor.plannerBlockColors[index]),
                          minHeight: 7.0,
                          semanticsLabel: 'semanticsLabel',
                          semanticsValue: 'semanticsValue',
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ]
        ],
      ),
    );
  }
}
