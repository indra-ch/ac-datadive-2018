#load("C:/Users/rawle/Desktop/Hackathon/accountability_console_data_cleaned.RData")
#write.csv(complaints,"C:/Users/rawle/Desktop/Hackathon/complaints.csv")

cnames <- names(complaints)

spc <- "                                 "

for (i in 1:54) {
  var <- cnames[[i]]
  test <- unique(complaints[,var])
  nt  <- length(test)
  nc  <- nchar(var)
  var <- paste(var,substr(spc,1,33-nc),sep="")
  if ((nt <= 21) & (i != 27)) {
    for (j in 1:nt) {
      val <- test[[j]]
      if (j == 1) {
        cat(i,"\t",var,"\t",j,"\t",val,"\n")
      } else {
        cat("\t",spc,"\t",j,"\t",val,"\n") 
      }
    }
  }
}

binary <- data.frame()
binlab <- data.frame()

k <- 0
vals <- c("ABD_SPF_CRP","EIB_CM","IFC_CAO","IDB_MICI","ERBD_PCM","WB_Panel","OPIC_OA",
          "FMO_ICM","ERBD_IRM","AfDB_IRM","JBIC_EEG","COES_CSR","JICA_EEG","UNDP_SRM")
for (j in 1:14) {
  k <- k + 1
  binlab[k,"Variable"] <- "IAM"
  binlab[k,"Value"]    <- vals[[j]]
}
binlab[15,"Variable"] <- "Filer"
binlab[15,"Value"]    <- "Exists"
binlab[16,"Variable"] <- "IFI Support"
binlab[16,"Value"]    <- "NA"
k <- 16
vals <- c("Advisory services","Equity Investment","Financial intermediary","Project/investment lending","Risk Guarantee","Other")
for (j in 1:6) {
  k <- k + 1
  binlab[k,"Variable"] <- "IFI Support"
  binlab[k,"Value"]    <- vals[[j]]
}
k <- 22
vals <- c("Agribusiness","Chemicals","Community capacity and development","Conservation and environmental protection",
          "Education","Energy","Extractives","Forestry","Healthcare","Infrastructure","Land reform","Manufacturing",
          "Procurement","Regulatory Development","Other")
for (j in 1:15) {
  k <- k + 1
  binlab[k,"Variable"] <- "Sector"
  binlab[k,"Value"]    <- vals[[j]]
}
k <- 37
vals <- c("Biodiversity","Consultation and disclosure","Corruption/fraud","Cultural heritage","Displacement",
          "Due diligence","Gender-based violence","Human rights","Indigenous peoples","Labor","Livelihoods",
          "Other community health and safety issues","Other environmental","Other gender-related issues",
          "Other retaliation","Pollution","Procurement","Property damage","Violence against the community",
          "Water","Other")
for (j in 1:21) {
  k <- k + 1
  binlab[k,"Variable"] <- "Issues"
  binlab[k,"Value"]    <- vals[[j]]
}
binlab[59,"Variable"] <- "Compliance"
binlab[59,"Value"]    <- "Report"
binlab[60,"Variable"] <- "Compliance"
binlab[60,"Value"]    <- "Non-Compliance"
binlab[61,"Variable"] <- "Filing Date"
binlab[61,"Value"]    <- "Exists"
binlab[62,"Variable"] <- "Registration"
binlab[62,"Value"]    <- "Started"
binlab[63,"Variable"] <- "Registration"
binlab[63,"Value"]    <- "Ended"
binlab[64,"Variable"] <- "Registration"
binlab[64,"Value"]    <- "NA"
k <- 64
vals <- c("closed_with_outcome","not_undertaken","closed_without_outcome")
for (j in 1:3) {
  k <- k + 1
  binlab[k,"Variable"] <- "Registration"
  binlab[k,"Value"]    <- vals[[j]]
}  
binlab[68,"Variable"] <- "Eligability"
binlab[68,"Value"]    <- "Started"
binlab[69,"Variable"] <- "Eligability"
binlab[69,"Value"]    <- "Ended"
binlab[70,"Variable"] <- "Eligability"
binlab[70,"Value"]    <- "NA"
k <- 70
vals <- c("closed_with_outcome","not_undertaken","closed_without_outcome")
for (j in 1:3) {
  k <- k + 1
  binlab[k,"Variable"] <- "Eligability"
  binlab[k,"Value"]    <- vals[[j]]
}  
binlab[74,"Variable"] <- "Why Not Eligable"
binlab[74,"Value"]    <- "NA"

