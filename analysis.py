import pandas as pd
import pyreadstat
from scipy.stats import pearsonr
from statsmodels.formula.api import ols

# 把sav文件转换为excel文件
sav_file_path = 'SLTBeav_v1.sav'
excel_file_path = 'SLTBeav.xlsx'
df, meta = pyreadstat.read_sav(sav_file_path)
df.to_excel(excel_file_path, index=False)

def cronbach_alpha(df):
    """
    Calculate Cronbach's Alpha for a set of items (columns) in a DataFrame.

    :param df: pandas DataFrame with items as columns
    :return: Cronbach's Alpha
    """
    df = df.dropna()
    num_items = len(df.columns)
    variance_sum = df.var(axis=0, ddof=1).sum()
    total_var = df.sum(axis=1).var(ddof=1)
    
    return (num_items / (num_items - 1)) * (1 - (variance_sum / total_var))

# 一、负担感是INQR问卷前六项得分的平均值
inqr_items = data[['INQRitem1', 'INQRitem2', 'INQRitem3', 'INQRitem4', 'INQRitem5', 'INQRitem6']]
data['burden'] = inqr_items.mean(axis=1)

# 二、（受损）归属感是INQR问卷后9项得分经过变换后的平均值
belong_items = pd.DataFrame()
belong_items['belong1'] = 7 - data['INQRitem7']
belong_items['belong2'] = 7 - data['INQRitem8']
belong_items['belong3'] = data['INQRitem9']
belong_items['belong4'] = 7 - data['INQRitem10']
belong_items['belong5'] = data['INQRitem11']
belong_items['belong6'] = data['INQRitem12']
belong_items['belong7'] = 7 - data['INQRitem13']
belong_items['belong8'] = 7 - data['INQRitem14']
belong_items['belong9'] = 7 - data['INQRitem15']

data['belong'] = belong_items.mean(axis=1)

# 三、失败感是defeat问卷（变换后）得分平均值

data['Defeat1'] = data['DSCALEitem1']
data['Defeat3'] = data['DSCALEitem3']
data['Defeat5'] = data['DSCALEitem5']
data['Defeat6'] = data['DSCALEitem6']
data['Defeat7'] = data['DSCALEitem7']
data['Defeat8'] = data['DSCALEitem8']
data['Defeat10'] = data['DSCALEitem10']
data['Defeat11'] = data['DSCALEitem11']
data['Defeat12'] = data['DSCALEitem12']
data['Defeat13'] = data['DSCALEitem13']
data['Defeat14'] = data['DSCALEitem14']
data['Defeat15'] = data['DSCALEitem15']
data['Defeat16'] = data['DSCALEitem16']
# Reverse coding for specific items
data['Defeat2'] = 4 - data['DSCALEitem2']
data['Defeat4'] = 4 - data['DSCALEitem4']
data['Defeat9'] = 4 - data['DSCALEitem9']
# Computing the mean for Defeat
defeat_items = ['Defeat1','Defeat2','Defeat3','Defeat4','Defeat5','Defeat6','Defeat7','Defeat8','Defeat9',
                'Defeat10','Defeat11','Defeat12','Defeat13','Defeat14','Defeat15','Defeat16']

data['Defeat'] = data[defeat_items].mean(axis=1)

# 四、逃避冲动是entrapment问卷得分平均值
entrapment_items = ['ENTRAPTSCALEitem' + str(i) for i in range(1, 17)]
data['Entrapment'] = data[entrapment_items].mean(axis=1)

# 五、自杀意念是迷你自杀评估量表的1和3项得分之和
data['MINIideation1'] = data['MINISUICIDEitem1'].apply(lambda x: 1 if x == 1 else 0)
data['MINIideation3'] = data['MINISUICIDEitem3'].apply(lambda x: 1 if x == 1 else 0)

data['MINIideation'] = data['MINIideation1'] + data['MINIideation3']

