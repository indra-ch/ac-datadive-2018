
# coding: utf-8

# # Section 0: forward
# - summary: I did a number of correlation analysis which all gave negative results, the only positive result is at the last section. 
# 
# # Section 1. Plot key statistics 
# 
# - import the csv
# - plot eligible rate for each IAM
# - plot "nan" rate (where 'eligible' column has no numbers) for each IAM
# - plot total number of complaint by each IAM

# In[2]:


import matplotlib.pyplot as plt
import numpy as np
import os
import pandas as pd

# set directories 
csvdir = 'C:/Users/Huayi/Desktop/ac-datadive-2018-master/Data/'
acname = 'accountability_console_data_cleaned.csv'
bmname = 'benchmark_data_cleaned.csv'

# read csv 
acfull = pd.read_csv(csvdir+acname)
bm = pd.read_csv(csvdir+bmname)

# sort the list by 'IAM'
acfull_1 = acfull.sort_values(by=['IAM'])

# find starting row of IAM by detecting where things change.  
stNo = [] # the number of strating row
nameLs = [] # the name of the IAM
for n, i in enumerate(acfull_1['IAM'].as_matrix()):
    if i != acfull_1['IAM'].as_matrix()[n-1]:
        nameLs.append([i]) 
        stNo.append([n]) 
        
nameLs= np.array(nameLs).flatten() 

# the last row for each IAM
endNo =stNo[1:]
endNo.append([len(acfull_1)-1])

# row number where values are 'nan'
nanidx = np.argwhere(acfull_1['ELIGIBLE'].isna().values == 1)
eligs = acfull_1['ELIGIBLE'].values
eligs[nanidx]= 0 # set 'nan' to zero
nans = np.zeros(len(eligs))
nans[nanidx] = 1

# succ_rate is the same as eligible_rate
succ = np.zeros(len(stNo))
succ_rate = np.zeros(len(stNo))
nan_rate = np.zeros(len(stNo))

for n in np.arange(len(stNo)):
    succ[n] = np.sum(acfull_1['ELIGIBLE'].values[stNo[n][0]:endNo[n][0]])
    succ_rate[n] = succ[n]/(endNo[n][0] -  stNo[n][0])
    nan_rate[n] = np.sum(nans[stNo[n][0]:endNo[n][0]])/(endNo[n][0] -  stNo[n][0])
    
# plots
# eligible rate
plt.figure()
plt.bar(np.arange(len(stNo)),succ_rate)
plt.xticks(np.arange(len(stNo)), nameLs, rotation='vertical')
plt.title('Eligible rate per IAM')
plt.show()

# 'Nan'_rate 
plt.figure()
plt.bar(np.arange(len(stNo)),nan_rate)
plt.xticks(np.arange(len(stNo)), nameLs, rotation='vertical')
plt.title('Nan rate per IAM')
plt.show()

# number of complaints
NoC= (np.array(endNo) -  np.array(stNo)).flatten() 
plt.figure()
plt.bar(np.arange(len(stNo)),NoC)
plt.xticks(np.arange(len(stNo)), nameLs, rotation='vertical')
plt.title('Number of complaints per IAM')
plt.show()

# exporting the data s a csv file. 
# stats.csv contain 'IAM', 'eligible_rate', 'nan_rate','Complaint_Num' for all IAMs
stats = pd.DataFrame( np.matrix([nameLs, succ_rate, nan_rate, NoC]).transpose(), columns=['IAM', 'eligible_rate', 'nan_rate','Complaint_Num'])
stats['Complaint_Num'] = stats['Complaint_Num'].astype('float')
stats = stats.sort_values(by=['Complaint_Num'],ascending=False)
stats.to_csv(csvdir+'stats.csv')


# # Section 2: focused correlation analysis on four IAMs
# 
# Based on the number of complaints per IAM, I identified 6 groups that have handled around 100 complaints or more.
# Within these 6 groups, 2 IAMs have the lowest eligible rate, another two have the highest eligible rate. 
# These 4 IAMs are put in to group1 & group2. I focus here on comparing if they have any correlation difference in benchmarked_data.
# 
# The hypothesis: if benchmarked_data can directly predict eligible rate, then benchmarked_data is more similar within groups, and more different btw the two groups. 
# 
# The null hypothesis: benchmarked_data doesn't predict eligible rate directly; each IAM operate by their own unknown logic. 
# 
# Conclusion: based on the final plots, the correlation is all over the place. This is in support of the null hypothesis. 