k <- 74
vals <- c("Addressed outside process","Case closed in earlier stage","Complaint withdrawn","Filer Issue",
          "Forwarded to other body within bank","Funding and/or consideration ended","Good faith requirement not met",
          "Inadequate information","Issues previously raised","Mechanism deemed involvement unnecessary",
          "Not desired by complainant","Outside of mandate","Project Completion Report issued","Unknown","Other")
for (j in 1:15) {
  k <- k + 1
  binlab[k,"Variable"] <- "Why Not Eligable"
  binlab[k,"Value"]    <- vals[[j]]
}
binlab[90,"Variable"] <- "Dispute Resolution"
binlab[90,"Value"]    <- "Started"
binlab[91,"Variable"] <- "Dispute Resolution"
binlab[91,"Value"]    <- "Ended"
binlab[92,"Variable"] <- "Dispute Resolution"
binlab[92,"Value"]    <- "NA"
k <- 92
vals <- c("closed_with_outcome","not_undertaken","closed_without_outcome","in_progress")
for (j in 1:4) {
  k <- k + 1
  binlab[k,"Variable"] <- "Dispute Resolution"
  binlab[k,"Value"]    <- vals[[j]]
}    
binlab[97,"Variable"] <- "Why No Dispute Resolution"
binlab[97,"Value"]    <- "NA"
k <- 97
vals <- c("Case closed in earlier stage","Mechanism deemed involvement unnecessary",
          "Actor(s) involved refused to participate","Unknown","Addressed outside process",
          "Not desired by complainant","Not offered by mechanism","Mechanism unable to contact complainant",
          "Complaint withdrawn","Funding and/or consideration ended")
for (j in 1:10) {
  k <- k + 1
  binlab[k,"Variable"] <- "Why No Dispute Resolution"
  binlab[k,"Value"]    <- vals[[j]]
}    
binlab[108,"Variable"] <- "Compliance Review"
binlab[108,"Value"]    <- "Started"
binlab[109,"Variable"] <- "Compliance Review"
binlab[109,"Value"]    <- "Ended"
binlab[110,"Variable"] <- "Compliance Review"
binlab[110,"Value"]    <- "NA"
k <- 110
vals <- c("closed_with_outcome","not_undertaken","closed_without_outcome","in_progress")
for (j in 1:4) {
  k <- k + 1
  binlab[k,"Variable"] <- "Compliance Review"
  binlab[k,"Value"]    <- vals[[j]]
}    
binlab[115,"Variable"] <- "Why No Compliance Review"
binlab[115,"Value"]    <- "NA"
k <- 115
vals <- c("Case closed in earlier stage","Mechanism deemed involvement unnecessary","Addressed outside process",
          "Complaint withdrawn","Mechanism unable to contact complainant","Unknown",
          "Funding and/or consideration ended","Complainant did not refile","Not desired by complainant",
          "Board did not approve","Not offered by mechanism")
for (j in 1:11) {
  k <- k + 1
  binlab[k,"Variable"] <- "Why No Compliance Review"
  binlab[k,"Value"]    <- vals[[j]]
}
binlab[127,"Variable"] <- "Monitoring"
binlab[127,"Value"]    <- "Started"
binlab[128,"Variable"] <- "Monitoring"
binlab[128,"Value"]    <- "Ended"
binlab[129,"Variable"] <- "Monitoring"
binlab[129,"Value"]    <- "NA"
k <- 129
vals <- c("closed_with_outcome","not_undertaken","closed_without_outcome","in_progress")
for (j in 1:4) {
  k <- k + 1
  binlab[k,"Variable"] <- "Monitoring"
  binlab[k,"Value"]    <- vals[[j]]
}    
binlab[134,"Variable"] <- "Why No Monitoring"
binlab[134,"Value"]    <- "NA"
k <- 134
vals <- c("Case closed in earlier stage","Mechanism deemed involvement unnecessary","Unknown",
          "Board did not approve","Funding and/or consideration ended")
