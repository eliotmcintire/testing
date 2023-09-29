minVer <- "0.0.8.9012"
if (isTRUE(packageVersion("SpaDES.project") < minVer)) {
  install.packages("SpaDES.project", 
                   repos = c("predictiveecology.r-universe.dev", getOption("repos")))
  # if the version hasn't been built yet ... need to use `remotes`
  if (isTRUE(packageVersion("SpaDES.project") < minVer)) {
    remotes::install_github("PredictiveEcology/SpaDES.project@transition") 
  }
}

# pkgload::load_all("c:/Eliot/GitHub/SpaDES.project")
# pkgload::load_all("c:/Eliot/GitHub/reproducible")
# pkgload::load_all("c:/Eliot/GitHub/SpaDES.core")
# mods <- SpaDES.project::listModules("fireSense", accounts = "PredictiveEcology")
out <- SpaDES.project::setupProject(
  modules = 
    file.path("PredictiveEcology", 
              # terra-migration
              c(paste0(
                c(# "Biomass_borealDataPrep", 
                  "fireSense_dataPrepFit", 
                  "fireSense_dataPrepPredict", 
                  "fireSense_IgnitionFit", 
                  "fireSense_SpreadFit"),
                "@terra-migration"),
                paste0(c(
                  # development
                  "fireSense", 
                  "fireSense_IgnitionPredict", 
                  "fireSense_SpreadPredict"),
                  "@development"),
                paste0(c(
                  #"fireSense_summary",
                  "fireSense_EscapeFit", 
                  "fireSense_EscapePredict"
                ), 
                "@main"
                )
              )),
  options = list(Require.cloneFrom = Sys.getenv("R_LIBS_USER"),
                 reproducible.inputPaths = if (user("emcintir")) "c:/Eliot/data" else NULL,
                 spades.moduleCodeChecks = FALSE,
                 spades.allowInitDuringSimInit = TRUE,
                 reproducible.showSimilar = TRUE,
                 reproducible.useMemoise = TRUE,
                 spades.useRequire = T,
                 gargle_oauth_email = if (user("emcintir")) "eliotmcintire@gmail.com" else NULL
                 
  ),
  params = list(.globals = list(sppEquivCol = 'LandR')),
  # studyArea = list("Sask", level = 2),
  studyArea = list("Sask", level = 2, NAME_2 = "14"), # handshake --> using the default epsg causes failure in prepRasterToMatch
  studyAreaLarge = studyArea,
  studyAreaName = "SK",
  package = "PredictiveEcology/reproducible@dealWithCorrupt (>= 2.0.8.9004)",
  # packages = "PredictiveEcology/LandR@development (HEAD)",
  # packages = NULL,
  # overwrite = TRUE,
  # updateRprofile = TRUE,
  useGit = FALSE#"Sub"
)
# pkgload::load_all("c:/Eliot/GitHub/LandR")

sim <- do.call(SpaDES.core::simInitAndSpades, out)