# In[3]:


# the 6 IAMs that have around 100 compaints or more.
# f_stats.csv contain 'IAM', 'eligible_rate', 'nan_rate','Complaint_Num' for the 6 IAMs
f_stats = stats.iloc[:6]
f_stats.to_csv(csvdir+'f_stats.csv')


# In[9]:


# seprate in to two groups. Gp1 has lowest eligible_rate, Gp2 has the highest. 
f_stats_sorted = f_stats.sort_values(by=['eligible_rate'])
gp1 = f_stats_sorted['IAM'].values[:2]
gp2 = f_stats_sorted['IAM'].values[-2:]

# the code below drops out rows that has answers that are non-quantifiable ('nq') and nan. 
# it also keeps track of how many rows are dropped. 
gps = np.append(gp1,gp2)
bm_gp = bm[gps]

# dropping non-quantifiable ('nq'), i.e. rows where it's not 'nan', or '1' or '0'
drop_idx = np.argwhere(np.sum(np.isin(bm_gp.values, ['1','0']) + bm_gp.isna().values, axis = 1) < 4 ) # row number
uq_percent = len(drop_idx)/len(bm_gp) # percentage of dropped for uq rows. 
bm_uqdropped = bm_gp.drop(index = drop_idx.flatten())

# drop rows where there is all 'nan'
allnan_idx = np.argwhere(np.sum(bm_uqdropped.isna().values, axis =1) ==4) # row number
allnan_idx= bm_uqdropped.index[allnan_idx.flatten()] # row number as index for the df
bm_uq_Anan_dropped = bm_uqdropped.drop(index=allnan_idx)

# amt & percentage of 'nan' in every column
nan_amt = np.sum(bm_uq_Anan_dropped.isna().values, axis =0)
nan_percent = nan_amt/ len(bm_uq_Anan_dropped)

# amt of rows that have all 0 or 1 answers in all columns 
ans_amt = np.sum(np.sum(np.isin(bm_uq_Anan_dropped.values, ['1','0']), axis =1) == 4)
ans_percent = ans_amt/ len(bm_uq_Anan_dropped)

# dropping rows that contain 3 or less 'nan'
nan_idx = bm_uq_Anan_dropped.index[np.argwhere(np.sum(np.isin(bm_uq_Anan_dropped.values, ['1','0']), axis = 1) < 4).flatten()]
bm_ans= bm_uq_Anan_dropped.drop(index = nan_idx)
bm_ans = bm_ans.astype('float')

####
# set where there is 'nan' to 1, and the rest to 0. 
bm_withnan = bm_uq_Anan_dropped
bm_withnan.values[np.isin(bm_withnan.values, ['1','0'])] = 0
bm_withnan.values[bm_withnan.isna()] = 1

####
# caculate correlation between every two IAMs & plot 
from itertools import combinations

# correlation for where all 4 answered either 0 or 1
comb = list(combinations(np.arange(len(gps)), 2))
corr = np.zeros(len(comb))
for n,i in enumerate(comb):    
    corr[n] = bm_ans[gps[i[0]]].corr(bm_ans[gps[i[1]]])
    
plt.figure()
plt.bar(np.arange(len(comb)), corr)
plt.xticks(np.arange(len(comb)), comb, rotation='vertical')
plt.legend(['0: %s'%gps[0] +'\n1: %s'%gps[1] + '\n2: %s'%gps[2] + '\n3: %s'%gps[3]])
plt.title('correlation between IAMs (yes/no answers)')
plt.show()

# correlation for where they answered 'nan'
bm_withnan = bm_withnan.astype('float')
corr_withnan = np.zeros(len(comb))
for n,i in enumerate(comb):    
    corr_withnan[n] = bm_withnan[gps[i[0]]].corr(bm_withnan[gps[i[1]]])
    
plt.figure()
plt.bar(np.arange(len(comb)), corr_withnan)
plt.xticks(np.arange(len(comb)), comb, rotation='vertical')
plt.legend(['0: %s'%gps[0] +'\n1: %s'%gps[1] + '\n2: %s'%gps[2] + '\n3: %s'%gps[3]])
plt.title('correlation between IAMs (nan answers)')
plt.show()


# # Section 3: Categorical correlations 
# 
# Since Section2 supports null hypothesis, I explored that idea that maybe group 1 & 2 differ by answers to questions in each category. Here I summed the the answers in each category and ran correlation between the two groups. 
# 
# Conclusion: based on the plots, categorical sums don't predict eligible_rate directly. 
# 