for (j in 1:5) {
  k <- k + 1
  binlab[k,"Variable"] <- "Why No Monitoring"
  binlab[k,"Value"]    <- vals[[j]]
}
binlab[140,"Variable"] <- "Date Closed"
binlab[140,"Value"]    <- "Exists"

for (i in 1:nrow(complaints)) {
  k <- 0
  vals <- c("ABD_SPF_CRP","EIB_CM","IFC_CAO","IDB_MICI","ERBD_PCM","WB_Panel","OPIC_OA",
            "FMO_ICM","ERBD_IRM","AfDB_IRM","JBIC_EEG","COES_CSR","JICA_EEG","UNDP_SRM")
  for (j in 1:14) {
    k <- k + 1
    var <- paste("B",k,sep="")
    binary[i,var] <- 0
    val <- vals[[j]]
    val0 <- complaints[[i,7]]
    if (!is.na(val0)) {
      if (val0 == val) {
        binary[i,var] <- 1
      }
    }
  }
  binary[i,"B15"] <- 0
  if (!is.na(complaints[[i,11]])){
    binary[i,"B15"] <- 1
  }
  binary[i,"B16"] <- 0
  if (is.na(complaints[[i,12]])){
    binary[i,"B16"] <- 1
  }
  k <- 16
  vals <- c("Advisory services","Equity Investment","Financial intermediary","Project/investment lending","Risk Guarantee","Other")
  for (j in 1:6) {
    k <- k + 1
    var <- paste("B",k,sep="")
    binary[i,var] <- 0
    val <- vals[[j]]
    for (h in 12:13) {
      val0 <- complaints[[i,h]]
      if (!is.na(val0)) {
        if (val0 == val) {
          binary[i,var] <- 1
        }
      }
    }
  }
  k <- 22
  vals <- c("Agribusiness","Chemicals","Community capacity and development","Conservation and environmental protection",
            "Education","Energy","Extractives","Forestry","Healthcare","Infrastructure","Land reform","Manufacturing",
            "Procurement","Regulatory Development","Other")

  for (j in 1:15) {
    k <- k + 1
    var <- paste("B",k,sep="")
    binary[i,var] <- 0
    val <- vals[[j]]
    for (h in 14:16) {
      val0 <- complaints[[i,h]]
      if (!is.na(val0)) {
        if (val0 == val) {
          binary[i,var] <- 1
        }
      }
    }
  }
  k <- 37
  vals <- c("Biodiversity","Consultation and disclosure","Corruption/fraud","Cultural heritage","Displacement",
            "Due diligence","Gender-based violence","Human rights","Indigenous peoples","Labor","Livelihoods",
            "Other community health and safety issues","Other environmental","Other gender-related issues",
            "Other retaliation","Pollution","Procurement","Property damage","Violence against the community",
            "Water","Other")
  for (j in 1:21) {
    k <- k + 1
    var <- paste("B",k,sep="")
    binary[i,var] <- 0
    val <- vals[[j]]
    for (h in 17:26) {
      val0 <- complaints[[i,h]]
      if (!is.na(val0)) {
        if (val0 == val) {
          binary[i,var] <- 1
        }
      }
    }
  }
  binary[i,"B59"] <- 0
  if (complaints[[i,28]]) {
    binary[i,"B59"] <- 1
  }
  binary[i,"B60"] <- 0
  if (complaints[[i,29]]) {
    binary[i,"B60"] <- 1
  }
  binary[i,"B61"] <- 0
  if (!is.na(complaints[[i,30]])) {
    binary[i,"B61"] <- 1
  }  
  binary[i,"B62"] <- 0
  if (!is.na(complaints[[i,31]])) {
    binary[i,"B62"] <- 1
  }  
  binary[i,"B63"] <- 0
  if (!is.na(complaints[[i,32]])) {
    binary[i,"B63"] <- 1
  }  
  binary[i,"B64"] <- 0
  if (is.na(complaints[[i,33]])) {
    binary[i,"B64"] <- 1
  }  
  k <- 64
  vals <- c("closed_with_outcome","not_undertaken","closed_without_outcome")
  for (j in 1:3) {
    k <- k + 1
    var <- paste("B",k,sep="")
    binary[i,var] <- 0
    val <- vals[[j]]
    val0 <- complaints[[i,33]]
    if (!is.na(val0)) {
      if (val0 == val) {
        binary[i,var] <- 1
      }
    }
  }  
  binary[i,"B68"] <- 0
  if (!is.na(complaints[[i,35]])) {
    binary[i,"B68"] <- 1
  }  
  binary[i,"B69"] <- 0
  if (!is.na(complaints[[i,36]])) {
    binary[i,"B69"] <- 1
  }  
  binary[i,"B70"] <- 0
  if (is.na(complaints[[i,37]])) {
    binary[i,"B70"] <- 1
  }  
  k <- 70
  vals <- c("closed_with_outcome","not_undertaken","closed_without_outcome")
  for (j in 1:3) {
    k <- k + 1
    var <- paste("B",k,sep="")
    binary[i,var] <- 0
    val <- vals[[j]]
    val0 <- complaints[[i,37]]
    if (!is.na(val0)) {
      if (val0 == val) {
        binary[i,var] <- 1
      }
    }
  }    
  binary[i,"B74"] <- 0
  if (is.na(complaints[[i,38]])) {
    binary[i,"B74"] <- 1
  }  
  k <- 74
  vals <- c("Addressed outside process","Case closed in earlier stage","Complaint withdrawn","Filer Issue",
            "Forwarded to other body within bank","Funding and/or consideration ended","Good faith requirement not met",
            "Inadequate information","Issues previously raised","Mechanism deemed involvement unnecessary",
            "Not desired by complainant","Outside of mandate","Project Completion Report issued","Unknown","Other")
  for (j in 1:15) {
    k <- k + 1
    var <- paste("B",k,sep="")
    binary[i,var] <- 0
    val <- vals[[j]]
    for (h in 38:40) {
      val0 <- complaints[[i,h]]
      if (!is.na(val0)) {
        if (val0 == val) {
          binary[i,var] <- 1
        }
      }
    }
  }
  binary[i,"B90"] <- 0
  if (!is.na(complaints[[i,41]])) {
    binary[i,"B90"] <- 1
  }  
  binary[i,"B91"] <- 0
  if (!is.na(complaints[[i,42]])) {
    binary[i,"B91"] <- 1
  }  
  binary[i,"B92"] <- 0
  if (is.na(complaints[[i,43]])) {
    binary[i,"B92"] <- 1
  }  
  k <- 92
  vals <- c("closed_with_outcome","not_undertaken","closed_without_outcome","in_progress")
  for (j in 1:4) {
    k <- k + 1
    var <- paste("B",k,sep="")
    binary[i,var] <- 0
    val <- vals[[j]]
    val0 <- complaints[[i,43]]
    if (!is.na(val0)) {
      if (val0 == val) {
        binary[i,var] <- 1
      }
    }
  }    
  binary[i,"B97"] <- 0
  if (is.na(complaints[[i,44]])) {
    binary[i,"B97"] <- 1
  }  
  k <- 97
  vals <- c("Case closed in earlier stage","Mechanism deemed involvement unnecessary",
            "Actor(s) involved refused to participate","Unknown","Addressed outside process",
            "Not desired by complainant","Not offered by mechanism","Mechanism unable to contact complainant",
            "Complaint withdrawn","Funding and/or consideration ended")
  for (j in 1:10) {
    k <- k + 1
    var <- paste("B",k,sep="")
    binary[i,var] <- 0
    val <- vals[[j]]
    val0 <- complaints[[i,44]]
    if (!is.na(val0)) {
      if (val0 == val) {
        binary[i,var] <- 1
      }
    }
  }    
  binary[i,"B108"] <- 0
  if (!is.na(complaints[[i,45]])) {
    binary[i,"B108"] <- 1
  }  
  binary[i,"B109"] <- 0
  if (!is.na(complaints[[i,46]])) {
    binary[i,"B109"] <- 1
  }  
  binary[i,"B110"] <- 0
  if (is.na(complaints[[i,47]])) {
    binary[i,"B110"] <- 1
  }  
  k <- 110
  vals <- c("closed_with_outcome","not_undertaken","closed_without_outcome","in_progress")
  for (j in 1:4) {
    k <- k + 1
    var <- paste("B",k,sep="")
    binary[i,var] <- 0
    val <- vals[[j]]
    val0 <- complaints[[i,47]]
    if (!is.na(val0)) {
      if (val0 == val) {
        binary[i,var] <- 1
      }
    }
  }    
  binary[i,"B115"] <- 0
  if (is.na(complaints[[i,48]])) {
    binary[i,"B115"] <- 1
  }  
  k <- 115
  vals <- c("Case closed in earlier stage","Mechanism deemed involvement unnecessary","Addressed outside process",
            "Complaint withdrawn","Mechanism unable to contact complainant","Unknown",
            "Funding and/or consideration ended","Complainant did not refile","Not desired by complainant",
            "Board did not approve","Not offered by mechanism")
  for (j in 1:11) {
    k <- k + 1
    var <- paste("B",k,sep="")
    binary[i,var] <- 0
    val <- vals[[j]]
    val0 <- complaints[[i,48]]
    if (!is.na(val0)) {
      if (val0 == val) {
        binary[i,var] <- 1
      }
    }
  }
  binary[i,"B127"] <- 0
  if (!is.na(complaints[[i,49]])) {
    binary[i,"B127"] <- 1
  }  
  binary[i,"B128"] <- 0
  if (!is.na(complaints[[i,50]])) {
    binary[i,"B128"] <- 1
  }  
  binary[i,"B129"] <- 0
  if (is.na(complaints[[i,51]])) {
    binary[i,"B129"] <- 1
  }  
  k <- 129
  vals <- c("closed_with_outcome","not_undertaken","closed_without_outcome","in_progress")
  for (j in 1:4) {
    k <- k + 1
    var <- paste("B",k,sep="")
    binary[i,var] <- 0
    val <- vals[[j]]
    val0 <- complaints[[i,51]]
    if (!is.na(val0)) {
      if (val0 == val) {
        binary[i,var] <- 1
      }
    }
  }    
  binary[i,"B134"] <- 0
  if (is.na(complaints[[i,52]])) {
    binary[i,"B134"] <- 1
  }  
  k <- 134
  vals <- c("Case closed in earlier stage","Mechanism deemed involvement unnecessary","Unknown",
            "Board did not approve","Funding and/or consideration ended")

  for (j in 1:5) {
    k <- k + 1
    var <- paste("B",k,sep="")
    binary[i,var] <- 0
    val <- vals[[j]]
    val0 <- complaints[[i,52]]
    if (!is.na(val0)) {
      if (val0 == val) {
        binary[i,var] <- 1
      }
    }
  }
  binary[i,"B140"] <- 0
  if (!is.na(complaints[[i,53]])) {
    binary[i,"B140"] <- 1
  } 
  val <- complaints[[i,54]]
  if (is.na(val)) {
    binary[i,"goal"] <- 0
  } else {
    binary[i,"goal"] <- val + 1
  }
} 

  
for (i in 1:nrow(complaints)) {
  t0 <- 
    0
  for (j in 1:14) {
    t0 <- t0 + binary[[i,j]]
  }
  if (t0 == 0) {
    cat("Prob1","\t",i,"\n")
  }
  t0 <- 
    0
  for (j in 16:22) {
    t0 <- t0 + binary[[i,j]]
  }
  if (t0 == 0) {
    cat("Prob2","\t",i,"\n")
  }
  t0 <- 
    0
  for (j in 23:37) {
    t0 <- t0 + binary[[i,j]]
  }
  if (t0 == 0) {
    cat("Prob3","\t",i,"\n")
  } 
  t0 <- 
    0
  for (j in 38:58) {
    t0 <- t0 + binary[[i,j]]
  }
  if (t0 == 0) {
    cat("Prob4","\t",i,"\n")
  }  
  t0 <- 
    0
  for (j in 64:67) {
    t0 <- t0 + binary[[i,j]]
  }
  if (t0 == 0) {
    cat("Prob5","\t",i,"\n")
  }  
  t0 <- 
    0
  for (j in 70:73) {
    t0 <- t0 + binary[[i,j]]
  }
  if (t0 == 0) {
    cat("Prob6","\t",i,"\n")
  }  
  t0 <- 
    0
  for (j in 74:89) {
    t0 <- t0 + binary[[i,j]]
  }
  if (t0 == 0) {
    cat("Prob7","\t",i,"\n")
  }  
  t0 <- 
    0
  for (j in 92:96) {
    t0 <- t0 + binary[[i,j]]
  }
  if (t0 == 0) {
    cat("Prob8","\t",i,"\n")
  }  
  t0 <- 
    0
  for (j in 97:107) {
    t0 <- t0 + binary[[i,j]]
  }
  if (t0 == 0) {
    cat("Prob9","\t",i,"\n")
  }  
  t0 <- 
    0
  for (j in 110:114) {
    t0 <- t0 + binary[[i,j]]
  }
  if (t0 == 0) {
    cat("Prob10","\t",i,"\n")
  }  
  t0 <- 
    0
  for (j in 115:126) {
    t0 <- t0 + binary[[i,j]]
  }
  if (t0 == 0) {
    cat("Prob11","\t",i,"\n")
  }  
  t0 <- 
    0
  for (j in 129:133) {
    t0 <- t0 + binary[[i,j]]
  }
  if (t0 == 0) {
    cat("Prob12","\t",i,"\n")
  }  
  t0 <- 
    0
  for (j in 134:139) {
    t0 <- t0 + binary[[i,j]]
  }
  if (t0 == 0) {
    cat("Prob13","\t",i,"\n")
  }  
}

