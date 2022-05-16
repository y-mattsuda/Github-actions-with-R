# パッケージ読み込み
if (!require("pacman")) {
  install.packages("pacman")
}
library("pacman")
pacman::p_load(KFAS, tidyverse, ggfortify, patchwork)

# データセット読み込み
# データセットは北川源四郎先生のこちらの講義資料を参照している
# アメリカの食品産業に従事する労働者人口（月）
# https://elf-c.he.u-tokyo.ac.jp/courses/377
d <- read_csv("Data/blsfood.csv") %>% ts

# KFASによる状態空間モデル構築
dlm <- KFAS::SSModel(
  H = NA,
  formula = as.numeric(d) ~
    SSMtrend(degree = 2, Q = list(NA, NA)) +
    SSMseasonal(period = 12, sea.type = "dummy", Q = NA)
)
fit_dlm <- KFAS::fitSSM(
  model = dlm,
  inits = c(1, 1, 1, 1)
)
result_dlm <- KFAS::KFS(
  model = fit_dlm$model,
  smoothing = c("state", "mean")
)

# 推定結果の可視化
p_data <- autoplot(
  d,
  main = "raw data",
  xlab = "",
  ylab = ""
) + theme_classic()
p_trend <- autoplot(
  result_dlm$alphahat[, "level"],
  main = "trend + level",
  xlab = "",
  ylab = ""
) + theme_classic()
p_year <- autoplot(
  result_dlm$alphahat[, "sea_dummy1"],
  main = "cyclic (1year)",
  xlab = "Time",
  ylab = ""
) + theme_classic()

p <- p_data / p_trend / p_year
ggsave(plot = p, filename = "Output/result1.png",  dpi = 300, width = 6.4, height = 4.8)