# In[10]:


# the code below try to parse out where each category start &  end 
bm_cat = bm['Category'].loc[bm_ans.index]
cat_idx = []
for n, i in enumerate(bm_cat.values):
    if i != bm_cat.values[n-1]:
        cat_idx.append(n)
        
#bm_cat.loc[cat_idx]    
cat_idx_end = cat_idx[1:]
cat_idx_end.append(len(bm_cat))

# category names 
sub_cat = bm_cat.values[cat_idx] 
# categorical sums 
cat_score = np.zeros([len(cat_idx),4])
for i in np.arange(len(cat_idx)):
    cat_score[i,:] = np.sum(bm_ans.values[cat_idx[i]:cat_idx_end[i],:], axis = 0)

# correlation btw every 2 IAMs. 
corr_cat = np.zeros(len(comb))
for n,i in enumerate(comb):    
    corr_cat[n] = np.corrcoef(cat_score[:,i[0]], cat_score[:,i[1]])[1,0]

# plot correlations 
plt.figure()
plt.bar(np.arange(len(comb)), corr_cat)
plt.xticks(np.arange(len(comb)), comb, rotation='vertical')
plt.legend(['0: %s'%gps[0] +'\n1: %s'%gps[1] + '\n2: %s'%gps[2] + '\n3: %s'%gps[3]])
plt.title('correlation between IAMs (category sums)')
plt.show()


# # Section 4: focus on 'eligibility requirements'
# 
# Since 'Eligibility requirements' are more decisive on if a project is eligible, here I looked compared answers under this categories between group 1 & 2. 
# 
# Conclusion: despite what the correlation plot shows, the two groups have almost answered '1' on all questions. I don't think difference in this category can separte the two groups. 

# In[11]:


#'Eligibility requirements'
er_idx = bm_cat.index[bm_cat == 'Eligibility requirements']
er = bm_ans.iloc[er_idx]

# added tiny difference to avoide "division by 0" problem
tiny = np.asarray([0, 1e-15, 0,0,0,0,0,0])

# correlation btw every 2 IAMs. 
corr_er = np.zeros(len(comb))
for n,i in enumerate(comb):    
    corr_er[n] = (er[gps[i[0]]]+tiny).corr(er[gps[i[1]]]+tiny)

# plot correlations 
plt.figure()
plt.bar(np.arange(len(comb)), corr_er)
plt.xticks(np.arange(len(comb)), comb, rotation='vertical')
plt.legend(['0: %s'%gps[0] +'\n1: %s'%gps[1] + '\n2: %s'%gps[2] + '\n3: %s'%gps[3]])
plt.title('correlation between IAMs (category sums)')
plt.show()


# # Section 5: the most different categories & benchmarks between two groups 
# 
# Are there categories and benchmarks that are same within group but different between groups? 
# i.e. are there critical categories/ benchmarks that segregate the two groups? 
# 
# Conclusion: 
# - The category 'Functions' is same for two IAMs in group1 not group2. No category satify this condition for group2. 
# -  One benchmark that satify this condition for the two groups:
#     - Benchmark: "Must the claim be brought for direct harm by the institution?"
#     - This is under the category: "Project-related scope and limitations of mechanism" 

# In[12]:


# find category that has same total score for the two IAMs in group1, but differ from group2. 
gp1_diff_idx = np.argwhere((cat_score[:,0] == cat_score[:,1]) & (cat_score[:,0] != cat_score[:,2]) & (cat_score[:,0] != cat_score[:,3]))
gp1_diff_cat = sub_cat[gp1_diff_idx]
print(gp1_diff_cat)

# find category that has same total score for the two IAMs in group2, but differ from group1. 
gp2_diff_idx = np.argwhere((cat_score[:,2] == cat_score[:,3]) & (cat_score[:,2] != cat_score[:,0]) & (cat_score[:,2] != cat_score[:,1]))
gp2_diff_cat = sub_cat[gp2_diff_idx]
print(gp2_diff_cat)


# In[13]:


# find benchmark that has same total answers for the two IAMs in group1, but differ from group2. 
gp1_qn_idx = np.argwhere((bm_ans.values[:,0] == bm_ans.values[:,1]) & (bm_ans.values[:,0] != bm_ans.values[:,2]) & (bm_ans.values[:,0] != bm_ans.values[:,3]))
gp1_idx  = bm_ans.index[gp1_qn_idx]
print(gp1_idx)

