library(exposomex)

rm(list = ls())

OutPath = stringr::str_c(getwd(),"/output")

res = exposomex::InitStatCros()

#load data

res1 = exposomex::LoadStatCros(PID = res$PID,
                               UseExample = "default",
                               DataPath = "input/input_@FigS3_StatCros_data.xlsx",
                               VocaPath = "input/input_@FigS3_StatCros_voca.xlsx")

res1$Expo$Data

#tidy data

res2 = exposomex::TidyDelMiss(PID = res$PID,
                              OutPath = OutPath)

res3 = exposomex::TidyDelNearZeroVar(PID = res$PID,
                                     OutPath = OutPath)

res4 = exposomex::TidyTransType(PID = res$PID,
                                OutPath = OutPath,
                                Vars = "Y1",
                                To = "factor")

res5 = exposomex::TidyTransScale(PID = res$PID,
                                 OutPath = OutPath,
                                 Vars = "all.x")

#screen potential risk factors

res5$Expo$Voca$GroupName %>% table()

res6 = exposomex::CrosAsso(PID=res$PID,
                           OutPath = OutPath,
                           Linear = T,
                           EpiDesign = "case.control",
                           VarsY = "Y1",
                           VarsX = "all.x", 
                           VarsN = "single.factor" ,
                           VarsSel = T,
                           VarsSelThr = 0.1,
                           Covariates = "all.c",
                           Family = "binomial",
                           RepMsr = T,
                           Corstr = "ar1")

res6$Y1_single.factor_case.control_binomial

res7 = exposomex::VizCrosAsso(PID=res$PID,
                              OutPath = OutPath,
                              VarsY = "Y1",
                              VarsN="single.factor",
                              Layout = "volcano",
                              Brightness = "dark",
                              Palette = "default1",
                              ColorFor = "beta.value",
                              SizeFor = "p.value")

res7$Y1_single.factor_volcano_dark_default1_beta.value_p.value

res8 = exposomex::MulOmicsCros(PID=res$PID,
                               OutPath = OutPath,
                               OmicGroups = "metabolome,chemical",
                               VarsY = "Y1",
                               VarsC = "all.c",
                               TuneMethod = 'default',
                               TuneNum = 5,
                               RsmpMethod = "cv",
                               Folds = 5,
                               Ratio = NULL,
                               Repeats = NULL,
                               VarsImpThr = 0.85,
                               SG_Lrns = "lasso,enet,rf,xgboost")

res8$SGModel_summary

# res9 = exposomex::VizMultOmic(PID=res$PID,
#                               OutPath = OutPath,
#                               VarsY = "Y1",
#                               NodeNum = 40,
#                               EdgeThr = 0.45,
#                               Layout = "force-directed",
#                               Brightness = "light",
#                               Palette = "default1")
FuncExit(PID = res$PID)