# 六、抑郁水平由贝克抑郁量表得分之和衡量
bdi_items_mapping = {
    'BDITristesse': 'BDIIIitem1',
    'BDIDecouragement': 'BDIIIitem2',
    'BDIEchec': 'BDIIIitem3',
    'BDIInsatisfaction': 'BDIIIitem4',
    'BDICulpabilite': 'BDIIIitem5',
    'BDIDeception': 'BDIIIitem6',
    'BDISuicide': 'BDIIIitem7',
    'BDIInterest': 'BDIIIitem8',
    'BDIDecision': 'BDIIIitem9',
    'BDIPerception': 'BDIIIitem10',
    'BDIRalentissement': 'BDIIIitem11',
    'BDIFatigue': 'BDIIIitem12',
    'BDIAppetit': 'BDIIIitem13'
}

# Compute BDI Variables
for bdi_item, bdiii_item in bdi_items_mapping.items():
    data[bdi_item] = data[bdiii_item] - 1
# Compute Total BDI Score
data['BDI'] = data[list(bdi_items_mapping.keys())].sum(axis=1)

data['BDIwithoutsuicide'] = data['BDI'] - data['BDISuicide']

# 七、自杀行为为迷你自杀评估量表第5项的得分
data['SuicidalBehav'] = data['MINISUICIDEitem5'].apply(lambda x: 1 if x == 1 else 0)

# 八、压力感为压力问卷各项变换后的得分之和
stress_items = ['Stress1', 'Stress2', 'Stress3', 'Stress4', 'Stress5', 
                'Stress6', 'Stress7', 'Stress8', 'Stress9', 'Stress10']

for i in range(1, 11):
    item = f'STRESSPSS10item{i}'
    if i in [4, 5, 7, 8]:  # Reverse coded items
        data[f'Stress{i}'] = 4 - data[item]
    else:
        data[f'Stress{i}'] = data[item]

data['Stress'] = data[stress_items].sum(axis=1)

# 九、无助感（绝望感）为贝克绝望量表各项变换后的得分之和
hopelessness_items = [f'Hopelessness{i}' for i in range(1, 21)]
data['Hopelessness1'] = data['DESESPOIRBECKitem1'].apply(lambda x: 1 if x == 2 else 0)
data['Hopelessness2'] = data['DESESPOIRBECKitem2'].apply(lambda x: 0 if x == 2 else 1)
data['Hopelessness3'] = data['DESESPOIRBECKitem3'].apply(lambda x: 1 if x == 2 else 0)
data['Hopelessness4'] = data['DESESPOIRBECKitem4'].apply(lambda x: 0 if x == 2 else 1)
data['Hopelessness5'] = data['DESESPOIRBECKitem5'].apply(lambda x: 1 if x == 2 else 0)
data['Hopelessness6'] = data['DESESPOIRBECKitem6'].apply(lambda x: 1 if x == 2 else 0)
data['Hopelessness7'] = data['DESESPOIRBECKitem7'].apply(lambda x: 0 if x == 2 else 1)
data['Hopelessness8'] = data['DESESPOIRBECKitem8'].apply(lambda x: 1 if x == 2 else 0)
data['Hopelessness9'] = data['DESESPOIRBECKitem9'].apply(lambda x: 0 if x == 2 else 1)
data['Hopelessness10'] = data['DESESPOIRBECKitem10'].apply(lambda x: 1 if x == 2 else 0)
data['Hopelessness11'] = data['DESESPOIRBECKitem11'].apply(lambda x: 0 if x == 2 else 1)
data['Hopelessness12'] = data['DESESPOIRBECKitem12'].apply(lambda x: 1 if x == 2 else 0)
data['Hopelessness13'] = data['DESESPOIRBECKitem13'].apply(lambda x: 1 if x == 2 else 0)
data['Hopelessness14'] = data['DESESPOIRBECKitem14'].apply(lambda x: 0 if x == 2 else 1)
data['Hopelessness15'] = data['DESESPOIRBECKitem15'].apply(lambda x: 1 if x == 2 else 0)
data['Hopelessness16'] = data['DESESPOIRBECKitem16'].apply(lambda x: 0 if x == 2 else 1)
data['Hopelessness17'] = data['DESESPOIRBECKitem17'].apply(lambda x: 0 if x == 2 else 1)
data['Hopelessness18'] = data['DESESPOIRBECKitem18'].apply(lambda x: 0 if x == 2 else 1)
data['Hopelessness19'] = data['DESESPOIRBECKitem19'].apply(lambda x: 1 if x == 2 else 0)
data['Hopelessness20'] = data['DESESPOIRBECKitem20'].apply(lambda x: 0 if x == 2 else 1)

