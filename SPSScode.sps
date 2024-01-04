##########Thwarted belongingness and perceived burdensomeness

RELIABILITY
  /VARIABLES=INQRitem1 INQRitem2 INQRitem3 INQRitem4 INQRitem5 INQRitem6
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /SUMMARY=TOTAL.

COMPUTE burden=mean(INQRitem1 to INQRitem6).
EXECUTE.

Items 7, 8, 10, 13, 14, and 15 are reverse coded.

COMPUTE belong1=7 - INQRitem7.
COMPUTE belong2=7 - INQRitem8.
COMPUTE belong3=INQRitem9.
COMPUTE belong4=7 - INQRitem10.
COMPUTE belong5=INQRitem11.
COMPUTE belong6=INQRitem12.
COMPUTE belong7=7 - INQRitem13.
COMPUTE belong8=7 - INQRitem14.
COMPUTE belong9=7 - INQRitem15.
EXECUTE.

RELIABILITY
  /VARIABLES=belong1 belong2 belong3 belong4 belong5 belong6 belong7 belong8 
    belong9
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /SUMMARY=TOTAL.

COMPUTE belong=mean(belong1 to belong9).
EXECUTE.


##########Defeat

COMPUTE Defeat1= DSCALEitem1.
COMPUTE Defeat2=4 - DSCALEitem2.
COMPUTE Defeat3=DSCALEitem3.
COMPUTE Defeat4=4 -DSCALEitem4.
COMPUTE Defeat5=DSCALEitem5.
COMPUTE Defeat6=DSCALEitem6.
COMPUTE Defeat7=DSCALEitem7.
COMPUTE Defeat8=DSCALEitem8.
COMPUTE Defeat9=4 -DSCALEitem9.
COMPUTE Defeat10=DSCALEitem10.
COMPUTE Defeat11=DSCALEitem11.
COMPUTE Defeat12=DSCALEitem12.
COMPUTE Defeat13=DSCALEitem13.
COMPUTE Defeat14=DSCALEitem14.
COMPUTE Defeat15=DSCALEitem15.
COMPUTE Defeat16=DSCALEitem16.
EXECUTE.

RELIABILITY
  /VARIABLES=Defeat1 Defeat2 Defeat3 Defeat4 Defeat5 Defeat6 Defeat7 Defeat8 Defeat9 Defeat10 
    Defeat11 Defeat12 Defeat13 Defeat14 Defeat15 Defeat16
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /SUMMARY=TOTAL.

COMPUTE Defeat=mean(Defeat1 to Defeat16).
EXECUTE.


##########Entrapment

RELIABILITY
  /VARIABLES=ENTRAPTSCALEitem1 ENTRAPTSCALEitem2 ENTRAPTSCALEitem3 ENTRAPTSCALEitem4 
    ENTRAPTSCALEitem5 ENTRAPTSCALEitem6 ENTRAPTSCALEitem7 ENTRAPTSCALEitem8 ENTRAPTSCALEitem9 
    ENTRAPTSCALEitem10 ENTRAPTSCALEitem11 ENTRAPTSCALEitem12 ENTRAPTSCALEitem13 ENTRAPTSCALEitem14 
    ENTRAPTSCALEitem15 ENTRAPTSCALEitem16
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /SUMMARY=TOTAL.


COMPUTE Entrapment=mean(ENTRAPTSCALEitem1 to ENTRAPTSCALEitem16).
EXECUTE.

##########Suicide Ideation MINI

IF  (MINISUICIDEitem1 = 1) MINIideation1=1.
IF  (MINISUICIDEitem1 = 2) MINIideation1=0.
IF  (MINISUICIDEitem3 = 1) MINIideation3=1.
IF  (MINISUICIDEitem3 = 2) MINIideation3=0.
EXECUTE.

RELIABILITY
  /VARIABLES=MINIideation1 MINIideation3
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /SUMMARY=TOTAL.

CORRELATIONS
  /VARIABLES=MINIideation1 MINIideation3
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

COMPUTE MINIideation=sum(MINIideation1, MINIideation3).
EXECUTE.

FREQUENCIES VARIABLES=MINIideation
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN MEDIAN
  /HISTOGRAM NORMAL
  /ORDER=ANALYSIS.

########## Test of the interpersonal theory

FREQUENCIES VARIABLES=burden belong
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN
  /ORDER=ANALYSIS.

COMPUTE burdenc=burden - 1.8442265795206974.
COMPUTE belongc=belong - 2.882923497267759.
EXECUTE.

FREQUENCIES VARIABLES=burden belong burdenc belongc
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN
  /ORDER=ANALYSIS.

COMPUTE BurdenXBelong=burdenc * belongc.
EXECUTE.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT MINIideation
  /METHOD=ENTER burdenc belongc
  /METHOD=ENTER BurdenXBelong.

