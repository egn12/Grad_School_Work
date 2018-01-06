//EMPIRICAL EXERCISES
/* Context: 145 companies (n) and four variables related to cost, factors of production and output. We want to estimate elasticities using a cobb-douglas
production function and a cost function. */
clear
import excel "/Users/elbagomeznavas/Desktop/nerlove.xls", sheet("NERLOVE") firstrow

*(b) Estimate the unrestricted model (1.7.4) by OLS. Can you replicate the estimates in the text? Yes, we get same results. 

*generating logs
gen l_tc= log(TC)
gen l_q = log(Q)
gen l_pl= log(PL)
gen l_pk= log(PK)
gen l_pf= log(PF)

regress l_tc l_q l_pl l_pk l_pf

*c) (Restricted least squares) Estimate the restricted model (1.7.6) by OLS

*generating new variables
gen l_tc_1 = log(TC/PF)
gen l_pl_1 = log(PL/PF)
gen l_pk_1 = log(PK/PF)

regress l_tc_1 l_q l_pl_1 l_pk_1


/*d) Estimate Model 1 by OLS. How well can you replicate Nerlove’s reported results? */
 
*separating into 5 groups
gen seqnum=_n
gen group1 = 1 if seqnum <=29 
gen group2 = 1 if seqnum > 29 & seqnum<=58
gen group3 = 1 if seqnum > 58 & seqnum<=87
gen group4 = 1 if seqnum >87 & seqnum <=116
gen group5 = 1 if seqnum >116 & seqnum <=145

replace group1 = 0 if group1 ==.
replace group2 = 0 if group2 ==.
replace group3 = 0 if group3 ==.
replace group4 = 0 if group4 ==.
replace group5 = 0 if group5 ==.

* running regression of the form of (1.7.6) on each group 

regress l_tc l_q l_pl l_pk l_pf if group1 == 1
regress l_tc l_q l_pl l_pk l_pf if group2 == 1
regress l_tc l_q l_pl l_pk l_pf if group3 == 1
regress l_tc l_q l_pl l_pk l_pf if group4 == 1
regress l_tc l_q l_pl l_pk l_pf if group5 == 1


/*On the basis of your estimates of beta 2, compute the point estimates of returns to scale in each of the five groups.

SOL: Point estimates for returns to scale (where we get point estimates by calculating 1/b_2 (where b_2 is the coefficient for log(q) for each sub-group 
1. 1/.3890935 
2. 1/.6596094 
3. 1/.9667114 
4. 1/.9343158 
5. 1/ 1.043459 

*/

/* Comment on general pattern of estimated error variance as output increases. What is the general pattern of estimated scale economies as the level of output increases? 
What is the general pattern of the estimated error variance as output increases? */

/*SOL: We can observe the estimated error variance through the root MSE. Thus, for each group we get the following MSE's: 
1. .02073 
2. .03329
3. .04768
4. .08584
5. .48806 

Therefore, we can observe that the general pattern of estimated error variance increases when output increases. */

*Define the variables for model 2

gen l_q_group1= l_q*group1
gen l_q_group2= l_q*group2
gen l_q_group3= l_q*group3
gen l_q_group4= l_q*group4
gen l_q_group5= l_q*group5

gen l_pl_group1= l_pl*group1
gen l_pl_group2= l_pl*group2
gen l_pl_group3= l_pl*group3
gen l_pl_group4= l_pl*group4
gen l_pl_group5= l_pl*group5


gen l_pk_group1= l_pk*group1
gen l_pk_group2= l_pk*group2
gen l_pk_group3= l_pk*group3
gen l_pk_group4= l_pk*group4
gen l_pk_group5= l_pk*group5

gen l_pf_group1= l_pf*group1
gen l_pf_group2= l_pf*group2
gen l_pf_group3= l_pf*group3
gen l_pf_group4= l_pf*group4
gen l_pf_group5= l_pf*group5

*e) Estimate Model 2 by OLS. Verify that the OLS coefficient estimates here are the same as those in (d). 

regress l_tc l_q_group1 l_q_group2 l_q_group3 l_q_group4 l_q_group5 l_pl_group1 l_pl_group2 l_pl_group3 l_pl_group4 l_pl_group5 l_pk_group1 l_pk_group2 l_pk_group3 l_pk_group4 l_pk_group5 l_pf_group1 l_pf_group2 l_pf_group3 l_pf_group4 l_pf_group5

/*f) (Chow test) Model 2 is more general than Model (1.7.6) because the coefficients can differ across groups.Test the null hypothesis that the coefficients are 
the same across groups. How many equations (restrictions) are in the null hypothesis? This test is sometimes called the Chow test for structural change. 
Calculate the p-value of the F-ratio. Hint: This is a linear hypothesis about the coefficients of Model 2. So take Model 2 to be the maintained hypothesis and (1.7.6)
 to be the restricted model. Use the formula (1.4.11) for the F-ratio. */
 
*Step 1 We run the combined regression  (Model 0/Baseline Model: No differences across groups)

regress l_tc_1 l_q l_pl_1 l_pk_1

*Step 2 We run the regresson with interaction terms (Model 2) 

regress l_tc l_q_group1 l_q_group2 l_q_group3 l_q_group4 l_q_group5 l_pl_group1 l_pl_group2 l_pl_group3 l_pl_group4 l_pl_group5 l_pk_group1 l_pk_group2 l_pk_group3 l_pk_group4 l_pk_group5 l_pf_group1 l_pf_group2 l_pf_group3 l_pf_group4 l_pf_group5
 

*Step 3 For the Chow test

gen ess_r = 21.6403212 
gen ess_u = 11.714693   
gen r= 20

gen num= (ess_r - (ess_u))/(r)
gen denom= ess_u/(n-r)
gen chow = num/denom
gen df1 =4
gen df2 =20


*Step 4 Calculate Gauss Command 

cdffc(chow,df1,df2)

/*h) Estimate Model 4 by weighted least squares on the whole sample of 145 firms. 
(Be careful about the treatment of the intercept; in the equation after weighting, none of the regressors is a constant.) 
Plot the residuals. Is there still evidence for conditional homoskedasticity or further nonlinearities? */

gen l_tc_1 = log(TC/PF)
gen l_pl_1 = log(PL/PF)
gen l_pk_1 = log(PK/PF)
gen l_q_2 = log(Q)^2

*wls l_tc_1 l_pl_1 l_pk_1 l_q_2 l_q, wvar(l_tc_1) type(abse) noconst graph
 
regress l_tc_1 l_pl_1 l_pk_1 l_q_2 l_q [aw = 1/PL ^2]

rvfplot, yline(0)
 
 
