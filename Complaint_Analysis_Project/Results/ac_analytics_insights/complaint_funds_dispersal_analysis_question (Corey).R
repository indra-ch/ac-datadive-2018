#How does eligibility status vary with whether a claim may be
#brought after full disbursal of funds?
load("accountability_console_data_cleaned.RData")
load("benchmark_data_cleaned.RData")
load("benchmark_data_cleaned_melted.RData")
benchmarks_melted %>% filter(Benchmark == 
  "May a claim be brought after full disbursal of funds?" &
  value == 0) %>% select(variable) 
#Based on this, it appears that the only IAM that doesn't 
#allow for this in the benchmark data is WB_Panel
WBEligible <- complaints %>% filter(IAM == "WB_Panel") %>% 
  select(ELIGIBLE) %>% filter(!is.na(ELIGIBLE)) %>% unlist()
NonWBEligible <- complaints %>% filter(IAM != "WB_Panel") %>% 
  select(ELIGIBLE) %>% filter(!is.na(ELIGIBLE)) %>% unlist()
WBEligibleProp = sum(WBEligible)/length(WBEligible)
NonWBEligibleProp = sum(NonWBEligible)/length(NonWBEligible)
WBEligibleProp
NonWBEligibleProp
prop.test(WBEligibleProp,length(WBEligible),p = NonWBEligibleProp,
          alternative = "greater")