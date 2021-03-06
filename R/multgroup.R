#' Independet K samples testing
#'
#' This is function let you perform automated inferential testing based on certain assumptions, some of which are tested automatically, then the propper test is perform, giving you an APA formated output with your statistical results.
#' @param data Your dataset in long format, can have some missing values.
#' @param variable Response variable, numeric.
#' @param by Grouping variable, a factor. It can have more than two levels.
#' @param type Whether you want to manually specify a parametric test (type = 'p'), a non-parametric test (type = 'np') or a robust test (type = 'r').
#' @param var.equal If `TRUE`, then Welch correction is applied to the degrees of freedom, only when `type = 'p'`.
#' @param trim Trim level for the mean (available only for robust test).
#' @param pairwise.comp Logical. For pairwise comparisons (i.e. post-hoc; default is FALSE).
#' @param p.adjust see `p.adjust.methods`.
#' @param markdown Whether you want the `$report` output formated for inline RMarkdown or as plain text.
#' @param ... Currently not used.
#' @keywords multgroup
#' @return A list of length 2 with `$report` of statistical test and `$method` used, or length 3 if `pairwise.comp = TRUE`.

multgroup <- function(data
                       , variable
                       , by
                       , type = 'auto'
                       , var.equal = FALSE
                       , trim = 0.1
                       , pairwise.comp = FALSE
                       , p.adjust = 'none'
                       , markdown = TRUE
                       , ...) {

  data <- rcl(data = data
              , variable = {{variable}}
              , by = {{by}}
              , paired = FALSE
              , spread = FALSE)

  result <- list()

    if(type == 'auto') {
      # Prueba de normalidad ----
      n.test <- all( tapply(
        X = data[[variable]],
        INDEX = list(data[[by]]),
        FUN = function(x) if(length(x) < 50) {
          stats::shapiro.test(x)$p.value } else {
          nortest::lillie.test(x)$p.value } ) > 0.05 )
      # Tipo de test
      type <- if(n.test) { 'check' } else { 'np' }
    }
    if(type %in% c('p','check')) {
      if(type == 'check') {
        # Prueba de Levene ----
        hvar.test <- car::leveneTest(data[[variable]], data[[by]] )[1,3] > 0.05
        var.equal <- if(hvar.test) { TRUE } else { FALSE }
      }
      if(var.equal) {
        # ANOVA de Fisher, muestras independientes ----
        test <- stats::oneway.test(stats::as.formula(paste(variable, by, sep = '~')), data, var.equal = TRUE)
        eta <- effectsize::effectsize(test, verbose = FALSE, ci = 0.95)

        if(pairwise.comp) {
          # Post-Hoc: T-Student ----
          result[['pwc.method']] <- "Student's t-test for independent samples"
          result[['pwc.table']] <- suppressWarnings(expr = {
            broomExtra::tidy_parameters(
            stats::pairwise.t.test(
            x = data[[variable]]
            , g = data[[by]]
            , pool.sd = FALSE
            , var.equal = TRUE
            , p.adjust.method = p.adjust
            , paired = FALSE)) })
        }
        if(markdown) {
          result[['full']] <- paste0(
            stats <- paste0('*F* ~Fisher~ (', round(test$parameter[1],1)
            ,', ', round(test$parameter[2],1)
            , ') = ', round(test$statistic,2)
            , ', *p* ',ifelse(test$p.value < 0.001, '< 0.001', paste(
              '=', round(test$p.value, 3) ) ) ), ', '
            , es <- paste0('$\\eta$^2^ = ', round(eta$Eta2,2)
            , ', CI~95%~[', round(eta$CI_low,2)
            , ', ', round(eta$CI_high,2), ']') )

          result[['stats']] <- stats
          result[['es']] <- es
        } else {
          result[['full']] <- paste0(
            stats <- paste0('F(', round(test$parameter[1],1)
            , ', ', round(test$parameter[2],1)
            , ') = ', round(test$statistic,2)
            , ', p ',ifelse(test$p.value < 0.001, '< 0.001', paste(
              '=', round(test$p.value, 3) ) ) ), ', '
            , es <- paste0('eta^2 = ', round(eta$Eta2,2)
            , ', CI95% [', round(eta$CI_low,2)
            , ', ', round(eta$CI_high,2), ']') )

          result[['stats']] <- stats
          result[['es']] <- es
        }

        result[['method']] <- "Fisher's ANOVA for independent samples"
        result
      } else {
        # ANOVA de Welch, muestras independientes ----
        test <- stats::oneway.test(stats::as.formula(paste(variable, by, sep = '~')), data, var.equal = FALSE)
        eta <- effectsize::effectsize(test, verbose = FALSE, ci = 0.95)

        if(pairwise.comp) {
          # Post-Hoc: Games Howell ----
          result[['pwc.method']] <- 'Games Howell test'
          result[['pwc.table']] <- suppressWarnings(
            expr = {
              broomExtra::tidy_parameters(
              PMCMRplus::gamesHowellTest(
              x = data[[variable]]
              , g = data[[by]]))[,c(1,2,4)] })
        }
        if(markdown)  {
          result[['full']] <- paste0(
            stats <- paste0('*F* ~Welch~ (', round(test$parameter[1],1)
            , ', ', round(test$parameter[2],1)
            , ') = ', round(test$statistic,2)
            , ', *p* ', ifelse(test$p.value < 0.001, '< 0.001', paste(
              '=', round(test$p.value, 3) ) ) ),', '
            , es <- paste0('$\\eta$^2^ = ', round(eta$Eta2,2)
            , ', CI~95%~[', round(eta$CI_low,2)
            , ', ', round(eta$CI_high,2), ']') )

          result[['stats']] <- stats
          result[['es']] <- es
        } else {
          result[['full']] <- paste0(
            stats <- paste0('F(',round(test$parameter[1],1)
            , ', ', round(test$parameter[2],1)
            , ') = ', round(test$statistic,2)
            , ', p ', ifelse(test$p.value < 0.001, '< 0.001', paste(
              '=', round(test$p.value, 3) ) ) ), ', '
            , es <- paste0('eta^2 = ', round(eta$Eta2,2)
            , ', CI95% [', round(eta$CI_low,2)
            , ', ', round(eta$CI_high,2), ']') )

          result[['stats']] <- stats
          result[['es']] <- es
        }

        result[['method']] <- "Welch's ANOVA for independent samples"
        result
      }
    } else if(type == 'r') {
      # ANOVA de medias recortadas, muestras independientes ----
      test <- WRS2::t1way(
        formula = stats::as.formula(paste0(variable,' ~ ',by))
        , data = data
        , tr = trim)

      if(pairwise.comp) {
        # Post-Hoc ----
          result[['pwc.method']] <- "Yuen's test on trimmed means"
          result[['pwc.table']] <- suppressWarnings(
            expr = {
              broomExtra::tidy_parameters(
              WRS2::lincon(
              formula = stats::as.formula(paste0(variable,' ~ ',by))
              , data = data
              , tr = trim))[,c(1,2,7)] })
      }
      if(markdown) {
          result[['full']] <- paste0(
            stats <- paste0('*F* ~trimed-means~ (', round(test$df1,1)
            ,', ', round(test$df2,1)
            , ') = ', round(test$test,2)
            , ', *p* ',ifelse(test$p.value < 0.001, '< 0.001', paste(
              '=', round(test$p.value, 3) ) ) ), ', '
            , es <- paste0('$\\xi$ = ', round(test$effsize,2)
            , ', CI~95%~[', round(test$effsize_ci[1],2)
            , ', ', round(test$effsize_ci[2],2), ']') )

          result[['stats']] <- stats
          result[['es']] <- es

        } else {
          result[['full']] <- paste0(
            stats <- paste0('F(', round(test$df1,1)
            ,', ', round(test$df2,1)
            , ') = ', round(test$test,2)
            , ', p ',ifelse(test$p.value < 0.001, '< 0.001', paste(
              '=', round(test$p.value, 3) ) ) ), ', '
            , es <- paste0('xi = ', round(test$effsize,2)
            , ', CI95% [', round(test$effsize_ci[1],2)
            , ', ', round(test$effsize_ci[2],2), ']') )

          result[['stats']] <- stats
          result[['es']] <- es
        }

      result[['method']] <- 'Heteroscedastic one way ANOVA for trimmed means'
      result
    } else {
      # Suma de rangos de Kruskal-Wallis, muestras independientes ----
      test <- stats::kruskal.test(stats::as.formula(paste(variable, by, sep = '~')), data)
      epsilon <- effectsize::rank_epsilon_squared(data[[variable]] ~ data[[by]], data)

      if(pairwise.comp) {
        # Post-Hoc: Dunn test ----
          result[['pwc.method']] <- "Dunn test"
          result[['pwc.table']] <- suppressWarnings(
            expr = {
              broomExtra::tidy_parameters(
              PMCMRplus::kwAllPairsDunnTest(
              x = data[[variable]]
              , g = data[[by]]
              , p.adjust.method = p.adjust))[,c(1,2,4)] })
      }
      if(markdown) {
          result[['full']] <- paste0(
            stats <- paste0('$\\chi$^2^ ~Kruskal-Wallis ~(', round(test$parameter,1)
            , ') = ', round(test$statistic,2)
            , ', *p* ',ifelse(test$p.value < 0.001, '< 0.001', paste(
              '=', round(test$p.value, 3) ) ) ),', '
            , es <- paste0('$\\epsilon$^2^ = ', round(epsilon$rank_epsilon_squared,2)
            , ', CI~95%~[', round(epsilon$CI_low,2)
            , ', ', round(epsilon$CI_high,2), ']') )

          result[["stats"]] <- stats
          result[["es"]] <- es
        } else {
          result[['full']] <- paste0(
            stats <- paste0('X^2(', round(test$parameter,1)
            , ') = ', round(test$statistic,2)
            , ', p ',ifelse(test$p.value < 0.001, '< 0.001', paste(
              '=', round(test$p.value, 3) ) ) ),', '
            , es <- paste0('epsilon^2 = ', round(epsilon$rank_epsilon_squared,2)
            , ', CI95% [', round(epsilon$CI_low,2)
            , ', ', round(epsilon$CI_high,2), ']') )

          result[["stats"]] <- stats
          result[["es"]] <- es
        }

      result[['method']] <- 'Kruskal Wallis one way ANOVA'
      result
    }
}