chisqtab <- data.frame(binlab)

tb <- table(list(binary$goal))

t0 <- tb[1]

t1 <- tb[2]

t2 <- tb[3]

for (i in 1:140) {
  var <- paste("B",i,sep="")
  s1 <- sum(binary[binary$goal==1,var])
  s2 <- sum(binary[binary$goal==2,var])
  tbt <- data.frame()
  tbt["goal1","B0"] <- t1 - s1
  tbt["goal2","B0"] <- t2 - s2
  tbt["goal1","B1"] <- s1
  tbt["goal2","B1"] <- s2
  r1 <- s1 + s2
  r0 <- t1 + t2 - s1 - s2
  r2 <- r0
  if (r1 < r0) {
    r2 <- r1
  }
  p0 <- (t2 - s2) / r0
  p1 <- s2 / r1
  cs <- chisq.test(tbt)
  xs <- cs[[1]]
  xp <- cs[[3]]
  xp <- 1 - xp  
  cat(var,"\t",xs,"\t",xp,"\t",p0,"\t",p1,"\n")
  if (is.nan(xs)) {
    xs <- 0
  }
  if (is.nan(xp)) {
    xp <- 0
  }
  if (is.nan(p1)) {
    p1 <- 0
  }
  if (is.nan(r1)) {
    r1 <- 0
  }
  chisqtab[i,"Chi_Sq_Stat"] <- xs
  chisqtab[i,"Prob_of_Dependence"] <- xp
  chisqtab[i,"Percent_Eligable"]   <- p1
  chisqtab[i,"Sample_Size"]        <- r1
  chisqtab[i,"Warning"]            <- ""
  if (r2 < 17) {
    chisqtab[i,"Warning"]          <- "Reults Directional"
    if (r2 < 9) {
      chisqtab[i,"Warning"]        <- "Reults Questionable"
      if (r2 < 5) {
        chisqtab[i,"Warning"]      <- "Reults Not Valid"
      }
    }
  }
}
write.csv(chisqtab,"C:/Users/rawle/Desktop/Hackathon/complaints Chi Square Variable Predictabiiity.csv")