# find benchmark that has same total answers for the two IAMs in group2, but differ from group1. 
gp2_qn_idx = np.argwhere((bm_ans.values[:,2] == bm_ans.values[:,3]) & (bm_ans.values[:,2] != bm_ans.values[:,0]) & (bm_ans.values[:,2] != bm_ans.values[:,1]))
gp2_idx  = bm_ans.index[gp2_qn_idx]
print(gp2_idx)

# print this common benchmark and the category. 
print('Category:', bm.iloc[gp2_idx[0][0]]['Category'], '\n', 'Benchmark:', bm.iloc[gp2_idx[0][0]]['Benchmark'])


# # Section 6: Number of issues per case per IAM
# 
# The analysis so far indicates that the benchmarked_data does not predict IAM eligible rate. This implies that the difference in IAM eligible rate may depend on what kind of cases they receive instead of their standards in processing them. 
# 
# - I computated number of issues per case per IAM. 
# - number of cases that have 2 or more issues per IAM.
# - 3 or more, 4 or more
# 
# Conclusion: 
# - Group2, which has a higher eligible rate, has more issues per case. 
# - Group2 also has more cases that have 2 or more issues. 

# In[75]:


# list of columns containing "issues"

issues = ["Issues_1", "Issues_2", "Issues_3", "Issues_4", "Issues_5", "Issues_6", "Issues_7", "Issues_8", "Issues_9", "Issues_10"]
issNo = 10-np.sum(acfull_1[issues].isna(),axis=1)


# No of issues per IAM 
issSum = np.zeros(len(stNo))
issPerC = np.zeros(len(stNo))
issM2rate = np.zeros(len(stNo))
issM3rate = np.zeros(len(stNo))
issM4rate = np.zeros(len(stNo))
for n in np.arange(len(stNo)):
    issSum[n] = np.sum(issNo[stNo[n][0]:endNo[n][0]])
    # total number of cases = number of rows - those that had 'nan' in 'eligible'
    caseNo = (endNo[n][0] -  stNo[n][0])-np.sum(nans[stNo[n][0]:endNo[n][0]])/(endNo[n][0] -  stNo[n][0])
    issPerC[n] = issSum[n]/caseNo                            
    issM2rate[n] = np.sum(issNo[stNo[n][0]:endNo[n][0]] > (2-1))/caseNo
    issM3rate[n] = np.sum(issNo[stNo[n][0]:endNo[n][0]] > (3-1))/caseNo
    issM4rate[n] = np.sum(issNo[stNo[n][0]:endNo[n][0]] > (4-1))/caseNo


# In[77]:


# Find issues per case for the 4 IAMs
issueNo = np.array([issPerC[nameLs =='ADB_SPF_CRP'],  issPerC[nameLs =='IDB_MICI'], issPerC[nameLs =='WB_Panel'], issPerC[nameLs =='EIB_CM']])
M2rate = np.array([issM2rate[nameLs =='ADB_SPF_CRP'],  issM2rate[nameLs =='IDB_MICI'], issM2rate[nameLs =='WB_Panel'], issM2rate[nameLs =='EIB_CM']])
M3rate = np.array([issM3rate[nameLs =='ADB_SPF_CRP'],  issM3rate[nameLs =='IDB_MICI'], issM3rate[nameLs =='WB_Panel'], issM3rate[nameLs =='EIB_CM']])
M4rate = np.array([issM4rate[nameLs =='ADB_SPF_CRP'],  issM4rate[nameLs =='IDB_MICI'], issM4rate[nameLs =='WB_Panel'], issM4rate[nameLs =='EIB_CM']])

#Plot
plt.figure()
plt.bar(np.arange(4),issueNo.flatten())
plt.xticks(np.arange(4), gps, rotation='vertical')
plt.title('Num. of issues per case per IAM')
plt.show()

plt.figure()
plt.bar(np.arange(4),M2rate.flatten())
plt.xticks(np.arange(4), gps, rotation='vertical')
plt.title('Num. of cases with 2 or more issues per IAM')
plt.show()

plt.figure()
plt.bar(np.arange(4),M3rate.flatten())
plt.xticks(np.arange(4), gps, rotation='vertical')
plt.title('Num. of cases with 3 or more issues per IAM')
plt.show()

plt.figure()
plt.bar(np.arange(4),M4rate.flatten())
plt.xticks(np.arange(4), gps, rotation='vertical')
plt.title('Num. of cases with 4 or more issues per IAM')
plt.show()