########## Test of the escape theory

FREQUENCIES VARIABLES=Defeat Entrapment
  /FORMAT=NOTABLE
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN
  /ORDER=ANALYSIS.

COMPUTE Defeatc=Defeat - 1.3452478213507624.
COMPUTE Entrapmentc=Entrapment - 1.263103318250377.
EXECUTE.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT MINIideation
  /METHOD=ENTER Defeat
  /METHOD=ENTER Entrapment.

########## Test of the two models

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT MINIideation
  /METHOD=ENTER burdenc belongc BurdenXBelong
  /METHOD=ENTER Defeatc
  /METHOD=ENTER Entrapmentc.



##########BDI

COMPUTE BDITristesse=BDIIIitem1 - 1.
COMPUTE BDIDecouragement=BDIIIitem2 -1.
COMPUTE BDIEchec=BDIIIitem3 - 1.
COMPUTE BDIInsatisfaction=BDIIIitem4 - 1.
COMPUTE BDICulpabilite=BDIIIitem5 - 1.
COMPUTE BDIDeception=BDIIIitem6 - 1.
COMPUTE BDISuicide=BDIIIitem7 - 1.
COMPUTE BDIInterest=BDIIIitem8 - 1.
COMPUTE BDIDecision=BDIIIitem9 - 1.
COMPUTE BDIPerception=BDIIIitem10 - 1.
COMPUTE BDIRalentissement=BDIIIitem11 - 1.
COMPUTE BDIFatigue=BDIIIitem12 - 1.
COMPUTE BDIAppetit=BDIIIitem13 - 1.
EXECUTE.

RELIABILITY
  /VARIABLES=BDITristesse BDIDecouragement BDIEchec BDIInsatisfaction BDICulpabilite BDIDeception 
    BDISuicide BDIInterest BDIDecision BDIPerception BDIRalentissement BDIFatigue BDIAppetit
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /SUMMARY=TOTAL.

COMPUTE BDI=sum(BDITristesse,BDIDecouragement,BDIEchec,BDIInsatisfaction,BDICulpabilite,
    BDIDeception,BDISuicide,BDIInterest,BDIDecision,BDIPerception,BDIRalentissement,BDIFatigue,
    BDIAppetit).
EXECUTE.

FREQUENCIES VARIABLES=BDI
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN
  /HISTOGRAM NORMAL
  /ORDER=ANALYSIS.


##########Suicidal behavior (past month)

IF  (MINISUICIDEitem5 = 1) SuicidalBehav=1.
IF  (MINISUICIDEitem5 = 2) SuicidalBehav=0.
EXECUTE.


##########Stress

COMPUTE Stress1=STRESSPSS10item1.
COMPUTE Stress2=STRESSPSS10item2.
COMPUTE Stress3=STRESSPSS10item3.
COMPUTE Stress4=4 - STRESSPSS10item4.
COMPUTE Stress5=4 -STRESSPSS10item5.
COMPUTE Stress6=STRESSPSS10item6.
COMPUTE Stress7=4 -STRESSPSS10item7.
COMPUTE Stress8=4 -STRESSPSS10item8.
COMPUTE Stress9=STRESSPSS10item9.
COMPUTE Stress10=STRESSPSS10item10.
EXECUTE.

RELIABILITY
  /VARIABLES=Stress1 Stress2 Stress3 Stress4 Stress5 Stress6 Stress7 Stress8 Stress9 Stress10
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /SUMMARY=TOTAL.

COMPUTE Stress=sum(Stress1 to Stress10).
EXECUTE.

##########Hoplessness