data['Hopelessness'] = data[hopelessness_items].sum(axis=1)

# Reliability
print(" alpha value of burden: ", cronbach_alpha(inqr_items), 
      "\n alpha value of belong: ", cronbach_alpha(belong_items), 
      "\n alpha value of failure: ", cronbach_alpha(data[defeat_items]), 
      "\n alpha value of escape: ", cronbach_alpha(data[entrapment_items]),
      "\n alpha value of suicide ideation: ",cronbach_alpha(data[['MINIideation1', 'MINIideation3']]),
      "\n alpha value of depression: ", cronbach_alpha(data[bdi_items_mapping.keys()]), 
      "\n alpha value of suicide behavior: NA",
      "\n alpha value of stress: ", cronbach_alpha(data[stress_items]), 
      "\n alpha value of hopelessness: ",cronbach_alpha(data[hopelessness_items]))

# Mean


print(" Mean of burden: ", data['burden'].mean(), 
      "\n Mean of belong: ", data['belong'].mean(),
      "\n Mean of failure: ", data['Defeat'].mean(), 
      "\n Mean of escape: ", data['Entrapment'].mean(),
      "\n Mean of depression: ", data['BDI'].mean(), 
      "\n Mean of depression without suicide: ", data['BDIwithoutsuicide'].mean(),       
      "\n Mean of suicide behavior: ", data['SuicidalBehav'].mean(),
      "\n Mean of stress: ", data['Stress'].mean(), 
      "\n Mean of hopelessness: ", data['Hopelessness'].mean())

# 首先，创建包含九个变量的新DataFrame
variables_df = data[['burden', 'belong', 'Defeat', 'Entrapment', 'MINIideation', 'BDI', 'SuicidalBehav', 'Stress', 'Hopelessness']]
# 删除含有缺失值的行
variables_df = variables_df.dropna()
# 初始化相关矩阵
correlation_matrix = pd.DataFrame(index=variables_df.columns, columns=variables_df.columns)

# 计算相关矩阵
for col1 in variables_df.columns:
    for col2 in variables_df.columns:
        if col1 != col2:  
            correlation, _ = pearsonr(variables_df[col1], variables_df[col2])
            correlation_matrix.loc[col1, col2] = correlation
        else:
            correlation_matrix.loc[col1, col2] = 1 
            
print(correlation_matrix)

# Centering variables
data['burdenc'] = data['burden'] - 1.8442265795206974
data['belongc'] = data['belong'] - 2.882923497267759
data['Defeatc'] = data['Defeat'] - 1.3452478213507624
data['Entrapmentc'] = data['Entrapment'] - 1.263103318250377
data['SuicidalBehavc'] = data['SuicidalBehav'] - 0.02287581699346405
data['BDIc'] = data['BDI'] - 8.669934640522875
data['BDIwithoutsuicidec'] = data['BDIwithoutsuicide'] - 8.506535947712418
data['Hopelessnessc'] = data['Hopelessness'] - 4.777049180327869
data['Stressc'] = data['Stress'] - 19.215686274509803
data['BurdenXBelong'] = data['burdenc'] * data['belongc']

columns_to_check = ['burdenc', 'belongc', 'BurdenXBelong', 'Defeatc', 'Entrapmentc', 'MINIideation']
data_clean = data.dropna(subset=columns_to_check)
for column in columns_to_check:
    data[column].fillna(data[column].mean(), inplace=True)

for column in ['SuicidalBehavc', 'BDIc', 'Hopelessnessc', 'Stressc', 'burdenc', 'belongc', 'BurdenXBelong', 'Defeatc', 'Entrapmentc']:
    if column not in data_clean.columns:
        print(f"Column {column} is missing.")

print(data_clean[['SuicidalBehavc', 'BDIc', 'Hopelessnessc', 'Stressc', 'burdenc', 'belongc', 'BurdenXBelong', 'Defeatc', 'Entrapmentc']].isnull().sum())

