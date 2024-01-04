PROC IMPORT OUT= WORK.aa 
            DATAFILE= "C:\Users\lilin\Desktop\grad\学位\课程\multiva
riate statistical analysis\SLTBeav.xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Sheet1$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
* 首先要处理数据，把量表中的各项分值整合转换为要用于统计分析的变量，本研究主要使用了九个变量：
  负担感、受损的归属感、失败感、逃避冲动、自杀行为、无助感、抑郁程度、压力感以及自杀意念
  接下来一一计算这些变量;

* 一、负担感：INQR问卷1-6项的得分平均值;
* Reliability Analysis for INQR Items;
proc corr data=aa alpha;
   var INQRitem1 INQRitem2 INQRitem3 INQRitem4 INQRitem5 INQRitem6;
run;

* Compute 'burden' Variable;
data aa;
   set aa;
   burden = mean(of INQRitem1-INQRitem6);
run;

* 二、受损的归属感：INQR问卷后九项处理后的平均值;
* Reverse Coding and Computing 'belong' Variables;
data aa;
   set aa;
   belong1 = 7 - INQRitem7;
   belong2 = 7 - INQRitem8;
   belong3 = INQRitem9;
   belong4 = 7 - INQRitem10;
   belong5 = INQRitem11;
   belong6 = INQRitem12;
   belong7 = 7 - INQRitem13;
   belong8 = 7 - INQRitem14;
   belong9 = 7 - INQRitem15;
run;

* Reliability Analysis for 'belong' Variables;
proc corr data=aa alpha;
   var belong1-belong9;
run;

* Compute 'belong' Variable;
data aa;
   set aa;
   belong = mean(of belong1-belong9);
run;

* 三、失败感;
data aa;
   set aa;
   defeat1 = DSCALEitem1;
   defeat2 = 4 - DSCALEitem2;
   defeat3 = DSCALEitem3;
   defeat4 = 4 - DSCALEitem4;
   defeat5 = DSCALEitem5;
   defeat6 = DSCALEitem6;
   defeat7 = DSCALEitem7;
   defeat8 = DSCALEitem8;
   defeat9 = 4 - DSCALEitem9;
   defeat10 = DSCALEitem10;
   defeat11 = DSCALEitem11;
   defeat12 = DSCALEitem12;
   defeat13 = DSCALEitem13;
   defeat14 = DSCALEitem14;
   defeat15 = DSCALEitem15;
   defeat16 = DSCALEitem16;
run;
* Reliability Analysis for 'defeat' Variables;
proc corr data=aa alpha;
   var defeat1-defeat16;
run;
data aa; set aa;
   defeat = mean(of defeat1-defeat16);
run;

* 四、逃避冲动：entrapment问卷得分平均值;
* Reliability Analysis;
proc corr data=aa alpha;
   var ENTRAPTSCALEitem1-ENTRAPTSCALEitem16;
run;
* Compute 'entrapment' Variable;
data aa;
   set aa;
   entrapment = mean(of ENTRAPTSCALEitem1-ENTRAPTSCALEitem16);
run;

* 五、自杀意念：迷你自杀风险评估第1和第3项得分之和;
*Suicide Ideation Analysis;
data aa;
   set aa;
   if MINISUICIDEitem1 = 1 then MINIideation1=1; else MINIideation1=0;
   if MINISUICIDEitem3 = 1 then MINIideation3=1; else MINIideation3=0;
run;

* Reliability Analysis for MINIideation Variables;
proc corr data=aa alpha;
   var MINIideation1 MINIideation3;
run;

data aa;
   set aa;
   MINIideation = sum(of MINIideation1 MINIideation3);
run;

* 六、抑郁程度：贝克抑郁量表各项得分之和;
data aa;
   set aa;
   BDITristesse = BDIIIitem1 - 1;
   BDIDecouragement = BDIIIitem2 - 1;
   BDIEchec = BDIIIitem3 - 1;
   BDIInsatisfaction = BDIIIitem4 - 1;
   BDICulpabilite = BDIIIitem5 - 1;
   BDIDeception = BDIIIitem6 - 1;
   BDISuicide = BDIIIitem7 - 1;
   BDIInterest = BDIIIitem8 - 1;
   BDIDecision = BDIIIitem9 - 1;
   BDIPerception = BDIIIitem10 - 1;
   BDIRalentissement = BDIIIitem11 - 1;
   BDIFatigue = BDIIIitem12 - 1;
   BDIAppetit = BDIIIitem13 - 1;
run;
* Compute 'BDI' Variable;
data aa;
   set aa;
   BDI = sum(of BDITristesse BDIDecouragement BDIEchec BDIInsatisfaction BDICulpabilite BDIDeception BDISuicide BDIInterest BDIDecision BDIPerception BDIRalentissement BDIFatigue BDIAppetit);
   BDIwithoutsuicide = sum(of BDITristesse BDIDecouragement BDIEchec BDIInsatisfaction BDICulpabilite BDIDeception BDIInterest BDIDecision BDIPerception BDIRalentissement BDIFatigue BDIAppetit);