IF  (DESESPOIRBECKitem1 = 1) Hopelessness1=0.
IF  (DESESPOIRBECKitem1 = 2) Hopelessness1=1.
EXECUTE.
IF  (DESESPOIRBECKitem2 = 1) Hopelessness2=1.
IF  (DESESPOIRBECKitem2 = 2) Hopelessness2=0.
EXECUTE.
IF  (DESESPOIRBECKitem3 = 1) Hopelessness3=0.
IF  (DESESPOIRBECKitem3 = 2) Hopelessness3=1.
EXECUTE.
IF  (DESESPOIRBECKitem4 = 1) Hopelessness4=1.
IF  (DESESPOIRBECKitem4 = 2) Hopelessness4=0.
EXECUTE.
IF  (DESESPOIRBECKitem5 = 1) Hopelessness5=0.
IF  (DESESPOIRBECKitem5 = 2) Hopelessness5=1.
EXECUTE.
IF  (DESESPOIRBECKitem6 = 1) Hopelessness6=0.
IF  (DESESPOIRBECKitem6 = 2) Hopelessness6=1.
EXECUTE.
IF  (DESESPOIRBECKitem7 = 1) Hopelessness7=1.
IF  (DESESPOIRBECKitem7 = 2) Hopelessness7=0.
EXECUTE.
IF  (DESESPOIRBECKitem8 = 1) Hopelessness8=0.
IF  (DESESPOIRBECKitem8 = 2) Hopelessness8=1.
EXECUTE.
IF  (DESESPOIRBECKitem9 = 1) Hopelessness9=1.
IF  (DESESPOIRBECKitem9 = 2) Hopelessness9=0.
EXECUTE.
IF  (DESESPOIRBECKitem10 = 1) Hopelessness10=0.
IF  (DESESPOIRBECKitem10 = 2) Hopelessness10=1.
EXECUTE.
IF  (DESESPOIRBECKitem11 = 1) Hopelessness11=1.
IF  (DESESPOIRBECKitem11 = 2) Hopelessness11=0.
EXECUTE.
IF  (DESESPOIRBECKitem12 = 1) Hopelessness12=0.
IF  (DESESPOIRBECKitem12 = 2) Hopelessness12=1.
EXECUTE.
IF  (DESESPOIRBECKitem13 = 1) Hopelessness13=0.
IF  (DESESPOIRBECKitem13 = 2) Hopelessness13=1.
EXECUTE.
IF  (DESESPOIRBECKitem14 = 1) Hopelessness14=1.
IF  (DESESPOIRBECKitem14 = 2) Hopelessness14=0.
EXECUTE.
IF  (DESESPOIRBECKitem15 = 1) Hopelessness15=0.
IF  (DESESPOIRBECKitem15 = 2) Hopelessness15=1.
EXECUTE.
IF  (DESESPOIRBECKitem16 = 1) Hopelessness16=1.
IF  (DESESPOIRBECKitem16 = 2) Hopelessness16=0.
EXECUTE.
IF  (DESESPOIRBECKitem17 = 1) Hopelessness17=1.
IF  (DESESPOIRBECKitem17 = 2) Hopelessness17=0.
EXECUTE.
IF  (DESESPOIRBECKitem18 = 1) Hopelessness18=1.
IF  (DESESPOIRBECKitem18 = 2) Hopelessness18=0.
EXECUTE.
IF  (DESESPOIRBECKitem19 = 1) Hopelessness19=0.
IF  (DESESPOIRBECKitem19 = 2) Hopelessness19=1.
EXECUTE.
IF  (DESESPOIRBECKitem20 = 1) Hopelessness20=1.
IF  (DESESPOIRBECKitem20 = 2) Hopelessness20=0.
EXECUTE.

RELIABILITY
  /VARIABLES=Hopelessness1 Hopelessness2 Hopelessness3 Hopelessness4 Hopelessness5 Hopelessness6 
    Hopelessness7 Hopelessness8 Hopelessness9 Hopelessness10 Hopelessness11 Hopelessness12 
    Hopelessness13 Hopelessness14 Hopelessness15 Hopelessness16 Hopelessness17 Hopelessness18 
    Hopelessness19 Hopelessness20
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /SUMMARY=TOTAL.

COMPUTE Hopelessness=SUM(Hopelessness1 to Hopelessness20).
EXECUTE.

##########Control variables

FREQUENCIES VARIABLES=Stress Hopelessness BDI SuicidalBehav
  /STATISTICS=MEAN
  /ORDER=ANALYSIS.

COMPUTE SuicidalBehavc=SuicidalBehav - 0.02287581699346405.
COMPUTE BDIc=BDI - 8.669934640522875.
COMPUTE Hopelessnessc=Hopelessness - 4.777049180327869.
COMPUTE Stressc=Stress - 19.215686274509803.
EXECUTE.

FREQUENCIES VARIABLES=Stressc Hopelessnessc BDIc SuicidalBehavc
  /STATISTICS=MEAN
  /ORDER=ANALYSIS.

########## Test of the two models with control variables

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT MINIideation
  /METHOD=ENTER SuicidalBehavc BDIc Hopelessnessc Stressc
  /METHOD=ENTER burdenc belongc BurdenXBelong
  /METHOD=ENTER Defeatc
  /METHOD=ENTER Entrapmentc.


########## BDI without suicide item

COMPUTE BDIwithoutsuicide=sum(BDITristesse,BDIDecouragement,BDIEchec,BDIInsatisfaction,
    BDICulpabilite,BDIDeception,BDIInterest,BDIDecision,BDIPerception,BDIRalentissement,BDIFatigue,
    BDIAppetit).
EXECUTE.

COMPUTE BDIwithoutsuicidec=BDIwithoutsuicide - 8.506535947712418.
EXECUTE.


REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT MINIideation
  /METHOD=ENTER SuicidalBehavc BDIwithoutsuicidec Hopelessnessc Stressc
  /METHOD=ENTER burdenc belongc BurdenXBelong
  /METHOD=ENTER Defeatc
  /METHOD=ENTER Entrapmentc.


