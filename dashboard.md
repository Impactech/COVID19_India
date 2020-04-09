<!-- ## Current Status -->
<table class="table table-striped table-hover" style="width: auto !important; float: right; margin-left: 10px;">
<thead>
<tr>
<th style="text-align:left;">
Status
</th>
<th style="text-align:right;">
Crowd Source
</th>
<th style="text-align:right;">
Ministry of Health and Family Welfare
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Deceased
</td>
<td style="text-align:right;">
28
</td>
<td style="text-align:right;">
166
</td>
</tr>
<tr>
<td style="text-align:left;">
Hospitalized
</td>
<td style="text-align:right;">
6088
</td>
<td style="text-align:right;">
5095
</td>
</tr>
<tr>
<td style="text-align:left;">
Recovered
</td>
<td style="text-align:right;">
119
</td>
<td style="text-align:right;">
473
</td>
</tr>
<tr>
<td style="text-align:left;">
Total
</td>
<td style="text-align:right;">
6236
</td>
<td style="text-align:right;">
5734
</td>
</tr>
</tbody>
</table>
**Crowd Sourced Data: **
<a href="https://www.covid19india.org/" class="uri">https://www.covid19india.org/</a>

**Official Data: ** Ministry of Health and Family Welfare Data hosted on
this repository
<a href="https://github.com/Impactech/covid19_india_data" class="uri">https://github.com/Impactech/covid19_india_data</a>

**World Data: ** Repository hosted by Johns Hopkins CSSE
<a href="https://github.com/CSSEGISandData/COVID-19" class="uri">https://github.com/CSSEGISandData/COVID-19</a>

Last update at **2020-04-09 16:22:03**

### Statewise Progression of cases with time

![](dashboard_files/figure-markdown_strict/unnamed-chunk-3-1.gif)

Data: Crowd sourced

Code:
<a href="https://github.com/Impactech/COVID19_India/blob/master/IndiaTimeseriesAnimation.R" class="uri">https://github.com/Impactech/COVID19_India/blob/master/IndiaTimeseriesAnimation.R</a>

Different cross sections of COVID19 data
----------------------------------------

   

### **Pan India**

 

#### Daily growth rate

The solid lines are smoothed conditional means, which indicated the
overall trend. The dots and the soft lines represent actual data.

Growth rate is calculated as:

*G*<sub>*c**u**r**r**e**n**t*</sub> = (*T**o**t**a**l*<sub>*p**r**e**v**i**o**u**s*</sub> − *T**o**t**a**l*<sub>*c**u**r**r**e**n**t*</sub>)/*T**o**t**a**l*<sub>*p**r**e**v**i**o**u**s*</sub>

![Daily Growth rate of COVID19 cases in
India](dashboard_files/figure-markdown_strict/unnamed-chunk-4-1.png)

Code:
<a href="https://github.com/Impactech/COVID19_India/blob/master/IndiaGrowthRate_v2.R" class="uri">https://github.com/Impactech/COVID19_India/blob/master/IndiaGrowthRate_v2.R</a>

 

#### New cases per day

![](dashboard_files/figure-markdown_strict/new_cases-1.png)

Code:
<a href="https://github.com/Impactech/COVID19_India/blob/master/DailyNewCasesIndia.R" class="uri">https://github.com/Impactech/COVID19_India/blob/master/DailyNewCasesIndia.R</a>

 

#### Cumulative

![Total number of COVID19 cases in India by
Date](dashboard_files/figure-markdown_strict/unnamed-chunk-7-1.png)

Code:
<a href="https://github.com/Impactech/COVID19_India/blob/master/IndiaCumulativeCases_v2.R" class="uri">https://github.com/Impactech/COVID19_India/blob/master/IndiaCumulativeCases_v2.R</a>

### **Weekly**

 

Since the daily growth rate can be noisy, it may be helpful to see the
weekly mean of daily growth rate to identify the tapering.

The Weekly mean of daily growth rate is calculated as follows:

*G*<sub>*W**e**e**k**l**y**M**e**a**n*</sub> = *N**e**w**C**a**s**e**s*<sub>*C**u**r**r**e**n**t**W**e**e**k*</sub> \* 100/(*S**u**n**d**a**y*<sub>*P**r**e**v**i**o**u**s*</sub> − *S**u**n**d**a**y*<sub>*L**a**t**e**s**t*</sub>) \* *C**u**m**u**l**a**t**i**v**e*<sub>*P**r**e**v**i**o**u**s**W**e**e**k*</sub>

![](dashboard_files/figure-markdown_strict/unnamed-chunk-9-1.png)

### **Statewise**

 

#### Statewise growth in cumulative number of cases.

![Statewise
Split](dashboard_files/figure-markdown_strict/unnamed-chunk-11-1.png)

Data: Crowd sourced

Code:
<a href="https://github.com/Impactech/COVID19_India/blob/master/IndiaTimeseries_v3.R" class="uri">https://github.com/Impactech/COVID19_India/blob/master/IndiaTimeseries_v3.R</a>

 

#### State wise split of cumulative number of cases as per last update.

![Statewise
Split](dashboard_files/figure-markdown_strict/unnamed-chunk-12-1.png)

Code:
<a href="https://github.com/Impactech/COVID19_India/blob/master/IndiaStateWise.R" class="uri">https://github.com/Impactech/COVID19_India/blob/master/IndiaStateWise.R</a>

### **Agewise**

 

#### Agewise split of cases in India

Data available for **1060** cases

![](dashboard_files/figure-markdown_strict/unnamed-chunk-13-1.png)

Code:
<a href="https://github.com/Impactech/COVID19_India/blob/master/IndiaAgewise.R" class="uri">https://github.com/Impactech/COVID19_India/blob/master/IndiaAgewise.R</a>

### **World**

 

#### Global Growth rate

![](dashboard_files/figure-markdown_strict/unnamed-chunk-14-1.png)

 

#### Global Daily New Cases

![](dashboard_files/figure-markdown_strict/unnamed-chunk-15-1.png)

 

#### Global Cumulative cases

![](dashboard_files/figure-markdown_strict/unnamed-chunk-16-1.png)

------------------------------------------------------------------------

This Dashboard is **[Hosted on
Github](https://github.com/Impactech/COVID19_India)**

by [Rahul Nayak](https://www.linkedin.com/in/rahulnyk/)

<img src="https://media-exp1.licdn.com/dms/image/C510BAQGXcesixi_kZA/company-logo_100_100/0?e=1594252800&amp;v=beta&amp;t=BplHG9oQxA1vuJfKGwffWcRH-ghA6phDyAwnRKMjk6w" width="40" />

**Impactech!** The [SmartLoo
Platform’s](https://www.linkedin.com/company/smart-loo) Technology
Wizards.