run;
* Reliability Analysis;
proc corr data=aa alpha;
   var BDITristesse BDIDecouragement BDIEchec BDIInsatisfaction BDICulpabilite BDIDeception BDISuicide BDIInterest BDIDecision BDIPerception BDIRalentissement BDIFatigue BDIAppetit;
run;

* 七、自杀行为：迷你自杀评估量表第5项得分;
data aa;
   set aa;
   if MINISUICIDEitem5 = 1 then SuicidalBehav=1; else SuicidalBehav=0;
run;

* 八、压力感：压力问卷;
data aa;
   set aa;
   Stress1 = STRESSPSS10item1;
   Stress2 = STRESSPSS10item2;
   Stress3 = STRESSPSS10item3;
   Stress4 = 4 - STRESSPSS10item4;
   Stress5 = 4 - STRESSPSS10item5;
   Stress6 = STRESSPSS10item6;
   Stress7 = 4 - STRESSPSS10item7;
   Stress8 = 4 - STRESSPSS10item8;
   Stress9 = STRESSPSS10item9;
   Stress10 = STRESSPSS10item10;
run;
* compute stress;
data aa;
   set aa;
   stress = sum(of Stress1-Stress10);
run;
* reliable analysis;
proc corr data = aa alpha;
   var Stress1-Stress10;
run;

* 九、无助感;
data aa;
   set aa;
   if DESESPOIRBECKitem1 = 2 then Hopelessness1=1; else Hopelessness1=0;
   if DESESPOIRBECKitem2 = 2 then Hopelessness2=0; else Hopelessness2=1;
   if DESESPOIRBECKitem3 = 2 then Hopelessness3=1; else Hopelessness3=0;
   if DESESPOIRBECKitem4 = 2 then Hopelessness4=0; else Hopelessness4=1;
   if DESESPOIRBECKitem5 = 2 then Hopelessness5=1; else Hopelessness5=0;
   if DESESPOIRBECKitem6 = 2 then Hopelessness6=1; else Hopelessness6=0;
   if DESESPOIRBECKitem7 = 2 then Hopelessness7=0; else Hopelessness7=1;
   if DESESPOIRBECKitem8 = 2 then Hopelessness8=1; else Hopelessness8=0;
   if DESESPOIRBECKitem9 = 2 then Hopelessness9=0; else Hopelessness9=1;
   if DESESPOIRBECKitem10 = 2 then Hopelessness10=1; else Hopelessness10=0;
   if DESESPOIRBECKitem11 = 2 then Hopelessness11=0; else Hopelessness11=1;
   if DESESPOIRBECKitem12 = 2 then Hopelessness12=1; else Hopelessness12=0;
   if DESESPOIRBECKitem13 = 2 then Hopelessness13=1; else Hopelessness13=0;
   if DESESPOIRBECKitem14 = 2 then Hopelessness14=0; else Hopelessness14=1;
   if DESESPOIRBECKitem15 = 2 then Hopelessness15=1; else Hopelessness15=0;
   if DESESPOIRBECKitem16 = 2 then Hopelessness16=0; else Hopelessness16=1;
   if DESESPOIRBECKitem17 = 2 then Hopelessness17=0; else Hopelessness17=1;
   if DESESPOIRBECKitem18 = 2 then Hopelessness18=0; else Hopelessness18=1;
   if DESESPOIRBECKitem19 = 2 then Hopelessness19=1; else Hopelessness19=0;
   if DESESPOIRBECKitem20 = 2 then Hopelessness20=0; else Hopelessness20=1;
run;

data aa; set aa;
   hopelessness = sum(of Hopelessness1-Hopelessness20);
run;

proc corr data=aa alpha;
   var Hopelessness1-Hopelessness20;
run;

* 处理完数据后我们得到了9个变量，首先检验这九个变量之间的Pearson相关系数进行初步探索;

proc corr data=aa;
   var burden belong defeat entrapment MINIideation BDI SuicidalBehav stress hopelessness;
run;

* Test of the Interpersonal Theory;
proc means data=aa mean std min max;
   var burden belong;
run;

data aa;
   set aa;
   burdenc = burden - 1.8442266;
   belongc = belong - 2.8829235;
   defeatc = defeat - 1.3452478;
   entrapmentc = entrapment - 1.2631033;
   suicidalbehavc = SuicidalBehav - 0.0228759;
   BDIc = BDI - 8.6699346;
   BDIwitoutsuicidec = BDIwithoutsuicide - 8.5065359;
   hopelessnessc = hopelessness - 4.7770492;
   stressc = stress - 19.2156863;
   BurdenXBelong = burdenc * belongc;
run;

* Regression Analysis;
proc reg data=aa;
   model MINIideation = burdenc belongc BurdenXBelong defeatc;
run;

proc reg data=aa;
   model MINIideation = burdenc belongc BurdenXBelong defeatc entrapmentc;
run;

proc reg data=aa;
   model MINIideation = suicidalbehavc BDIwitoutsuicidec hopelessnessc stressc burdenc belongc BurdenXBelong defeatc entrapmentc;
run;
