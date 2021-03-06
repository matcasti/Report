
<table>
  <tr>
    <th> <img src="README_files/logo.png" width="300"/> </th>
    <th width="20"></th>
    <th> <h1 style="text-align:left;">writR: Inferential statistics and reporting in APA style</h1> </br>
         <p style="text-align:center;">For automated and basic inferential testing.</p> </th>
  </tr>
</table>
</br>

[![DOI](https://zenodo.org/badge/343749343.svg)](https://zenodo.org/badge/latestdoi/343749343)

### Installation

For installation of developmental version run in your R console:

``` r
install.packages("remotes")
remotes::install_github("matcasti/writR")
```

### Citation

To cite package 'writR' in publications run the following code in your `R` console:


```r
citation('writR')
```

```
## 
## To cite package 'writR' in publications use:
## 
##   Matías Castillo Aguilar (2021). writR: Inferential statistics and
##   reporting in APA style. R package version 0.1.1.
##   https://github.com/matcasti/writR
## 
## A BibTeX entry for LaTeX users is
## 
##   @Manual{,
##     title = {writR: Inferential statistics and reporting in APA style},
##     author = {Matías {Castillo Aguilar}},
##     year = {2021},
##     note = {R package version 0.1.1},
##     url = {https://github.com/matcasti/writR},
##   }
```

## Summary of available tests

#### For paired samples designs

| Nº of groups | Type                           | Test                                        | Function in `R`        |
|:------------:|--------------------------------|---------------------------------------------|------------------------|
|      2       | `type = 'p'`: parametric.      | Student's t-test.                           | `stats::t.test`        |
|      2       | `type = 'r'`: robust.          | Yuen's test for trimmed means.              | `WRS2::yuend`          |
|      2       | `type = 'np'`: non-parametric. | Wilcoxon signed-rank test.                  | `stats::wilcox.test`   |
|     \> 2     | `type = 'p'`: parametric.      | One-way repeated measures ANOVA (rmANOVA).  | `afex::aov_ez`         |
|     \> 2     | `type = 'p'`: parametric.      | rmANOVA with Greenhouse-Geisser correction. | `afex::aov_ez`         |
|     \> 2     | `type = 'p'`: parametric.      | rmANOVA with Huynh-Feldt correction.        | `afex::aov_ez`         |
|     \> 2     | `type = 'r'`: robust.          | Heteroscedastic rmANOVA for trimmed means.  | `WRS2::rmanova`        |
|     \> 2     | `type = 'np'`: non-parametric. | Friedman rank sum test.                     | `stats::friedman.test` |

#### For independent samples design

| Nº of groups | Type                           | Test                                             | Function in `R`       |
|:------------:|--------------------------------|--------------------------------------------------|-----------------------|
|      2       | `type = 'p'`: parametric.      | Student's t-test.                                | `stats::t.test`       |
|      2       | `type = 'p'`: parametric.      | Welch's t-test.                                  | `stats::t.test`       |
|      2       | `type = 'r'`: robust.          | Yuen's test for trimmed means.                   | `WRS2::yuen`          |
|      2       | `type = 'np'`: non-parametric. | Mann-Whitney *U* test.                           | `stats::wilcox.test`  |
|     \> 2     | `type = 'p'`: parametric.      | Fisher's One-way ANOVA.                          | `stats::oneway.test`  |
|     \> 2     | `type = 'p'`: parametric.      | Welch's One-way ANOVA.                           | `stats::oneway.test`  |
|     \> 2     | `type = 'np'`: non-parametric. | Kruskal-Wallis one-way ANOVA.                    | `stats::kruskal.test` |
|     \> 2     | `type = 'r'`: robust.          | Heteroscedastic one-way ANOVA for trimmed means. | `WRS2::t1way`         |

#### Corresponding Post-Hoc tests for Nº groups \> 2

|   Design    | Type                                            | Test                                                                                                                                                          | Function in `R`                 |
|:-----------:|-------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------|
|   Paired    | `type = 'p'`: parametric.                       | Student's t-test.                                                                                                                                             | `stats::pairwise.t.test`        |
|   Paired    | `type = 'np'`: non-parametric.                  | Conover-Iman all-pairs comparison test.                                                                                                                       | `PMCMRplus::durbinAllPairsTest` |
|   Paired    | `type = 'r'`: robust.                           | Yuen's test for trimmed means (see [Wilcox, 2012](http://mqala.co.za/veed/Introduction%20to%20Robust%20Estimation%20and%20Hypothesis%20Testing.pdf), p. 385). | `WRS2::rmmcp`                   |
| Independent | `type = 'p'`: parametric + `var.equal = TRUE`.  | Student's t-test.                                                                                                                                             | `stats::pairwise.t.test`        |
| Independent | `type = 'p'`: parametric + `var.equal = FALSE`. | Games-Howell test.                                                                                                                                            | `PMCMRplus::gamesHowellTest`    |
| Independent | `type = 'np'`: non-parametric.                  | Dunn's test.                                                                                                                                                  | `PMCMRplus::kwAllPairsDunnTest` |
| Independent | `type = 'r'`: robust.                           | Yuen's test for trimmed means (see [Mair and Wilcox](https://rdrr.io/rforge/WRS2/f/inst/doc/WRS2.pdf)).                                                       | `WRS2::lincon`                  |

# Automated testing

By default, `report` function, checks automatically the assumptions of the test based on the parameters of the data entered


```r
library(writR) # Load the writR package

set.seed(123)
Diets <- data.frame(
    weight = c(rnorm(n = 100/2, mean = 70, sd = 7)   # Treatment
             , rnorm(n = 100/2, mean = 66, sd = 7) ) # Control
  , diet = gl(n = 2, k = 100/2, labels = c('Treatment', 'Control') ) )
  
result <- report(
  data = Diets,
  variable = weight, # dependent variable
  by = diet, # independent variable
  type = 'auto', # default
  markdown = TRUE # output in Markdown format (for inline text)? otherwise plain text.
)

result
```

```
## $full
## [1] "*t* ~Student~ (98) = 2.51, *p* = 0.014, *d* ~Cohen's~ = 0.51, CI~95%~[0.1, 0.91]"
## 
## $stats
## [1] "*t* ~Student~ (98) = 2.51, *p* = 0.014"
## 
## $es
## [1] "*d* ~Cohen's~ = 0.51, CI~95%~[0.1, 0.91]"
## 
## $method
## [1] "Student's t-test for independent samples"
```

## Inline results in APA style

The core function: `report` by default return a list of length two in Markdown format (as seen before) for inline results. An example using same data as before:

> The analysis of the effects of the treatment shows an statistically significant difference between the groups, `result$full`, evaluated through `result$method`.

translates into this:

> The analysis of the effects of the treatment shows an statistically significant difference between the groups, *t* <sub>Student</sub> (98) = 2.509, *p* = 0.014, *d* <sub>Cohen's</sub> = 0.51, CI<sub>95%</sub>[0.1, 0.91], evaluated through Student's t-test for independent samples.

## Mixed effects ANOVA

By using `aov_r` function is possible to get the statistical report of between/within-subject(s) factor(s) for factorial designs using `afex` package under the hood for statistical reporting. Let's see an example


```r
# set parameters to simulate data with a between and within subject factor
within <- 3
between <- 2
n <- 400

set.seed(123)
Stroop <- data.frame(
  Subject = rep(1:n, within),
  Gender = gl(between, n/between, length = n*within, labels = c('Male','Female')),
  Time = gl(within, n, length = n*within),
  Score = rnorm(n*within, mean = 150, sd = 30))

# Manipulate data to generate interaction between Gender and Time
Stroop <- within(Stroop, {
  Score[Gender == 'Male' & Time == 1] <- Score[Gender == 'Male' & Time == 1]*1
  Score[Gender == 'Male' & Time == 2] <- Score[Gender == 'Male' & Time == 2]*1.15
  Score[Gender == 'Male' & Time == 3] <- Score[Gender == 'Male' & Time == 3]*1.3
  Score[Gender == 'Female' & Time == 1] <- Score[Gender == 'Female' & Time == 1]*1
  Score[Gender == 'Female' & Time == 2] <- Score[Gender == 'Female' & Time == 2]*0.85
  Score[Gender == 'Female' & Time == 3] <- Score[Gender == 'Female' & Time == 3]*0.7
})


r <- aov_r(
  data = Stroop
, response = Score
, between = Gender
, within = Time
, id = Subject
, es = 'omega' # omega squared as our measure of effect size
, sphericity = 'auto' # check if sphericity is not being violated
)

r
```

```
## $full
## $full$Gender
## [1] "*F* ~Fisher~ (1, 398) = 682.91, *p* < 0.001, $\\omega$^2^ = 0.63, CI~95%~[0.58, 0.67]"
## 
## $full$Time
## [1] "*F* ~Fisher~ (2, 796) = 0.11, *p* = 0.894, $\\omega$^2^ = 0, CI~95%~[0, 0]"
## 
## $full$Gender_Time
## [1] "*F* ~Fisher~ (2, 796) = 223.68, *p* < 0.001, $\\omega$^2^ = 0.27, CI~95%~[0.22, 0.32]"
## 
## 
## $stats
## $stats$Gender
## [1] "*F* ~Fisher~ (1, 398) = 682.91, *p* < 0.001"
## 
## $stats$Time
## [1] "*F* ~Fisher~ (2, 796) = 0.11, *p* = 0.894"
## 
## $stats$Gender_Time
## [1] "*F* ~Fisher~ (2, 796) = 223.68, *p* < 0.001"
## 
## 
## $es
## $es$Gender
## [1] "$\\omega$^2^ = 0.63, CI~95%~[0.58, 0.67]"
## 
## $es$Time
## [1] "$\\omega$^2^ = 0, CI~95%~[0, 0]"
## 
## $es$Gender_Time
## [1] "$\\omega$^2^ = 0.27, CI~95%~[0.22, 0.32]"
```

For inline results with previous data we would do something like this:

> In order to analyze the effect of gender on subjects' scores in each of the evaluation periods, we performed an analysis of variance (ANOVA) with between- and within-subjects factors. From the analyses, we find that gender has a large effect ( `r$es$Gender` ) on scores when adjusting for each of the time periods, `r$stats$Gender`. In a similar way we find a significant interaction between evaluative time and gender ( `r$stats$Gender_Time` ), indicating unequal responses between males and females over time, `r$es$Gender_Time`, however, time alone is not able to explain statistically significantly the variance in scores, `r$full$Time`.

Which will translate into this after evaluation in R Markdown:

> In order to analyze the effect of gender on subjects' scores in each of the evaluation periods, we performed an analysis of variance (ANOVA) with between- and within-subjects factors. From the analyses, we find that gender has a large effect ( 𝜔<sup>2</sup> = 0.63, CI<sub>95%</sub>[0.58, 0.67] ) on scores when adjusting for each of the time periods, *F* <sub>Fisher</sub> (1, 398) = 682.91, *p* \< 0.001. In a similar way we find a significant interaction between evaluative time and gender ( *F* <sub>Fisher</sub> (2, 796) = 223.68, *p* \< 0.001 ), indicating unequal responses between males and females over time, 𝜔<sup>2</sup> = 0.27, CI<sub>95%</sub>[0.22, 0.32], however, time alone is not able to explain statistically significantly the variance in scores, *F* <sub>Fisher</sub> (2, 796) = 0.11, *p* = 0.894, 𝜔<sup>2</sup> = 0, CI<sub>95%</sub>[0, 0].

When you have more than 1 factor (between or within subjects) you have to specify them as a character vector: `between = c('factor1', 'factor2' ...)`, and the same for `within = c('factor1', 'factor2' ...)`.

## Paired samples design

For paired designs you need to set `paired = TRUE`, and then, based on the numbers of groups detected after removing missing values, the test will run depending on the parameters stablished.

#### \> 2 groups

When `type = 'auto'` the next assumptions will be checked for \> 2 paired samples:

| Assumption checked | How is tested                                                            | If met                                    | If not                                                  |
|--------------------|--------------------------------------------------------------------------|-------------------------------------------|---------------------------------------------------------|
| Normality          | `stats::shapiro.test` for n \< 50 or `nortest::lillie.test` for n \>= 50 | Sphericity check.                         | Friedman rank sum test                                  |
| Sphericity         | `afex::test_sphericity(model)`                                           | One-way repeated measures ANOVA (rmANOVA) | Greenhouse-Geisser or Huynh-Feldt correction is applied |


```r
set.seed(123)
Cancer <- data.frame(
    cells = round(c(rnorm(n = 150/3, mean = 100, sd = 15)   # Basal
           , rnorm(n = 150/3, mean = 98, sd = 10)   # Time-1
           , rnorm(n = 150/3, mean = 98, sd = 5) )) # Time-2
  , period = gl(n = 3, k = 150/3, labels = c('Basal', 'Time-1', 'Time-2') ) )

report(
  data = Cancer
  , variable = cells
  , by = period
  , paired = TRUE
  , pairwise.comp = TRUE # set to TRUE for pairwise comparisons
  , markdown = FALSE
  )
```

```
## $pwc.method
## [1] "Student's t-test for dependent samples"
## 
## $pwc.table
## # A tibble: 3 x 3
##   group1 group2 p.value
##   <chr>  <chr>    <dbl>
## 1 Time-1 Basal   0.657 
## 2 Time-2 Basal   0.0757
## 3 Time-2 Time-1  0.0894
## 
## $full
## [1] "F(1.7, 81) = 1.82, p = 0.175, eta^2 = 0.04, CI95% [0, 0.12]"
## 
## $stats
## [1] "F(1.7, 81) = 1.82, p = 0.175"
## 
## $es
## [1] "eta^2 = 0.04, CI95% [0, 0.12]"
## 
## $method
## [1] "One-way repeated measures ANOVA with Greenhouse-Geisser correction"
```

However, you can specify your own parameters for the selection of the test:

| Test                                       | Parameters                                           |
|--------------------------------------------|------------------------------------------------------|
| One-way repeated measures ANOVA (rmANOVA)  | `paired = TRUE` + `type = 'p'` + `sphericity = TRUE` |
| rmANOVA with Greenhouse-Geisser correction | `paired = TRUE` + `type = 'p'` + `sphericity = 'GG'` |
| rmANOVA with Huynh-Feldt correction        | `paired = TRUE` + `type = 'p'` + `sphericity = 'HF'` |
| Heteroscedastic rmANOVA for trimmed means  | `paired = TRUE` + `type = 'r'`                       |
| Friedman rank sum test                     | `paired = TRUE` + `type = 'np'`                      |

#### 2 groups

Similar as before, if `type = 'auto'` assumptions will be checked for 2 paired samples:

| Assumption checked | How is tested                                                            | If met           | If not                    |
|--------------------|--------------------------------------------------------------------------|------------------|---------------------------|
| Normality          | `stats::shapiro.test` for n \< 50 or `nortest::lillie.test` for n \>= 50 | Student's t-test | Wilcoxon signed-rank test |


```r
CancerTwo <- Cancer[Cancer$period %in% c('Time-1','Time-2'),]
  
report(
  data = CancerTwo
  , variable = cells
  , by = period
  , paired = TRUE
  , markdown = FALSE
  )
```

```
## $full
## [1] "t(49) = 1.73, p = 0.089, d = 0.25, CI95% [-0.04, 0.53]"
## 
## $stats
## [1] "t(49) = 1.73, p = 0.089"
## 
## $es
## [1] "d = 0.25, CI95% [-0.04, 0.53]"
## 
## $method
## [1] "Student's t-test for dependent samples"
```

Same as above, you can specify your own parameters for the selection of the test:

| Test                                               | Parameters                      |
|----------------------------------------------------|---------------------------------|
| Student's t-test for paired samples                | `paired = TRUE` + `type = 'p'`  |
| Wilcoxon signed-rank test                          | `paired = TRUE` + `type = 'np'` |
| Yuen's test on trimmed means for dependent samples | `paired = TRUE` + `type = 'r'`  |

## Independent samples design

For independent samples you need to set `paired = FALSE`, and then, based on the numbers of groups detected, the test will run depending on the parameters stablished.

#### \> 2 groups

When `type = 'auto'` the next assumptions will be checked for \> 2 independent samples:

| Assumption checked       | How is tested                                                            | If met                          | If not               |
|--------------------------|--------------------------------------------------------------------------|---------------------------------|----------------------|
| Normality                | `stats::shapiro.test` for n \< 50 or `nortest::lillie.test` for n \>= 50 | Homogeneity of variances check. | Kruskal-Wallis ANOVA |
| Homogeneity of variances | `car::leveneTest`                                                        | Fisher's ANOVA                  | Welch's ANOVA        |


```r
set.seed(123)
Cancer <- data.frame(
    cells = round(c(rnorm(n = 90/3, mean = 100, sd = 20)   # Control
           , rnorm(n = 90/3, mean = 95, sd = 12)   # Drug A
           , rnorm(n = 90/3, mean = 90, sd = 15) )) # Drug B
  , group = gl(n = 3, k = 90/3, labels = c('Control', 'Drug A', 'Drug B') ) )

report(
  data = Cancer
  , variable = cells
  , by = group
  , paired = FALSE
  , pairwise.comp = TRUE
  , markdown = FALSE
  )
```

```
## $pwc.method
## [1] "Games Howell test"
## 
## $pwc.table
## # A tibble: 3 x 3
##   group1 group2  p.value
##   <chr>  <chr>     <dbl>
## 1 Drug A Control  0.881 
## 2 Drug B Control  0.125 
## 3 Drug B Drug A   0.0790
## 
## $full
## [1] "F(2, 54.7) = 3.04, p = 0.056, eta^2 = 0.1, CI95% [0, 0.25]"
## 
## $stats
## [1] "F(2, 54.7) = 3.04, p = 0.056"
## 
## $es
## [1] "eta^2 = 0.1, CI95% [0, 0.25]"
## 
## $method
## [1] "Welch's ANOVA for independent samples"
```

However, you can specify your own parameters for the selection of the test:

| Test                                            | Parameters                                            |
|-------------------------------------------------|-------------------------------------------------------|
| Fisher's One-way ANOVA                          | `paired = FALSE` + `type = 'p'` + `var.equal = TRUE`  |
| Welch's One-way ANOVA                           | `paired = FALSE` + `type = 'p'` + `var.equal = FALSE` |
| Kruskal–Wallis one-way ANOVA                    | `paired = FALSE` + `type = 'np'`                      |
| Heteroscedastic one-way ANOVA for trimmed means | `paired = FALSE` + `type = 'r'`                       |

#### 2 groups

Just like above, if `type = 'auto'` assumptions will be checked for 2 independent samples:

| Assumption checked       | How is tested                                                            | If met                          | If not                |
|--------------------------|--------------------------------------------------------------------------|---------------------------------|-----------------------|
| Normality                | `stats::shapiro.test` for n \< 50 or `nortest::lillie.test` for n \>= 50 | Homogeneity of variances check. | Mann-Whitney *U* test |
| Homogeneity of variances | `car::leveneTest`                                                        | Student's t-test                | Welch's t-test        |


```r
report(
  data = Cancer[Cancer$group %in% c('Drug A','Drug B'),]
  , variable = cells
  , by = group
  , var.equal = F
  , paired = FALSE
  , markdown = FALSE
  )
```

```
## $full
## [1] "t(58) = 2.21, p = 0.031, d = 0.58, CI95% [0.05, 1.1]"
## 
## $stats
## [1] "t(58) = 2.21, p = 0.031"
## 
## $es
## [1] "d = 0.58, CI95% [0.05, 1.1]"
## 
## $method
## [1] "Student's t-test for independent samples"
```

You can specify your own parameters for the selection of the test as well:

| Test                                     | Parameters                                            |
|------------------------------------------|-------------------------------------------------------|
| Student's t-test for independent samples | `paired = FALSE` + `type = 'p'` + `var.equal = TRUE`  |
| Welch's t-test for independent samples   | `paired = FALSE` + `type = 'p'` + `var.equal = FALSE` |
| Mann–Whitney *U* test                    | `paired = FALSE` + `type = 'np'`                      |
| Yuen's test on trimmed means             | `paired = FALSE` + `type = 'r'`                       |

## Dependencies

The package writR is standing on the shoulders of giants. `writR` depends on the following packages:


```r
library(deepdep)
plot_dependencies('writR', local = TRUE, depth = 3)
```

![](README_files/figure-html/unnamed-chunk-8-1.svg)<!-- -->

## Acknowledgments

I would like to thank Indrajeet Patil for being an inspiration for this package, as an extension of `statsExpressions`. Naturally this package is in its first steps, but I hope that future collaborative work can expand the potential of this package.

## Contact

For any issues or collaborations you can send me an email at:

-   matcasti\@umag.cl