# 检验人际关系理论单独的预测能力
# Regression analysis
model = ols('MINIideation ~ burdenc + belongc + BurdenXBelong', data=data).fit()
regression_ITS = model.summary()

print(regression_ITS)

# 检验逃避理论单独的预测能力（两步）
import statsmodels.api as sm

# Step 1: MINIideation regressed on Defeat
X1 = sm.add_constant(data['Defeatc'])
modelE1 = sm.OLS(data['MINIideation'], X1).fit()

# Step 2: MINIideation regressed on both Defeat and Entrapment
X2 = sm.add_constant(data[['Defeatc', 'Entrapmentc']])
modelE2 = sm.OLS(data['MINIideation'], X2).fit()

stepE1 = modelE1.summary()
stepE2 = modelE2.summary()

print(stepE1, stepE2)

# 联合检验人际关系理论和逃避理论的预测能力

X = sm.add_constant(data_clean[['burdenc', 'belongc', 'BurdenXBelong', 'Defeatc', 'Entrapmentc']])

# Step 1: Include burdenc, belongc, BurdenXBelong
model_step1 = sm.OLS(data_clean['MINIideation'], X[['const', 'burdenc', 'belongc', 'BurdenXBelong']]).fit()

# Step 2: Add Defeatc
model_step2 = sm.OLS(data_clean['MINIideation'], X[['const', 'burdenc', 'belongc', 'BurdenXBelong', 'Defeatc']]).fit()

# Step 3: Add Entrapmentc
model_step3 = sm.OLS(data_clean['MINIideation'], X).fit()

# Getting the summaries of the models
summary_step1 = model_step1.summary()
summary_step2 = model_step2.summary()
summary_step3 = model_step3.summary()

print(summary_step1, summary_step2, summary_step3)

data_clean = data.dropna().reset_index(drop=True)
# Step 1: Add Control Variables
X_step1 = sm.add_constant(data[['SuicidalBehavc', 'BDIc', 'Hopelessnessc', 'Stressc']])
model_step1 = sm.OLS(data['MINIideation'], X_step1).fit()

# Step 2: Add burdenc, belongc, BurdenXBelong
X_step2 = X_step1.join(data[['burdenc', 'belongc', 'BurdenXBelong']])
model_step2 = sm.OLS(data['MINIideation'], X_step2).fit()

# Step 3: Add Defeatc
X_step3 = X_step2.join(data[['Defeatc']])
model_step3 = sm.OLS(data['MINIideation'], X_step3).fit()

# Step 4: Add Entrapmentc
X_step4 = X_step3.join(data[['Entrapmentc']])
model_step4 = sm.OLS(data['MINIideation'], X_step4).fit()

# Getting the summaries of the models
summary_step1 = model_step1.summary()
summary_step2 = model_step2.summary()
summary_step3 = model_step3.summary()
summary_step4 = model_step4.summary()

print(summary_step1, summary_step2, summary_step3, summary_step4)

# Step 1: Add Control Variables and BDIwithoutsuicidec
X_step1 = sm.add_constant(data[['SuicidalBehavc', 'BDIwithoutsuicidec', 'Hopelessnessc', 'Stressc']])
model_step1 = sm.OLS(data['MINIideation'], X_step1).fit()

# Step 2: Add burdenc, belongc, BurdenXBelong
X_step2 = X_step1.join(data[['burdenc', 'belongc', 'BurdenXBelong']])
model_step2 = sm.OLS(data['MINIideation'], X_step2).fit()

# Step 3: Add Defeatc
X_step3 = X_step2.join(data[['Defeatc']])
model_step3 = sm.OLS(data['MINIideation'], X_step3).fit()

# Step 4: Add Entrapmentc
X_step4 = X_step3.join(data[['Entrapmentc']])
model_step4 = sm.OLS(data['MINIideation'], X_step4).fit()

# Getting the summaries of the models
summary_step1 = model_step1.summary()
summary_step2 = model_step2.summary()
summary_step3 = model_step3.summary()
summary_step4 = model_step4.summary()

print(summary_step1, summary_step2, summary_step3, summary_step4)
